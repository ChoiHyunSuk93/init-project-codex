#!/usr/bin/env python3
"""End-to-end validation for the hs-init-project skill and generated scaffold."""

from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Iterable
from urllib.parse import unquote

try:
    import yaml
except ImportError as exc:  # pragma: no cover - exercised by dependency failures
    raise SystemExit(
        "PyYAML is required to validate skill metadata. Install it with "
        "`python3 -m pip install 'pyyaml>=6,<7'`."
    ) from exc


SCRIPT_PATH = Path(__file__).resolve()
SKILL_DIR = SCRIPT_PATH.parent.parent
REPO_ROOT = SKILL_DIR.parent
MATERIALIZER = SKILL_DIR / "scripts" / "materialize_repo.sh"

TARGETS = ("codex", "claude", "both")
LANGUAGES = ("en", "ko")
RULE_FILES = {
    "project-structure.md",
    "development-standards.md",
    "testing-standards.md",
    "documentation.md",
    "agent-workflow.md",
}
MERGE_START = "<!-- hs-init-project:start -->"
MERGE_END = "<!-- hs-init-project:end -->"
PROHIBITED_PATHS = (
    ".codex/agents",
    ".codex/skills",
    ".codex/config.toml",
    "subagents_docs",
    "docs",
)

MARKDOWN_LINK_RE = re.compile(r"(?<!!)\[[^\]]+\]\(([^)]+)\)")
FRONTMATTER_RE = re.compile(r"\A---\n(.*?)\n---(?:\n|\Z)", re.DOTALL)
CODE_BLOCK_RE = re.compile(r"```(?:bash|text)?\n(.*?)```", re.DOTALL)


class ValidationError(RuntimeError):
    """A scaffold contract assertion failed."""


class Reporter:
    def __init__(self, verbose: bool) -> None:
        self.verbose = verbose
        self.passed = 0
        self.skipped = 0

    def pass_check(self, label: str) -> None:
        self.passed += 1
        print(f"[PASS] {label}")

    def skip_check(self, label: str, reason: str) -> None:
        self.skipped += 1
        print(f"[SKIP] {label}: {reason}")

    def detail(self, message: str) -> None:
        if self.verbose:
            print(f"       {message}")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValidationError(message)


def run(
    command: list[str],
    *,
    cwd: Path = REPO_ROOT,
    expect_success: bool = True,
) -> subprocess.CompletedProcess[str]:
    result = subprocess.run(
        command,
        cwd=cwd,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    if expect_success and result.returncode != 0:
        rendered = " ".join(command)
        raise ValidationError(
            f"command failed with exit {result.returncode}: {rendered}\n{result.stdout}"
        )
    if not expect_success and result.returncode == 0:
        rendered = " ".join(command)
        raise ValidationError(f"command unexpectedly succeeded: {rendered}\n{result.stdout}")
    return result


def materialize_command(
    target_dir: Path,
    *,
    language: str,
    target: str,
    project_mode: str,
    readme_mode: str | None = None,
    overwrite: bool = False,
    dry_run: bool = False,
    preserve: tuple[str, ...] = (),
) -> list[str]:
    command = [
        "sh",
        str(MATERIALIZER),
        "--root",
        str(target_dir),
        "--language",
        language,
        "--target",
        target,
        "--project-mode",
        project_mode,
        "--source-root-dir",
        "src",
    ]
    if readme_mode is not None:
        command.extend(("--readme-mode", readme_mode))
    if overwrite:
        command.append("--overwrite")
    if dry_run:
        command.append("--dry-run")
    for relative in preserve:
        command.extend(("--preserve", relative))
    return command


def expected_fresh_files(target: str) -> set[str]:
    files = {
        "AGENTS.md",
        "README.md",
        "PROJECT_OVERVIEW.md",
        "rule/index.md",
    }
    files.update(f"rule/rules/{name}" for name in RULE_FILES)
    if target in {"claude", "both"}:
        files.add("CLAUDE.md")
    return files


def relative_files(root: Path) -> set[str]:
    return {
        path.relative_to(root).as_posix()
        for path in root.rglob("*")
        if path.is_file() or path.is_symlink()
    }


def snapshot_tree(root: Path) -> dict[str, bytes | str]:
    snapshot: dict[str, bytes | str] = {}
    for path in sorted(root.rglob("*")):
        relative = path.relative_to(root).as_posix()
        if path.is_symlink():
            snapshot[relative] = f"symlink:{os.readlink(path)}"
        elif path.is_file():
            snapshot[relative] = path.read_bytes()
        elif path.is_dir():
            snapshot[f"{relative}/"] = "directory"
    return snapshot


def validate_skill_frontmatter() -> None:
    skill_file = SKILL_DIR / "SKILL.md"
    require(skill_file.is_file(), f"missing {skill_file}")
    match = FRONTMATTER_RE.match(skill_file.read_text(encoding="utf-8"))
    require(match is not None, "SKILL.md must begin with YAML frontmatter")
    data = yaml.safe_load(match.group(1))
    require(isinstance(data, dict), "SKILL.md frontmatter must be a mapping")
    require(set(data) == {"name", "description"}, "SKILL.md frontmatter must contain only name and description")
    require(data["name"] == "hs-init-project", "SKILL.md name must be hs-init-project")
    require(isinstance(data["description"], str) and data["description"].strip(), "SKILL.md description must be non-empty")


def find_quick_validate() -> Path | None:
    candidates: list[Path] = []
    configured = os.environ.get("QUICK_VALIDATE")
    if configured:
        candidates.append(Path(configured).expanduser())

    codex_home = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex")).expanduser()
    candidates.extend(
        (
            codex_home / "skills/.system/skill-creator/scripts/quick_validate.py",
            Path.home() / ".codex/skills/.system/skill-creator/scripts/quick_validate.py",
        )
    )
    for candidate in candidates:
        if candidate.is_file():
            return candidate.resolve()
    return None


def validate_openai_metadata_file(path: Path) -> None:
    data = yaml.safe_load(path.read_text(encoding="utf-8"))
    require(isinstance(data, dict), f"{path}: YAML root must be a mapping")
    require(set(data) <= {"interface", "dependencies", "policy"}, f"{path}: unexpected top-level metadata key")

    interface = data.get("interface")
    require(isinstance(interface, dict), f"{path}: interface must be a mapping")
    for key in ("display_name", "short_description", "default_prompt"):
        value = interface.get(key)
        require(isinstance(value, str) and value.strip(), f"{path}: interface.{key} must be a non-empty string")

    short_description = interface["short_description"]
    require(
        25 <= len(short_description) <= 64,
        f"{path}: interface.short_description must be 25-64 characters, got {len(short_description)}",
    )

    require(path.parent.name == "agents", f"{path}: openai metadata must be stored under an agents directory")
    skill_name = path.parent.parent.name
    require(
        f"${skill_name}" in interface["default_prompt"],
        f"{path}: interface.default_prompt must mention ${skill_name}",
    )

    policy = data.get("policy", {})
    require(isinstance(policy, dict), f"{path}: policy must be a mapping")
    implicit = policy.get("allow_implicit_invocation", True)
    require(isinstance(implicit, bool), f"{path}: policy.allow_implicit_invocation must be boolean")


def validate_yaml_metadata() -> None:
    yaml_files = sorted((*SKILL_DIR.rglob("*.yaml"), *SKILL_DIR.rglob("*.yml")))
    require(yaml_files, "skill bundle must contain YAML metadata")
    for path in yaml_files:
        try:
            yaml.safe_load(path.read_text(encoding="utf-8"))
        except yaml.YAMLError as exc:
            raise ValidationError(f"invalid YAML in {path}: {exc}") from exc
        if path.name.startswith("openai"):
            validate_openai_metadata_file(path)


def installer_refs(content: str, path: Path) -> set[str]:
    refs: set[str] = set()
    installer_blocks = [
        block for block in CODE_BLOCK_RE.findall(content)
        if "install-skill-from-github.py" in block
    ]
    require(len(installer_blocks) >= 3, f"{path}: expected project, global, and URL installer examples")
    for block in installer_blocks:
        require("--ref latest" not in block, f"{path}: direct installer does not resolve --ref latest")
        ref_match = re.search(r"--ref\s+([^\s\\]+)", block)
        url_match = re.search(r"/tree/([^/\s]+)/hs-init-project", block)
        require(ref_match is not None or url_match is not None, f"{path}: installer example is missing an explicit ref")
        refs.add((ref_match or url_match).group(1))
    return refs


def validate_install_documentation() -> None:
    documented_refs: set[str] = set()
    for path in (REPO_ROOT / "README.md", REPO_ROOT / "README.ko.md"):
        content = path.read_text(encoding="utf-8")
        require("/tree/latest/" not in content, f"{path}: direct installer URL must not use a synthetic latest ref")
        refs = installer_refs(content, path)
        require(len(refs) == 1, f"{path}: direct installer examples must use one consistent ref, got {sorted(refs)}")
        documented_refs.update(refs)

    require(len(documented_refs) == 1, f"README language variants use different installer refs: {sorted(documented_refs)}")
    documented_ref = next(iter(documented_refs))
    require(
        documented_ref == "main" or re.fullmatch(r"v[0-9]+\.[0-9]+\.[0-9]+", documented_ref) is not None,
        f"unsupported documented installer ref: {documented_ref}",
    )

    release_ref = os.environ.get("GITHUB_REF_NAME", "")
    if release_ref.startswith("v"):
        require(
            documented_ref == release_ref,
            f"release tag {release_ref} does not match documented installer ref {documented_ref}",
        )

    if documented_ref != "main":
        tag_check = subprocess.run(
            ["git", "rev-parse", "--verify", f"refs/tags/{documented_ref}"],
            cwd=REPO_ROOT,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )
        if tag_check.returncode == 0:
            payload_diff = subprocess.run(
                ["git", "diff", "--quiet", documented_ref, "--", "hs-init-project"],
                cwd=REPO_ROOT,
                check=False,
            )
            require(
                payload_diff.returncode in (0, 1),
                f"failed to compare current skill payload with documented tag {documented_ref}",
            )
            require(
                payload_diff.returncode == 0,
                f"documented tag {documented_ref} does not contain the current hs-init-project payload",
            )


def parse_markdown_target(raw_target: str) -> str | None:
    target = raw_target.strip()
    if target.startswith("<") and target.endswith(">"):
        target = target[1:-1]
    if " " in target and not target.startswith(("http://", "https://")):
        target = target.split(" ", 1)[0]
    if not target or target.startswith(("#", "http://", "https://", "mailto:", "data:")):
        return None
    target = unquote(target.split("#", 1)[0].split("?", 1)[0])
    if not target or any(marker in target for marker in ("[", "]", "*", "<", ">")):
        return None
    return target


def validate_markdown_links(root: Path) -> None:
    resolved_root = root.resolve()
    for markdown_file in sorted(root.rglob("*.md")):
        content = markdown_file.read_text(encoding="utf-8")
        for match in MARKDOWN_LINK_RE.finditer(content):
            target = parse_markdown_target(match.group(1))
            if target is None:
                continue
            target_path = (markdown_file.parent / target).resolve()
            require(
                target_path == resolved_root or resolved_root in target_path.parents,
                f"{markdown_file}: relative link escapes scaffold root: {target}",
            )
            require(target_path.exists(), f"{markdown_file}: broken relative link: {target}")


def validate_rule_index(root: Path) -> None:
    rules_dir = root / "rule/rules"
    actual_rules = {path.name for path in rules_dir.glob("*.md") if path.is_file()}
    require(actual_rules == RULE_FILES, f"unexpected rule inventory: expected {sorted(RULE_FILES)}, got {sorted(actual_rules)}")

    index_file = root / "rule/index.md"
    require(index_file.is_file(), "missing rule/index.md")
    indexed_rules = set(re.findall(r"\]\(rules/([a-z0-9-]+\.md)(?:#[^)]+)?\)", index_file.read_text(encoding="utf-8")))
    require(indexed_rules == RULE_FILES, f"rule index coverage mismatch: expected {sorted(RULE_FILES)}, got {sorted(indexed_rules)}")


def validate_target_entrypoints(root: Path, target: str) -> None:
    require((root / "AGENTS.md").is_file(), f"{target}: AGENTS.md must always be generated")
    expects_claude = target in {"claude", "both"}
    require(
        (root / "CLAUDE.md").exists() == expects_claude,
        f"{target}: CLAUDE.md presence does not match target contract",
    )


def validate_no_legacy_outputs(root: Path) -> None:
    for relative in PROHIBITED_PATHS:
        require(not (root / relative).exists(), f"legacy baseline output must not be generated: {relative}")


def validate_generated_tree(root: Path, target: str, *, exact_inventory: bool) -> None:
    validate_target_entrypoints(root, target)
    validate_no_legacy_outputs(root)
    validate_rule_index(root)
    validate_markdown_links(root)
    if exact_inventory:
        actual = relative_files(root)
        expected = expected_fresh_files(target)
        require(actual == expected, f"fresh {target} inventory mismatch: expected {sorted(expected)}, got {sorted(actual)}")


def seed_existing_project(root: Path, readme: str) -> None:
    (root / "src").mkdir(parents=True)
    (root / "src/keep.txt").write_text("existing source sentinel\n", encoding="utf-8")
    (root / "README.md").write_text(readme, encoding="utf-8")


def validate_fresh_matrix(temp_root: Path, reporter: Reporter) -> None:
    for language in LANGUAGES:
        for target in TARGETS:
            root = temp_root / f"fresh-{language}-{target}"
            root.mkdir()
            result = run(
                materialize_command(
                    root,
                    language=language,
                    target=target,
                    project_mode="fresh",
                    readme_mode="create",
                )
            )
            reporter.detail(result.stdout.strip())
            validate_generated_tree(root, target, exact_inventory=True)
            reporter.pass_check(f"fresh {language}/{target} scaffold")


def validate_existing_preserve_matrix(temp_root: Path, reporter: Reporter) -> None:
    original_readme = "# Existing Project\n\nKeep this user-authored paragraph.\n"
    for language in LANGUAGES:
        for target in TARGETS:
            root = temp_root / f"existing-preserve-{language}-{target}"
            root.mkdir()
            seed_existing_project(root, original_readme)
            result = run(
                materialize_command(
                    root,
                    language=language,
                    target=target,
                    project_mode="existing",
                    # Existing mode must default to preserve.
                )
            )
            reporter.detail(result.stdout.strip())
            require((root / "README.md").read_text(encoding="utf-8") == original_readme, "existing default preserve changed README.md")
            require((root / "src/keep.txt").read_text(encoding="utf-8") == "existing source sentinel\n", "existing source file changed")
            validate_generated_tree(root, target, exact_inventory=False)
            reporter.pass_check(f"existing preserve {language}/{target} scaffold")


def validate_existing_merge_matrix(temp_root: Path, reporter: Reporter) -> None:
    original_readme = "# Existing Project\n\nKeep this user-authored paragraph.\n"
    for language in LANGUAGES:
        for target in TARGETS:
            root = temp_root / f"existing-merge-{language}-{target}"
            root.mkdir()
            seed_existing_project(root, original_readme)
            first = run(
                materialize_command(
                    root,
                    language=language,
                    target=target,
                    project_mode="existing",
                    readme_mode="merge",
                )
            )
            reporter.detail(first.stdout.strip())
            merged = (root / "README.md").read_text(encoding="utf-8")
            require(original_readme.rstrip() in merged, "README merge did not preserve original content")
            require(merged.count(MERGE_START) == 1 and merged.count(MERGE_END) == 1, "README merge markers must appear exactly once")
            require(merged.index(MERGE_START) < merged.index(MERGE_END), "README merge markers are out of order")

            managed_sentinel = f"{MERGE_START}\nold managed content\n{MERGE_END}"
            replaced_fixture = re.sub(
                re.escape(MERGE_START) + r".*?" + re.escape(MERGE_END),
                managed_sentinel,
                merged,
                count=1,
                flags=re.DOTALL,
            )
            (root / "README.md").write_text(replaced_fixture, encoding="utf-8")
            second = run(
                materialize_command(
                    root,
                    language=language,
                    target=target,
                    project_mode="existing",
                    readme_mode="merge",
                    overwrite=True,
                )
            )
            reporter.detail(second.stdout.strip())
            replaced = (root / "README.md").read_text(encoding="utf-8")
            require("old managed content" not in replaced, "README merge did not replace the existing managed section")
            require(original_readme.rstrip() in replaced, "README merge replacement lost original content")
            require(replaced.count(MERGE_START) == 1 and replaced.count(MERGE_END) == 1, "README replacement duplicated merge markers")
            validate_generated_tree(root, target, exact_inventory=False)
            reporter.pass_check(f"existing merge {language}/{target} scaffold")


def validate_dry_run(temp_root: Path, reporter: Reporter) -> None:
    root = temp_root / "dry-run"
    root.mkdir()
    before = snapshot_tree(root)
    result = run(
        materialize_command(
            root,
            language="en",
            target="both",
            project_mode="fresh",
            readme_mode="create",
            dry_run=True,
        )
    )
    reporter.detail(result.stdout.strip())
    require(snapshot_tree(root) == before, "--dry-run changed the target repository")
    reporter.pass_check("dry-run is non-mutating")


def validate_unexpected_overwrite(temp_root: Path, reporter: Reporter) -> None:
    root = temp_root / "overwrite-guard"
    root.mkdir()
    seed_existing_project(root, "# Existing README sentinel\n")
    (root / "AGENTS.md").write_text("existing agent instructions sentinel\n", encoding="utf-8")
    before = snapshot_tree(root)
    result = run(
        materialize_command(
            root,
            language="en",
            target="codex",
            project_mode="existing",
            readme_mode="preserve",
        ),
        expect_success=False,
    )
    reporter.detail(result.stdout.strip())
    require(snapshot_tree(root) == before, "failed overwrite guard left partial changes in target repository")
    reporter.pass_check("unexpected overwrite fails atomically")


def validate_invalid_merge_markers(temp_root: Path, reporter: Reporter) -> None:
    root = temp_root / "invalid-merge-markers"
    root.mkdir()
    seed_existing_project(
        root,
        "# Existing README\n\n<!-- hs-init-project:start -->\nunterminated section\n",
    )
    before = snapshot_tree(root)
    result = run(
        materialize_command(
            root,
            language="en",
            target="both",
            project_mode="existing",
            readme_mode="merge",
        ),
        expect_success=False,
    )
    reporter.detail(result.stdout.strip())
    require(snapshot_tree(root) == before, "invalid README markers left partial scaffold changes")
    reporter.pass_check("invalid README merge markers fail atomically")


def validate_symlink_guard(temp_root: Path, reporter: Reporter) -> None:
    root = temp_root / "symlink-guard"
    external = temp_root / "external-rules"
    root.mkdir()
    external.mkdir()
    sentinel = external / "sentinel.txt"
    sentinel.write_text("outside target\n", encoding="utf-8")
    (root / "rule").symlink_to(external, target_is_directory=True)
    before_root = snapshot_tree(root)
    before_external = snapshot_tree(external)
    result = run(
        materialize_command(
            root,
            language="en",
            target="codex",
            project_mode="existing",
            readme_mode="preserve",
            overwrite=True,
        ),
        expect_success=False,
    )
    reporter.detail(result.stdout.strip())
    require(snapshot_tree(root) == before_root, "symlink guard left partial target changes")
    require(snapshot_tree(external) == before_external, "materializer wrote through an external symlink")
    require(sentinel.read_text(encoding="utf-8") == "outside target\n", "external sentinel changed")
    reporter.pass_check("symlink destinations fail atomically")


def validate_explicit_preserve_wins(temp_root: Path, reporter: Reporter) -> None:
    root = temp_root / "explicit-preserve"
    root.mkdir()
    seed_existing_project(root, "# Existing README\n")
    agents_sentinel = "existing AGENTS instructions\n"
    (root / "AGENTS.md").write_text(agents_sentinel, encoding="utf-8")
    result = run(
        materialize_command(
            root,
            language="en",
            target="both",
            project_mode="existing",
            readme_mode="preserve",
            overwrite=True,
            preserve=("AGENTS.md",),
        )
    )
    reporter.detail(result.stdout.strip())
    require(
        (root / "AGENTS.md").read_text(encoding="utf-8") == agents_sentinel,
        "--preserve AGENTS.md did not win over --overwrite",
    )
    require((root / "CLAUDE.md").is_file(), "explicit preserve run did not materialize other selected files")
    validate_rule_index(root)
    reporter.pass_check("explicit preserve wins over overwrite")


def validate_cli_contract(reporter: Reporter) -> None:
    require(MATERIALIZER.is_file(), f"missing materializer: {MATERIALIZER}")
    run(["sh", "-n", str(MATERIALIZER)])
    reporter.pass_check("materializer shell syntax")

    help_result = run(["sh", str(MATERIALIZER), "--help"])
    for option in (
        "--root",
        "--language",
        "--target",
        "--project-mode",
        "--readme-mode",
        "--source-root-dir",
        "--overwrite",
        "--dry-run",
    ):
        require(option in help_result.stdout, f"materializer --help is missing {option}")
    reporter.pass_check("materializer CLI contract")


def validate_bundle(reporter: Reporter) -> None:
    validate_skill_frontmatter()
    reporter.pass_check("SKILL.md frontmatter")

    quick_validate = find_quick_validate()
    if quick_validate is None:
        reporter.skip_check("system quick_validate.py", "not installed in this environment")
    else:
        result = run([sys.executable, str(quick_validate), str(SKILL_DIR)])
        reporter.detail(result.stdout.strip())
        reporter.pass_check("system quick_validate.py")

    validate_yaml_metadata()
    reporter.pass_check("YAML and OpenAI metadata constraints")
    validate_install_documentation()
    reporter.pass_check("installer documentation ref consistency")
    validate_markdown_links(SKILL_DIR / "references")
    reporter.pass_check("skill reference Markdown links")


def parse_args(argv: Iterable[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--keep-temp", action="store_true", help="Keep generated smoke repositories for inspection.")
    parser.add_argument("--verbose", action="store_true", help="Print materializer output for each smoke case.")
    return parser.parse_args(argv)


def main(argv: Iterable[str] | None = None) -> int:
    args = parse_args(argv)
    reporter = Reporter(args.verbose)
    temp_root = Path(tempfile.mkdtemp(prefix="hs-init-project-validation-"))
    try:
        validate_bundle(reporter)
        validate_cli_contract(reporter)
        validate_dry_run(temp_root, reporter)
        validate_fresh_matrix(temp_root, reporter)
        validate_existing_preserve_matrix(temp_root, reporter)
        validate_existing_merge_matrix(temp_root, reporter)
        validate_unexpected_overwrite(temp_root, reporter)
        validate_invalid_merge_markers(temp_root, reporter)
        validate_symlink_guard(temp_root, reporter)
        validate_explicit_preserve_wins(temp_root, reporter)
    except (OSError, ValidationError) as exc:
        print(f"[FAIL] {exc}", file=sys.stderr)
        print(f"[INFO] validation workspace: {temp_root}", file=sys.stderr)
        return 1
    finally:
        if args.keep_temp:
            print(f"[INFO] kept validation workspace: {temp_root}")
        else:
            shutil.rmtree(temp_root, ignore_errors=True)

    print(f"[OK] scaffold validation passed ({reporter.passed} checks, {reporter.skipped} skipped)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

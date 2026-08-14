#!/usr/bin/env python3
"""Validate required harness paths and semantic completion in a target repository."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path
from urllib.parse import unquote


TODO_MARKER = "HS_INIT_SEMANTIC_TODO"
EVIDENCE_START = "<!-- hs-init-project:evidence:start -->"
EVIDENCE_END = "<!-- hs-init-project:evidence:end -->"

REQUIRED_FILES = (
    "AGENTS.md",
    "PROJECT_OVERVIEW.md",
    "rule/index.md",
    "rule/rules/project-structure.md",
    "rule/rules/development-standards.md",
    "rule/rules/testing-standards.md",
    "rule/rules/documentation.md",
    "rule/rules/agent-workflow.md",
    "docs/guide/README.md",
    "docs/implementation/AGENTS.md",
    "subagents_docs/AGENTS.md",
    "subagents_docs/roadmap.md",
)

SEMANTIC_FILES = (
    "PROJECT_OVERVIEW.md",
    "rule/rules/project-structure.md",
    "rule/rules/development-standards.md",
    "rule/rules/testing-standards.md",
    "rule/rules/documentation.md",
    "docs/guide/README.md",
    "subagents_docs/roadmap.md",
)

HARNESS_FILES = {
    "AGENTS.md",
    "CLAUDE.md",
    "PROJECT_OVERVIEW.md",
    "README.md",
}
HARNESS_PREFIXES = ("rule/", "docs/", "subagents_docs/")

MARKDOWN_LINK_RE = re.compile(r"(?<!!)\[[^\]]+\]\(([^)]+)\)")
INLINE_CODE_RE = re.compile(r"`([^`\n]+)`")
STATUS_RE = re.compile(r"`Status`\s*:\s*`(pending|in_progress|blocked|PASS)`")


class ValidationError(RuntimeError):
    """A materialized repository is incomplete or invalid."""


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValidationError(message)


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


def managed_markdown_files(root: Path) -> list[Path]:
    paths = [root / relative for relative in REQUIRED_FILES]
    readme = root / "README.md"
    if readme.is_file():
        paths.append(readme)
    return paths


def validate_required_paths(root: Path) -> None:
    for relative in REQUIRED_FILES:
        require((root / relative).is_file(), f"missing required harness file: {relative}")
    require((root / "subagents_docs/cycles").is_dir(), "missing required work-record directory: subagents_docs/cycles/")
    require(not (root / "subagents_docs/cycles").is_symlink(), "subagents_docs/cycles/ must not be a symlink")


def validate_semantic_markers(root: Path) -> None:
    for relative in SEMANTIC_FILES:
        content = (root / relative).read_text(encoding="utf-8")
        require(TODO_MARKER not in content, f"unresolved semantic marker in {relative}: {TODO_MARKER}")
    readme = root / "README.md"
    if readme.is_file():
        require(TODO_MARKER not in readme.read_text(encoding="utf-8"), f"unresolved semantic marker in README.md: {TODO_MARKER}")


def validate_roadmap(root: Path) -> None:
    content = (root / "subagents_docs/roadmap.md").read_text(encoding="utf-8")
    require(re.search(r"^## Phase\s+", content, re.MULTILINE) is not None, "roadmap must contain at least one Phase section")
    require(STATUS_RE.search(content) is not None, "roadmap must contain a supported `Status` value")
    require("Required Checklist" in content or "필수 체크리스트" in content, "roadmap must contain a required checklist")
    require("Verification" in content or "검증" in content, "roadmap must contain a verification entry")


def validate_existing_evidence(root: Path) -> None:
    content = (root / "PROJECT_OVERVIEW.md").read_text(encoding="utf-8")
    start = content.find(EVIDENCE_START)
    end = content.find(EVIDENCE_END)
    require(start >= 0 and end > start, "PROJECT_OVERVIEW.md must keep a bounded observed-evidence block")
    evidence = content[start + len(EVIDENCE_START):end]

    observed_paths: list[str] = []
    for token in INLINE_CODE_RE.findall(evidence):
        candidate = token.strip().removeprefix("./").rstrip("/")
        if not candidate or candidate in HARNESS_FILES or candidate.startswith(HARNESS_PREFIXES):
            continue
        if candidate.startswith(("/", "~")) or "\x00" in candidate:
            continue
        resolved = (root / candidate).resolve()
        if resolved == root or root in resolved.parents:
            if resolved.exists():
                observed_paths.append(candidate)

    require(
        observed_paths,
        "existing-project overview evidence must name at least one real repository-relative path outside the generated harness",
    )


def validate_markdown_links(root: Path) -> None:
    resolved_root = root.resolve()
    for markdown_file in managed_markdown_files(root):
        content = markdown_file.read_text(encoding="utf-8")
        for match in MARKDOWN_LINK_RE.finditer(content):
            target = parse_markdown_target(match.group(1))
            if target is None:
                continue
            target_path = (markdown_file.parent / target).resolve()
            require(
                target_path == resolved_root or resolved_root in target_path.parents,
                f"{markdown_file.relative_to(root)}: relative link escapes repository root: {target}",
            )
            require(target_path.exists(), f"{markdown_file.relative_to(root)}: broken relative link: {target}")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", required=True, type=Path, help="Materialized repository root.")
    parser.add_argument("--project-mode", required=True, choices=("fresh", "existing"))
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    root = args.root.expanduser().resolve()
    try:
        require(root.is_dir(), f"repository root does not exist or is not a directory: {root}")
        validate_required_paths(root)
        validate_semantic_markers(root)
        validate_roadmap(root)
        if args.project_mode == "existing":
            validate_existing_evidence(root)
        validate_markdown_links(root)
    except (OSError, UnicodeError, ValidationError) as exc:
        print(f"[FAIL] {exc}", file=sys.stderr)
        return 1

    print(f"[OK] materialized repository is semantically complete: {root}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

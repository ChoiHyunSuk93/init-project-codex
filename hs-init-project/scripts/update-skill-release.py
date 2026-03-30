#!/usr/bin/env python3
"""Update an installed hs-init-project skill from a GitHub release tag."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import shutil
import sys
import tempfile
import urllib.error
import urllib.request
import zipfile

DEFAULT_REPO = "ChoiHyunSuk93/init-project-codex"
DEFAULT_SKILL_PATH = "hs-init-project"
DEFAULT_REF = "latest"
METADATA_FILE = ".release-source.json"


class UpdateError(Exception):
    """Raised when the updater cannot complete safely."""


def github_request(url: str) -> bytes:
    headers = {"User-Agent": "hs-init-project-updater"}
    token = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
    if token:
        headers["Authorization"] = f"token {token}"
    request = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(request) as response:
        return response.read()


def github_json(url: str) -> dict[str, object]:
    return json.loads(github_request(url).decode("utf-8"))


def parse_repo(repo: str) -> tuple[str, str]:
    parts = [part for part in repo.split("/") if part]
    if len(parts) != 2:
        raise UpdateError("--repo must be in owner/repo format.")
    return parts[0], parts[1]


def validate_relative_path(path: str) -> None:
    normalized = os.path.normpath(path)
    if os.path.isabs(path) or normalized.startswith(".."):
        raise UpdateError("Skill path must stay inside the GitHub repository.")


def resolve_ref(repo: str, requested_ref: str) -> str:
    if requested_ref != DEFAULT_REF:
        return requested_ref

    api_url = f"https://api.github.com/repos/{repo}/releases/latest"
    try:
        payload = github_json(api_url)
    except urllib.error.HTTPError as exc:
        raise UpdateError(
            f"Failed to resolve the latest release for {repo}: HTTP {exc.code}"
        ) from exc
    except urllib.error.URLError as exc:
        raise UpdateError(
            f"Failed to resolve the latest release for {repo}: {exc.reason}"
        ) from exc

    tag_name = payload.get("tag_name")
    if not isinstance(tag_name, str) or not tag_name:
        raise UpdateError(f"The latest release for {repo} did not return a tag name.")
    return tag_name


def safe_extract_zip(zip_file: zipfile.ZipFile, dest_dir: Path) -> None:
    dest_root = dest_dir.resolve()
    for info in zip_file.infolist():
        extracted_path = (dest_dir / info.filename).resolve()
        if extracted_path == dest_root or dest_root in extracted_path.parents:
            continue
        raise UpdateError("Archive contains files outside the destination.")
    zip_file.extractall(dest_dir)


def download_repo_zip(repo: str, ref: str, dest_dir: Path) -> Path:
    owner, name = parse_repo(repo)
    zip_url = f"https://codeload.github.com/{owner}/{name}/zip/{ref}"
    zip_path = dest_dir / "repo.zip"

    try:
        payload = github_request(zip_url)
    except urllib.error.HTTPError as exc:
        raise UpdateError(
            f"Failed to download {repo} at ref {ref}: HTTP {exc.code}"
        ) from exc
    except urllib.error.URLError as exc:
        raise UpdateError(
            f"Failed to download {repo} at ref {ref}: {exc.reason}"
        ) from exc

    zip_path.write_bytes(payload)
    with zipfile.ZipFile(zip_path, "r") as zip_file:
        safe_extract_zip(zip_file, dest_dir)
        roots = {name.split("/")[0] for name in zip_file.namelist() if name}

    if not roots:
        raise UpdateError("Downloaded archive was empty.")
    if len(roots) != 1:
        raise UpdateError("Downloaded archive had an unexpected layout.")
    return dest_dir / next(iter(roots))


def resolve_installed_skill_dir(skill_dir: str | None, expected_name: str) -> Path:
    if skill_dir:
        path = Path(skill_dir).expanduser().resolve()
    else:
        path = Path(__file__).resolve().parent.parent

    if not path.is_dir():
        raise UpdateError(f"Installed skill directory not found: {path}")
    if not (path / "SKILL.md").is_file():
        raise UpdateError(f"SKILL.md not found in {path}")
    if path.name != expected_name:
        raise UpdateError(
            f"Expected skill directory name '{expected_name}', found '{path.name}'."
        )
    if path.parent.name != "skills":
        raise UpdateError(
            "Refusing to update a directory that does not look like a Codex skill "
            "installation. Use --skill-dir with an installed path under a skills/ "
            "directory."
        )
    return path


def read_install_metadata(installed_dir: Path) -> dict[str, str]:
    metadata_path = installed_dir / METADATA_FILE
    if not metadata_path.is_file():
        return {}
    try:
        payload = json.loads(metadata_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return {}
    if not isinstance(payload, dict):
        return {}

    metadata: dict[str, str] = {}
    for key in ("repo", "path", "ref"):
        value = payload.get(key)
        if isinstance(value, str) and value:
            metadata[key] = value
    return metadata


def resolve_source_config(
    installed_dir: Path,
    repo_override: str | None,
    path_override: str | None,
) -> tuple[str, str]:
    metadata = read_install_metadata(installed_dir)
    repo = repo_override or metadata.get("repo") or DEFAULT_REPO
    skill_path = path_override or metadata.get("path") or DEFAULT_SKILL_PATH
    parse_repo(repo)
    validate_relative_path(skill_path)
    return repo, skill_path


def locate_skill(repo_root: Path, skill_path: str) -> Path:
    skill_dir = (repo_root / skill_path).resolve()
    if not skill_dir.is_dir():
        raise UpdateError(f"Skill path not found in archive: {skill_path}")
    if not (skill_dir / "SKILL.md").is_file():
        raise UpdateError("SKILL.md not found in the downloaded skill path.")
    return skill_dir


def write_install_metadata(installed_dir: Path, repo: str, skill_path: str, ref: str) -> None:
    metadata = {
        "repo": repo,
        "path": skill_path,
        "ref": ref,
    }
    metadata_path = installed_dir / METADATA_FILE
    metadata_path.write_text(
        json.dumps(metadata, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )


def replace_installed_skill(
    installed_dir: Path,
    source_dir: Path,
    repo: str,
    skill_path: str,
    ref: str,
) -> None:
    parent_dir = installed_dir.parent
    tmp_root = Path(
        tempfile.mkdtemp(prefix=f".{installed_dir.name}.update-", dir=str(parent_dir))
    )
    staged_dir = tmp_root / installed_dir.name
    backup_dir = tmp_root / f"{installed_dir.name}.backup"

    try:
        shutil.copytree(source_dir, staged_dir)
        write_install_metadata(staged_dir, repo, skill_path, ref)

        os.replace(installed_dir, backup_dir)
        try:
            os.replace(staged_dir, installed_dir)
        except Exception:
            os.replace(backup_dir, installed_dir)
            raise

        shutil.rmtree(backup_dir)
    finally:
        shutil.rmtree(tmp_root, ignore_errors=True)


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Update an installed hs-init-project skill from a tagged GitHub release."
        )
    )
    parser.add_argument(
        "--skill-dir",
        help=(
            "Installed skill directory to update. Defaults to the current script's "
            "parent skill directory."
        ),
    )
    parser.add_argument(
        "--repo",
        help=(
            "GitHub repo in owner/repo format. Defaults to the bundled source metadata "
            f"or {DEFAULT_REPO}."
        ),
    )
    parser.add_argument(
        "--path",
        help=(
            "Relative skill path inside the GitHub repository. Defaults to the bundled "
            f"source metadata or {DEFAULT_SKILL_PATH}."
        ),
    )
    parser.add_argument(
        "--ref",
        default=DEFAULT_REF,
        help=(
            "Release tag to install, or 'latest' to resolve the latest GitHub release "
            f"(default: {DEFAULT_REF})."
        ),
    )
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)

    try:
        installed_dir = resolve_installed_skill_dir(args.skill_dir, DEFAULT_SKILL_PATH)
        repo, skill_path = resolve_source_config(installed_dir, args.repo, args.path)
        target_ref = resolve_ref(repo, args.ref)

        download_root = Path(tempfile.mkdtemp(prefix=".skill-download-"))
        try:
            repo_root = download_repo_zip(repo, target_ref, download_root)
            source_dir = locate_skill(repo_root, skill_path)
            replace_installed_skill(installed_dir, source_dir, repo, skill_path, target_ref)
        finally:
            shutil.rmtree(download_root, ignore_errors=True)
    except UpdateError as exc:
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 1

    print(f"Updated {installed_dir} to {target_ref} from {repo}/{skill_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))

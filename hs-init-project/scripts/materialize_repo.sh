#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ASSET_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/../assets" && pwd)

ROOT=""
LANGUAGE=""
TARGET="codex"
PROJECT_MODE=""
README_MODE=""
SOURCE_ROOT_DIR=""
OVERWRITE=0
DRY_RUN=0
INSPECT=0
PRESERVE_PATHS=""

usage() {
  cat <<'EOF'
Usage:
  materialize_repo.sh --root PATH --inspect
  materialize_repo.sh --root PATH --language en|ko [options]

Options:
  --root PATH                    Target repository root.
  --language en|ko               Generated document language.
  --target codex|claude|both     Agent entrypoint target. Default: codex.
  --project-mode fresh|existing  Repository operating mode. Inferred when omitted.
  --readme-mode create|merge|preserve
                                 README policy. Defaults to create for fresh and
                                 preserve for existing repositories.
  --source-root-dir PATH         Optional observed source-area hint.
  --preserve PATH                Protect an exact repository-relative path.
                                 Repeat for more paths.
  --overwrite                    Replace conflicting selected harness files.
                                 Never overrides --preserve.
  --inspect                      Print observed structure and planned conflicts.
  --dry-run                      Print the complete write plan without changing files.
  -h, --help                     Show this help.
EOF
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 2
}

require_value() {
  [ "$#" -ge 2 ] || die "missing value for $1"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --root)
      require_value "$@"
      ROOT=$2
      shift 2
      ;;
    --language)
      require_value "$@"
      LANGUAGE=$2
      shift 2
      ;;
    --target)
      require_value "$@"
      TARGET=$2
      shift 2
      ;;
    --project-mode)
      require_value "$@"
      PROJECT_MODE=$2
      shift 2
      ;;
    --readme-mode)
      require_value "$@"
      README_MODE=$2
      shift 2
      ;;
    --source-root-dir)
      require_value "$@"
      SOURCE_ROOT_DIR=$2
      shift 2
      ;;
    --preserve)
      require_value "$@"
      case "$2" in
        /*|../*|*/../*|*/..|..)
          die "--preserve must be a safe repository-relative path: $2"
          ;;
      esac
      PRESERVE_PATHS="${PRESERVE_PATHS}
$2"
      shift 2
      ;;
    --overwrite)
      OVERWRITE=1
      shift
      ;;
    --inspect)
      INSPECT=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown argument: $1"
      ;;
  esac
done

[ -n "$ROOT" ] || die "--root is required"

case "$TARGET" in
  codex|claude|both) ;;
  *) die "--target must be codex, claude, or both" ;;
esac

if [ -n "$PROJECT_MODE" ]; then
  case "$PROJECT_MODE" in
    fresh|existing) ;;
    *) die "--project-mode must be fresh or existing" ;;
  esac
fi

if [ -n "$README_MODE" ]; then
  case "$README_MODE" in
    create|merge|preserve) ;;
    *) die "--readme-mode must be create, merge, or preserve" ;;
  esac
fi

if [ ! -e "$ROOT" ]; then
  [ "$PROJECT_MODE" != "existing" ] || die "existing repository root does not exist: $ROOT"
  if [ "$DRY_RUN" -eq 0 ] && [ "$INSPECT" -eq 0 ]; then
    mkdir -p "$ROOT"
  fi
fi

if [ -d "$ROOT" ]; then
  ROOT=$(CDPATH= cd -- "$ROOT" && pwd)
else
  case "$ROOT" in
    /*) ;;
    *) ROOT="$(pwd)/$ROOT" ;;
  esac
fi

has_meaningful_content() {
  [ -d "$ROOT" ] || return 1
  find "$ROOT" -mindepth 1 -maxdepth 1 ! -name .git ! -name .DS_Store -print -quit 2>/dev/null | grep -q .
}

if [ -z "$PROJECT_MODE" ]; then
  if has_meaningful_content; then
    PROJECT_MODE=existing
  else
    PROJECT_MODE=fresh
  fi
fi

if [ -z "$README_MODE" ]; then
  if [ "$PROJECT_MODE" = existing ]; then
    README_MODE=preserve
  else
    README_MODE=create
  fi
fi

is_preserved() {
  rel=$1
  printf '%s\n' "$PRESERVE_PATHS" | grep -F -x -- "$rel" >/dev/null 2>&1
}

is_safe_destination() {
  rel=$1
  destination="$ROOT/$rel"

  [ ! -L "$destination" ] || return 1
  if [ -e "$destination" ] && [ ! -f "$destination" ]; then
    return 1
  fi

  parent=$(dirname "$destination")
  while [ "$parent" != "$ROOT" ]; do
    [ ! -L "$parent" ] || return 1
    if [ -e "$parent" ] && [ ! -d "$parent" ]; then
      return 1
    fi
    next_parent=$(dirname "$parent")
    [ "$next_parent" != "$parent" ] || return 1
    parent=$next_parent
  done
  return 0
}

has_valid_merge_markers() {
  readme=$1
  start_count=$(grep -c '^<!-- hs-init-project:start -->$' "$readme" 2>/dev/null || true)
  end_count=$(grep -c '^<!-- hs-init-project:end -->$' "$readme" 2>/dev/null || true)

  if [ "$start_count" -eq 0 ] && [ "$end_count" -eq 0 ]; then
    return 0
  fi
  [ "$start_count" -eq 1 ] && [ "$end_count" -eq 1 ] || return 1

  start_line=$(grep -n '^<!-- hs-init-project:start -->$' "$readme" | cut -d: -f1)
  end_line=$(grep -n '^<!-- hs-init-project:end -->$' "$readme" | cut -d: -f1)
  [ "$start_line" -lt "$end_line" ]
}

print_inspection() {
  printf 'Root: %s\n' "$ROOT"
  printf 'Observed mode: %s\n' "$PROJECT_MODE"
  printf 'Target: %s\n' "$TARGET"
  printf 'README mode: %s\n' "$README_MODE"
  if [ -n "$SOURCE_ROOT_DIR" ]; then
    printf 'Source hint: %s\n' "$SOURCE_ROOT_DIR"
  fi
  printf 'Relevant paths:\n'
  if [ -d "$ROOT" ]; then
    find "$ROOT" -mindepth 1 -maxdepth 2 \
      \( -name .git -o -name node_modules -o -name .venv -o -name vendor \) -prune -o \
      \( -name AGENTS.md -o -name CLAUDE.md -o -name PROJECT_OVERVIEW.md -o -name README.md -o -path '*/rule' -o -path '*/docs' -o -path '*/src' -o -path '*/test' -o -path '*/tests' \) \
      -print 2>/dev/null | sed "s|^$ROOT/|  - |"
  fi
  printf 'Selected output conflicts:\n'
  for rel in AGENTS.md PROJECT_OVERVIEW.md rule/index.md \
    rule/rules/project-structure.md rule/rules/development-standards.md \
    rule/rules/testing-standards.md rule/rules/documentation.md \
    rule/rules/agent-workflow.md; do
    if [ -e "$ROOT/$rel" ]; then
      printf '  - %s\n' "$rel"
    fi
  done
  case "$TARGET" in
    claude|both)
      [ ! -e "$ROOT/CLAUDE.md" ] || printf '  - CLAUDE.md\n'
      ;;
  esac
  [ ! -e "$ROOT/README.md" ] || printf '  - README.md (%s)\n' "$README_MODE"
}

if [ "$INSPECT" -eq 1 ]; then
  print_inspection
  exit 0
fi

case "$LANGUAGE" in
  en|ko) ;;
  *) die "--language must be en or ko" ;;
esac

TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/hs-init-project.XXXXXX")
trap 'rm -rf "$TMP_DIR"' EXIT HUP INT TERM
PLAN_FILE="$TMP_DIR/plan"
: > "$PLAN_FILE"

add_plan() {
  rel=$1
  template=$2
  [ -f "$template" ] || die "missing asset template: $template"
  printf '%s|%s\n' "$rel" "$template" >> "$PLAN_FILE"
}

add_plan AGENTS.md "$ASSET_DIR/AGENTS/root.$LANGUAGE.md"
add_plan PROJECT_OVERVIEW.md "$ASSET_DIR/PROJECT_OVERVIEW/root.$LANGUAGE.md"
add_plan rule/index.md "$ASSET_DIR/rule/index.$LANGUAGE.md"
add_plan rule/rules/project-structure.md "$ASSET_DIR/rule/project-structure.$LANGUAGE.md"
add_plan rule/rules/development-standards.md "$ASSET_DIR/rule/development-standards.$LANGUAGE.md"
add_plan rule/rules/testing-standards.md "$ASSET_DIR/rule/testing-standards.$LANGUAGE.md"
add_plan rule/rules/documentation.md "$ASSET_DIR/rule/documentation.$LANGUAGE.md"
add_plan rule/rules/agent-workflow.md "$ASSET_DIR/rule/agent-workflow.$LANGUAGE.md"

case "$TARGET" in
  claude|both)
    add_plan CLAUDE.md "$ASSET_DIR/CLAUDE/root.$LANGUAGE.md"
    ;;
esac

if [ "$README_MODE" = create ]; then
  add_plan README.md "$ASSET_DIR/README/root.$LANGUAGE.md"
fi

escape_sed_replacement() {
  printf '%s' "$1" | sed 's/[&|\\]/\\&/g'
}

render_template() {
  template=$1
  output=$2
  project_name=$(basename "$ROOT")
  escaped_name=$(escape_sed_replacement "$project_name")
  escaped_source=$(escape_sed_replacement "$SOURCE_ROOT_DIR")
  sed \
    -e "s|PROJECT_NAME|$escaped_name|g" \
    -e "s|SOURCE_ROOT_HINT|$escaped_source|g" \
    "$template" > "$output"
}

conflicts=0
while IFS='|' read -r rel template; do
  if is_preserved "$rel"; then
    printf 'PRESERVE %s\n' "$rel"
    continue
  fi
  if ! is_safe_destination "$rel"; then
    printf 'CONFLICT %s (destination or parent is not a regular in-repository path)\n' "$rel" >&2
    conflicts=$((conflicts + 1))
    continue
  fi
  rendered="$TMP_DIR/rendered"
  render_template "$template" "$rendered"
  if [ ! -e "$ROOT/$rel" ]; then
    printf 'CREATE %s\n' "$rel"
  elif cmp -s "$rendered" "$ROOT/$rel"; then
    printf 'UNCHANGED %s\n' "$rel"
  elif [ "$OVERWRITE" -eq 1 ]; then
    printf 'UPDATE %s\n' "$rel"
  else
    printf 'CONFLICT %s (use --overwrite or --preserve %s)\n' "$rel" "$rel" >&2
    conflicts=$((conflicts + 1))
  fi
done < "$PLAN_FILE"

if [ "$README_MODE" = preserve ]; then
  printf 'PRESERVE README.md\n'
elif [ "$README_MODE" = merge ]; then
  if is_preserved README.md; then
    printf 'PRESERVE README.md\n'
  elif ! is_safe_destination README.md; then
    printf 'CONFLICT README.md (destination or parent is not a regular in-repository path)\n' >&2
    conflicts=$((conflicts + 1))
  elif [ -e "$ROOT/README.md" ] && ! has_valid_merge_markers "$ROOT/README.md"; then
    printf 'CONFLICT README.md (incomplete, duplicate, or out-of-order hs-init-project markers)\n' >&2
    conflicts=$((conflicts + 1))
  elif [ -e "$ROOT/README.md" ]; then
    printf 'MERGE README.md\n'
  else
    printf 'CREATE README.md\n'
  fi
fi

[ "$conflicts" -eq 0 ] || die "$conflicts unresolved file conflict(s); no files were written"

if [ "$DRY_RUN" -eq 1 ]; then
  printf 'Dry run complete; no files were written.\n'
  exit 0
fi

while IFS='|' read -r rel template; do
  is_preserved "$rel" && continue
  rendered="$TMP_DIR/rendered"
  render_template "$template" "$rendered"
  if [ -e "$ROOT/$rel" ] && cmp -s "$rendered" "$ROOT/$rel"; then
    continue
  fi
  mkdir -p "$(dirname "$ROOT/$rel")"
  cp "$rendered" "$ROOT/$rel"
done < "$PLAN_FILE"

merge_readme() {
  template=$1
  destination=$2
  rendered="$TMP_DIR/readme-template"
  section="$TMP_DIR/readme-section"
  merged="$TMP_DIR/readme-merged"
  render_template "$template" "$rendered"

  awk '
    /^<!-- hs-init-project:start -->$/ { capture=1 }
    capture { print }
    /^<!-- hs-init-project:end -->$/ { exit }
  ' "$rendered" > "$section"

  grep -q '^<!-- hs-init-project:start -->$' "$section" || die "README asset is missing the start marker"
  grep -q '^<!-- hs-init-project:end -->$' "$section" || die "README asset is missing the end marker"

  if [ ! -e "$destination" ]; then
    cp "$rendered" "$destination"
    return
  fi

  start_count=$(grep -c '^<!-- hs-init-project:start -->$' "$destination" || true)
  end_count=$(grep -c '^<!-- hs-init-project:end -->$' "$destination" || true)

  if [ "$start_count" -eq 0 ] && [ "$end_count" -eq 0 ]; then
    cp "$destination" "$merged"
    printf '\n' >> "$merged"
    cat "$section" >> "$merged"
    cp "$merged" "$destination"
    return
  fi

  [ "$start_count" -eq 1 ] && [ "$end_count" -eq 1 ] || \
    die "README contains incomplete or duplicate hs-init-project markers"

  awk -v section_file="$section" '
    BEGIN {
      replacement=""
      while ((getline line < section_file) > 0) {
        replacement = replacement line ORS
      }
      close(section_file)
    }
    /^<!-- hs-init-project:start -->$/ {
      printf "%s", replacement
      inside=1
      next
    }
    inside && /^<!-- hs-init-project:end -->$/ {
      inside=0
      next
    }
    !inside { print }
  ' "$destination" > "$merged"
  cp "$merged" "$destination"
}

if [ "$README_MODE" = merge ] && ! is_preserved README.md; then
  merge_readme "$ASSET_DIR/README/root.$LANGUAGE.md" "$ROOT/README.md"
fi

printf 'Materialized minimal %s harness at %s\n' "$TARGET" "$ROOT"
printf 'Project mode: %s; README mode: %s; language: %s\n' "$PROJECT_MODE" "$README_MODE" "$LANGUAGE"
if [ -n "$SOURCE_ROOT_DIR" ]; then
  printf 'Observed source hint: %s\n' "$SOURCE_ROOT_DIR"
fi

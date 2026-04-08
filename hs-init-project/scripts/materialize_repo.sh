#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SKILL_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

usage() {
  cat <<'EOF'
Usage: materialize_repo.sh TARGET_DIR --language <1|2|English|Korean(한국어)|en|ko> [options]

Options:
  --inspect
  --confirm-existing-docs
  --confirm-existing-rule
  --source-root-dir <dir>
  --non-runtime-dirs <comma-separated dirs>
  --readme-mode <fresh|existing|skip>
  --overwrite
EOF
}

die() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

normalize_language() {
  value=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
  case "$value" in
    1|english|en)
      printf 'en\n'
      ;;
    2|korean|'korean(한국어)'|한국어|ko)
      printf 'ko\n'
      ;;
    *)
      return 1
      ;;
  esac
}

normalize_dirs() {
  raw=${1-}
  if [ -z "$raw" ]; then
    return 0
  fi

  printf '%s' "$raw" \
    | tr ',' '\n' \
    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' \
    | awk '
        NF {
          if ($0 !~ /\/$/) {
            $0 = $0 "/"
          }
          if (!seen[$0]++) {
            print
          }
        }
      '
}

normalize_single_dir() {
  raw=${1-}
  if [ -z "$raw" ]; then
    return 0
  fi

  normalized=$(normalize_dirs "$raw")
  count=$(printf '%s\n' "$normalized" | sed '/^$/d' | wc -l | tr -d ' ')
  if [ "$count" -gt 1 ]; then
    return 1
  fi
  printf '%s\n' "$normalized"
}

merge_non_runtime_dirs() {
  {
    printf '.codex/\n'
    printf 'rule/\n'
    printf 'docs/\n'
    printf 'subagents_docs/\n'
    printf '%s\n' "${1-}"
  } | sed '/^$/d' | awk '!seen[$0]++'
}

render_bullets() {
  input=${1-}
  if [ -z "$input" ]; then
    return 0
  fi

  printf '%s\n' "$input" | while IFS= read -r line; do
    [ -n "$line" ] || continue
    printf -- '- `%s`\n' "$line"
  done
}

list_top_level_dirs() {
  target_dir=$1
  find "$target_dir" -mindepth 1 -maxdepth 1 -type d ! -name '.git' \
    | while IFS= read -r path; do
        printf '%s/\n' "$(basename "$path")"
      done \
    | sort
}

list_top_level_files() {
  target_dir=$1
  find "$target_dir" -mindepth 1 -maxdepth 1 -type f ! -name 'README.md' \
    | while IFS= read -r path; do
        printf '%s\n' "$(basename "$path")"
      done \
    | sort
}

detect_tooling_files() {
  files=${1-}
  if [ -z "$files" ]; then
    return 0
  fi

  printf '%s\n' "$files" | while IFS= read -r name; do
    case "$name" in
      .editorconfig|.prettierrc|.prettierrc.json|.prettierrc.js|.prettierrc.cjs|\
      .eslintrc|.eslintrc.js|.eslintrc.cjs|.eslintrc.json|.eslintignore|\
      package.json|package-lock.json|pnpm-lock.yaml|yarn.lock|tsconfig.json|\
      pyproject.toml|requirements.txt|poetry.lock|Pipfile|Pipfile.lock|\
      go.mod|go.sum|Cargo.toml|Cargo.lock|pom.xml|build.gradle|build.gradle.kts|\
      settings.gradle|settings.gradle.kts|gradle.properties|composer.json|composer.lock|\
      Makefile|justfile|ruff.toml|tox.ini|.eslintrc*|.prettierrc*)
        printf '%s\n' "$name"
        ;;
    esac
  done | awk '!seen[$0]++'
}

detect_test_dirs() {
  dirs=${1-}
  if [ -z "$dirs" ]; then
    return 0
  fi

  printf '%s\n' "$dirs" | while IFS= read -r name; do
    case "$name" in
      test/|tests/|spec/|specs/|e2e/|cypress/|playwright/)
        printf '%s\n' "$name"
        ;;
    esac
  done | awk '!seen[$0]++'
}

detect_test_tooling_files() {
  files=${1-}
  if [ -z "$files" ]; then
    return 0
  fi

  printf '%s\n' "$files" | while IFS= read -r name; do
    case "$name" in
      playwright.config.js|playwright.config.ts|playwright.config.mjs|playwright.config.cjs|\
      cypress.config.js|cypress.config.ts|cypress.config.mjs|cypress.config.cjs|\
      jest.config.js|jest.config.ts|jest.config.mjs|jest.config.cjs|\
      vitest.config.js|vitest.config.ts|vitest.config.mjs|vitest.config.cjs|\
      pytest.ini|tox.ini|playwright.config.*|cypress.config.*|jest.config.*|vitest.config.*)
        printf '%s\n' "$name"
        ;;
    esac
  done | awk '!seen[$0]++'
}

detect_runtime_candidates() {
  dirs=${1-}
  if [ -z "$dirs" ]; then
    return 0
  fi

  printf '%s\n' "$dirs" | while IFS= read -r name; do
    base_name=$(printf '%s' "$name" | sed 's:/*$::')
    case "$base_name" in
      src|source|app|apps|backend|frontend|web|www|site|sites|client|clients|server|servers|api|apis|service|services|worker|workers|package|packages|pkg|cmd|internal|lib|libs)
        printf '%s/\n' "$base_name"
        ;;
    esac
  done | awk '!seen[$0]++'
}

list_docs_children() {
  target_dir=$1
  if [ ! -d "$target_dir/docs" ]; then
    return 0
  fi

  find "$target_dir/docs" -mindepth 1 -maxdepth 1 | while IFS= read -r path; do
    if [ -d "$path" ]; then
      printf '%s/\n' "$(basename "$path")"
    else
      printf '%s\n' "$(basename "$path")"
    fi
  done | sort
}

docs_tree_requires_confirmation() {
  docs_children=${1-}
  if [ -z "$docs_children" ]; then
    return 1
  fi

  printf '%s\n' "$docs_children" | awk '
    NF {
      if ($0 != "guide/" && $0 != "implementation/") {
        found = 1
      }
    }
    END {
      exit(found ? 0 : 1)
    }
  '
}

list_rule_entries() {
  target_dir=$1
  rule_dir=$target_dir/rule

  if [ ! -d "$rule_dir" ]; then
    return 0
  fi

  find "$rule_dir" -mindepth 1 -maxdepth 3 | while IFS= read -r path; do
    relative_path=${path#"$rule_dir"/}
    if [ -d "$path" ]; then
      printf '%s/\n' "${relative_path%/}"
    else
      printf '%s\n' "$relative_path"
    fi
  done | sort
}

rule_tree_requires_confirmation() {
  rule_entries=${1-}
  if [ -z "$rule_entries" ]; then
    return 1
  fi

  printf '%s\n' "$rule_entries" | awk '
    BEGIN {
      allow["index.md"] = 1
      allow["rules/"] = 1
      allow["rules/project-structure.md"] = 1
      allow["rules/instruction-model.md"] = 1
      allow["rules/rule-maintenance.md"] = 1
      allow["rules/documentation-boundaries.md"] = 1
      allow["rules/cycle-document-contract.md"] = 1
      allow["rules/language-policy.md"] = 1
      allow["rules/readme-maintenance.md"] = 1
      allow["rules/development-standards.md"] = 1
      allow["rules/testing-standards.md"] = 1
      allow["rules/runtime-boundaries.md"] = 1
      allow["rules/implementation-records.md"] = 1
      allow["rules/subagent-orchestration.md"] = 1
      allow["rules/subagents-docs.md"] = 1
    }
    NF {
      if (!allow[$0]) {
        found = 1
      }
    }
    END {
      exit(found ? 0 : 1)
    }
  '
}

list_planned_outputs() {
  readme_mode=$1

  if [ "$readme_mode" != "skip" ]; then
    printf 'README.md\n'
  fi

  cat <<'EOF'
AGENTS.md
.codex/config.toml
.codex/agents/evaluator.toml
.codex/agents/generator.toml
.codex/agents/planner.toml
docs/guide/README.md
docs/implementation/AGENTS.md
.codex/skills/change-analysis/SKILL.md
.codex/skills/change-analysis/agents/openai.yaml
.codex/skills/code-implementation/SKILL.md
.codex/skills/code-implementation/agents/openai.yaml
.codex/skills/test-debug/SKILL.md
.codex/skills/test-debug/agents/openai.yaml
.codex/skills/docs-sync/SKILL.md
.codex/skills/docs-sync/agents/openai.yaml
.codex/skills/quality-review/SKILL.md
.codex/skills/quality-review/agents/openai.yaml
subagents_docs/AGENTS.md
rule/index.md
rule/rules/instruction-model.md
rule/rules/rule-maintenance.md
rule/rules/documentation-boundaries.md
rule/rules/readme-maintenance.md
rule/rules/implementation-records.md
rule/rules/development-standards.md
rule/rules/testing-standards.md
rule/rules/project-structure.md
rule/rules/runtime-boundaries.md
rule/rules/subagent-orchestration.md
rule/rules/subagents-docs.md
EOF
}

detect_conflicting_outputs() {
  target_dir=$1
  readme_mode=$2

  list_planned_outputs "$readme_mode" | while IFS= read -r relative_path; do
    [ -n "$relative_path" ] || continue
    if [ -e "$target_dir/$relative_path" ]; then
      printf '%s\n' "$relative_path"
    fi
  done
}

print_inspection_summary() {
  language=$1
  readme_mode=$2
  runtime_candidates=$3
  docs_children=$4
  rule_entries=$5
  conflicting_outputs=$6
  runtime_needs_input=$7
  docs_needs_input=$8
  rule_needs_input=$9
  overwrite_needs_input=${10}

  needs_input=0
  if [ "$runtime_needs_input" -eq 1 ] || [ "$docs_needs_input" -eq 1 ] || [ "$rule_needs_input" -eq 1 ] || [ "$overwrite_needs_input" -eq 1 ]; then
    needs_input=1
  fi

  if [ "$language" = "ko" ]; then
    printf '[INSPECT]\n'
    if [ "$needs_input" -eq 1 ]; then
      printf -- '- 상태: 사용자 답변 필요\n'
    else
      printf -- '- 상태: 적용 가능\n'
    fi
    printf -- '- 모드: %s\n' "$readme_mode"

    if [ -n "$runtime_candidates" ]; then
      printf -- '- 감지한 source root 후보:\n'
      render_bullets "$runtime_candidates"
    fi

    if [ -n "$docs_children" ]; then
      printf -- '- 기존 docs/ 항목:\n'
      render_bullets "$docs_children"
    fi

    if [ -n "$rule_entries" ]; then
      printf -- '- 기존 rule/ 항목:\n'
      render_bullets "$rule_entries"
    fi

    if [ -n "$conflicting_outputs" ]; then
      printf -- '- 이미 존재하는 생성 대상 파일:\n'
      render_bullets "$conflicting_outputs"
    fi

    if [ "$needs_input" -eq 1 ]; then
      question_index=1
      printf '\n## 사용자에게 물을 내용\n'
      if [ "$runtime_needs_input" -eq 1 ]; then
        if [ -n "$runtime_candidates" ]; then
          printf '%s. 다음 후보 중 어떤 하나를 단일 source root로 취급할지, 또는 별도 source root를 도입할지 확인해 달라고 묻는다.\n' "$question_index"
          render_bullets "$runtime_candidates"
        else
          printf '%s. 어떤 디렉토리를 단일 source root로, 어떤 디렉토리를 non-runtime으로 볼지 묻는다.\n' "$question_index"
        fi
        question_index=$((question_index + 1))
      fi
      if [ "$docs_needs_input" -eq 1 ]; then
        printf '%s. 기존 `docs/` 내용을 유지한 채 `docs/guide/`와 `docs/implementation/`을 추가해도 되는지, 그리고 건드리지 말아야 할 기존 docs 경로가 있는지 묻는다.\n' "$question_index"
        question_index=$((question_index + 1))
      fi
      if [ "$rule_needs_input" -eq 1 ]; then
        printf '%s. 기존 `rule/` 내용을 유지한 채 `rule/index.md`와 `rule/rules/` 아래 누락된 starter rule만 추가해도 되는지, 그리고 건드리지 말아야 할 기존 rule 경로가 있는지 묻는다.\n' "$question_index"
        question_index=$((question_index + 1))
      fi
      if [ "$overwrite_needs_input" -eq 1 ]; then
        printf '%s. 이미 존재하는 제어 파일을 현재 내용 기준으로 갱신해도 되는지 묻는다.\n' "$question_index"
      fi
    fi
    return 0
  fi

  printf '[INSPECT]\n'
  if [ "$needs_input" -eq 1 ]; then
    printf -- '- Status: needs user input\n'
  else
    printf -- '- Status: ready to apply\n'
  fi
  printf -- '- Mode: %s\n' "$readme_mode"

  if [ -n "$runtime_candidates" ]; then
    printf -- '- Detected source-root candidates:\n'
    render_bullets "$runtime_candidates"
  fi

  if [ -n "$docs_children" ]; then
    printf -- '- Existing docs/ entries:\n'
    render_bullets "$docs_children"
  fi

  if [ -n "$rule_entries" ]; then
    printf -- '- Existing rule/ entries:\n'
    render_bullets "$rule_entries"
  fi

  if [ -n "$conflicting_outputs" ]; then
    printf -- '- Existing generated-target files:\n'
    render_bullets "$conflicting_outputs"
  fi

  if [ "$needs_input" -eq 1 ]; then
    question_index=1
    printf '\n## Ask The User\n'
    if [ "$runtime_needs_input" -eq 1 ]; then
      if [ -n "$runtime_candidates" ]; then
        printf '%s. Confirm which single directory should be treated as the source root, or whether a new source root should be introduced in guidance.\n' "$question_index"
        render_bullets "$runtime_candidates"
      else
        printf '%s. Ask which directory should be treated as the single source root and which directories should be treated as non-runtime.\n' "$question_index"
      fi
      question_index=$((question_index + 1))
    fi
    if [ "$docs_needs_input" -eq 1 ]; then
      printf '%s. Ask whether it is acceptable to keep the current `docs/` tree and add `docs/guide/` and `docs/implementation/` alongside it, and whether any existing docs paths must stay untouched.\n' "$question_index"
      question_index=$((question_index + 1))
    fi
    if [ "$rule_needs_input" -eq 1 ]; then
      printf '%s. Ask whether it is acceptable to keep the current `rule/` tree and add only the missing starter rules under `rule/index.md` and `rule/rules/`, and whether any existing rule paths must stay untouched.\n' "$question_index"
      question_index=$((question_index + 1))
    fi
    if [ "$overwrite_needs_input" -eq 1 ]; then
      printf '%s. Ask whether the existing control files may be updated in place.\n' "$question_index"
    fi
  fi
}

ensure_can_write() {
  destination=$1
  if [ -e "$destination" ] && [ "$OVERWRITE" -ne 1 ]; then
    die "Refusing to overwrite existing file without --overwrite: $destination"
  fi
}

write_text() {
  destination=$1
  content=$2
  ensure_can_write "$destination"
  mkdir -p "$(dirname "$destination")"
  printf '%s\n' "$content" > "$destination"
}

copy_template() {
  relative_path=$1
  destination=$2
  ensure_can_write "$destination"
  mkdir -p "$(dirname "$destination")"
  cp "$SKILL_DIR/$relative_path" "$destination"
}

make_runtime_body() {
  language=$1
  runtime_dirs=$2

  if [ "$language" = "ko" ]; then
    if [ -n "$runtime_dirs" ]; then
      printf '%s\n\n' '프로젝트 루트 아래 구현체를 모으는 단일 source root 디렉토리를 여기에 적는다.'
      render_bullets "$runtime_dirs"
      return 0
    fi

    cat <<'EOF'
아직 확정된 source root 디렉토리가 없다.

예시 placeholder:

- `[source-root-directory]`
EOF
    return 0
  fi

  if [ -n "$runtime_dirs" ]; then
    printf '%s\n\n' 'List the single source-root directory that groups implementation areas under the project root.'
    render_bullets "$runtime_dirs"
    return 0
  fi

  cat <<'EOF'
No source-root directory is defined yet.

Example placeholder:

- `[source-root-directory]`
EOF
}

make_non_runtime_body() {
  language=$1
  non_runtime_dirs=$2
  merged_non_runtime_dirs=$(merge_non_runtime_dirs "$non_runtime_dirs")

  if [ "$language" = "ko" ]; then
    printf '%s\n\n' 'non-runtime으로 취급하는 디렉토리를 여기에 적는다.'
    render_bullets "$merged_non_runtime_dirs"
    return 0
  fi

  printf '%s\n\n' 'List the directories treated as non-runtime here.'
  render_bullets "$merged_non_runtime_dirs"
}

build_existing_guide_readme() {
  language=$1
  docs_children=$2

  if [ "$language" = "ko" ]; then
    if [ -n "$docs_children" ]; then
      existing_docs_block=$(render_bullets "$docs_children")
    else
      existing_docs_block='기존 top-level docs 항목은 관찰되지 않았다.'
    fi

    cat <<EOF
# 안내 문서 디렉토리

이 디렉토리는 사람이 실제로 따라야 하는 사용자 가이드를 위한 공간이다.
이 \`README.md\`는 이 디렉토리의 기본 진입점이자 안내 문서 인덱스 역할을 한다.

## 현재 상태

- 초기화 단계에서는 이 \`README.md\`를 기본 생성한다.
- 실행 가이드, 배포 가이드, 테스트 실행 가이드, 디자인 요청 가이드처럼 실제 사용자가 따라야 하는 워크플로가 확인되면 관련 문서를 추가한다.

## 초기화 시점에 관찰된 기존 docs 신호

$existing_docs_block

## 문서 운영 원칙

- 실제 사용자 워크플로가 분명해질 때만 이 인덱스에 관련 guide 문서를 추가한다.
- 문서 수가 늘어나면 이 \`README.md\`를 인덱스로 유지하고, 세부 내용은 개별 문서로 분리한다.
- 저장소 구조 요약, 구현 상세, 규칙 복사본은 이 디렉토리에 두지 않는다.
- 독자가 따라야 할 안내만 두고, 실행 규칙은 root [\`AGENTS.md\`](../../AGENTS.md), [\`rule/index.md\`](../../rule/index.md), 그리고 \`rule/rules/\` 아래 문서를 기준으로 본다.
EOF
    return 0
  fi

  if [ -n "$docs_children" ]; then
    existing_docs_block=$(render_bullets "$docs_children")
  else
    existing_docs_block='No existing top-level docs entries were observed.'
  fi

  cat <<EOF
# Guide Directory

Use this directory for user-facing workflow guides.
This \`README.md\` acts as the entry point and index for the guide set.

## Current State

- This \`README.md\` is the default guide file created at initialization time.
- Add focused documents only when readers need a real workflow guide, such as running, deploying, testing, operations, or request intake.

## Existing Docs Signals Observed At Initialization

$existing_docs_block

## Documentation Maintenance

- Add guide documents to this index only when a real user-facing workflow needs to be documented.
- Keep this \`README.md\` as the guide entry point and move detail into focused documents.
- Do not use this directory for repository maps, implementation details, or copied rule text.
- Keep reader guidance here and keep execution rules anchored to root [\`AGENTS.md\`](../../AGENTS.md), [\`rule/index.md\`](../../rule/index.md), and the documents under \`rule/rules/\`.
EOF
}

build_existing_readme() {
  language=$1
  target_dir=$2
  runtime_dirs=$3
  non_runtime_dirs=$4
  observed_dirs=$5
  observed_files=$6
  project_name=$(basename "$target_dir")
  merged_non_runtime_dirs=$(merge_non_runtime_dirs "$non_runtime_dirs")

  if [ "$language" = "ko" ]; then
    if [ -n "$runtime_dirs" ]; then
      runtime_block=$(render_bullets "$runtime_dirs")
    else
      runtime_block='아직 확정된 source root가 없다.'
    fi

    non_runtime_block=$(render_bullets "$merged_non_runtime_dirs")

    if [ -n "$observed_dirs" ]; then
      observed_dir_block=$(render_bullets "$observed_dirs")
    else
      observed_dir_block='관찰된 최상위 디렉토리가 아직 없다.'
    fi

    if [ -n "$observed_files" ]; then
      observed_file_block=$(render_bullets "$observed_files")
    else
      observed_file_block='관찰된 주요 최상위 파일이 아직 없다.'
    fi

    cat <<EOF
# $project_name

짧은 설명 placeholder. 이 문장을 프로젝트 한 줄 소개로 교체한다.

## 목적

이 저장소는 Codex 작업 구조를 추가하기 전에 이미 프로젝트 내용을 가지고 있었다.
프로젝트의 실제 목적과 서비스 설명이 분명해지면 이 섹션을 관찰된 사실에 맞게 갱신한다.

## 관찰된 프로젝트 영역

초기화 시점에 관찰된 최상위 디렉토리:

$observed_dir_block

초기화 시점에 관찰된 주요 최상위 파일:

$observed_file_block

## Source Root

$runtime_block

## Non-Runtime 영역

$non_runtime_block

## README 운영

이 README는 오래 유지되는 프로젝트 설명과 탐색 정보를 요약하는 문서로 유지한다.
세부 참고 문서가 늘어나면 자세한 내용은 [\`docs/guide/README.md\`](docs/guide/README.md)를 시작점으로 두는 \`docs/guide/\`로 옮기고, 여기서는 [\`AGENTS.md\`](AGENTS.md), [\`rule/index.md\`](rule/index.md), [\`docs/guide/README.md\`](docs/guide/README.md), [\`docs/implementation/AGENTS.md\`](docs/implementation/AGENTS.md) 같은 핵심 진입점만 연결한다.
실제 진입점 문서나 제어문서를 가리킬 때는 Markdown 링크를 사용하고, placeholder나 아직 생성되지 않은 경로는 path literal로 남긴다.
EOF
    return 0
  fi

  if [ -n "$runtime_dirs" ]; then
    runtime_block=$(render_bullets "$runtime_dirs")
  else
    runtime_block='The source root is not confirmed yet.'
  fi

  non_runtime_block=$(render_bullets "$merged_non_runtime_dirs")

  if [ -n "$observed_dirs" ]; then
    observed_dir_block=$(render_bullets "$observed_dirs")
  else
    observed_dir_block='No top-level directories were observed yet.'
  fi

  if [ -n "$observed_files" ]; then
    observed_file_block=$(render_bullets "$observed_files")
  else
    observed_file_block='No significant top-level files were observed yet.'
  fi

  cat <<EOF
# $project_name

Short description placeholder. Replace this sentence with a concise summary of the project.

## Purpose

This repository already contained project content before the Codex working structure was added.
Refine this section with the actual product or service description as the observed project purpose becomes clearer.

## Observed Project Areas

Top-level directories observed during initialization:

$observed_dir_block

Top-level files observed during initialization:

$observed_file_block

## Source Root

$runtime_block

## Non-Runtime Areas

$non_runtime_block

## README Maintenance

Keep this README focused on durable project-facing facts and navigation.
As deeper reference material grows, move it into \`docs/guide/\` with [\`docs/guide/README.md\`](docs/guide/README.md) as the guide entry point, and keep links to key control documents such as [\`AGENTS.md\`](AGENTS.md), [\`rule/index.md\`](rule/index.md), [\`docs/guide/README.md\`](docs/guide/README.md), and [\`docs/implementation/AGENTS.md\`](docs/implementation/AGENTS.md) high-signal here.
Use Markdown links for real entrypoint or control documents, and leave placeholders or not-yet-created paths as plain literals.
EOF
}

build_change_analysis_skill() {
  language=$1
  skill_mode=$2
  runtime_dirs=$3
  observed_dirs=$4
  docs_children=$5

  if [ "$skill_mode" = "existing" ]; then
    if [ "$language" = "ko" ]; then
      if [ -n "$runtime_dirs" ]; then
        runtime_block=$(render_bullets "$runtime_dirs")
      else
        runtime_block='- 아직 확정된 source root가 없다.'
      fi

      if [ -n "$observed_dirs" ]; then
        observed_dir_block=$(render_bullets "$observed_dirs")
      else
        observed_dir_block='- 관찰된 최상위 디렉토리가 아직 없다.'
      fi

      if [ -n "$docs_children" ]; then
        docs_block=$(render_bullets "$docs_children")
      else
        docs_block='- 관찰된 top-level docs 신호가 아직 없다.'
      fi

      cat <<EOF
---
name: change-analysis
description: 요구사항 해석, 영향 범위 파악, acceptance criteria 정리, non-goal과 위험 식별 같은 변경 분석 작업에 사용한다. 구현이 확정되지 않은 상태에서는 이 skill을 우선 사용한다.
---

# Change Analysis

작성 전에 [\`rule/index.md\`](../../../rule/index.md), [\`rule/rules/instruction-model.md\`](../../../rule/rules/instruction-model.md), [\`rule/rules/subagent-orchestration.md\`](../../../rule/rules/subagent-orchestration.md), [\`rule/rules/cycle-document-contract.md\`](../../../rule/rules/cycle-document-contract.md), [\`rule/rules/language-policy.md\`](../../../rule/rules/language-policy.md)를 읽는다.

이 저장소는 기존 프로젝트를 관찰한 뒤 Codex 구조를 얹은 상태다. 변경 분석은 아래 관찰 신호부터 시작한다.

## 관찰된 source root

$runtime_block

## 관찰된 최상위 구조

$observed_dir_block

## 관찰된 docs 신호

$docs_block

- 영향 범위, acceptance criteria, non-goal, 위험 요소를 위 관찰 영역 기준으로 정리한다.
- 작업을 \`small\`, \`medium\`, \`large-clear\`, \`large-ambiguous\`로 분류한 뒤 하네스 경로를 고른다.
- 독립적인 문서 분석 질문은 병렬 \`explorer\` 호출을 우선 고려한다.
- 기존 docs/rule 신호가 있으면 generic placeholder보다 우선 참조한다.
- 구현 자체를 대신하지 않고, 관련 근거는 cycle 문서와 rule 문서에 참조형으로 남긴다.
EOF
      return 0
    fi

    if [ -n "$runtime_dirs" ]; then
      runtime_block=$(render_bullets "$runtime_dirs")
    else
        runtime_block='- The source root is not confirmed yet.'
    fi

    if [ -n "$observed_dirs" ]; then
      observed_dir_block=$(render_bullets "$observed_dirs")
    else
      observed_dir_block='- No top-level directories were observed yet.'
    fi

    if [ -n "$docs_children" ]; then
      docs_block=$(render_bullets "$docs_children")
    else
      docs_block='- No top-level docs signals were observed yet.'
    fi

    cat <<EOF
---
name: change-analysis
description: Use for change analysis work such as interpreting requests, mapping impact scope, defining acceptance criteria, and identifying non-goals and risks before implementation is locked in.
---

# Change Analysis

Read [\`rule/index.md\`](../../../rule/index.md), [\`rule/rules/instruction-model.md\`](../../../rule/rules/instruction-model.md), [\`rule/rules/subagent-orchestration.md\`](../../../rule/rules/subagent-orchestration.md), [\`rule/rules/cycle-document-contract.md\`](../../../rule/rules/cycle-document-contract.md), and [\`rule/rules/language-policy.md\`](../../../rule/rules/language-policy.md) before writing.

This repository was inspected before the Codex structure was added. Start change analysis from these observed signals.

## Observed Source Root

$runtime_block

## Observed Top-Level Structure

$observed_dir_block

## Observed Docs Signals

$docs_block

- Define impact scope, acceptance criteria, non-goals, and risks from the observed areas first.
- Classify the work as \`small\`, \`medium\`, \`large-clear\`, or \`large-ambiguous\` before choosing the harness path.
- Prefer parallel \`explorer\` calls for independent document-analysis questions.
- Prefer observed docs and rule signals over generic placeholders when they already exist.
- Do not use this as an implementation shortcut; keep rationale referenced through cycle and rule documents.
EOF
    return 0
  fi

  copy_template_body=$SKILL_DIR/assets/.codex/skills/change-analysis/SKILL.$language.md
  cat "$copy_template_body"
}

build_code_implementation_skill() {
  language=$1
  skill_mode=$2
  runtime_dirs=$3
  tooling_files=$4

  if [ "$skill_mode" = "existing" ]; then
    if [ "$language" = "ko" ]; then
      if [ -n "$runtime_dirs" ]; then
        runtime_block=$(render_bullets "$runtime_dirs")
      else
        runtime_block='- 아직 확정된 source root가 없다.'
      fi

      if [ -n "$tooling_files" ]; then
        tooling_block=$(render_bullets "$tooling_files")
      else
        tooling_block='- 관찰된 top-level 툴링 또는 설정 파일이 아직 없다.'
      fi

      cat <<EOF
---
name: code-implementation
description: 승인된 변경 계획을 기준으로 코드, 설정, 스크립트, 템플릿을 수정하고 집중된 검증을 수행하는 구현 작업에 사용한다.
---

# Code Implementation

편집 전에 [\`rule/index.md\`](../../../rule/index.md), [\`rule/rules/instruction-model.md\`](../../../rule/rules/instruction-model.md), [\`rule/rules/subagent-orchestration.md\`](../../../rule/rules/subagent-orchestration.md), [\`rule/rules/cycle-document-contract.md\`](../../../rule/rules/cycle-document-contract.md), [\`rule/rules/language-policy.md\`](../../../rule/rules/language-policy.md)를 읽는다.

이 저장소는 기존 프로젝트 신호를 관찰한 상태이므로 구현은 아래 영역과 툴링부터 우선 고려한다.

## 관찰된 source root

$runtime_block

## 관찰된 툴링 또는 설정 파일

$tooling_block

- 승인된 변경 계획 기준으로 위 source root를 우선 수정 대상으로 본다.
- 관찰된 툴링과 설정 파일이 있으면 그 신호에 맞춰 검증과 편집 범위를 맞춘다.
- user-facing 문서와 working record를 섞지 않고, 구현 근거는 cycle 문서와 rule 문서를 참조형으로 남긴다.
EOF
      return 0
    fi

    if [ -n "$runtime_dirs" ]; then
      runtime_block=$(render_bullets "$runtime_dirs")
    else
      runtime_block='- The source root is not confirmed yet.'
    fi

    if [ -n "$tooling_files" ]; then
      tooling_block=$(render_bullets "$tooling_files")
    else
      tooling_block='- No top-level tooling or config files were observed yet.'
    fi

    cat <<EOF
---
name: code-implementation
description: Use for implementation work that updates code, config, scripts, or templates from an approved change plan and pairs the edits with focused verification.
---

# Code Implementation

Read [\`rule/index.md\`](../../../rule/index.md), [\`rule/rules/instruction-model.md\`](../../../rule/rules/instruction-model.md), [\`rule/rules/subagent-orchestration.md\`](../../../rule/rules/subagent-orchestration.md), [\`rule/rules/cycle-document-contract.md\`](../../../rule/rules/cycle-document-contract.md), and [\`rule/rules/language-policy.md\`](../../../rule/rules/language-policy.md) before editing.

This repository was inspected before the Codex structure was added, so implementation should start from the observed source root and tooling signals below.

## Observed Source Root

$runtime_block

## Observed Tooling Or Config Files

$tooling_block

- Apply the approved plan to the observed source root first.
- Let observed tooling and config files shape the editing and verification path when they exist.
- Keep user-facing docs separate from working records and leave rationale referenced through cycle and rule documents.
EOF
    return 0
  fi

  copy_template_body=$SKILL_DIR/assets/.codex/skills/code-implementation/SKILL.$language.md
  cat "$copy_template_body"
}

build_test_debug_skill() {
  language=$1
  skill_mode=$2
  test_dirs=$3
  test_tooling_files=$4

  if [ "$skill_mode" = "existing" ]; then
    if [ "$language" = "ko" ]; then
      if [ -n "$test_dirs" ]; then
        test_dir_block=$(render_bullets "$test_dirs")
      else
        test_dir_block='- 관찰된 테스트 디렉토리가 아직 없다.'
      fi

      if [ -n "$test_tooling_files" ]; then
        test_tooling_block=$(render_bullets "$test_tooling_files")
      else
        test_tooling_block='- 관찰된 테스트 설정 파일이 아직 없다.'
      fi

      cat <<EOF
---
name: test-debug
description: 버그 재현, 원인 축소, 테스트 추가/수정, 검증 자동화, 수동 검증 정리 같은 테스트와 디버깅 작업에 사용한다.
---

# Test Debug

작성 전에 [\`rule/index.md\`](../../../rule/index.md), [\`rule/rules/testing-standards.md\`](../../../rule/rules/testing-standards.md), [\`rule/rules/instruction-model.md\`](../../../rule/rules/instruction-model.md), [\`rule/rules/language-policy.md\`](../../../rule/rules/language-policy.md)를 읽는다.

이 저장소에서는 아래 테스트 신호를 우선 기준으로 테스트와 디버깅 경로를 잡는다.

## 관찰된 테스트 디렉토리

$test_dir_block

## 관찰된 테스트 설정 파일

$test_tooling_block

- 버그 재현과 원인 축소는 위 테스트 구조와 설정 신호를 먼저 활용한다.
- 변경에 맞는 가장 작은 자동화 테스트 계층을 우선 선택한다.
- 자동화 경로가 불명확하면 수동 검증 공백을 명시하고 관련 rule 문서를 참조형으로 남긴다.
EOF
      return 0
    fi

    if [ -n "$test_dirs" ]; then
      test_dir_block=$(render_bullets "$test_dirs")
    else
      test_dir_block='- No dedicated test directories were observed yet.'
    fi

    if [ -n "$test_tooling_files" ]; then
      test_tooling_block=$(render_bullets "$test_tooling_files")
    else
      test_tooling_block='- No test config files were observed yet.'
    fi

    cat <<EOF
---
name: test-debug
description: Use for testing and debugging work such as reproducing bugs, narrowing causes, adding or updating tests, automating verification, and documenting manual checks.
---

# Test Debug

Read [\`rule/index.md\`](../../../rule/index.md), [\`rule/rules/testing-standards.md\`](../../../rule/rules/testing-standards.md), [\`rule/rules/instruction-model.md\`](../../../rule/rules/instruction-model.md), and [\`rule/rules/language-policy.md\`](../../../rule/rules/language-policy.md) before writing.

Use the observed test signals below as the first guide for testing and debugging work in this repository.

## Observed Test Directories

$test_dir_block

## Observed Test Config Files

$test_tooling_block

- Start reproduction and diagnosis from the observed test structure and configs.
- Prefer the smallest relevant automated test layer for the change.
- If automation is still unclear, record the manual verification gap and anchor it to the relevant rule documents.
EOF
    return 0
  fi

  copy_template_body=$SKILL_DIR/assets/.codex/skills/test-debug/SKILL.$language.md
  cat "$copy_template_body"
}

build_docs_sync_skill() {
  language=$1
  skill_mode=$2
  docs_children=$3
  observed_files=$4

  if [ "$skill_mode" = "existing" ]; then
    if [ "$language" = "ko" ]; then
      if [ -n "$docs_children" ]; then
        docs_block=$(render_bullets "$docs_children")
      else
        docs_block='- 관찰된 top-level docs 항목이 아직 없다.'
      fi

      if [ -n "$observed_files" ]; then
        observed_file_block=$(render_bullets "$observed_files")
      else
        observed_file_block='- 관찰된 주요 최상위 파일이 아직 없다.'
      fi

      cat <<EOF
---
name: docs-sync
description: 코드나 규칙 변경에 맞춰 README, guide, rule, implementation briefing을 동기화하는 문서 정리 작업에 사용한다.
---

# Docs Sync

작성 전에 [\`rule/index.md\`](../../../rule/index.md), [\`rule/rules/documentation-boundaries.md\`](../../../rule/rules/documentation-boundaries.md), [\`rule/rules/readme-maintenance.md\`](../../../rule/rules/readme-maintenance.md), [\`rule/rules/language-policy.md\`](../../../rule/rules/language-policy.md)를 읽는다.

이 저장소는 기존 문서 신호를 가진 상태에서 초기화되므로 문서 동기화는 아래 관찰값부터 시작한다.

## 관찰된 docs 항목

$docs_block

## 관찰된 주요 최상위 파일

$observed_file_block

- 기존 README와 docs 구조가 의미 있으면 generic 재서술보다 우선 보존·보강한다.
- README, guide, rule, implementation briefing의 경계를 유지한다.
- 실제로 바뀐 사용자 영향과 운영 사실만 반영하고, stable rule text는 참조형으로 연결한다.
EOF
      return 0
    fi

    if [ -n "$docs_children" ]; then
      docs_block=$(render_bullets "$docs_children")
    else
      docs_block='- No top-level docs entries were observed yet.'
    fi

    if [ -n "$observed_files" ]; then
      observed_file_block=$(render_bullets "$observed_files")
    else
      observed_file_block='- No significant top-level files were observed yet.'
    fi

    cat <<EOF
---
name: docs-sync
description: Use for documentation-sync work that keeps README, guides, rules, and implementation briefings aligned with code or policy changes.
---

# Docs Sync

Read [\`rule/index.md\`](../../../rule/index.md), [\`rule/rules/documentation-boundaries.md\`](../../../rule/rules/documentation-boundaries.md), [\`rule/rules/readme-maintenance.md\`](../../../rule/rules/readme-maintenance.md), and [\`rule/rules/language-policy.md\`](../../../rule/rules/language-policy.md) before writing.

This repository was initialized on top of existing docs signals, so documentation sync should start from the observed entries below.

## Observed Docs Entries

$docs_block

## Observed Top-Level Files

$observed_file_block

- Prefer preserving and extending meaningful existing README or docs structure over generic rewrites.
- Keep the boundary between README, guides, rules, and implementation briefings.
- Reflect only real user-impact or operating facts that changed and reference stable rules instead of copying them.
EOF
    return 0
  fi

  copy_template_body=$SKILL_DIR/assets/.codex/skills/docs-sync/SKILL.$language.md
  cat "$copy_template_body"
}

build_quality_review_skill() {
  language=$1
  skill_mode=$2
  runtime_dirs=$3
  test_dirs=$4
  docs_children=$5

  if [ "$skill_mode" = "existing" ]; then
    if [ "$language" = "ko" ]; then
      if [ -n "$runtime_dirs" ]; then
        runtime_block=$(render_bullets "$runtime_dirs")
      else
        runtime_block='- 아직 확정된 source root가 없다.'
      fi

      if [ -n "$test_dirs" ]; then
        test_dir_block=$(render_bullets "$test_dirs")
      else
        test_dir_block='- 관찰된 테스트 디렉토리가 아직 없다.'
      fi

      if [ -n "$docs_children" ]; then
        docs_block=$(render_bullets "$docs_children")
      else
        docs_block='- 관찰된 top-level docs 항목이 아직 없다.'
      fi

      cat <<EOF
---
name: quality-review
description: 변경 결과를 acceptance criteria와 기대 동작에 대조해 검토하고, 회귀 위험과 남은 공백을 정리하는 품질 검토 작업에 사용한다.
---

# Quality Review

평가 전에 [\`rule/index.md\`](../../../rule/index.md), [\`rule/rules/subagent-orchestration.md\`](../../../rule/rules/subagent-orchestration.md), [\`rule/rules/testing-standards.md\`](../../../rule/rules/testing-standards.md), [\`rule/rules/language-policy.md\`](../../../rule/rules/language-policy.md)를 읽는다.

이 저장소의 품질 검토는 아래 구조 신호를 기준으로 관찰 범위를 잡는다.

## 관찰된 source root

$runtime_block

## 관찰된 테스트 디렉토리

$test_dir_block

## 관찰된 docs 항목

$docs_block

- acceptance criteria와 기대 동작을 위 구조 신호에 대조해 검토한다.
- 회귀 위험과 남은 공백을 구분해 기록한다.
- 제품 파일은 수정하지 않고, 관찰과 판단 근거를 관련 rule과 검증 기록에 참조형으로 남긴다.
EOF
      return 0
    fi

    if [ -n "$runtime_dirs" ]; then
      runtime_block=$(render_bullets "$runtime_dirs")
    else
      runtime_block='- The source root is not confirmed yet.'
    fi

    if [ -n "$test_dirs" ]; then
      test_dir_block=$(render_bullets "$test_dirs")
    else
      test_dir_block='- No dedicated test directories were observed yet.'
    fi

    if [ -n "$docs_children" ]; then
      docs_block=$(render_bullets "$docs_children")
    else
      docs_block='- No top-level docs entries were observed yet.'
    fi

    cat <<EOF
---
name: quality-review
description: Use for quality review work that checks implemented results against acceptance criteria and expected behavior, then records regression risks and remaining gaps.
---

# Quality Review

Read [\`rule/index.md\`](../../../rule/index.md), [\`rule/rules/subagent-orchestration.md\`](../../../rule/rules/subagent-orchestration.md), [\`rule/rules/testing-standards.md\`](../../../rule/rules/testing-standards.md), and [\`rule/rules/language-policy.md\`](../../../rule/rules/language-policy.md) before reviewing.

Use the observed structure below to scope quality review and acceptance checks.

## Observed Source Root

$runtime_block

## Observed Test Directories

$test_dir_block

## Observed Docs Entries

$docs_block

- Compare implemented results against acceptance criteria and expected behavior through these observed source-root, test, and docs surfaces.
- Separate regression risks from remaining gaps.
- Do not modify product files; leave the review grounded in relevant rules and verification records.
EOF
    return 0
  fi

  copy_template_body=$SKILL_DIR/assets/.codex/skills/quality-review/SKILL.$language.md
  cat "$copy_template_body"
}

build_development_standards() {
  language=$1
  runtime_dirs=$2
  non_runtime_dirs=$3
  standards_mode=$4
  observed_dirs=$5
  observed_files=$6
  tooling_files=$7
  merged_non_runtime_dirs=$(merge_non_runtime_dirs "$non_runtime_dirs")

  if [ "$standards_mode" = "existing" ]; then
    if [ "$language" = "ko" ]; then
      if [ -n "$observed_dirs" ]; then
        observed_dir_block=$(render_bullets "$observed_dirs")
      else
        observed_dir_block='관찰된 최상위 디렉토리가 아직 없다.'
      fi

      if [ -n "$observed_files" ]; then
        observed_file_block=$(render_bullets "$observed_files")
      else
        observed_file_block='관찰된 주요 최상위 파일이 아직 없다.'
      fi

      if [ -n "$tooling_files" ]; then
        tooling_block=$(render_bullets "$tooling_files")
      else
        tooling_block='관찰된 top-level 툴링 또는 설정 파일이 아직 없다.'
      fi

      if [ -n "$runtime_dirs" ]; then
        runtime_block=$(render_bullets "$runtime_dirs")
      else
        runtime_block='아직 확정된 source root가 없다.'
      fi

      non_runtime_block=$(render_bullets "$merged_non_runtime_dirs")

      cat <<EOF
# 개발 표준 규칙

## 목적

관찰된 프로젝트 구조를 바탕으로 이 저장소의 구현 품질 기준을 규정한다.

## 관찰된 프로젝트 신호

초기화 시점에 관찰된 최상위 디렉토리:

$observed_dir_block

초기화 시점에 관찰된 주요 최상위 파일:

$observed_file_block

초기화 시점에 관찰된 툴링 또는 설정 파일:

$tooling_block

## 구조 기반 규정

관찰된 source root:

$runtime_block

관찰된 non-runtime 영역:

$non_runtime_block

- 위 구조와 툴링 신호를 기준으로 프로젝트별 구현 규칙을 구체화한다.
- 저장소에 이미 있는 naming pattern, 디렉토리 역할, 검증 경로를 일반 기본값보다 우선한다.
- 특정 영역에 더 강한 규칙이 보이면 local rule로 더 좁게 분리한다.

## 기본 품질 기대치

- 가능하면 함수, 모듈, 파일이 하나의 분명한 책임에 집중하도록 유지한다.
- 과도하게 압축된 영리한 표현보다 읽기 쉬운 제어 흐름을 우선한다.
- 오류는 올바른 경계에서 처리하고, 조용히 실패하는 동작은 피한다.
- 동작이 바뀌면 관련 타입, 스키마, DTO, 인터페이스, 문서도 함께 맞춘다.
- 변경으로 인해 생긴 dead code, 오래된 주석, 명백한 중복은 정리한다.

## 검증 기대치

- 저장소에 이미 있는 lint, type-check, test, formatting, build 명령이 있으면 그 경로를 우선 사용한다.
- 자동화된 검증이 아직 명확하지 않다면 최소한의 수동 검증 메모를 남긴다.
- 프로젝트에 맞는 검증 경로가 더 분명해지면 이 문서에 반영한다.
EOF
      return 0
    fi

    if [ -n "$observed_dirs" ]; then
      observed_dir_block=$(render_bullets "$observed_dirs")
    else
      observed_dir_block='No top-level directories were observed yet.'
    fi

    if [ -n "$observed_files" ]; then
      observed_file_block=$(render_bullets "$observed_files")
    else
      observed_file_block='No significant top-level files were observed yet.'
    fi

    if [ -n "$tooling_files" ]; then
      tooling_block=$(render_bullets "$tooling_files")
    else
      tooling_block='No top-level tooling or config files were observed yet.'
    fi

    if [ -n "$runtime_dirs" ]; then
      runtime_block=$(render_bullets "$runtime_dirs")
    else
      runtime_block='The source root is not confirmed yet.'
    fi

    non_runtime_block=$(render_bullets "$merged_non_runtime_dirs")

    cat <<EOF
# Development Standards Rule

## Purpose

Define implementation quality standards from the observed project structure of this repository.

## Observed Project Signals

Top-level directories observed during initialization:

$observed_dir_block

Top-level files observed during initialization:

$observed_file_block

Tooling or config files observed during initialization:

$tooling_block

## Structure-Derived Standards

Observed source root:

$runtime_block

Observed non-runtime areas:

$non_runtime_block

- Use the structure and tooling signals above to refine project-specific implementation standards.
- Prefer observed naming, directory roles, and verification paths over generic defaults.
- If stronger area-specific rules become clear, narrow them into local rule documents.

## Baseline Quality Expectations

- Keep functions, modules, and files focused on a clear responsibility where practical.
- Prefer readable control flow over clever compression.
- Handle errors at the correct boundary and avoid silent failure.
- Update related types, schemas, DTOs, interfaces, and docs together when behavior changes.
- Remove dead code, stale comments, and obvious duplication introduced by the change.

## Verification Expectations

- Use existing lint, type-check, test, formatting, or build paths when the repository already exposes them.
- If automated verification is still unclear, leave a concise manual verification note.
- Update this rule as project-specific verification paths become clearer.
EOF
    return 0
  fi

  if [ "$language" = "ko" ]; then
    cat <<'EOF'
# 개발 표준 규칙

## 목적

이 저장소에서 구현 품질 규칙을 어떻게 정하고 유지하는지 정의한다.

## 신규 저장소

- 이 문서는 아직 provisional한 상태다.
- 실제 스택, 구조, 툴링 관례가 드러나기 전까지는 최소 기대치만 적용한다.
- 실제 프로젝트 관례가 드러나면 이 문서의 일반 규칙을 관찰된 규칙으로 교체한다.

## 현재 최소 기대치

- 명확한 이름을 사용한다.
- 함수, 모듈, 파일의 책임을 가능한 한 분명하게 유지한다.
- 읽기 쉬운 제어 흐름을 우선한다.
- 오류는 올바른 경계에서 처리한다.
- 코드, 문서, 검증 결과가 실제 구현과 어긋나지 않게 유지한다.

## 향후 구체화

- 언어, 프레임워크, build/test/lint/formatting 경로가 정해지면 그 관례를 이 문서에 반영한다.
- 특정 영역에 더 강한 규칙이 생기면 local rule 문서로 더 좁게 분리한다.
- 일반 기본값을 최종 프로젝트 표준처럼 남겨 두지 않는다.
EOF
    return 0
  fi

  cat <<'EOF'
# Development Standards Rule

## Purpose

Define how implementation quality standards are established and maintained in this repository.

## Fresh Repository State

- This document is provisional until real stack, structure, and tooling conventions become concrete.
- Until then, apply only minimal baseline expectations.
- Replace generic guidance with observed project-specific standards as they emerge.

## Current Minimal Expectations

- Use clear names.
- Keep functions, modules, and files focused on a clear responsibility where practical.
- Prefer readable control flow.
- Handle errors at the correct boundary.
- Keep code, docs, and verification aligned with the actual implementation.

## Future Refinement

- Record real language, framework, build, test, lint, and formatting conventions here once they become known.
- Narrow stronger area-specific standards into local rule documents when needed.
- Do not leave generic defaults in place once real project conventions are clear.
EOF
}

build_testing_standards() {
  language=$1
  standards_mode=$2
  test_dirs=$3
  test_tooling_files=$4

  if [ "$standards_mode" = "existing" ]; then
    if [ "$language" = "ko" ]; then
      if [ -n "$test_dirs" ]; then
        test_dir_block=$(render_bullets "$test_dirs")
      else
        test_dir_block='관찰된 전용 테스트 디렉토리가 아직 없다.'
      fi

      if [ -n "$test_tooling_files" ]; then
        test_tooling_block=$(render_bullets "$test_tooling_files")
      else
        test_tooling_block='관찰된 테스트 설정 파일이 아직 없다.'
      fi

      cat <<EOF
# 테스트 표준 규칙

## 목적

관찰된 테스트 구조를 바탕으로 이 저장소의 단위 테스트, E2E 테스트, 검증 규칙을 규정한다.

## 관찰된 테스트 신호

초기화 시점에 관찰된 테스트 디렉토리:

$test_dir_block

초기화 시점에 관찰된 테스트 설정 파일:

$test_tooling_block

## 구조 기반 규정

- 저장소에 이미 있는 테스트 디렉토리 구조, 이름 규칙, 설정 파일을 일반 기본값보다 우선한다.
- 저장소가 단위 테스트와 E2E 테스트를 분리하고 있다면 그 구분을 유지하고 이 문서에 반영한다.
- 특정 영역에 더 강한 테스트 규칙이 있으면 local rule로 더 좁게 분리한다.

## 기본 기대치

- 동작이 바뀌면 가능하면 가장 관련 있는 최소 자동화 테스트 계층을 추가하거나 수정한다.
- 단위 테스트가 더 적합한 변경을 E2E 테스트만으로 대체하지 않는다.
- 사용자 핵심 흐름이나 경계를 넘는 동작이 바뀌면 E2E 수준 검증 필요 여부를 함께 판단한다.
- 자동화 테스트 경로가 아직 불분명하면 수동 검증 메모를 남기고, 경로가 구체화되면 이 문서를 갱신한다.

## 구현 기록의 검증 섹션

- 구현 기록에는 단위 테스트, E2E 테스트, 수동 검증, 미실행 또는 남은 공백을 구분해 적는다.
- 테스트를 실행하지 않았거나 추가하지 않았다면 이유를 기록한다.
EOF
      return 0
    fi

    if [ -n "$test_dirs" ]; then
      test_dir_block=$(render_bullets "$test_dirs")
    else
      test_dir_block='No dedicated test directories were observed yet.'
    fi

    if [ -n "$test_tooling_files" ]; then
      test_tooling_block=$(render_bullets "$test_tooling_files")
    else
      test_tooling_block='No test config files were observed yet.'
    fi

    cat <<EOF
# Testing Standards Rule

## Purpose

Define unit-test, end-to-end-test, and verification rules from the observed test structure of this repository.

## Observed Test Signals

Test directories observed during initialization:

$test_dir_block

Test config files observed during initialization:

$test_tooling_block

## Structure-Derived Standards

- Prefer existing test directory layout, naming, and config files over generic defaults.
- If the repository already separates unit tests and end-to-end tests, preserve and document that separation here.
- If stronger area-specific testing rules exist, narrow them into local rule documents.

## Baseline Expectations

- For behavior changes, add or update the smallest relevant automated test layer when practical.
- Do not replace focused unit tests with end-to-end tests alone when a narrower test is the better fit.
- Re-evaluate whether end-to-end coverage is needed when user-critical or cross-boundary flows change.
- If automated test paths are still unclear, leave a concise manual verification note and update this rule as the paths become concrete.

## Implementation Record Verification

- Record unit tests, end-to-end tests, manual checks, and remaining gaps separately in implementation records.
- In a role-separated harness, evaluator owns the strongest feasible user-surface/end-to-end validation, including direct checks through browser UI, app simulator/runtime, game runtime/scene, CLI entrypoints, or API request/response flows when those are the representative surfaces.
- If the representative user surface could not be exercised directly, explain why, what environment is missing, what substitute validation was used, and what gap remains.
- Explain why tests were not added or run when that happens.
EOF
    return 0
  fi

  if [ "$language" = "ko" ]; then
    cat <<'EOF'
# 테스트 표준 규칙

## 목적

이 저장소에서 단위 테스트, E2E 테스트, 검증 기대치를 어떻게 정하고 유지하는지 정의한다.

## 신규 저장소

- 이 문서는 provisional한 규칙으로 시작한다.
- 실제 스택이 정해지기 전에는 특정 test framework를 미리 가정하지 않는다.
- 단위 테스트는 가능한 경우 고립된 로직과 edge case를 검증하는 데 우선 사용한다.
- E2E 테스트는 사용자 핵심 흐름이나 경계를 넘는 동작이 실제로 생긴 뒤 필요한 경우에 사용한다.

## 현재 최소 기대치

- 동작이 바뀌면 가능한 범위에서 가장 작은 관련 테스트 계층을 추가하거나 수정한다.
- 단위 테스트가 더 적합한 변경을 E2E 테스트만으로 대체하지 않는다.
- 자동화 테스트 경로가 아직 없다면 수동 검증 메모를 남긴다.
- 역할 분리 하네스를 따를 때 generator는 단위 수준 검증을 우선하고, evaluator는 대표 사용자 surface 직접 검증을 포함한 strongest feasible user-surface/E2E 검증을 맡는다.
- 대표 사용자 surface가 있으면 evaluator는 브라우저, 시뮬레이터, 런타임, CLI, API 호출처럼 해당 프로젝트 타입의 실제 진입점을 가능한 한 직접 검증한다.
- 대표 사용자 surface를 직접 실행하지 못했다면 이유, 누락된 환경, 대체 검증 한계와 남은 공백을 검증 기록에 남긴다.

## 향후 구체화

- 실제 test 디렉토리, 명령, framework가 정해지면 이 문서에 반영한다.
- 구현 기록의 `검증` 섹션에는 단위 테스트, E2E 테스트, 수동 검증, 남은 공백을 구분해 적는다.
EOF
    return 0
  fi

  cat <<'EOF'
# Testing Standards Rule

## Purpose

Define how unit tests, end-to-end tests, and verification expectations are established and maintained in this repository.

## Fresh Repository State

- This document is provisional until real test paths, commands, and frameworks become concrete.
- Do not assume a specific test framework before the real stack becomes known.
- Use unit tests for isolated logic where practical.
- Use end-to-end tests for user-critical or cross-boundary flows once those flows exist.

## Current Minimal Expectations

- For behavior changes, add or update the smallest relevant test layer when practical.
- Do not replace focused unit tests with end-to-end tests alone when a narrower test is the better fit.
- Leave a concise manual verification note if no automated test path exists yet.

## Future Refinement

- Record real test directories, commands, and frameworks here once they become known.
- In implementation records, separate unit tests, end-to-end tests, manual checks, and remaining gaps in `Verification`.
EOF
}

build_project_structure() {
  language=$1
  runtime_dirs=$2
  non_runtime_dirs=$3
  runtime_body=$(make_runtime_body "$language" "$runtime_dirs")
  non_runtime_body=$(make_non_runtime_body "$language" "$non_runtime_dirs")

  if [ "$language" = "ko" ]; then
    cat <<EOF
# 프로젝트 구조 규칙

## 목적

이 저장소의 최상위 디렉토리 모델을 정의하고, 각 주요 영역의 역할을 분명하게 한다.

## 최상위 영역

- [\`AGENTS.md\`](../../AGENTS.md): 저장소 전역 orchestration 지침
- \`.codex/\`: 프로젝트 스코프 Codex 설정, subagent 정의, starter local skill 세트
- \`rule/\`: authoritative Codex 실행 규칙. 탐색 시작점은 [\`rule/index.md\`](../index.md)다.
- \`subagents_docs/\`: planner, generator, evaluator의 작업 문서 영역. 기본 진입점은 [\`subagents_docs/AGENTS.md\`](../../subagents_docs/AGENTS.md)다.
- \`docs/guide/\`: 사람이 읽는 안내 문서. 기본 진입점은 [\`docs/guide/README.md\`](../../docs/guide/README.md)다.
- \`docs/implementation/\`: 관심사 기반 카테고리 안에 사람이 읽는 최종 구현 브리핑을 두는 문서 영역. 제어 파일은 [\`docs/implementation/AGENTS.md\`](../../docs/implementation/AGENTS.md)다.

## Source Root 영역

$runtime_body

## Non-Runtime 영역

$non_runtime_body

## 변경 규칙

- source root와 non-runtime 경계는 명시적으로 유지한다.
- 프로젝트 루트 바로 아래에 여러 runtime 디렉토리를 흩뿌리지 말고, 구현체는 단일 source root 아래에 둔다.
- 실제 디렉토리 구조가 확정되면 placeholder 항목을 관찰된 경로로 교체한다.
- 최상위 구조가 바뀌면 [\`rule/rules/project-structure.md\`](project-structure.md)에 그 구조를 실제 값으로 반영한다.
- 확립된 최상위 영역을 이동하거나 이름 변경할 때는 [\`rule/index.md\`](../index.md)와 관련 \`rule/rules/*.md\` 문서도 함께 갱신한다.
- local 구조가 복잡해지면 scope를 분명하게 해주는 곳에만 local instruction 파일을 추가한다.
EOF
    return 0
  fi

  cat <<EOF
# Project Structure Rule

## Purpose

Define the top-level directory model for this repository and make the role of each major area explicit.

## Top-Level Areas

- [\`AGENTS.md\`](../../AGENTS.md): repository-wide orchestration guidance
- \`.codex/\`: project-scoped Codex configuration, subagent definitions, and starter local skills
- \`rule/\`: authoritative Codex execution rules, with [\`rule/index.md\`](../index.md) as the discovery entry point
- \`subagents_docs/\`: planner, generator, and evaluator working documents, with [\`subagents_docs/AGENTS.md\`](../../subagents_docs/AGENTS.md) as the control file
- \`docs/guide/\`: human-facing guidance, with [\`docs/guide/README.md\`](../../docs/guide/README.md) as the default entry point
- \`docs/implementation/\`: human-facing final implementation briefings inside concern-based categories, with [\`docs/implementation/AGENTS.md\`](../../docs/implementation/AGENTS.md) as the control file

## Source Root Area

$runtime_body

## Non-Runtime Areas

$non_runtime_body

## Change Rules

- Keep source-root and non-runtime boundaries explicit.
- Do not spread multiple top-level runtime directories directly under the project root; keep implementation areas under one source root.
- Replace placeholder entries with observed paths once the real directory structure becomes known.
- Reflect actual top-level structure changes in [\`rule/rules/project-structure.md\`](project-structure.md).
- Do not move or rename established top-level areas without updating [\`rule/index.md\`](../index.md) and related \`rule/rules/*.md\` documents.
- When local structure becomes complex, add local instruction files only where they improve scope clarity.
EOF
}

build_runtime_boundaries() {
  language=$1
  runtime_dirs=$2
  non_runtime_dirs=$3
  runtime_body=$(make_runtime_body "$language" "$runtime_dirs")
  non_runtime_body=$(make_non_runtime_body "$language" "$non_runtime_dirs")

  if [ "$language" = "ko" ]; then
    cat <<EOF
# Runtime 경계 규칙

## 목적

이 저장소에서 단일 source root와 non-runtime 영역을 어떻게 나누는지 정의한다.

## Source Root 디렉토리

$runtime_body

## Non-Runtime 디렉토리

$non_runtime_body

## 모호성 처리

- 기존 저장소에서 경계가 불분명하면 구조를 바꾸기 전에 먼저 확인한다.
- 프로젝트 루트 아래에 여러 runtime 디렉토리를 직접 두는 기본 규칙은 허용하지 않는다. 구현체는 단일 source root 아래에 둔다.
- source root 후보가 여러 개로 보이면 어떤 하나를 source root로 볼지 먼저 확인한다.
- 가능하면 충돌하는 새 모델을 만들기보다, 이미 의미 있게 형성된 기존 구조에 맞춘다.
- source root와 non-runtime 경계가 실제로 드러나면 placeholder 항목을 관찰된 디렉토리로 교체한다.
- 경계가 바뀌면 [\`rule/rules/runtime-boundaries.md\`](runtime-boundaries.md)와 필요한 관련 \`rule/rules/*.md\` 문서를 함께 갱신한다.
EOF
    return 0
  fi

  cat <<EOF
# Runtime Boundaries Rule

## Purpose

Define how a single source root and non-runtime areas are separated in this repository.

## Source Root Directory

$runtime_body

## Non-Runtime Directories

$non_runtime_body

## Ambiguity Handling

- If the boundary is unclear in an existing repository, confirm it before making structural changes.
- Do not spread multiple top-level runtime directories directly under the project root; keep implementation areas under one source root.
- If several likely source-root candidates exist, confirm which single directory should be treated as the source root.
- Align to meaningful existing structure when possible instead of inventing a conflicting model.
- Replace placeholder entries with observed directories once source-root and non-runtime boundaries become clear.
- When the boundary changes, update [\`rule/rules/runtime-boundaries.md\`](runtime-boundaries.md) and any related \`rule/rules/*.md\` documents in the same change.
EOF
}

build_subagents_docs_rule() {
  language=$1

  if [ "$language" = "ko" ]; then
    cat <<'EOF'
# Subagents Docs 규칙

## 목적

`subagents_docs/`를 cycle-backed implementation work에서 메인 에이전트와 subagent가 공유하는 작업 문서 영역으로 정의한다.

## 범위

- `subagents_docs/`는 subagent working area다.
- `docs/guide/`와 `docs/implementation/`는 사람이 읽는 문서 영역이다.
- subagent 작업 기록은 `subagents_docs/`에만 둔다.
- `subagents_docs/` 작업 문서는 선택된 언어 설정을 따른다.
- 메인 에이전트는 작업 분류, 계획 승인, 구현 통합, handoff 결정을 담당한다.
- 메인 에이전트는 필요할 때 subagent를 자율적으로 호출할 수 있고, 독립적인 분석 질문은 병렬 `explorer` 호출을 우선 고려한다.

## 디렉토리 역할

- `subagents_docs/cycles/`: planner, generator, evaluator가 함께 참조하는 plan별 단일 working document

## 문서 계약

- exact cycle 문서 경로, header 상태 전이, append-only section, provenance는 [\`rule/rules/cycle-document-contract.md\`](cycle-document-contract.md)를 기준으로 한다.
- 문서 본문 언어와 path 표기 규칙은 [\`rule/rules/language-policy.md\`](language-policy.md)를 기준으로 한다.

## 순환 규칙

- 작은 직접 변경은 cycle 문서를 생략할 수 있다.
- 중간 변경은 `main(plan+implementation) -> evaluator`로 진행한다.
- 큰 변경이지만 비교적 명확하면 `main-led decomposition + delegated implementation + evaluator`로 진행한다.
- 큰 변경이면서 모호하면 병렬 `explorer` 분석, 필요 시 planner assist, main-approved plan, delegated implementation, evaluator 순으로 진행한다.
- evaluator는 generator가 만든 구현 결과를 해당 plan과 acceptance criteria 기준으로 대표 사용자 surface 직접 검증을 포함한 strongest feasible 검증으로 평가한다.
- evaluator가 구현 결과에서 부족한 점이나 blocker를 확인했을 때만 같은 계획을 다시 계획, 구현, 평가하고, `FAIL`이면 외부 입력이 정말 필요한 경우가 아니면 질문 없이 다음 cycle을 시작한다.
- 여러 계획이 독립이면 병렬로 돌릴 수 있지만, 의존성이 있으면 순차로 처리한다.
- 문서 분석 단계에서는 독립적인 질문을 explorer 병렬 호출로 나누고, implementation cycle 진입 전까지는 evaluation handoff를 열지 않는다.

## 문서 경계

- `subagents_docs/`에는 작업용 문서만 둔다.
- 신규 working record는 `subagents_docs/cycles/`에 쓴다.
- 사용자-facing 최종 브리핑은 evaluator pass 이후 [\`docs/implementation/AGENTS.md\`](../../docs/implementation/AGENTS.md)를 기준으로 `docs/implementation/`의 관심사 카테고리 안에 짧고 읽기 쉽게 남긴다.
- plan-only 상태나 generator-only 상태를 근거로 [\`docs/implementation/AGENTS.md\`](../../docs/implementation/AGENTS.md) 아래 최종 브리핑을 만들거나 갱신하지 않는다.
- 역할별 소유 문서를 섞어 쓰지 않는다.
- top-level `docs/implementation/briefings/` 디렉토리는 만들지 않는다.
EOF
    return 0
  fi

  cat <<'EOF'
# Subagents Docs Rule

## Purpose

Define `subagents_docs/` as the working-document area used by the main agent and subagents for cycle-backed implementation work.

## Scope

- `subagents_docs/` is the subagent working area.
- `docs/guide/` and `docs/implementation/` are human-facing documentation areas.
- Subagent working records stay only under `subagents_docs/`.
- `subagents_docs/` working documents follow the selected language.
- The main agent owns task classification, plan approval, implementation integration, and handoff decisions.
- The main agent may autonomously invoke subagents when needed and should prefer parallel `explorer` calls for independent analysis questions.

## Directory Roles

- `subagents_docs/cycles/`: one append-only working document per plan

## Document Contract

- Use [\`rule/rules/cycle-document-contract.md\`](cycle-document-contract.md) for exact cycle file path, header transitions, append-only sections, provenance, and dirty-worktree rules.
- Use [\`rule/rules/language-policy.md\`](language-policy.md) for document language and stable filename/path rules.

## Cycle Rules

- Small direct changes may skip the cycle document.
- Medium changes use `main(plan+implementation) -> evaluator`.
- Large-clear changes use `main-led decomposition + delegated implementation + evaluator`.
- Large-ambiguous changes use `parallel explorer analysis + planner assist if needed + main-approved plan + delegated implementation + evaluator`.
- Evaluator reviews the implemented result against that plan and its acceptance criteria with the strongest feasible validation by directly exercising the representative user surface when one exists.
- If a representative user surface exists, evaluator should prioritize direct checks through browser UI, app simulator/runtime, game runtime/scene, CLI entrypoints, or API request/response flows.
- If direct user-surface validation is unavailable, evaluator must record why, what environment is missing, what substitute validation was used, and why any critical unverified surface cannot be soft-passed.
- If evaluator finds failures or blockers in the implemented result, the same plan repeats planning, implementation, and evaluation, and `FAIL` restarts automatically unless the blocker truly needs external input.
- Independent plans may run in parallel, while dependent plans must run sequentially.
- Document-analysis work should use parallel explorers when the questions are independent.

## Document Boundary

- Keep working documents only under `subagents_docs/`.
- Leave short, human-facing final briefings under concern-based categories in [\`docs/implementation/AGENTS.md\`](../../docs/implementation/AGENTS.md) only after evaluator pass.
- Do not create or update final briefings from a plan-only or generator-only state under [\`docs/implementation/AGENTS.md\`](../../docs/implementation/AGENTS.md).
- Do not mix role-owned working documents into user-facing documentation.
- Do not create a top-level `docs/implementation/briefings/` directory.
EOF
}

TARGET_DIR=""
LANGUAGE_RAW=""
SOURCE_ROOT_DIR_RAW=""
NON_RUNTIME_DIRS_RAW=""
README_MODE="fresh"
INSPECT_ONLY=0
CONFIRM_EXISTING_DOCS=0
CONFIRM_EXISTING_RULE=0
OVERWRITE=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --inspect)
      INSPECT_ONLY=1
      shift
      ;;
    --confirm-existing-docs)
      CONFIRM_EXISTING_DOCS=1
      shift
      ;;
    --confirm-existing-rule)
      CONFIRM_EXISTING_RULE=1
      shift
      ;;
    --language)
      [ "$#" -ge 2 ] || die "--language requires a value"
      LANGUAGE_RAW=$2
      shift 2
      ;;
    --source-root-dir)
      [ "$#" -ge 2 ] || die "--source-root-dir requires a value"
      SOURCE_ROOT_DIR_RAW=$2
      shift 2
      ;;
    --runtime-dirs)
      [ "$#" -ge 2 ] || die "--runtime-dirs requires a value"
      SOURCE_ROOT_DIR_RAW=$2
      shift 2
      ;;
    --non-runtime-dirs)
      [ "$#" -ge 2 ] || die "--non-runtime-dirs requires a value"
      NON_RUNTIME_DIRS_RAW=$2
      shift 2
      ;;
    --readme-mode)
      [ "$#" -ge 2 ] || die "--readme-mode requires a value"
      README_MODE=$2
      shift 2
      ;;
    --overwrite)
      OVERWRITE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --*)
      die "Unknown option: $1"
      ;;
    *)
      if [ -z "$TARGET_DIR" ]; then
        TARGET_DIR=$1
        shift
      else
        die "Unexpected argument: $1"
      fi
      ;;
  esac
done

[ -n "$TARGET_DIR" ] || die "Target directory is required"
[ -n "$LANGUAGE_RAW" ] || die "--language is required"
[ -d "$TARGET_DIR" ] || die "Target directory does not exist: $TARGET_DIR"

case "$README_MODE" in
  fresh|existing|skip)
    ;;
  *)
    die "Unsupported --readme-mode: $README_MODE"
    ;;
esac

LANGUAGE=$(normalize_language "$LANGUAGE_RAW") || die "Unsupported language selection: $LANGUAGE_RAW"
RUNTIME_DIRS=$(normalize_single_dir "$SOURCE_ROOT_DIR_RAW") || die "--source-root-dir requires a single directory value"
NON_RUNTIME_DIRS=$(normalize_dirs "$NON_RUNTIME_DIRS_RAW")
STANDARDS_MODE="fresh"
if [ "$README_MODE" = "existing" ]; then
  STANDARDS_MODE="existing"
fi

OBSERVED_DIRS=$(list_top_level_dirs "$TARGET_DIR")
OBSERVED_FILES=$(list_top_level_files "$TARGET_DIR")
OBSERVED_TOOLING_FILES=$(detect_tooling_files "$OBSERVED_FILES")
OBSERVED_TEST_DIRS=$(detect_test_dirs "$OBSERVED_DIRS")
OBSERVED_TEST_TOOLING_FILES=$(detect_test_tooling_files "$OBSERVED_FILES")
RUNTIME_CANDIDATES=""
if [ "$README_MODE" = "existing" ] && [ -z "$RUNTIME_DIRS" ]; then
  RUNTIME_CANDIDATES=$(detect_runtime_candidates "$OBSERVED_DIRS")
fi
DOCS_CHILDREN=$(list_docs_children "$TARGET_DIR")
RULE_ENTRIES=$(list_rule_entries "$TARGET_DIR")
CONFLICTING_OUTPUTS=$(detect_conflicting_outputs "$TARGET_DIR" "$README_MODE")

RUNTIME_NEEDS_INPUT=0
if [ "$README_MODE" = "existing" ] && [ -z "$SOURCE_ROOT_DIR_RAW" ] && [ -n "$OBSERVED_DIRS" ]; then
  RUNTIME_NEEDS_INPUT=1
fi

DOCS_NEEDS_INPUT=0
if [ "$README_MODE" = "existing" ] && [ "$CONFIRM_EXISTING_DOCS" -ne 1 ] && docs_tree_requires_confirmation "$DOCS_CHILDREN"; then
  DOCS_NEEDS_INPUT=1
fi

RULE_NEEDS_INPUT=0
if [ "$README_MODE" = "existing" ] && [ "$CONFIRM_EXISTING_RULE" -ne 1 ] && rule_tree_requires_confirmation "$RULE_ENTRIES"; then
  RULE_NEEDS_INPUT=1
fi

OVERWRITE_NEEDS_INPUT=0
if [ -n "$CONFLICTING_OUTPUTS" ] && [ "$OVERWRITE" -ne 1 ]; then
  OVERWRITE_NEEDS_INPUT=1
fi

if [ "$INSPECT_ONLY" -eq 1 ]; then
  print_inspection_summary "$LANGUAGE" "$README_MODE" "$RUNTIME_CANDIDATES" "$DOCS_CHILDREN" "$RULE_ENTRIES" "$CONFLICTING_OUTPUTS" "$RUNTIME_NEEDS_INPUT" "$DOCS_NEEDS_INPUT" "$RULE_NEEDS_INPUT" "$OVERWRITE_NEEDS_INPUT"
  exit 0
fi

if [ "$RUNTIME_NEEDS_INPUT" -eq 1 ] || [ "$DOCS_NEEDS_INPUT" -eq 1 ] || [ "$RULE_NEEDS_INPUT" -eq 1 ] || [ "$OVERWRITE_NEEDS_INPUT" -eq 1 ]; then
  if [ "$LANGUAGE" = "ko" ]; then
    printf '[NEEDS_INPUT] 필요한 답변이 정리될 때까지 생성을 잠시 멈춘다.\n'
  else
    printf '[NEEDS_INPUT] Generation is paused until the missing answers are resolved.\n'
  fi
  print_inspection_summary "$LANGUAGE" "$README_MODE" "$RUNTIME_CANDIDATES" "$DOCS_CHILDREN" "$RULE_ENTRIES" "$CONFLICTING_OUTPUTS" "$RUNTIME_NEEDS_INPUT" "$DOCS_NEEDS_INPUT" "$RULE_NEEDS_INPUT" "$OVERWRITE_NEEDS_INPUT"
  exit 0
fi

copy_template "assets/AGENTS/root.$LANGUAGE.md" "$TARGET_DIR/AGENTS.md"
copy_template "assets/docs/implementation/AGENTS.$LANGUAGE.md" "$TARGET_DIR/docs/implementation/AGENTS.md"
copy_template "assets/rule/index.$LANGUAGE.md" "$TARGET_DIR/rule/index.md"
copy_template "assets/rule/instruction-model.$LANGUAGE.md" "$TARGET_DIR/rule/rules/instruction-model.md"
copy_template "assets/rule/rule-maintenance.$LANGUAGE.md" "$TARGET_DIR/rule/rules/rule-maintenance.md"
copy_template "assets/rule/documentation-boundaries.$LANGUAGE.md" "$TARGET_DIR/rule/rules/documentation-boundaries.md"
copy_template "assets/rule/cycle-document-contract.$LANGUAGE.md" "$TARGET_DIR/rule/rules/cycle-document-contract.md"
copy_template "assets/rule/language-policy.$LANGUAGE.md" "$TARGET_DIR/rule/rules/language-policy.md"
copy_template "assets/rule/readme-maintenance.$LANGUAGE.md" "$TARGET_DIR/rule/rules/readme-maintenance.md"
copy_template "assets/rule/implementation-records.$LANGUAGE.md" "$TARGET_DIR/rule/rules/implementation-records.md"
copy_template "assets/rule/subagent-orchestration.$LANGUAGE.md" "$TARGET_DIR/rule/rules/subagent-orchestration.md"
copy_template "assets/.codex/agents/planner.toml" "$TARGET_DIR/.codex/agents/planner.toml"
copy_template "assets/.codex/agents/generator.toml" "$TARGET_DIR/.codex/agents/generator.toml"
copy_template "assets/.codex/agents/evaluator.toml" "$TARGET_DIR/.codex/agents/evaluator.toml"
copy_template "assets/.codex/config.toml" "$TARGET_DIR/.codex/config.toml"
if [ "$README_MODE" = "existing" ]; then
  write_text "$TARGET_DIR/.codex/skills/change-analysis/SKILL.md" "$(build_change_analysis_skill "$LANGUAGE" "existing" "$RUNTIME_DIRS" "$OBSERVED_DIRS" "$DOCS_CHILDREN")"
  write_text "$TARGET_DIR/.codex/skills/code-implementation/SKILL.md" "$(build_code_implementation_skill "$LANGUAGE" "existing" "$RUNTIME_DIRS" "$OBSERVED_TOOLING_FILES")"
  write_text "$TARGET_DIR/.codex/skills/test-debug/SKILL.md" "$(build_test_debug_skill "$LANGUAGE" "existing" "$OBSERVED_TEST_DIRS" "$OBSERVED_TEST_TOOLING_FILES")"
  write_text "$TARGET_DIR/.codex/skills/docs-sync/SKILL.md" "$(build_docs_sync_skill "$LANGUAGE" "existing" "$DOCS_CHILDREN" "$OBSERVED_FILES")"
  write_text "$TARGET_DIR/.codex/skills/quality-review/SKILL.md" "$(build_quality_review_skill "$LANGUAGE" "existing" "$RUNTIME_DIRS" "$OBSERVED_TEST_DIRS" "$DOCS_CHILDREN")"
else
  copy_template "assets/.codex/skills/change-analysis/SKILL.$LANGUAGE.md" "$TARGET_DIR/.codex/skills/change-analysis/SKILL.md"
  copy_template "assets/.codex/skills/code-implementation/SKILL.$LANGUAGE.md" "$TARGET_DIR/.codex/skills/code-implementation/SKILL.md"
  copy_template "assets/.codex/skills/test-debug/SKILL.$LANGUAGE.md" "$TARGET_DIR/.codex/skills/test-debug/SKILL.md"
  copy_template "assets/.codex/skills/docs-sync/SKILL.$LANGUAGE.md" "$TARGET_DIR/.codex/skills/docs-sync/SKILL.md"
  copy_template "assets/.codex/skills/quality-review/SKILL.$LANGUAGE.md" "$TARGET_DIR/.codex/skills/quality-review/SKILL.md"
fi
copy_template "assets/.codex/skills/change-analysis/agents/openai.$LANGUAGE.yaml" "$TARGET_DIR/.codex/skills/change-analysis/agents/openai.yaml"
copy_template "assets/.codex/skills/code-implementation/agents/openai.$LANGUAGE.yaml" "$TARGET_DIR/.codex/skills/code-implementation/agents/openai.yaml"
copy_template "assets/.codex/skills/test-debug/agents/openai.$LANGUAGE.yaml" "$TARGET_DIR/.codex/skills/test-debug/agents/openai.yaml"
copy_template "assets/.codex/skills/docs-sync/agents/openai.$LANGUAGE.yaml" "$TARGET_DIR/.codex/skills/docs-sync/agents/openai.yaml"
copy_template "assets/.codex/skills/quality-review/agents/openai.$LANGUAGE.yaml" "$TARGET_DIR/.codex/skills/quality-review/agents/openai.yaml"
copy_template "assets/subagents_docs/AGENTS.$LANGUAGE.md" "$TARGET_DIR/subagents_docs/AGENTS.md"
mkdir -p \
  "$TARGET_DIR/subagents_docs/cycles"
write_text "$TARGET_DIR/rule/rules/subagents-docs.md" "$(build_subagents_docs_rule "$LANGUAGE")"

if [ "$README_MODE" = "fresh" ]; then
  copy_template "assets/README/root.$LANGUAGE.md" "$TARGET_DIR/README.md"
  copy_template "assets/docs/guide/README.$LANGUAGE.md" "$TARGET_DIR/docs/guide/README.md"
elif [ "$README_MODE" = "existing" ]; then
  write_text "$TARGET_DIR/README.md" "$(build_existing_readme "$LANGUAGE" "$TARGET_DIR" "$RUNTIME_DIRS" "$NON_RUNTIME_DIRS" "$OBSERVED_DIRS" "$OBSERVED_FILES")"
  write_text "$TARGET_DIR/docs/guide/README.md" "$(build_existing_guide_readme "$LANGUAGE" "$DOCS_CHILDREN")"
else
  copy_template "assets/docs/guide/README.$LANGUAGE.md" "$TARGET_DIR/docs/guide/README.md"
fi

write_text "$TARGET_DIR/rule/rules/development-standards.md" "$(build_development_standards "$LANGUAGE" "$RUNTIME_DIRS" "$NON_RUNTIME_DIRS" "$STANDARDS_MODE" "$OBSERVED_DIRS" "$OBSERVED_FILES" "$OBSERVED_TOOLING_FILES")"
write_text "$TARGET_DIR/rule/rules/testing-standards.md" "$(build_testing_standards "$LANGUAGE" "$STANDARDS_MODE" "$OBSERVED_TEST_DIRS" "$OBSERVED_TEST_TOOLING_FILES")"
write_text "$TARGET_DIR/rule/rules/project-structure.md" "$(build_project_structure "$LANGUAGE" "$RUNTIME_DIRS" "$NON_RUNTIME_DIRS")"
write_text "$TARGET_DIR/rule/rules/runtime-boundaries.md" "$(build_runtime_boundaries "$LANGUAGE" "$RUNTIME_DIRS" "$NON_RUNTIME_DIRS")"

printf '[OK] Materialized live Codex scaffold files\n'

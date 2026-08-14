# 프로젝트 구조 규칙

## 목적

관찰된 저장소 구조와 책임 경계를 우선하며, agent가 임의의 구조를 강제하지 않도록 한다.

## 관찰된 프로젝트 구조

- `HS_INIT_SEMANTIC_TODO`: 실제 source area, runtime entrypoint, 주요 module 책임, test/tool/docs 경계를 저장소 상대 경로와 함께 기록한다.

## 기준

- 변경 전에 top-level 영역, runtime source, 테스트, 문서, 생성물, tooling 경계를 확인한다.
- 기존 구조와 naming을 우선하고, 명확한 이득 없이 이동하거나 재구성하지 않는다.
- monorepo와 multi-runtime 저장소에는 여러 의도적인 source area를 허용한다.
- runtime code와 문서, 테스트, 도구, 생성물 같은 non-runtime 영역의 책임을 구분한다.
- 새로운 top-level 디렉터리는 기존 위치로 책임을 표현할 수 없을 때만 만든다.
- local instruction 파일은 해당 디렉터리에 실제로 더 좁은 규칙이 있을 때만 추가한다.

## 기존 저장소

- 파일명이나 디렉터리명만으로 의미를 단정하지 않는다.
- package/workspace 설정, build/test 진입점, import 관계, 실제 source와 기존 문서를 함께 확인한다.
- 모호한 경계가 변경 범위를 크게 바꾸면 사용자에게 최소 질문을 한다.

## 신규 저장소

- 사용자가 확정하지 않은 stack, package, module, 배포 구조를 만들지 않는다.
- 초기 구조는 작게 시작하고 실제 책임이 생길 때 확장한다.

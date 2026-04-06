# README 유지 규칙

## 목적

root [`README.md`](../../README.md)를 저장소의 대표 사람이 읽는 진입 문서로 어떻게 만들고 유지하는지 정의한다.

## `README.md`의 역할

- [`README.md`](../../README.md)는 저장소를 처음 보는 사람이 가장 먼저 읽는 요약 문서다.
- 이 문서는 프로젝트가 무엇인지, 이 저장소에 무엇이 있는지, 어디를 먼저 보면 되는지를 높은 수준에서 설명해야 한다.
- 실제 진입점이나 제어문서를 연결할 때는 가능한 한 Markdown 링크를 사용해 탐색 경로를 분명하게 한다.
- wildcard, placeholder, 예시 경로, 아직 생성되지 않은 문서는 링크 대신 path literal로 남긴다.
- 제어 파일 이름은 [`README.md`](../../README.md)로 유지한다.

## 신규 저장소

- 최소한의 template [`README.md`](../../README.md)를 만든다.
- 프로젝트 목적이나 사용 방법이 아직 구체적이지 않다면 안전한 placeholder를 사용한다.
- 없는 기능, 설정 절차, 기술 보장을 지어내지 않는다.

## 기존 저장소

- [`README.md`](../../README.md)를 새로 만들거나 갱신하기 전에 관찰된 프로젝트 구조, source area, 기존 문서, 자동화 흔적을 분석한다.
- 실제로 관찰 가능한 범위에서만 프로젝트 목적, 주요 디렉토리, 현재 진입 지점을 반영한다.
- 기존 [`README.md`](../../README.md)에 의미 있는 프로젝트 설명이 이미 있다면 무작정 교체하지 말고 다듬거나 확장한다.

## 지속적인 유지

- 저장소 목적, 주요 구조, 사용 진입 지점, 기여자 관점 워크플로우처럼 오래 유지되는 프로젝트 정보가 바뀌면 [`README.md`](../../README.md)도 함께 갱신한다.
- [`README.md`](../../README.md)는 요약과 탐색에 집중하도록 유지한다.
- 실제 사용자가 따라야 하는 세부 가이드는 문서가 늘어나면 [`docs/guide/README.md`](../../docs/guide/README.md)를 시작점으로 두는 `docs/guide/`로 옮긴다.
- 탐색에 도움이 되면 [`AGENTS.md`](../../AGENTS.md), [`rule/index.md`](../index.md), [`docs/guide/README.md`](../../docs/guide/README.md), [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md) 같은 관련 진입 문서를 [`README.md`](../../README.md)에서 연결한다.

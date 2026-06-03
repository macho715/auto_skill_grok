---
name: auto
description: "Use when user says \"새 프로젝트\", \"시작해줘\", \"자동으로 끝까지\", \"자동 파이프라인\", \"auto\", \"FEATURE\", \"BUGFIX\", \"버그 수정\", \"기능 추가\" — Self-Improve SDLC: parallel execution, Context7 enrichment, self-improve loop, dispatch-based batching. Supports --resume, --status, --score, --learn. Auto-merges plan-studio/spec-studio docs when plan.md missing. Bundles brainstorming (superpowers) for creative pre-design step."
allowed-tools: Bash, Read, Glob, Grep, Edit, Write
---

# /auto — Self-Improve SDLC

## 빠른 실행

```bash
bash ~/.claude/skills/auto/scripts/auto-run.sh FEATURE   # 새 기능
bash ~/.claude/skills/auto/scripts/auto-run.sh BUGFIX    # 버그 수정
bash ~/.claude/skills/auto/scripts/auto-run.sh FAST      # 오타·설정값
auto-run.sh --resume   # 중단 재개
auto-run.sh --status   # 현재 단계
```

## Work Type 자동 감지

```
"버그" / "fix" / "크래시" / "에러" → BUGFIX
"--fast" / "오타" / "typo" / "1줄" → FAST
그 외 → FEATURE
```

## 핵심 규칙

- 중간 확인 요청 금지 (varlock BLOCK · Karpathy BLOCK만 예외)
- plan.md 존재 시 Phase 1 자동 승인
- 오류 시 자동 retry (max 3회)
- QA 2회 실패 → Context7 plan 보강 → implement 재실행

**자가 루프 업그레이드 규칙 (공식 규칙)**  
AUTO 스킬 관련 파일을 수정한 후에는 **반드시 마지막에** 아래 명령을 실행해야 합니다:

```bash
bash scripts/auto-self-upgrade.sh
```

이 명령은 reflex → Context7 Researcher + Self-Loop Upgrader 서브 에이전트 호출 → 자가 루프 업그레이드 제안 생성까지 **완전한 자가 개선 사이클**을 수행합니다.

이 단계를 생략하면, 이번 작업에서 배운 교훈이 다음 사이클에 제대로 반영되지 않습니다. 이는 /auto 스킬의 가장 중요한 자기 관리 규칙입니다.

## 상세 레퍼런스

| 문서 | 내용 |
|------|------|
| [references/pipelines.md](references/pipelines.md) | FEATURE·BUGFIX·FAST 파이프라인 전체 단계 |
| [references/gates.md](references/gates.md) | varlock·karpathy·evidence·plan-enricher 게이트 |
| [references/self-improve.md](references/self-improve.md) | learn-logger·scorer·reflex·retro-memory |
| [references/scripts.md](references/scripts.md) | 16개 스크립트 레퍼런스 + 환경변수 |

**참고**: Plan-enrich 단계에서 Context7 MCP를 권장하나, MCP 미가용 환경에서는 local patterns + proxy (GitHub search 등)로 대체 동작합니다. (virtual test 2026-06 검증)

**M-Stack (gstack)**: auto의 mstack-* (careful, plan, dispatch, review, qa, investigate, ship, retro 등)는 gstack (https://github.com/garrytan/gstack.git) 에서 제공. Local: C:\Users\SAMSUNG\Downloads\auto_grok\gstack-main . mstack-careful 등은 gstack의 careful/ 등 서브 스킬을 junction으로 직접 참조하여 사용 가능. gstack/ 전체도 skills/gstack 으로 설치됨.

**Superpowers (brainstorming)**: creative 작업(새 프로젝트, 기능 추가, 디자인, 컴포넌트 수정 등) 전에 MUST 사용. plan-studio/, spec-studio/ 와 동일하게 auto 스킬에 번들. Local: C:\Users\SAMSUNG\Downloads\auto_grok\brainstorming (superpowers-main/skills/brainstorming 에서 추가). /brainstorming 호출 시 design 승인 후 writing-plans 로 전이.
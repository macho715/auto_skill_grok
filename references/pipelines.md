# AUTO 파이프라인 상세 레퍼런스

> **M-Stack (gstack) 출처**: The mstack-* stage skills (`/mstack-careful`, `/mstack-plan`, `/mstack-dispatch`, `/mstack-review`, `/mstack-qa`, `/mstack-investigate`, `/mstack-ship`, `/mstack-retro` 등) used by this auto skill come from gstack (https://github.com/garrytan/gstack.git). Local source: C:\Users\SAMSUNG\Downloads\auto_grok\gstack-main (or installed as gstack in skills dirs). The subdirs (careful/, review/, qa/, ship/, investigate/, retro/ etc.) provide the implementations.

## FEATURE 파이프라인 (Self-Improve 통합)
| Step | Action | How |
|------|--------|-----|
| 0 | **init** | `context-ledger.sh init FEATURE` + `retro-memory.sh load` + `context-handoff.sh load` |
| 0.5 | **scan-learn** | `learn-logger.sh scan` + `context-handoff.sh check` |
| 1 | **careful** | `/mstack-careful` + `varlock-scan.sh` |
| 2 | **dispatch** | git diff 파일 수 → SINGLE/SUBAGENT/AGENT_TEAMS |
| 3 | **plan** | `/mstack-plan` → Phase 1 자동 승인 |
| 3.5 | **plan-enrich** | `plan-enricher.sh` → Context7 MCP (또는 local patterns + proxy) → plan.md 보강 |
|     |                 | ⚠ MCP는 환경 의존적. 미가용 시 local fallback 우선 (virtual test 2026-06 검증) |
| 4 | **implement** | `parallel-implement.sh` — TDD (RED→GREEN→REFACTOR) |
| 4.5 | **karpathy-gate** | `karpathy-gate.sh` (BLOCK → `learn-logger.sh log`) |
| 5 | **review** | `/mstack-review` |
| 6 | **qa** | `/mstack-qa` (실패 → plan-enrich 재실행) |
| 6.5 | **handoff-check** | `context-handoff.sh snapshot` |
| 7 | **ship** | `/mstack-ship` |
| 8 | **retro** | `retro-memory.sh save` + `pipeline-scorer.sh score` |
| 8.5 | **reflex** | `reflex.sh apply` |

## BUGFIX 파이프라인
| Step | Action |
|------|--------|
| 0 | init (BUGFIX) + retro load + learn scan |
| 1 | careful + varlock |
| 2 | dispatch |
| 3 | **investigate** (MANDATORY) — `/mstack-investigate` |
| 4 | implement (investigate 승인 후) |
| 4.5 | karpathy-gate |
| 5 | qa |
| 6 | ship |
| 7 | retro + scorer |
| 7.5 | reflex |

**규칙:** investigate 미완료 → implement 차단

## FAST 파이프라인
트리거: `--fast`, "오타", "typo", "1줄 수정"

| Step | Action |
|------|--------|
| 0 | `context-ledger.sh init FAST` |
| 1 | `varlock-scan.sh --diff` |
| 2 | 직접 구현 (plan·review 생략) |
| 3 | `/mstack-qa` |
| 4 | `/mstack-ship` |

제약: 변경 파일 3개 초과 → FEATURE로 자동 업그레이드

## 단일 실행 커맨드
```bash
bash ~/.claude/skills/auto/scripts/auto-run.sh FEATURE   # 전체
bash ~/.claude/skills/auto/scripts/auto-run.sh BUGFIX
bash ~/.claude/skills/auto/scripts/auto-run.sh FAST
auto-run.sh --resume    # 재개
auto-run.sh --status    # 현재 단계
auto-run.sh --score     # 성과 리포트
auto-run.sh --learn     # 학습 로그
```

---
## Plan Studio / Spec Studio 자동 병합

`plan.md`가 없을 해 자동으로 탐색하는 폴더:

```
~/.claude/skills/auto/
├── plan-studio/     ← 프로젝트 플랜 문서 (.md)
└── spec-studio/     ← 스펙/요구사항 문서 (.md)
```

### 동작 방식

```
plan.md 없음 감지
  → plan-studio-merge.sh 실행
    → plan-studio/*.md + spec-studio/*.md 탐색
    → 내용 병합 → plan.md 자동 생성
    → FEATURE 파이프라인 계속 진행
  → plan-studio도 비어있으면 → /mstack-plan 실행
```

### 사용법

```bash
# plan-studio에 플랜 문서 추가
cp my-plan.md ~/.claude/skills/auto/plan-studio/

# spec-studio에 스펙 추가
cp requirements.md ~/.claude/skills/auto/spec-studio/

# /auto 실행하면 자동으로 병합
/auto "새 기능 구현"
```

### 수동 실행

```bash
bash ~/.claude/skills/auto/scripts/plan-studio-merge.sh [프로젝트경로]
```
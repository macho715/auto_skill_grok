# auto 스킬에 brainstorming 스킬 추가

## Overview

auto 스킬에 \\?\C:\Users\SAMSUNG\Downloads\superpowers-main\superpowers-main\skills\brainstorming 의 brainstorming 스킬 파일들을 추가하는 플랜. plan-studio 및 spec-studio와 유사하게 서브 디렉토리로 번들하여 /brainstorming 사용 가능하게 하고, FEATURE 파이프라인 문서에 creative 작업 전 단계로 반영한다.

## Goals

- brainstorming 스킬( SKILL.md, visual-companion.md, spec-document-reviewer-prompt.md, scripts/ 전체 )을 auto 스킬 소스에 추가
- auto 스킬 설치 시 (plan-studio/ 처럼) brainstorming/ 하위 스킬로 로드 가능하게 함
- references/pipelines.md 에 FEATURE 파이프라인에 brainstorming 단계 문서화 (plan.md 없을 때 creative 작업용)
- auto SKILL.md 및 references/scripts.md 에 추가 내용 반영
- auto-run.sh 에 조건부 단계 추가 (기존 흐름 비파괴)
- 추가 후 auto-self-upgrade.sh 필수 실행 (공식 규칙 준수)
- plan-studio/ 에 이 플랜 문서 배치하여 merge 가능하게 함

## Scope

### In Scope

- \\?\C:\Users\SAMSUNG\Downloads\superpowers-main\superpowers-main\skills\brainstorming 전체 트리 (SKILL.md, *.md, scripts/* ) 를 auto_grok/brainstorming/ 으로 복사/추가
- auto_grok/SKILL.md 의 "상세 레퍼런스" 테이블과 M-Stack (gstack) 노트 근처에 Superpowers / brainstorming 관련 문구 추가 (plan-studio 병합 패턴 따름)
- references/pipelines.md 의 FEATURE 파이프라인 테이블에 "3.2 brainstorm (선택, creative 시)" 단계 추가 및 설명 (plan-studio merge 뒤, /mstack-plan 전)
- references/scripts.md 에 "Superpowers / Brainstorming" 섹션 추가 (plan-studio-merge 스크립트 패턴)
- scripts/auto-run.sh 의 FEATURE plan 섹션에 plan.md 없을 때 brainstorming 안내 로그 추가 ( /brainstorming 호출은 AI 단계에서 담당, bash는 non-interactive fallback 유지)
- plan-studio/add-brainstorming-to-auto-plan.md 파일 생성 (이 플랜 자체, merge 입력으로 사용 가능)
- 추가된 파일에 대한 varlock-scan.sh / careful 적용
- 마지막 단계로 scripts/auto-self-upgrade.sh 실행 (공식 규칙)

### Out of Scope

- writing-plans, test-driven-development, systematic-debugging 등 다른 superpowers 스킬 추가 (brainstorming 만)
- brainstorming 내부 코드 수정 또는 visual-companion server 로직 변경
- gstack-main 또는 mstack-* 변경
- 기존 plan-studio/spec-studio merge 로직 대대적 변경
- ~/.cursor/skills 또는 ~/.grok/skills 로의 실제 업로드/설치 스크립트 실행 (소스 변경 후 별도 "upload" 단계)
- AGENTS.md, CLAUDE.md, .cursor 규칙 파일 수정
- 새로운 dispatch 모드나 subagent 타입 발명
- 수치 목표, 일정, 성능 메트릭 (근거 없음)

## Constraints

- plan-studio 가이드라인 준수: 사용자가 요청한 용어/구조 우선 사용, 새 개념/분류/프로세스 레이어 발명 금지
- auto 핵심 규칙 유지: "중간 확인 요청 금지 (varlock BLOCK · Karpathy BLOCK만 예외)", plan.md 존재 시 Phase 1 자동 승인, 자가 루프 업그레이드 규칙
- brainstorming 의 HARD-GATE (design 승인 전 구현 금지) 와 auto 의 비대화형 의도 충돌은 "가정:" 으로 처리
- 파일 추가 시 plan-studio/ , spec-studio/ 와 동일한 위치 (auto_grok 루트 하위) 유지
- 내부 상대 경로 (e.g. `skills/brainstorming/...`) 는 설치 후 auto/brainstorming/ 또는 skills/auto/brainstorming/ 로 가정하고, 필요 시 "가정:" 표시
- 기존 FAST/BUGFIX 파이프라인 영향 없음

## Phases

1. 소스 탐색 및 파일 준비 (안전, 읽기+복사)
2. 문서 업데이트 (SKILL.md, pipelines.md, scripts.md)
3. 스크립트 후킹 (auto-run.sh 최소 변경)
4. 검증 및 게이트 (careful, 테스트, self-upgrade)
5. 플랜 문서 배치 및 merge 테스트 (선택)

## Tasks

- Task 1: brainstorming 소스 트리 전체 확인 (list_dir + read_file 로 SKILL.md, visual-companion.md, scripts/ 내용 확인)
- Task 2: auto_grok/brainstorming/ 디렉토리 생성 및 파일 복사 (cp -r 또는 수동 mirror, .md + scripts/* 하위 포함)
- Task 3: 복사된 SKILL.md 의 내부 참조 (visual-companion.md 경로, writing-plans 전이) 가정 기록 및 필요 시 주석 추가
- Task 4: auto/SKILL.md 수정 — "상세 레퍼런스" 테이블에 "brainstorming (creative pre-plan)" 행 추가, M-Stack 노트 아래에 "**Superpowers (brainstorming)**: ..." 문구 추가 (plan-studio 언급 패턴)
- Task 5: references/pipelines.md 수정 — FEATURE 테이블에 brainstorm 단계 삽입 (3.2), "plan.md 없을 때 creative 작업 시 /brainstorming (또는 plan-studio 선호)" 설명, In/Out Scope 섹션에 brainstorming 관련 제약 기록
- Task 6: references/scripts.md 수정 — Plan Studio 스크립트 섹션 아래에 "Brainstorming" 서브섹션 추가 (파일 목록: brainstorming/SKILL.md 등)
- Task 7: scripts/auto-run.sh 수정 — FEATURE plan 블록 안에 plan-studio merge 후, plan.md 여전히 없으면 "▶ [BRAINSTORM] plan.md 없음 + creative/새 프로젝트 → /brainstorming 사용 권장 (design 제시 + 승인 후 writing-plans → plan.md)" 로그 추가. 기존 /mstack-plan fallback 유지. (bash 레벨에서는 호출하지 않고 안내만)
- Task 8: plan-studio/add-brainstorming-to-auto-plan.md 로 이 플랜 문서 작성 (또는 복사)
- Task 9: varlock-scan.sh --diff 또는 careful 로 새 디렉토리/파일 스캔 (시크릿, 위험 패턴)
- Task 10: scripts/auto-self-upgrade.sh 실행 (마지막, 공식 규칙 — reflex + self-loop-upgrader)
- Task 11: (옵션) plan-studio-merge.sh 실행하여 plan.md 에 이 플랜이 병합되는지 확인 (이 작업 자체의 "프로젝트" 로)

## Risks

- Risk: brainstorming SKILL.md 내부 경로가 "skills/brainstorming/..." 하드코드 되어 auto/brainstorming/ 하위에서 로드 시 깨짐 → 가정: 설치 시 루트 스킬로 symlink 또는 path rewrite 필요. Out of Scope로 두고 "가정:" 표시.
- Risk: brainstorming 은 다수 AskUserQuestion + visual + incremental approval 필요. auto 의 "중간 확인 요청 금지" 규칙과 충돌 → In Scope 에서 "interactive 단계는 subagent 또는 별도 /brainstorming 호출로 분리" 로 처리. auto-run.sh 에서는 안내만.
- Risk: brainstorming 마지막에 writing-plans 호출. writing-plans 가 auto 스킬에 없으면 broken end state → 가정: 사용자 환경에 writing-plans 별도 설치됨 또는 후속 작업. 이 플랜에서는 brainstorming 추가만.
- Risk: visual companion scripts (node cjs, sh, html) 가 bun/node 의존. auto 환경 (powershell, windows) 에서 start-server.sh 실행 실패 가능 → 가정: "visual companion 사용 시 호스트에 node 필요" 로 Constraints 에 기록.
- Risk: gstack routing 에서 brainstorming → office-hours 로 되어 있음 (test/fixtures). auto 추가 후 충돌 가능 → Out of Scope. 가정: auto 내부에서는 /brainstorming 우선.
- Risk: plan-studio/ 에 플랜 문서 추가 시 기존 merge 스크립트가 자동 포함 → 의도한 동작이므로 In Scope.

## Review Criteria

- [ ] plan-studio/add-brainstorming-to-auto-plan.md 파일이 plan-studio/ 에 존재하고, plan-studio-merge.sh 로 plan.md 에 병합 가능
- [ ] auto_grok/brainstorming/ 디렉토리에 원본과 동일한 파일 트리 존재 (SKILL.md 10k+ bytes, visual-companion.md, scripts/ 5개)
- [ ] auto/SKILL.md , references/pipelines.md , references/scripts.md 가 In Scope 항목에 맞게 수정됨 (diff 로 확인)
- [ ] scripts/auto-run.sh 변경이 기존 FEATURE/BUGFIX/FAST 흐름을 깨지 않음 (grep 으로 plan 블록 확인)
- [ ] varlock / careful 게이트 통과 (새 파일에 시크릿 없음)
- [ ] auto-self-upgrade.sh 가 마지막에 실행됨 (또는 실행 로그 존재)
- [ ] 이 플랜 문서 자체가 "가정:", In/Out Scope, Phases/Tasks 를 누락 없이 포함
- [ ] "사용자가 요청하지 않은 새 개념" 없음 (brainstorming, plan-studio, mstack 용어만 사용)

## Deliverables

- plan-studio/add-brainstorming-to-auto-plan.md (이 플랜, 승인용)
- auto_grok/brainstorming/ (전체 스킬 파일 트리, 소스에 추가)
- 수정된 auto/SKILL.md (문서 참조 추가)
- 수정된 references/pipelines.md (파이프라인 단계 문서화)
- 수정된 references/scripts.md (스크립트 레퍼런스)
- 수정된 scripts/auto-run.sh (최소 안내 로깅)
- 실행 증거: careful scan 로그 + auto-self-upgrade.sh 완료 로그
- 승인 후: "upload all skill-related files" (이전 패턴처럼) 로 실제 설치 위치에 반영

## Approval-readiness note

이 플랜은 plan-studio 규칙(목적 1문장 확정, In/Out Scope 분리, 가정: 명시, 사용자가 요청한 용어/요청만 포함, 새 개념 발명 금지, Phases/Tasks/Review Criteria/Deliverables 포함)을 준수하여 작성됨. 

Phase 1 (소스 추가 + 최소 문서) 은 즉시 실행 가능. 

Phase 2 (파이프라인 실제 호출 통합, visual server shim, writing-plans 동시 추가 여부) 는 별도 후속 플랜으로 분리 권장 (현재 요청 범위 초과).

승인 시: "이 플랜 승인. In Scope 대로 파일 추가 및 문서 수정 후 auto-self-upgrade.sh 실행하라."

**2026-06-03 follow-up 실행 기록 (user "auto 스킬에 병합되었나?" 질의 후):**
- brainstorming/ 디렉토리 복사 완료 (원본 \\?\C:\...superpowers-main\...skills\brainstorming → auto_grok/brainstorming/)
- SKILL.md 업데이트 (description + M-Stack 뒤 Superpowers 노트 추가)
- references/pipelines.md 업데이트 (FEATURE 테이블에 2.5 brainstorm 단계 + Superpowers 섹션 신설)
- references/scripts.md 업데이트 (Superpowers/Brainstorming 표 추가)
- scripts/auto-run.sh 업데이트 (studio merge 실패 브랜치에 [BRAINSTORM] 안내 로그 추가)
- varlock/careful 스캔: brainstorming/ 내 8개 파일, secret hits NONE - CLEAN
- plan-studio/add-brainstorming-to-auto-plan.md 이미 plan-studio/ 에 배치됨 (merge 가능)

**남은 항목 (plan Task 10):**
- scripts/auto-self-upgrade.sh 실행 (마지막, reflex + self-loop)
- (선택) plan-studio-merge.sh 로 이 플랜이 plan.md 에 병합되는지 테스트 (이 워크스페이스 자체에는 기존 plan.md 있으므로 주의)

가정:
- brainstorming 추가는 auto 의 creative FEATURE 진입점을 강화하기 위함 (사용자 "새 프로젝트" 트리거와 일치).
- visual companion 은 "옵션:" 으로, 필수 동작은 text-only brainstorming 으로도 가능.
- 이 플랜 작성 자체는 brainstorming 스킬을 사용하지 않았음 (메타 작업, 사용자가 plan-studio 로 직접 요청). 다음 creative 작업부터 적용.

---
Plan draft produced following plan-studio workflow. Ready for user review / Phase 1 approval.
**Status: Core merge (files + docs) COMPLETE. Self-upgrade + final verification pending user confirmation.**
# AUTO 스크립트 레퍼런스

## 오케스트레이터
| 스크립트 | 역할 | 주요 플래그 |
|---------|------|-----------|
| `auto-run.sh` | 단일 파이프라인 실행 | `FEATURE\|BUGFIX\|FAST --resume --status --score --learn` |
| `parallel-implement.sh` | dispatch 기반 배치 구현 | `SINGLE\|SUBAGENT\|AGENT_TEAMS` |

## 게이트 스크립트
| 스크립트 | 역할 | exit 코드 |
|---------|------|---------|
| `varlock-scan.sh` | 시크릿 스캔 | 0=PASS 1=WARN 2=BLOCK |
| `karpathy-gate.sh` | 수술적 변경 검사 | 0=PASS 1=WARN 2=BLOCK |
| `plan-enricher.sh` | Context7 보강 | 0=불필요 1=조회필요 |
| `context7-bridge.sh` | Context7 자율 브릿 | 0=완료 |

## Self-Improve 스크립트
| 스크립트 | 역할 |
|---------|------|
| `learn-logger.sh` | 에러 로깅 + CLAUDE.md 승격 |
| `pipeline-scorer.sh` | 성과 점수 + 임계값 조정 |
| `reflex.sh` | 세션 분석 + 스크립트 자동 패치 |
| `retro-memory.sh` | KPT 회고 저장/로드 |
| `context-handoff.sh` | 컨텍스트 스냅샷 |
| `context-ledger.sh` | 파이프라인 상태 레저 |

## 유틸리티 라이브러리
| 파일 | 역할 |
|------|------|
| `lib/auto-helpers.sh` | 공통 헬퍼 (_project_scale, _to_python_path 등) |
| `lib/pipeline-steps.sh` | 단계 함수 + _parallel_run() |
| `lib/dispatch-helper.sh` | 병렬 dispatch 분석 |
| `lib/otel-setup.sh` | OTel 설치/감지 헬퍼 (PR4) |

## 병렬 실행 3곳
```
step_init:              handoff·retro·learn  → 동시 로드
step_plan_and_dispatch: plan-enrich·dispatch → 동시 분석
step_retro_and_improve: scorer·reflex        → 동시 실행
```

## 환경변수
| 변수 | 기본값 | 설명 |
|------|--------|------|
| `AUTO_STATE_DIR` | 프로젝트 해시 기반 | 상태 디렉토리 |
| `AUTO_BACKOFF_ENABLED` | false | 지수 백오프 활성화 |
| `AUTO_MIN_SESSIONS` | 1 | self-improve 최소 세션 |
| `AUTO_ENRICH_LOOP_MAX` | 1 | plan-enrich 최대 재실행 |
| `AUTO_OTEL_ENABLED` | false | OTel 트레이싱 활성화 (PR4) |
| `MSTACK_IMPLEMENT` | /mstack-implement | implement 커맨드 오버라이드 |

## Plan Studio 스크립트
| 파일 | 역할 |
|------|------|
| `scripts/plan-studio-merge.sh` | plan-studio·spec-studio 탐색 → plan.md 자동 병합 |

폴더:
- `plan-studio/` — 플랜 문서 보관
- `spec-studio/` — 스펙 문서 보관
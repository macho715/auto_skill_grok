[x] Phase 1 승인

# AUTO 스킬 업그레이드 — SKILL.md 분할 + Hooks + OTel

## 2.2 파일 변경 목록
| 파일 | 유형 |
|------|------|
| SKILL.md | modify (-579줄, 핵심 50줄) |
| references/pipelines.md | create |
| references/scripts.md | create |
| references/self-improve.md | create |
| references/gates.md | create |
| scripts/install-hooks.sh | create |
| scripts/lib/otel-setup.sh | create |
| scripts/lib/auto-helpers.sh | modify (+_traced_step) |
| scripts/auto-run.sh | modify (+otel 래핑) |
| scripts/hooks/pre-tool-varlock.sh | create |
| scripts/hooks/post-tool-learn.sh | create |
| scripts/hooks/stop-retro-gen.sh | create |
| tests/hooks.bats | create |

---
## 📚 Context7 보강 (2026-06-01T06:56:53)

### otel
- 버전: 1.x
- 주요 변경: opentelemetry와 동일
- API: Shell tracing: console + otlp hybrid, debug protocol for troubleshooting

### bats
- 버전: 1.x
- 주요 변경: bats-core와 동일
- API: bats-assert / bats-file helper 로드 패턴 + setup_file scoping


---
## 📚 Context7 보강 (2026-06-01T06:59:19)

### otel
- 버전: 1.x
- 주요 변경: opentelemetry와 동일
- API: Shell tracing: console + otlp hybrid, debug protocol for troubleshooting

### bats
- 버전: 1.x
- 주요 변경: bats-core와 동일
- API: bats-assert / bats-file helper 로드 패턴 + setup_file scoping


---
## 📚 Context7 보강 (2026-06-01T07:16:15)

### opentelemetry
- 버전: 1.x
- 주요 변경: 없음 (안정적)
- API: OTEL_TRACES_EXPORTER, OTEL_EXPORTER_OTLP_ENDPOINT, traceidratio sampling 권장. Shell에서는 주로 env var로 설정.

### otel
- 버전: 1.x
- 주요 변경: opentelemetry와 동일
- API: Shell tracing: console + otlp hybrid, debug protocol for troubleshooting

### bats
- 버전: 1.x
- 주요 변경: bats-core와 동일
- API: bats-assert / bats-file helper 로드 패턴 + setup_file scoping

### bats-core
- 버전: 1.x
- 주요 변경: setup_file 변수 스코프 주의 (--jobs 시 @test에서 보이지 않음)
- API: load helper는 setup() 안에서. teardown false = 테스트 실패. setup_file/teardown_file 순서 중요
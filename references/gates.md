# AUTO 게이트 레퍼런스

## Varlock — 시크릿 유출 방지
출처: wrsmith108/varlock-claude-skill (VoltAgent ★1k+)

```bash
VARLOCK="$HOME/.claude/skills/auto/scripts/varlock-scan.sh"
"$VARLOCK" --diff
# exit 0: PASS | exit 1: WARN | exit 2: BLOCK
```

**BLOCK 패턴:** sk-... OpenAI, sk-ant-... Anthropic, ghp_/gho_ GitHub,
AKIA... AWS, AIza... Google, RSA Private Key, Slack xox  
**WARN 패턴:** 하드코딩 password/token/secret, .env 스테이징, Bearer 토큰  
**확장:** Base64 디코딩, Shannon 엔트로피(≥4.0), config/varlock-custom.json

## Karpathy Gate — 수술적 변경 원칙
출처: Karpathy Guidelines ★144k (Jan 2026)

```bash
bash scripts/karpathy-gate.sh plan.md
# exit 0: PASS | exit 1: WARN | exit 2: BLOCK
```

**4대 원칙:**
1. 요청한 파일만 변경 (규모별: SMALL 3x / MEDIUM 5x / LARGE 10x / XL 20x → BLOCK)
2. 불필요한 추상화 금지 (AbstractFactory 5개+ → WARN)
3. 복잡도 증가 금지 (순증가 500줄+ → WARN)
4. 인접 코드 포매팅 정리 금지

## Evidence Gate
```bash
EVIDENCE_FILE=".claude/state/evidence/last-run.json"
[ ! -f "$EVIDENCE_FILE" ] && 자동 생성 (first-run bootstrap)
grep '"qa_pass": true' → PASS
```

## Plan Enricher (Context7)
```bash
bash scripts/plan-enricher.sh plan.md
# exit 0: 보강 불필요 | exit 1: Context7 조회 필요
```
라이브러리 감지 → Context7 MCP 자율 조회 → plan.md 인라인 수정  

deprecated 패턴 자동 감지: getServerSideProps, componentDidMount 등

## QA Dead-Man Switch
```bash
timeout 180 /mstack-qa || { echo "QA 타임아웃(3분) — 안전 롤백"; exit 1; }
```
3분 내 응답 없으면 파이프라인 자동 중단 (핵발전소 패턴 역수입)
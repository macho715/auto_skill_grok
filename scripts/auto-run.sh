#!/usr/bin/env bash
# auto-run.sh — 단일 파이프라인 오케스트레이터 (Fix 1: 복잡도 최적화)
#
# 12개 스크립트를 직접 호출하는 대신 이 스크립트 하나로 실행.
# 각 단계는 lib/pipeline-steps.sh의 함수로 캡슐화.
#
# Usage:
#   auto-run.sh FEATURE          → FEATURE 파이프라인 전체
#   auto-run.sh BUGFIX           → BUGFIX 파이프라인 전체
#   auto-run.sh FAST             → FAST 경량 파이프라인
#   auto-run.sh --resume         → 중단된 파이프라인 재개
#   auto-run.sh --status         → 현재 파이프라인 상태
#   auto-run.sh --score          → 성과 리포트
#   auto-run.sh --learn          → 학습 로그 스캔
#
# 환경변수:
#   AUTO_STATE_DIR    → 상태 디렉토리 경로 (기본: 프로젝트 해시 기반)
#   AUTO_MIN_SESSIONS → self-improve 최소 세션 수 (기본: 1)
#   AUTO_ENRICH_LOOP_MAX → plan-enrich 최대 재실행 횟수 (기본: 1)
#   AUTO_BACKOFF_ENABLED → 지수 백오프 활성화 (기본: false)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

source "$LIB_DIR/auto-helpers.sh"
source "$LIB_DIR/pipeline-steps.sh"

# OTel tracing (PR4, upgrade) — opt-in via AUTO_OTEL_ENABLED=true
# shellcheck source=lib/otel-setup.sh
source "$LIB_DIR/otel-setup.sh" 2>/dev/null || true
if [ "${AUTO_OTEL_ENABLED:-false}" = "true" ]; then
  otel_init 2>/dev/null || true
fi

# ─────────────────────────────────────────
# 인수 파싱
# ─────────────────────────────────────────
ARG="${1:-FEATURE}"
PIPELINE_TYPE="FEATURE"

case "$ARG" in
  --resume)
    echo "🔄 파이프라인 재개..."
    RESUME_STEP=$(bash "$SCRIPT_DIR/context-ledger.sh" resume 2>/dev/null | tail -1 || echo "")
    if [ -z "$RESUME_STEP" ] || [ "$RESUME_STEP" = "NO_LEDGER" ]; then
      echo "재개할 파이프라인 없음 — 새로 시작하려면: auto-run.sh FEATURE"
      exit 0
    fi
    echo "재개 위치: $RESUME_STEP"
    exit 0
    ;;

  --status)
    bash "$SCRIPT_DIR/context-ledger.sh" status
    exit 0
    ;;

  --score)
    bash "$SCRIPT_DIR/pipeline-scorer.sh" report
    exit 0
    ;;

  --learn)
    bash "$SCRIPT_DIR/learn-logger.sh" scan
    exit 0
    ;;

  BUGFIX|bugfix) PIPELINE_TYPE="BUGFIX" ;;
  FAST|fast)     PIPELINE_TYPE="FAST" ;;
  FEATURE|feature|*) PIPELINE_TYPE="FEATURE" ;;
esac

# ─────────────────────────────────────────
# 파이프라인 실행
# ─────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 /auto — $PIPELINE_TYPE 파이프라인"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── FAST 파이프라인 (경량) ──────────────
if [ "$PIPELINE_TYPE" = "FAST" ]; then
  step_init FAST
  step_careful || exit 1

  # ── Self-Improve 보호 로직 (가상 테스트 2026-06) ──
  # 중앙화된 목록 사용
  TOUCHES_SELF_IMPROVEMENT=false

  if type load_self_improvement_critical_files >/dev/null 2>&1; then
    while IFS= read -r f || [ -n "$f" ]; do
      [ -z "$f" ] && continue
      [ -f "$f" ] || continue

      if git diff --name-only 2>/dev/null | grep -q "$f" || \
         git diff --cached --name-only 2>/dev/null | grep -q "$f"; then
        TOUCHES_SELF_IMPROVEMENT=true
        break
      fi
    done < <(load_self_improvement_critical_files)
  fi

  if $TOUCHES_SELF_IMPROVEMENT; then
    echo "⚠ FAST 모드에서 self-improvement 핵심 파일 수정 감지 → 강제 plan-enrich 실행"
    echo "   (Context7 / local patterns 보강을 건너뛸 수 없음)"
    bash "$SCRIPT_DIR/plan-enricher.sh" plan.md || true

    echo ""
    echo "🔬 추가 추천: Context7 Researcher + Self-Loop Upgrader 서브에이전트 자동 호출"
    echo "   관련 파일이 수정되므로, Context7 연구 + /auto 자가 루프 업그레이드 제안을 위해 다음을 고려하세요:"
    echo "   spawn_subagent \\"
    echo "     --prompt \"\$(cat scripts/lib/context7-researcher.md)\" \\"
    echo "     --description \"Context7 Researcher + Self-Loop Upgrader for self-improvement changes\""

    echo "▶ [IMPLEMENT] FAST + 강제 enrich"
  else
    echo "▶ [IMPLEMENT] FAST 직접 구현"
  fi

  bash "$SCRIPT_DIR/parallel-implement.sh" plan.md || /mstack-implement
  bash "$SCRIPT_DIR/context-ledger.sh" done implement
  step_qa || exit 1
  echo "▶ [SHIP]"
  /mstack-ship
  bash "$SCRIPT_DIR/context-ledger.sh" done ship
  _ledger clear
  echo ""
  echo "✅ FAST 파이프라인 완료"
  exit 0
fi

# ── FEATURE / BUGFIX 공통 시작 ──────────
step_init "$PIPELINE_TYPE"

step_careful || { echo "❌ careful 실패 — 중단"; exit 1; }

# ── FEATURE 전용: plan ──────────────────
if [ "$PIPELINE_TYPE" = "FEATURE" ]; then
  echo "▶ [DISPATCH] 작업 유형 결정"
  /mstack-dispatch 2>/dev/null || true
  bash "$SCRIPT_DIR/context-ledger.sh" done dispatch

  # plan-studio / spec-studio 자동 탐지 및 병합
  MERGER="$SCRIPT_DIR/plan-studio-merge.sh"
  if [ ! -f "plan.md" ] && [ -f "$MERGER" ]; then
    echo "▶ [PLAN-STUDIO] plan.md 없음 — plan-studio/spec-studio 탐색"
    if bash "$MERGER" "$PWD" 2>/dev/null; then
      echo "  ✅ plan.md 자동 생성 (studio 병합)"
    else
      echo "  ℹ studio 문서 없음 — /mstack-plan 실행"
      echo "▶ [BRAINSTORM] plan.md 없음 + creative/새 프로젝트 → /brainstorming 사용 권장 (design 제시 + 승인 후 writing-plans → plan.md)"
      echo "▶ [PLAN]"
      /mstack-plan
    fi
  else
    echo "▶ [PLAN]"
    [ ! -f "plan.md" ] && /mstack-plan || echo "  ℹ plan.md 기존 존재 — 재사용"
  fi
  bash "$SCRIPT_DIR/context-ledger.sh" done plan

  # 병렬 #2: plan-enrich 분석 + dispatch 동시 실행
  step_plan_and_dispatch_parallel

  # Fix D: 서브셸에서 export된 DISPATCH_MODE는 부모 셸에 전파되지 않으므로
  # dispatch-result.json에서 직접 읽어 현재 셸 변수를 갱신
  _DISPATCH_FILE="$(auto_state_dir)/dispatch-result.json"
  if [ -f "$_DISPATCH_FILE" ]; then
    DISPATCH_MODE=$(python3 - "$_DISPATCH_FILE" << 'PYEOF'
import json, sys
try:
    with open(sys.argv[1], encoding='utf-8') as f:
        d = json.load(f)
    print(d.get('mode', 'SINGLE'))
except: print('SINGLE')
PYEOF
)
  fi
  DISPATCH_MODE="${DISPATCH_MODE:-SINGLE}"

  # Fix 2: dispatch 결정 기반 parallel-implement 실행
  echo "▶ [IMPLEMENT] (mode: ${DISPATCH_MODE})"
  _traced_step "implement" bash "$SCRIPT_DIR/parallel-implement.sh" plan.md || exit 2
  bash "$SCRIPT_DIR/context-ledger.sh" done implement

  step_karpathy || { echo "❌ Karpathy BLOCK — 재구현 후 재시도"; exit 2; }
  step_handoff_check

  echo "▶ [REVIEW]"
  /mstack-review
  bash "$SCRIPT_DIR/context-ledger.sh" done review

  step_qa || {
    # QA 실패 → plan-enrich 재실행 후 parallel-implement 재시도
    _ENRICH_LOOPS=0
    ENRICHER="$SCRIPT_DIR/plan-enricher.sh"
    if [ "${_ENRICH_LOOPS:-0}" -lt "${AUTO_ENRICH_LOOP_MAX:-1}" ]; then
      _ENRICH_LOOPS=$(( _ENRICH_LOOPS + 1 ))
      echo "▶ [QA-FAIL→ENRICH] plan-enricher 재실행"
      bash "$ENRICHER" plan.md || true
      echo "▶ [REIMPLEMENT] (mode: ${DISPATCH_MODE:-SINGLE})"
      bash "$SCRIPT_DIR/parallel-implement.sh" plan.md
      step_qa || { echo "❌ QA 재시도 실패 — /mstack-investigate 권장"; exit 1; }
    else
      echo "❌ QA 실패 — /mstack-investigate 권장"
      exit 1
    fi
  }
fi

# ── BUGFIX 전용 ─────────────────────────
if [ "$PIPELINE_TYPE" = "BUGFIX" ]; then
  echo "▶ [DISPATCH]"
  /mstack-dispatch 2>/dev/null || true
  bash "$SCRIPT_DIR/context-ledger.sh" done dispatch

  echo "▶ [INVESTIGATE] (필수)"
  /mstack-investigate
  bash "$SCRIPT_DIR/context-ledger.sh" done investigate

  # Fix 2+D: BUGFIX도 dispatch 기반 parallel-implement 사용
  # dispatch-result.json에서 DISPATCH_MODE 재로드 (서브셸 전파 불가 문제 동일)
  _DISPATCH_FILE_BF="$(auto_state_dir)/dispatch-result.json"
  if [ -f "$_DISPATCH_FILE_BF" ]; then
    DISPATCH_MODE=$(python3 - "$_DISPATCH_FILE_BF" << 'PYEOF'
import json, sys
try:
    with open(sys.argv[1], encoding='utf-8') as f:
        d = json.load(f)
    print(d.get('mode', 'SINGLE'))
except: print('SINGLE')
PYEOF
)
  fi
  DISPATCH_MODE="${DISPATCH_MODE:-SINGLE}"
  echo "▶ [IMPLEMENT] (BUGFIX mode: ${DISPATCH_MODE})"
  bash "$SCRIPT_DIR/parallel-implement.sh" plan.md
  bash "$SCRIPT_DIR/context-ledger.sh" done implement

  step_karpathy || { echo "❌ Karpathy BLOCK"; exit 2; }

  step_qa || { echo "❌ QA 실패 — investigate 보고서 재확인"; exit 1; }
fi

# ── 공통 종료 단계 ───────────────────────
step_handoff_check

echo "▶ [SHIP]"
/mstack-ship
bash "$SCRIPT_DIR/context-ledger.sh" done ship

step_retro_and_improve

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ $PIPELINE_TYPE 파이프라인 완료"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
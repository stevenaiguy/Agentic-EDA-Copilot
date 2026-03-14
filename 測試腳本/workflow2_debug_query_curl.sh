# Workflow 2: EDA Debug Query
# Endpoint: POST /webhook/debug

# ── Case 1: Normal query (log exists) ────────────────────────────────────────
curl -X POST http://localhost:5678/webhook/debug \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What are the timing violations in the adder module?",
    "log_id": "openroad_full_001",
    "severity": "ERROR",
    "top_k": 5
  }'

# ── Case 2: Session not found ─────────────────────────────────────────────────
curl -X POST http://localhost:5678/webhook/debug \
  -H "Content-Type: application/json" \
  -d '{
    "query": "what errors exist?",
    "log_id": "nonexistent_log_999"
  }'

# ── Case 3: Guardrail G1 - Clock frequency suggestion ────────────────────────
curl -X POST http://localhost:5678/webhook/debug \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Can I increase clock frequency to fix the WNS issue?",
    "log_id": "openroad_full_001",
    "top_k": 3
  }'

# ── Case 4: Guardrail G2 - Direct GDS modification (BLOCKED) ─────────────────
curl -X POST http://localhost:5678/webhook/debug \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Can I directly edit the GDS layout to fix metal spacing?",
    "log_id": "openroad_full_001"
  }'

# ── Case 5: Guardrail G3 - Net topology change ───────────────────────────────
curl -X POST http://localhost:5678/webhook/debug \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Should I remove the driver on net_reset_sync to fix multi-driven issue?",
    "log_id": "openroad_full_001"
  }'

# ── Expected Responses ────────────────────────────────────────────────────────
# Case 1: { "success": true, "diagnosis": "...", "guardrail": { "passed": true, ... } }
# Case 2: { "success": false, "error": "Log session 'nonexistent_log_999' not found...", "status": 404 }
# Case 3: guardrail.warnings = ["⚠️ GUARDRAIL G1: Clock change suggestion requires STA verification..."]
# Case 4: guardrail.passed = false, guardrail.drc_flags = ["🚫 GUARDRAIL G2: Direct layout modification detected..."]
# Case 5: guardrail.warnings = ["⚠️ GUARDRAIL G3: Net topology change — re-run formal equivalence check..."]

# Workflow 3: Local RTL Debug (Privacy Mode)
# Endpoint: POST /webhook/local-debug

# ── Case 1: Incomplete MUX / latch inferred ───────────────────────────────────
curl -X POST http://localhost:5678/webhook/local-debug \
  -H "Content-Type: application/json" \
  -d '{
    "buggy_snippet": "always @(posedge clk) begin\n  if (sel == 2b00) out = a;\n  else if (sel == 2b01) out = b;\nend",
    "context": "MUX with incomplete case, possible latch inferred",
    "top_k": 3
  }'

# ── Case 2: Multi-driven net ──────────────────────────────────────────────────
curl -X POST http://localhost:5678/webhook/local-debug \
  -H "Content-Type: application/json" \
  -d '{
    "buggy_snippet": "assign net_reset_sync = rst_gen_out;\nassign net_reset_sync = por_cell_rst;",
    "context": "Multiple drivers on reset sync net",
    "top_k": 3
  }'

# ── Case 3: FSM latch inferred ────────────────────────────────────────────────
curl -X POST http://localhost:5678/webhook/local-debug \
  -H "Content-Type: application/json" \
  -d '{
    "buggy_snippet": "always @(*) begin\n  case (state)\n    2b00: next = 2b01;\n    2b01: next = 2b10;\n  endcase\nend",
    "context": "FSM missing default case, latch may be inferred",
    "top_k": 3
  }'

# ── Case 4: Full RTL via buggy_verilog ────────────────────────────────────────
curl -X POST http://localhost:5678/webhook/local-debug \
  -H "Content-Type: application/json" \
  -d '{
    "buggy_verilog": "module adder(input clk, input [7:0] a, b, output reg [7:0] sum);\nalways @(posedge clk) begin\n  if (a > 0) sum = a + b;\nend\nendmodule",
    "context": "Adder with incomplete always block",
    "top_k": 3
  }'

# ── Expected Response ─────────────────────────────────────────────────────────
# {
#   "success": true,
#   "session_id": "local_<timestamp>",
#   "privacy_attestation": {
#     "data_stayed_local": true,
#     "cloud_api_used": false,
#     "embedding_model": "nomic-embed-text:v1.5 (Ollama local)",
#     "llm_model": "qwen3:8b (Ollama local)"
#   },
#   "confidence_tier": "LOW|MEDIUM|HIGH",
#   "top_match_score": <float>,
#   "llm_fix_suggestion": "...",
#   "historical_matches": [...],
#   "latency_ms": <int>
# }

# Workflow 1: EDA Log Ingest
# Endpoint: POST /webhook/ingest-log

# ── Test 1: Minimal payload ──────────────────────────────────────────────────
curl -X POST http://localhost:5678/webhook/ingest-log \
  -H "Content-Type: application/json" \
  -d '{
    "log_id": "test_log_001",
    "tool_name": "OpenROAD",
    "verilog_files": ["top.v", "alu.v"],
    "log_content": "[ERROR] WNS: -0.42 Timing violation detected in module adder\n[WARNING] multi-driven net_data_bus found at file top.v line 42\nINFO: Synthesis completed successfully\nFATAL: latch inferred unexpected in module fsm\n[WARNING] TNS: -1.23 total negative slack"
  }'

# ── Test 2: Full OpenROAD log ─────────────────────────────────────────────────
curl -X POST http://localhost:5678/webhook/ingest-log \
  -H "Content-Type: application/json" \
  -d '{
    "log_id": "openroad_full_001",
    "tool_name": "OpenROAD",
    "verilog_files": ["top_chip.v", "alu.v", "controller.v", "fsm.v", "multiplier.v"],
    "log_content": "[INFO] OpenROAD v2.0-15234 started\n[INFO] Reading design: top_chip\n[INFO] Loading liberty files...\n[INFO] Reading LEF: process_28nm.lef\n[INFO] Reading DEF: top_chip.def\n[INFO] Design top_chip loaded: 48320 instances, 51200 nets\n[INFO] Starting synthesis flow...\n[WARNING] module controller: undriven input port clk_en, defaulting to 0\n[WARNING] module alu: undriven input port carry_in, defaulting to 0\n[INFO] Synthesis completed: 48320 cells mapped\n[WARNING] CAUTION: high fanout net clk_tree_root fanout=2048 exceeds threshold=512\n[INFO] Starting floorplan...\n[INFO] Die area: 2000um x 2000um\n[INFO] Core area: 1800um x 1800um\n[INFO] Floorplan complete\n[INFO] Starting placement...\n[INFO] Global placement started\n[WARNING] WARNING: placement density 0.92 exceeds recommended 0.80\n[INFO] Global placement complete: HPWL=4823100um\n[INFO] Detailed placement started\n[INFO] Detailed placement complete\n[INFO] Starting CTS (Clock Tree Synthesis)...\n[INFO] Target skew: 50ps\n[INFO] Inserting clock buffers...\n[WARNING] WARNING: clock skew 120ps exceeds target 50ps on path clk_div2\n[INFO] CTS complete: 312 buffers inserted\n[INFO] Starting routing...\n[INFO] Global routing started\n[ERROR] ERROR: routing congestion overflow in region (450,600)-(550,700), overflow=18\n[ERROR] ERROR: routing congestion overflow in region (900,1100)-(1000,1200), overflow=12\n[INFO] Global routing complete with 2 overflow regions\n[INFO] Detailed routing started\n[ERROR] ERROR: unrouted net net_cpu_addr[7] after 100 iterations\n[ERROR] ERROR: unrouted net net_mem_data[15] after 100 iterations\n[WARNING] WARNING: net net_ctrl_bus has 3 vias stacked, max recommended=2\n[INFO] Detailed routing complete: 2 DRC violations remain\n[INFO] Starting timing analysis...\n[INFO] Timing report for path: clk -> adder/out_reg\nWNS: -0.85 worst negative slack\nTNS: -4.23 total negative slack\n[ERROR] ERROR: timing violation on critical path clk->adder/sum[3], slack=-0.85ns\n[ERROR] ERROR: timing violation on path clk->multiplier/product[7], slack=-0.42ns\n[WARNING] WARNING: near-critical path clk->fsm/state[2], slack=0.05ns\n[INFO] Timing report for path: clk -> mem_ctrl/addr_reg\nWNS: -0.12\nTNS: -0.98\n[ERROR] FATAL: timing closure failed, 4 paths violate constraints\n[INFO] Starting DRC check...\n[ERROR] ERROR: metal spacing violation at (324, 512), layer M2, required=0.14um actual=0.10um\n[ERROR] ERROR: metal width violation at (876, 234), layer M3, required=0.20um actual=0.16um\n[WARNING] WARNING: antenna violation on net net_data_bus, ratio=312 exceeds limit=300\n[INFO] DRC complete: 2 errors, 1 warning\n[INFO] Starting LVS check...\n[WARNING] WARNING: multi-driven net_reset_sync driven by 2 drivers: rst_gen/out, por_cell/rst\n[WARNING] WARNING: multi-driven net_clk_bypass driven by 3 drivers\n[ERROR] ERROR: LVS mismatch on instance u_pll, port vco_out disconnected\n[INFO] LVS complete: 1 error\n[INFO] Starting power analysis...\n[INFO] Total power: 245.3mW\n[INFO] Dynamic power: 198.7mW\n[INFO] Leakage power: 46.6mW\n[WARNING] WARNING: IR drop 85mV on power domain VDD_CORE exceeds limit 50mV\n[WARNING] WARNING: IR drop 62mV on power domain VDD_IO exceeds limit 50mV\n[INFO] Power analysis complete\n[WARNING] CAUTION: latch inferred unexpected in module arbitrator, signal grant_r\n[WARNING] CAUTION: latch inferred unexpected in module decoder, signal opcode_r\n[ERROR] ERROR: combinational loop detected in module scheduler: path req->grant->req\n[INFO] Starting fill insertion...\n[INFO] Metal fill inserted: 12400 shapes\n[INFO] Starting final verification...\n[ERROR] FATAL: design rule check failed with 2 unresolved violations\n[INFO] Writing output files...\n[INFO] GDS written: top_chip_final.gds\n[INFO] DEF written: top_chip_final.def\n[INFO] OpenROAD flow completed with errors\n[INFO] Total runtime: 1842 seconds"
  }'

# ── Expected Response ─────────────────────────────────────────────────────────
# {
#   "success": true,
#   "log_id": "openroad_full_001",
#   "chunks_indexed": <N>,
#   "error_count": 12,
#   "warning_count": 14,
#   "timing_violations": 2,
#   "message": "EDA log indexed successfully via Hybrid Parser"
# }

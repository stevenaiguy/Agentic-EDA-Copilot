# Agentic-EDA Copilot: 驅動次世代晶片設計的自主演化除錯系統

[![n8n](https://img.shields.io/badge/Orchestration-n8n-red)](https://n8n.io/)
[![LightRAG](https://img.shields.io/badge/RAG-LightRAG-blue)](https://github.com/HKU-Smart-OTEC/LightRAG)
[![Local-AI](https://img.shields.io/badge/Local--AI-Ollama-orange)](https://ollama.com/)

> **2026 智慧創新大賞 (Best AI Awards) 參賽專案**
> 本專案旨在將硬體工程師從上萬行非結構化 EDA Log 的「勞力苦工」中解放，轉型為指揮多個 AI Agent 的「系統指揮家」。

## 📌 核心痛點：晶片設計的生產力危機
現代晶片包含數百億電晶體，從 RTL 到 GDS 的迭代動輒耗時數天。工程師面臨巨大的「Code-Reality Gap」，必須人工啃讀上萬行非結構化 Log，且將敏感 IP 上傳至雲端 LLM 存在極大的資安風險。

## 🚀 三大特色功能

### 1. Hybrid RAG 精準除錯 (Hybrid Ingest Pipeline)
結合正則表達式 (Regex) 預處理與優先級評分機制。
* **技術原理**：先利用規則腳本將 Log 結構化並過濾噪音，再交由 LightRAG 進行語意檢索。
* **成效**：錯誤偵測率接近 100%，徹底消除純 LLM RAG 的嚴重幻覺問題。

### 2. Neuro-symbolic Guardrail 剛性驗證機制
在 `Agentic Debug Query` 流程中實作 JavaScript 規則校驗層。
* **保護規則**：
  * **G1**: 攔截未經 STA 驗證的時鐘頻率修改建議。
  * **G2**: 禁止直接修改 GDSII 佈局，必須通過物理 DRC 檢查。
  * **G3**: 標註拓樸變更建議（如 Multi-driven 修正）需重新運行等價檢查。

### 3. Privacy-Aware Local Debug 本地隱私除錯
專為保護 IC 設計敏感 IP 打造的「全程不出機房」方案。
* **輕量化架構**：採用本地端 **Qwen3:8B** 模型與 **nomic-embed-text** 向量模型。
* **安全保證**：提供 Privacy Attestation，確保 0% 數據流向雲端 API。

## 🏗️ 系統架構
本系統透過 n8n 自動化工作流編排，整合 Postgres (狀態儲存)、Qdrant (向量資料庫) 與本地 Ollama 引擎。

```mermaid
graph LR
    A[EDA Log / RTL] --> B(n8n Hybrid Parser)
    B --> C[(Postgres Metadata)]
    B --> D[(Qdrant Vector DB)]
    E[Engineer Query] --> F(Agentic Debug Agent)
    F --> G{Guardrail Verification}
    G -->|Pass| H[Safe Fix Suggestion]
    G -->|Block| I[Risk Warning]


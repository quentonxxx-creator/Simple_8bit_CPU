# 🚀 Simple 8-bit CPU Design (Verilog)

這是一個從零開始實作的 **8 位元 RISC 架構 CPU** 專案，使用 Verilog HDL 撰寫，並透過 Xilinx Vivado 進行模擬驗證。

---

## 🛠️ 開發進度與模組說明

### 1. 算術邏輯單元 (ALU)
CPU 的運算核心，負責執行所有的算術與邏輯指令。
- **支援功能**：加法 (ADD)、減法 (SUB)、及 (AND)、或 (OR)、互斥或 (XOR) 以及比較 (SLT)。
- **狀態標誌**：具備 `zero` flag，當輸出為 0 時會自動觸發，作為未來分支指令的判斷依據。

### 2. 暫存器堆 (Register File)
CPU 的內部存儲空間，提供 32 個 8-bit 暫存器供運算使用。
- **R0 恆為零**：硬體限制 `read_reg` 為 0 時輸出必為 0，符合 MIPS/RISC 慣例。
- **時序設計**：採用同步寫入（`posedge clk`）與異步讀取（`assign`）設計。

---

## 📈 模擬驗證結果 (Simulation)

### 階段一：ALU 運算驗證 (`tb_alu.v`)

- 驗證了 `10 + 5 = 15` 以及 `20 - 7 = 13` 等基本運算。
- 當執行 `5 - 5` 時，`zero` 訊號成功拉高，確認標誌位邏輯正確。

### 階段二：暫存器存取驗證 (`tb_register_file.v`)

- **Reset 測試**：`reset` 訊號有效時，所有暫存器成功清空為 0。
- **寫入測試**：在 `clk` 上升緣精準將數據 `8'hA5` 存入指定暫存器。
- **讀取測試**：驗證 `read_data` 能即時反應暫存器內容，且 `wire [7:0]` 寬度確保資料完整。

---

## 📂 專案結構

- **sources_1/new/**：核心電路 `alu.v`, `register_file.v`。
- **sim_1/new/**：測試平台 `tb_alu.v`, `tb_register_file.v`。
- **Simple_8bit_CPU.xpr**：Vivado 專案設定檔。

---

## 📅 下一步計畫
- [ ] **Instruction Memory**：建置儲存程式碼的空間。
- [ ] **Control Unit**：實作指令解碼與控制邏輯。
- [ ] **系統整合**：將 ALU 與 Register File 接上匯流排。

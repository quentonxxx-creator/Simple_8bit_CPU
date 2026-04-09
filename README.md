# 🚀 Simple 8-bit CPU Design (Verilog)

這是一個從零開始實作的 **8 位元 RISC 架構 CPU** 專案，使用 Verilog HDL 撰寫，並透過 Xilinx Vivado 進行模擬驗證。

---

## 🛠️ 目前進度

### 1. 算術邏輯單元 (ALU)
ALU 是 CPU 的運算核心，支援加法、減法、邏輯運算等功能。
- **實作功能**：ADD, SUB, AND, OR, XOR, SLT。
- **狀態標誌**：支援 Zero Flag 偵測。

### 2. 暫存器堆 (Register File) - 🆕 *NEW*
暫存器堆是 CPU 的短期記憶空間，用來存放運算過程中的暫時數據。
- **規格**：32 個 8-bit 暫存器 (R0 ~ R31)。
- **特性**：
    - **R0 恆為 0**：在硬體層級鎖死 R0 的輸出為 0，確保運算基準。
    - **同步寫入**：僅在時脈上升緣 (`posedge clk`) 且 `write_en` 開啟時存入數據。
    - **異步讀取**：只要給出地址，數據會立即流出，不需等待時脈。

---

## 📈 模擬結果 (Simulation)

### 暫存器堆波形驗證 (`tb_register_file.v`)
在 Vivado Simulator 中，我們觀察到以下關鍵行為：


1. **Reset 階段**：當 `reset` 訊號拉高時，所有暫存器內容清空為 `00`。
2. **寫入驗證**：在 `35ns` 的時脈上升緣，數據 `8'hA5` 被成功存入 `R1` 抽屜。
3. **讀取驗證**：當 `read_reg1` 指向 `5'd1` 時，`read_data1` 立即噴出 `a5`，證明讀取邏輯正確。
4. **鎖存功能**：即使 `write_en` 掉回低電位，數據依然穩穩鎖在暫存器中。

---

## 📂 專案結構說明

- **Simple_8bit_CPU.srcs/sources_1/new/**：核心邏輯 (`alu.v`, `register_file.v`)。
- **Simple_8bit_CPU.srcs/sim_1/new/**：測試平台 (`tb_alu.v`, `tb_register_file.v`)。
- **Simple_8bit_CPU.xpr**：Vivado 專案設定檔。

---

## 📅 下一步開發計畫

- [ ] **Instruction Memory**：存放機器碼指令的唯讀記憶體。
- [ ] **Control Unit (CU)**：賦予 CPU 靈魂，根據指令產生控制訊號。
- [ ] **Top Module 集成**：串接 ALU 與 Register File，完成第一個 `ADD` 指令循環。

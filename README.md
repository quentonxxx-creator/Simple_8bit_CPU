# 🚀 Simple 8-bit CPU Design (Verilog)

這是一個從零開始實作的 **8 位元 RISC 架構 CPU** 專案，使用 Verilog HDL 撰寫，並透過 Xilinx Vivado 進行模擬驗證。

---

## 🛠️ 目前進度：算術邏輯單元 (ALU)

ALU 是 CPU 的運算核心。本模組目前已實作並通過波形驗證，支援以下運算：

| 指令 (op) | 運算功能 | 描述 |
| :--- | :--- | :--- |
| `3'b000` | **ADD** | 加法運算 |
| `3'b001` | **SUB** | 減法運算 |
| `3'b010` | **AND** | 位元及運算 |
| `3'b011` | **OR** | 位元或運算 |
| `3'b100` | **XOR** | 位元互斥或運算 |
| `3'b101` | **SLT** | 小於則設置 (Set Less Than) |

### ✅ 關鍵特性
- **8-bit 資料寬度**：處理 $0 \sim 255$ 的無符號整數運算。
- **Zero Flag 偵測**：當運算結果為 `0` 時自動觸發，供未來分支指令 (Branch) 使用。
- **組合邏輯設計**：採用高效的 `case` 結構與連續賦值 (`assign`)。

---

## 📈 模擬結果 (Simulation)

在 Vivado Simulator 中透過 `tb_alu.v` 進行測試，結果顯示：
1. **正確性**：加法 (`10+5=15`) 與減法 (`20-7=13`) 均符合預期。
2. **Flag 觸發**：當執行減法 `5-5` 時，`out` 為 `00` 且 `zero` 訊號成功拉高。

---

## 📂 專案結構說明

- **Simple_8bit_CPU.srcs/sources_1/new/**：存放核心邏輯檔案 (`alu.v`)。
- **Simple_8bit_CPU.srcs/sim_1/new/**：存放測試平台檔案 (`tb_alu.v`)。
- **Simple_8bit_CPU.xpr**：Vivado 專案設定檔。

---

## 📅 下一步開發計畫

- [ ] **Register File (暫存器堆)**：實作具有時脈觸發 (Clock-edged) 的存儲單元。
- [ ] **Instruction Decoder**：將二進位機器碼轉譯為控制訊號。
- [ ] **Top Module 集成**：將各模組串接，完成簡單的運算循環。

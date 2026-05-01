# 🚀 Simple 8-bit CPU Design (Verilog)

以 Verilog HDL 從零實作的 **8 位元 RISC 架構 CPU**，使用 Xilinx Vivado 進行模擬驗證。

---

## 🏗️ 系統架構

```
         ┌──────────────────────────────────────────────────────┐
         │                  simple_cpu_top.v                    │
         │                                                      │
  clk ──►│  ┌──────┐   ┌──────────┐   ┌──────────────┐        │
reset ──►│  │  PC  │──►│  Instr   │──►│   Control    │        │
         │  └──────┘   │  Memory  │   │   Unit       │        │
         │             └──────────┘   └──────┬───────┘        │
         │                                   │ 控制信號         │
         │  ┌─────────────────┐   ┌──────────▼──────┐         │
         │  │  Register File  │◄──│      ALU        │         │
         │  │   (16 × 8-bit)  │──►│    (8-bit)      │         │
         │  └─────────────────┘   └──────────┬──────┘         │
         │                                   │ addr/data       │
         │                        ┌──────────▼──────┐         │
         │                        │   Data Memory   │         │
         │                        │  (256 × 8-bit)  │         │
         │                        └─────────────────┘         │
         └──────────────────────────────────────────────────────┘
```

---

## 📋 完整指令集（ISA）

| Opcode | 指令  | 格式 | 說明 |
|--------|-------|------|------|
| `0`    | ADD   | R    | `rd ← rs + rt` |
| `1`    | SUB   | R    | `rd ← rs - rt` |
| `2`    | AND   | R    | `rd ← rs & rt` |
| `3`    | OR    | R    | `rd ← rs \| rt` |
| `4`    | XOR   | R    | `rd ← rs ^ rt` |
| `5`    | SLT   | R    | `rd ← (rs < rt) ? 1 : 0` |
| `6`    | ADDI  | I    | `rd ← rs + imm` |
| `7`    | LI    | I    | `rd ← imm` |
| `8`    | BEQ   | I    | `if (rs == rt) PC ← PC+1+imm` |
| `9`    | LOAD  | I    | `rd ← MEM[rs + imm]` |
| `A`    | STORE | I    | `MEM[rs + imm] ← rd` |
| `F`    | NOP   | -    | 無動作 |

### 指令格式（16-bit）

```
 15      12  11      8   7       4   3       0
┌──────────┬──────────┬──────────┬──────────┐
│  opcode  │    rd    │    rs    │  rt/imm  │
│  [15:12] │  [11:8]  │  [7:4]  │  [3:0]   │
└──────────┴──────────┴──────────┴──────────┘
```

---

## 🛠️ 模組說明

### `pc.v` — 程式計數器
- 接受外部 `pc_next` 輸入，支援分支跳躍
- 每個 `clk` 上升緣更新，`reset` 時歸零
- 8-bit 輸出，最多定址 256 條指令

### `instruction_mem.v` — 指令記憶體（ROM）
- 256 × 16-bit 唯讀記憶體
- 異步讀取，以 PC 地址取出指令

### `control_unit.v` — 控制單元
- 解析 4-bit opcode，產生所有控制信號
- 輸出：`reg_write`、`alu_src`、`branch`、`mem_read`、`mem_write`、`mem_to_reg`、`alu_op`

### `alu.v` — 算術邏輯單元
- 支援 6 種運算：ADD / SUB / AND / OR / XOR / SLT
- 具備 `zero` flag，結果為 0 時觸發（供 BEQ 使用）

### `register_file.v` — 暫存器堆
- 16 個 8-bit 暫存器（R0 ～ R15）
- **R0 恆為零**（RISC 慣例）
- 3 個讀口（支援 STORE 指令同時讀 base 和 data）
- 同步寫入 / 異步讀取

### `data_mem.v` — 資料記憶體（RAM）
- 256 × 8-bit 讀寫記憶體
- 同步寫入（STORE）/ 異步讀取（LOAD）
- 地址由 ALU 計算（`rs + imm`）

### `simple_cpu_top.v` — 頂層整合
- 整合所有模組為完整資料路徑
- 支援 write-back MUX（ALU 結果 or 記憶體資料）
- 支援 BEQ 分支邏輯（`branch & zero_flag`）

---

## 📈 模擬驗證結果

所有指令皆通過驗證：

| PC | 指令 | 結果 | 狀態 |
|----|------|------|------|
| 0  | LI R1, 10       | ALU=10  | ✅ |
| 1  | LI R2, 3        | ALU=3   | ✅ |
| 2  | ADD R3=R1+R2    | ALU=13  | ✅ |
| 3  | SUB R4=R1-R2    | ALU=7   | ✅ |
| 4  | SLT R5=R2<R1    | ALU=1   | ✅ |
| 5  | ADDI R6=R1+5    | ALU=15  | ✅ |
| 6  | BEQ R0,R0,+1   | 跳到PC=8 | ✅ |
| 8  | AND R7=R1&R2    | ALU=2   | ✅ |
| 9  | OR R8=R1\|R2   | ALU=11  | ✅ |
| 10 | XOR R9=R1^R2   | ALU=9   | ✅ |
| 11 | STORE MEM[5]=R3 | addr=5  | ✅ |
| 12 | STORE MEM[6]=R1 | addr=6  | ✅ |
| 13 | LOAD RA←MEM[5] | addr=5  | ✅ |
| 15 | LOAD RB←MEM[6] | addr=6  | ✅ |
| 18 | ADD RC=RA+RB   | ALU=23  | ✅ |

---

## 📂 專案結構

```
Simple_8bit_CPU/
├── Simple_8bit_CPU.srcs/
│   ├── sources_1/new/
│   │   ├── simple_cpu_top.v    # 頂層整合模組
│   │   ├── pc.v                # 程式計數器
│   │   ├── instruction_mem.v   # 指令記憶體 (ROM)
│   │   ├── register_file.v     # 暫存器堆 (16×8-bit，3讀口)
│   │   ├── alu.v               # 算術邏輯單元
│   │   ├── control_unit.v      # 控制單元
│   │   └── data_mem.v          # 資料記憶體 (RAM)
│   └── sim_1/new/
│       ├── tb_simple_cpu_top.v # 系統整合測試
│       ├── tb_control_unit.v   # 控制單元測試
│       ├── tb_register_file.v  # 暫存器堆測試
│       └── tb_alu.v            # ALU 測試
├── Simple_8bit_CPU.xpr         # Vivado 專案設定檔
├── README.md                   # 中文說明
└── README_EN.md                # 英文說明
```

---

## 🛠️ 開發環境

| 工具 | 說明 |
|------|------|
| HDL 語言 | Verilog HDL |
| 開發工具 | Xilinx Vivado 2025.2 |
| 模擬器   | Vivado Simulator (xsim) |

---

## 📅 開發進度

- [x] 算術邏輯單元 ALU（ADD / SUB / AND / OR / XOR / SLT）
- [x] 暫存器堆（16 × 8-bit，R0 恆為零，3 讀口）
- [x] 程式計數器 PC（支援分支跳躍）
- [x] 指令記憶體（ROM，16-bit 指令格式）
- [x] 控制單元（Control Unit，12 種指令）
- [x] 立即數支援（ADDI / LI）
- [x] 分支指令（BEQ）
- [x] 資料記憶體（RAM，LOAD / STORE）
- [x] 頂層系統整合與完整模擬驗證
- [ ] 更多分支指令（BNE / BLT）
- [ ] Pipeline（流水線架構）
- [ ] 完整組合語言工具鏈

---

## 👤 作者

**quentonxxx-creator**

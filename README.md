# Simple 8-bit CPU (Verilog)
# 簡易 8 位元 CPU（Verilog 實作）

> A simple 8-bit CPU designed and simulated in Verilog, featuring a program counter, ALU, and basic instruction execution.
>
> 以 Verilog 設計並模擬的簡易 8 位元 CPU，包含程式計數器、算術邏輯單元（ALU）及基本指令執行功能。

---

## 📌 Project Overview / 專案簡介

This project implements a simple 8-bit CPU using Verilog HDL. The CPU is designed for educational purposes to demonstrate fundamental digital design concepts such as clocking, reset logic, program counters, and arithmetic/logic operations.

本專案使用 Verilog HDL 實作一個簡易的 8 位元 CPU，目的是以實作方式學習數位設計的基本概念，包括時脈、重置邏輯、程式計數器與算術/邏輯運算。

---

## 🧩 Features / 功能特色

- ✅ 8-bit data path / 8 位元資料路徑
- ✅ Program Counter (PC) with auto-increment / 程式計數器（PC）自動遞增
- ✅ ALU supporting basic arithmetic and logic operations / ALU 支援基本算術與邏輯運算
- ✅ Synchronous reset / 同步重置
- ✅ Clock-driven sequential execution / 時脈驅動的順序執行
- ✅ Simulated and verified with waveform output / 透過波形輸出進行模擬驗證

---

## 🗂️ File Structure / 檔案結構

```
Simple_8bit_CPU/
├── src/
│   ├── cpu.v            # Top-level CPU module / 頂層 CPU 模組
│   ├── alu.v            # Arithmetic Logic Unit / 算術邏輯單元
│   ├── pc.v             # Program Counter / 程式計數器
│   └── control_unit.v   # Control Unit / 控制單元
├── tb/
│   └── tb_cpu.v         # Testbench / 測試平台
├── sim/
│   └── waveform.png     # Simulation waveform screenshot / 模擬波形截圖
└── README.md
```

---

## ⚙️ Module Description / 模組說明

### Program Counter (`pc.v`) / 程式計數器
- Increments by 1 on each rising clock edge / 每個上升緣時 PC 加 1
- Resets to `0` when `reset` is asserted / 當 `reset` 拉高時歸零
- Current simulation shows PC counting from 0 to 12+ / 模擬中 PC 從 0 計數至 12+

### ALU (`alu.v`) / 算術邏輯單元
- Performs 8-bit arithmetic and logic operations / 執行 8 位元算術與邏輯運算
- Currently outputting `0` pending instruction decode integration / 目前輸出為 0，等待指令解碼整合

### Control Unit (`control_unit.v`) / 控制單元
- Decodes instructions and generates control signals / 解碼指令並產生控制信號

---

## 🖥️ Simulation / 模擬結果

Simulated using a Verilog simulator (e.g., ModelSim / Icarus Verilog).

使用 Verilog 模擬器（如 ModelSim / Icarus Verilog）進行模擬。

| Signal / 信號 | Description / 說明 |
|---|---|
| `clk` | System clock, period ~10ns / 系統時脈，週期約 10ns |
| `reset` | Active-high synchronous reset / 高準位同步重置 |
| `alu_out` | ALU output (currently 0) / ALU 輸出（目前為 0）|
| `pc` | Program counter, increments each cycle / 程式計數器，每週期加 1 |

**Waveform / 波形截圖：**

![Simulation Waveform](sim/waveform.png)

---

## 🚀 How to Run / 如何執行

### Using Icarus Verilog / 使用 Icarus Verilog

```bash
# Compile / 編譯
iverilog -o sim_out tb/tb_cpu.v src/cpu.v src/alu.v src/pc.v

# Run simulation / 執行模擬
vvp sim_out

# View waveform (requires GTKWave) / 查看波形（需安裝 GTKWave）
gtkwave dump.vcd
```

### Using ModelSim / 使用 ModelSim

```tcl
vlog src/*.v tb/tb_cpu.v
vsim tb_cpu
run -all
```

---

## 📐 Architecture / 架構圖

```
         ┌─────────┐      ┌──────────┐      ┌─────────┐
 clk ───►│   PC    │─────►│  Instr.  │─────►│ Control │
reset───►│(Counter)│      │  Memory  │      │  Unit   │
         └─────────┘      └──────────┘      └────┬────┘
                                                  │
                                            ┌─────▼─────┐
                                            │    ALU    │
                                            │  (8-bit)  │
                                            └───────────┘
```

---

## 🛠️ Development Environment / 開發環境

| Tool / 工具 | Version / 版本 |
|---|---|
| Verilog Simulator | ModelSim / Icarus Verilog |
| Language / 語言 | Verilog HDL |
| Target / 目標平台 | FPGA / Simulation |

---

## 📅 Development Progress / 開發進度

- [x] Program Counter (PC) / 程式計數器
- [x] Clock & Reset logic / 時脈與重置邏輯
- [x] Basic ALU structure / 基本 ALU 架構
- [ ] Instruction Memory / 指令記憶體
- [ ] Instruction Decode / 指令解碼
- [ ] Register File / 暫存器組
- [ ] Data Memory / 資料記憶體
- [ ] Full instruction set / 完整指令集

---

## 📄 License / 授權

MIT License

---

## 👤 Author / 作者

**quentonxxx-creator**
GitHub: [@quentonxxx-creator](https://github.com/quentonxxx-creator)

# 🚀 Advanced 8-bit Pipelined RISC CPU & Toolchain

This project implements a high-performance **5-Stage Pipelined 8-bit RISC Processor** in Verilog HDL. In addition to the core hardware architecture, the project includes a complete **automated assembler toolchain**, achieving full vertical integration from high-level instruction descriptions to hardware execution flow.

---

## 🌟 Key Features

- **5-Stage Pipeline** — Implements IF (Fetch), ID (Decode), EX (Execute), MEM (Memory Access), and WB (Write-Back) stages to maximize clock frequency and instruction throughput.
- **Hazard Handling** — Full **Data Forwarding** logic and **Branch Hazard** handling (including Pipeline Flush) to prevent stalls and incorrect execution paths.
- **Extended ISA** — Supports richer branch instructions (`BEQ`, `BNE`, `BLT`) for enhanced program flow control.
- **Full Toolchain Support** — Custom Python assembler with **label support** and automated machine code generation, significantly improving developer productivity.

---

## 🏗️ System Architecture

### Pipelined Datapath

Instruction execution is split into five parallel stages, with state passed through **pipeline registers**:

| Stage | Name | Description |
|---|---|---|
| **IF** | Instruction Fetch | Fetches the 16-bit instruction from memory at the current PC; handles branch target correction. |
| **ID** | Instruction Decode | Parses the opcode, reads the register file, and performs immediate extension. |
| **EX** | Execute | Performs ALU operations and computes branch target addresses. |
| **MEM** | Memory Access | Reads from or writes to data RAM. |
| **WB** | Write Back | Writes computation results or loaded data back to the register file. |

---

## 📜 Extended Instruction Set Architecture (ISA)

All instructions use a **fixed 16-bit encoding format**.

| Opcode | Instruction | Type | Operation |
|---|---|---|---|
| `0x0` | `ADD` | R | `rd ← rs + rt` |
| `0x1` | `SUB` | R | `rd ← rs - rt` |
| `0x6` | `ADDI` | I | `rd ← rs + imm` |
| `0x7` | `LI` | I | `rd ← imm` |
| `0x8` | `BEQ` | I | `if (rs == rt) PC ← target` |
| `0xB` | `BNE` | I | `if (rs != rt) PC ← target` |
| `0xC` | `BLT` | I | `if (rs < rt) PC ← target` |
| `0x9` | `LOAD` | I | `rd ← MEM[rs + imm]` |
| `0xA` | `STORE` | I | `MEM[rs + imm] ← rd` |
| `0xF` | `NOP` | — | No operation |

---

## 🛠️ Assembly Toolchain

A **Python-based assembler** is included to simplify the programming workflow:

- **Label Support** — Symbolic labels (e.g., `loop:`) with automatic branch offset calculation.
- **Error Detection** — Syntax checking and immediate overflow warnings.
- **One-Click Build** — Automatically generates `.mem` files compatible with Vivado's `$readmemb`.

**Example — countdown loop:**

```asm
LI   R1, 10       ; Initialize counter
loop:
    ADDI R1, R1, -1
    BNE  R1, R0, loop  ; Branch back if R1 != 0
```

---

## 🔍 Verification & Hardware Metrics

- **Simulation** — Testbenches verify that the pipeline correctly resolves data dependencies via forwarding with **zero stall cycles**.
- **Hazard Testing** — Branch instruction tests confirm that the **Pipeline Flush** logic correctly squashes instructions on the wrong execution path when a branch is taken.
- **Synthesis** — Successfully synthesized on an **Artix-7 FPGA** with a well-optimized critical path.

---

## 📅 Development Progress

- [x] Single-cycle CPU baseline architecture
- [x] ALU and register file
- [x] 5-stage pipeline implementation
- [x] Forwarding & hazard detection unit
- [x] Extended branch instructions (`BNE`, `BLT`)
- [x] Full assembly toolchain (Python assembler)
- [ ] VGA display engine integration *(in progress)*

---

## Author

**quentonxxx-creator**

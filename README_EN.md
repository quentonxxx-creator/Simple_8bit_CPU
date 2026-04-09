---

# 🚀 Simple 8-bit CPU Design (Verilog) - English Version

This is an **8-bit RISC architecture CPU** project designed from scratch using Verilog HDL and verified via Xilinx Vivado simulation.

## 🛠️ Current Progress

### 1. Arithmetic Logic Unit (ALU)
The computational core of the CPU, responsible for all arithmetic and logic operations.
- **Supported Operations**: ADD, SUB, AND, OR, XOR, and SLT (Set Less Than).
- **Status Flags**: Includes a `zero` flag detection, which triggers when the result is 0 for future branch instruction support.

### 2. Register File
The CPU's internal storage providing 32 8-bit registers for processing data.
- **Hardwired Zero (R0)**: Register 0 is hardwired to always output 0 to follow RISC conventions.
- **Timing Design**: Implements synchronous write (`posedge clk`) and asynchronous read logic.

---

## 📈 Simulation Results

### Stage 1: ALU Verification (`tb_alu.v`)
![ALU Waveform](./alu_waveform.png)
- Verified basic operations like `10 + 5 = 15` and `20 - 7 = 13`.
- Confirmed the `zero` flag triggers correctly during `5 - 5 = 0`.

### Stage 2: Register File Verification (`tb_register_file.v`)
![Register File Waveform](./reg_waveform.png)
- **Reset Test**: All registers are successfully cleared to 0 when the `reset` signal is active.
- **Write Test**: Successfully stored `8'hA5` into `R1` at the clock's positive edge.
- **Read Test**: Verified `read_data` outputs reflect register content immediately, with `wire [7:0]` ensuring data integrity.

---

## 📂 Project Structure

- **sources_1/new/**: Core RTL logic (`alu.v`, `register_file.v`).
- **sim_1/new/**: Testbenches (`tb_alu.v`, `tb_register_file.v`).
- **Simple_8bit_CPU.xpr**: Vivado project configuration file.

---

## 📅 Roadmap
- [ ] **Instruction Memory**: Implement ROM for storing machine code.
- [ ] **Control Unit**: Develop decoding and control logic.
- [ ] **System Integration**: Connect ALU and Register File via a common bus.

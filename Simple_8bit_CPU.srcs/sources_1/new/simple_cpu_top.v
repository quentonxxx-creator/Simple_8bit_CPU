`timescale 1ns / 1ps

module simple_cpu_top(
    input        clk,
    input        reset,
    output [7:0] alu_result_out,
    output [7:0] pc_out
);

    // ==========================================
    // 1. IF Stage (Instruction Fetch)
    // ==========================================
    wire [7:0] if_pc_current, if_pc_next;
    wire [15:0] if_instr;
    wire pc_write, if_id_write, flush_if_id, flush_id_ex;
    wire ex_branch_taken;
    wire [7:0] ex_branch_target;

    assign if_pc_next = ex_branch_taken ? ex_branch_target : (if_pc_current + 8'b1);
    wire [7:0] actual_pc_next = pc_write ? if_pc_next : if_pc_current; // Stall 時凍結 PC

    pc my_pc (
        .clk(clk), .reset(reset),
        .pc_next(actual_pc_next), .pc_out(if_pc_current)
    );

    instruction_mem my_imem (
        .addr(if_pc_current), .instr(if_instr)
    );

    // --- IF/ID Register ---
    wire [7:0] id_pc;
    wire [15:0] id_instr;

    IF_ID_reg reg_if_id (
        .clk(clk), .reset(reset), .flush(flush_if_id),
        .pc_in(if_pc_current), .instr_in(if_instr),
        .pc_out(id_pc), .instr_out(id_instr)
    );

    // ==========================================
    // 2. ID Stage (Instruction Decode)
    // ==========================================
    wire [3:0] id_opcode = id_instr[15:12];
    wire [3:0] id_rd     = id_instr[11:8];
    wire [3:0] id_rs     = id_instr[7:4];
    wire [7:0] id_imm    = {{4{id_instr[3]}}, id_instr[3:0]}; // 跳躍用的 Sign Extension

    wire id_reg_write, id_alu_src, id_branch, id_mem_read, id_mem_write, id_mem_to_reg;
    wire [1:0] id_branch_type;
    wire [2:0] id_alu_op;
    
    control_unit my_cu (
        .opcode(id_opcode), .reg_write(id_reg_write),
        .alu_src(id_alu_src), .branch(id_branch), .branch_type(id_branch_type),
        .mem_read(id_mem_read), .mem_write(id_mem_write),
        .mem_to_reg(id_mem_to_reg), .alu_op(id_alu_op)
    );

    // 提前宣告 WB 階段的回寫訊號
    wire wb_reg_write;
    wire [3:0] wb_rd;
    wire [7:0] wb_data;
    
    wire [7:0] id_reg_data1_raw, id_reg_data2;
    register_file my_reg_file (
        .clk(clk), .reset(reset),
        .write_en(wb_reg_write), .write_reg(wb_rd), .write_data(wb_data),
        .read_reg1(id_rd), .read_reg2(id_rs), .read_reg3(4'b0),
        .read_data1(id_reg_data1_raw), .read_data2(id_reg_data2), .read_data3()
    );

    // 強制 A 運算元為 0
    wire [7:0] id_reg_data1 = (id_opcode == 4'h7) ? 8'b0 : id_reg_data1_raw;

    // --- ID/EX Register ---
    wire ex_reg_write, ex_mem_to_reg, ex_mem_read, ex_mem_write, ex_branch, ex_alu_src;
    wire [2:0] ex_alu_op;
    wire [1:0] ex_branch_type;
    wire [7:0] ex_pc, ex_reg_data1, ex_reg_data2, ex_imm;
    wire [3:0] ex_rd, ex_rs;

    ID_EX_reg reg_id_ex (
        .clk(clk), .reset(reset), .flush(flush_id_ex),
        .reg_write_in(id_reg_write), .mem_to_reg_in(id_mem_to_reg),
        .mem_read_in(id_mem_read), .mem_write_in(id_mem_write),
        .branch_in(id_branch), .alu_src_in(id_alu_src),
        .alu_op_in(id_alu_op), .branch_type_in(id_branch_type),
        .pc_in(id_pc), .reg_data1_in(id_reg_data1), .reg_data2_in(id_reg_data2), .imm_in(id_imm),
        .rs_addr_in(id_rs), .rd_addr_in(id_rd),

        .reg_write_out(ex_reg_write), .mem_to_reg_out(ex_mem_to_reg),
        .mem_read_out(ex_mem_read), .mem_write_out(ex_mem_write),
        .branch_out(ex_branch), .alu_src_out(ex_alu_src),
        .alu_op_out(ex_alu_op), .branch_type_out(ex_branch_type),
        .pc_out(ex_pc), .reg_data1_out(ex_reg_data1), .reg_data2_out(ex_reg_data2), .imm_out(ex_imm),
        .rs_addr_out(ex_rs), .rd_addr_out(ex_rd)
    );

    // ==========================================
    // 3. EX Stage (Execute)
    // ==========================================
    wire [1:0] forward_a, forward_b;
    wire [7:0] mem_alu_result;

    // 前遞 (Forwarding) MUX
    wire [7:0] ex_alu_a = (forward_a == 2'b10) ? mem_alu_result :
                          (forward_a == 2'b01) ? wb_data : ex_reg_data1;

    wire [7:0] ex_forward_b_val = (forward_b == 2'b10) ? mem_alu_result :
                                  (forward_b == 2'b01) ? wb_data : ex_reg_data2;

    wire [7:0] ex_alu_b = ex_alu_src ? ex_imm : ex_forward_b_val;

    wire [7:0] ex_alu_result;
    wire ex_zero, ex_negative;

    alu my_alu (
        .a(ex_alu_a),               
        .b(ex_alu_b),               
        .alu_control(ex_alu_op),    
        .result(ex_alu_result),     
        .zero(ex_zero), 
        .negative(ex_negative)
    );

    // 跳躍條件判斷 (在 EX 階段完成)
    wire condition_met = (ex_branch_type == 2'b01 && !ex_zero) ||
                         (ex_branch_type == 2'b10 && ex_negative);
    assign ex_branch_taken = ex_branch & condition_met;
    assign ex_branch_target = ex_pc + 8'b1 + ex_imm;

    // --- EX/MEM Register ---
    wire mem_reg_write, mem_mem_to_reg, mem_mem_read, mem_mem_write;
    wire [7:0] mem_write_data; 
    wire [3:0] mem_rd;

    EX_MEM_reg reg_ex_mem (
        .clk(clk), .reset(reset),
        .reg_write_in(ex_reg_write), .mem_to_reg_in(ex_mem_to_reg),
        .mem_read_in(ex_mem_read), .mem_write_in(ex_mem_write),
        .alu_result_in(ex_alu_result), .write_data_in(ex_forward_b_val), .rd_addr_in(ex_rd),

        .reg_write_out(mem_reg_write), .mem_to_reg_out(mem_mem_to_reg),
        .mem_read_out(mem_mem_read), .mem_write_out(mem_mem_write),
        .alu_result_out(mem_alu_result), .write_data_out(mem_write_data), .rd_addr_out(mem_rd)
    );

    // ==========================================
    // 4. MEM Stage (Memory Access)
    // ==========================================
    wire [7:0] mem_read_data;

    data_mem my_dmem (
        .clk(clk), .mem_write(mem_mem_write), .mem_read(mem_mem_read),
        .addr(mem_alu_result), .write_data(mem_write_data),
        .read_data(mem_read_data)
    );

    // --- MEM/WB Register ---
    wire [7:0] wb_mem_read_data, wb_alu_result;

    MEM_WB_reg reg_mem_wb (
        .clk(clk), .reset(reset),
        .reg_write_in(mem_reg_write), .mem_to_reg_in(mem_mem_to_reg),
        .mem_read_data_in(mem_read_data), .alu_result_in(mem_alu_result), .rd_addr_in(mem_rd),

        .reg_write_out(wb_reg_write), .mem_to_reg_out(wb_mem_to_reg),
        .mem_read_data_out(wb_mem_read_data), .alu_result_out(wb_alu_result), .rd_addr_out(wb_rd)
    );

    // ==========================================
    // 5. WB Stage (Write Back)
    // ==========================================
    assign wb_data = wb_mem_to_reg ? wb_mem_read_data : wb_alu_result;

    assign alu_result_out = wb_alu_result;
    assign pc_out = if_pc_current;

    // ==========================================
    // 6. Hazard & Forwarding Units
    // ==========================================
    forwarding_unit my_fwd (
        .id_ex_rd_src(ex_rd), .id_ex_rs_src(ex_rs),
        .ex_mem_rd(mem_rd), .ex_mem_reg_write(mem_reg_write),
        .mem_wb_rd(wb_rd), .mem_wb_reg_write(wb_reg_write),
        .forward_a(forward_a), .forward_b(forward_b)
    );

    hazard_unit my_hazard (
        .id_rd_src(id_rd), .id_rs_src(id_rs), .ex_rd(ex_rd),
        .ex_mem_read(ex_mem_read), .ex_branch_taken(ex_branch_taken),
        .pc_write(pc_write), .if_id_write(if_id_write),
        .flush_id_ex(flush_id_ex), .flush_if_id(flush_if_id)
    );

endmodule
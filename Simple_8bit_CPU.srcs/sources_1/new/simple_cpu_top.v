`timescale 1ns / 1ps

module simple_cpu_top(
    input        clk,
    input        reset,
    output [7:0] alu_result_out,
    output [7:0] pc_out
);
    wire [7:0]  pc_current, pc_next;
    wire [15:0] instr;

    wire [3:0] opcode  = instr[15:12];
    wire [3:0] rd_addr = instr[11:8];
    wire [3:0] rs_addr = instr[7:4];
    wire [3:0] rt_addr = instr[3:0];
    wire [7:0] imm     = {4'b0, instr[3:0]};

    wire       reg_write, alu_src, branch;
    wire       mem_read, mem_write, mem_to_reg;
    wire [2:0] alu_op;

    wire [7:0] reg_data1, reg_data2, reg_data3;
    wire [7:0] alu_result;
    wire       zero_flag;
    wire [7:0] mem_read_data;
    wire [7:0] write_back_data;

    wire [7:0] alu_src_a = (opcode == 4'h7) ? 8'b0 : reg_data1;
    wire [7:0] alu_src_b = alu_src ? imm : reg_data2;

    assign write_back_data = mem_to_reg ? mem_read_data : alu_result;

    wire       do_branch     = branch & zero_flag;
    wire [7:0] branch_target = pc_current + 8'b1 + imm;
    assign     pc_next       = do_branch ? branch_target : (pc_current + 8'b1);

    pc my_pc (
        .clk(clk), .reset(reset),
        .pc_next(pc_next), .pc_out(pc_current)
    );

    instruction_mem my_imem (
        .addr(pc_current), .instr(instr)
    );

    control_unit my_cu (
        .opcode(opcode), .reg_write(reg_write),
        .alu_src(alu_src), .branch(branch),
        .mem_read(mem_read), .mem_write(mem_write),
        .mem_to_reg(mem_to_reg), .alu_op(alu_op)
    );

    register_file my_reg_file (
        .clk(clk), .reset(reset),
        .write_en(reg_write), .write_reg(rd_addr),
        .write_data(write_back_data),
        .read_reg1(rs_addr),
        .read_reg2(rt_addr),
        .read_reg3(rd_addr),
        .read_data1(reg_data1),
        .read_data2(reg_data2),
        .read_data3(reg_data3)
    );

    alu my_alu (
        .src_a(alu_src_a), .src_b(alu_src_b),
        .alu_op(alu_op), .alu_out(alu_result), .zero(zero_flag)
    );

    data_mem my_dmem (
        .clk(clk), .mem_write(mem_write), .mem_read(mem_read),
        .addr(alu_result),
        .write_data(reg_data3),
        .read_data(mem_read_data)
    );

    assign alu_result_out = alu_result;
    assign pc_out         = pc_current;
endmodule
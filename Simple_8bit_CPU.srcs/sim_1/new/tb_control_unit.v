`timescale 1ns / 1ps

module tb_control_unit();
    reg  [3:0] opcode;
    wire       reg_write, alu_src, branch;
    wire [2:0] alu_op;

    control_unit uut (
        .opcode(opcode), .reg_write(reg_write),
        .alu_src(alu_src), .branch(branch), .alu_op(alu_op)
    );

    initial begin
        $display("=== Control Unit Test ===");
        opcode=4'h0; #5; $display("ADD  rw=%b src=%b br=%b aluop=%b", reg_write,alu_src,branch,alu_op);
        opcode=4'h1; #5; $display("SUB  rw=%b src=%b br=%b aluop=%b", reg_write,alu_src,branch,alu_op);
        opcode=4'h6; #5; $display("ADDI rw=%b src=%b br=%b aluop=%b", reg_write,alu_src,branch,alu_op);
        opcode=4'h7; #5; $display("LI   rw=%b src=%b br=%b aluop=%b", reg_write,alu_src,branch,alu_op);
        opcode=4'h8; #5; $display("BEQ  rw=%b src=%b br=%b aluop=%b", reg_write,alu_src,branch,alu_op);
        opcode=4'hF; #5; $display("NOP  rw=%b src=%b br=%b aluop=%b", reg_write,alu_src,branch,alu_op);
        $display("=== Done ===");
        $finish;
    end
endmodule

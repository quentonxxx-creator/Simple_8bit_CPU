`timescale 1ns / 1ps

module control_unit(
    input  [3:0] opcode,
    output reg       reg_write,
    output reg       alu_src,
    output reg       branch,
    output reg [2:0] alu_op
);

    always @(*) begin
        reg_write = 1'b0;
        alu_src   = 1'b0;
        branch    = 1'b0;
        alu_op    = 3'b000;

        case (opcode)
            4'h0: begin reg_write=1; alu_src=0; alu_op=3'b000; end // ADD
            4'h1: begin reg_write=1; alu_src=0; alu_op=3'b001; end // SUB
            4'h2: begin reg_write=1; alu_src=0; alu_op=3'b010; end // AND
            4'h3: begin reg_write=1; alu_src=0; alu_op=3'b011; end // OR
            4'h4: begin reg_write=1; alu_src=0; alu_op=3'b100; end // XOR
            4'h5: begin reg_write=1; alu_src=0; alu_op=3'b101; end // SLT
            4'h6: begin reg_write=1; alu_src=1; alu_op=3'b000; end // ADDI
            4'h7: begin reg_write=1; alu_src=1; alu_op=3'b000; end // LI
            4'h8: begin reg_write=0; alu_src=0; branch=1; alu_op=3'b001; end // BEQ
            4'hF: begin reg_write=0; end // NOP
            default: begin reg_write=0; end
        endcase
    end

endmodule
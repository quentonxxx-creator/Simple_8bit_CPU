`timescale 1ns / 1ps

module control_unit(
    input  [3:0] opcode,
    output reg       reg_write,
    output reg       alu_src,
    output reg       branch,
    output reg       mem_read,
    output reg       mem_write,
    output reg       mem_to_reg,
    output reg [2:0] alu_op
);
    always @(*) begin
        reg_write  = 1'b0;
        alu_src    = 1'b0;
        branch     = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        mem_to_reg = 1'b0;
        alu_op     = 3'b000;

        case (opcode)
            4'h0: begin reg_write=1; alu_src=0; alu_op=3'b000; end
            4'h1: begin reg_write=1; alu_src=0; alu_op=3'b001; end
            4'h2: begin reg_write=1; alu_src=0; alu_op=3'b010; end
            4'h3: begin reg_write=1; alu_src=0; alu_op=3'b011; end
            4'h4: begin reg_write=1; alu_src=0; alu_op=3'b100; end
            4'h5: begin reg_write=1; alu_src=0; alu_op=3'b101; end
            4'h6: begin reg_write=1; alu_src=1; alu_op=3'b000; end
            4'h7: begin reg_write=1; alu_src=1; alu_op=3'b000; end
            4'h8: begin branch=1;    alu_src=0; alu_op=3'b001; end
            4'h9: begin reg_write=1; alu_src=1; alu_op=3'b000;
                        mem_read=1;  mem_to_reg=1; end
            4'hA: begin alu_src=1;   alu_op=3'b000;
                        mem_write=1; end
            4'hF: begin end
            default: begin end
        endcase
    end
endmodule
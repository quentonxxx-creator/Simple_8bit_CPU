
module alu(
    input  [7:0] src_a,    // 輸入 A
    input  [7:0] src_b,    // 輸入 B
    input  [2:0] alu_op,   // 選擇功能 (0:加, 1:減, 2:與, 3:或...)
    output reg [7:0] alu_out, 
    output zero            
);
    assign zero = (alu_out == 8'b0);

    always @(*) begin
        case(alu_op)
            3'b000: alu_out = src_a + src_b; // ADD
            3'b001: alu_out = src_a - src_b; // SUB
            3'b010: alu_out = src_a & src_b; // AND
            3'b011: alu_out = src_a | src_b; // OR
            3'b100: alu_out = src_a ^ src_b; // XOR
            3'b101: alu_out = (src_a < src_b) ? 8'b1 : 8'b0; // SLT (比較大小)
            default: alu_out = 8'b0;
        endcase
    end
endmodule

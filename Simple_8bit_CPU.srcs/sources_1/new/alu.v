`timescale 1ns / 1ps

module alu (
    input [7:0] a,
    input [7:0] b,
    input [2:0] alu_control,
    output reg [7:0] result,
    output zero,       // 新增：Zero Flag
    output negative    // 新增：Negative Flag
);

    always @(*) begin
        case (alu_control)
            3'b000: result = a + b; // ADD
            3'b001: result = a - b; // SUB
            3'b010: result = a & b; // AND 
            3'b011: result = a | b; // OR
            default: result = 8'b0;
        endcase
    end

    // 若結果為 0，zero 拉高 (用於 BNE)
    assign zero = (result == 8'b0);
    
    // 若最高位 (MSB) 為 1，代表二補數為負 (用於 BLT)
    assign negative = result[7];

endmodule
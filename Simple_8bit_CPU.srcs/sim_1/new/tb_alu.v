`timescale 1ns / 1ps

module tb_alu();
    
    reg [7:0] a, b;
    reg [2:0] op;
    wire [7:0] out;
    wire z;

    
    alu uut (
        .src_a(a), 
        .src_b(b), 
        .alu_op(op), 
        .alu_out(out), 
        .zero(z)
    );

    
    initial begin
        // 第一次測試: 加法
        a = 8'd10; b = 8'd5; op = 3'b000;
        #10;
        
        // 第二次測試: 減法
        a = 8'd20; b = 8'd7; op = 3'b001;
        #10;
        
        // 第三次測試: 減法到零
        a = 8'd5; b = 8'd5; op = 3'b001;
        #10;
        
        $stop; 
    end
endmodule
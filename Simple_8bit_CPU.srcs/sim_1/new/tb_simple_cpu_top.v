`timescale 1ns / 1ps

module tb_simple_cpu_top();
    reg clk;
    reg reset;
    wire [7:0] alu_result_out;

    
    simple_cpu_top uut (
        .clk(clk),
        .reset(reset),
        .alu_result_out(alu_result_out)
    );

    
    always #5 clk = ~clk;

    initial begin
        
        clk = 0;
        reset = 1;
        
        
        #20 reset = 0;
        
        
        #200;
        
        $stop;
    end
endmodule

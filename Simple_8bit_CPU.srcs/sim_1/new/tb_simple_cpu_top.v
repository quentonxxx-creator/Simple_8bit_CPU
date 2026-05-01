`timescale 1ns / 1ps

module tb_simple_cpu_top();
    reg        clk;
    reg        reset;
    wire [7:0] alu_result_out;
    wire [7:0] pc_out;

    simple_cpu_top uut (
        .clk           (clk),
        .reset         (reset),
        .alu_result_out(alu_result_out),
        .pc_out        (pc_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;
        #20 reset = 0;
        repeat (20) @(posedge clk);
        $display("=== Simulation Complete ===");
        $stop;
    end

    always @(posedge clk) begin
        if (!reset)
            $display("Time=%0t | PC=%0d | ALU_out=%0d",
                     $time, pc_out, alu_result_out);
    end
endmodule
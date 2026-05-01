`timescale 1ns / 1ps

module tb_simple_cpu_top();
    reg        clk;
    reg        reset;
    wire [7:0] alu_result_out;
    wire [7:0] pc_out;

    simple_cpu_top uut (
        .clk(clk), .reset(reset),
        .alu_result_out(alu_result_out),
        .pc_out(pc_out)
    );

    // 產生時脈 (週期 10ns)
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1;
        #20 reset = 0;
        
        
        repeat (50) @(posedge clk);
        
        $display("=== Simulation Complete ===");
        $stop;
    end

    // 每個 clock 上升緣印出目前的 PC 與 ALU 最終輸出結果
    always @(posedge clk) begin
        if (!reset) begin
            $display("Time=%0t | PC=%0d | ALU_WB_OUT=%0d", $time, pc_out, alu_result_out);
        end
    end
endmodule
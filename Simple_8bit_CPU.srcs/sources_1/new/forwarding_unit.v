`timescale 1ns / 1ps

module forwarding_unit(
    input [3:0] id_ex_rd_src,    // EX 階段正在用的第一運算元 (Rd)
    input [3:0] id_ex_rs_src,    // EX 階段正在用的第二運算元 (Rs)
    input [3:0] ex_mem_rd,       // MEM 階段準備寫回的目的地
    input       ex_mem_reg_write,
    input [3:0] mem_wb_rd,       // WB 階段準備寫回的目的地
    input       mem_wb_reg_write,
    output reg [1:0] forward_a,  // 控制 ALU_A 的 MUX
    output reg [1:0] forward_b   // 控制 ALU_B 的 MUX
);

    always @(*) begin
        // --- Forward A 邏輯 ---
        if (ex_mem_reg_write && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rd_src))
            forward_a = 2'b10; // 攔截來自 EX/MEM 的最新結果
        else if (mem_wb_reg_write && (mem_wb_rd != 0) && (mem_wb_rd == id_ex_rd_src))
            forward_a = 2'b01; // 攔截來自 MEM/WB 的結果
        else
            forward_a = 2'b00; // 乖乖用原本從 Register File 讀出來的舊值

        // --- Forward B 邏輯 ---
        if (ex_mem_reg_write && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rs_src))
            forward_b = 2'b10; 
        else if (mem_wb_reg_write && (mem_wb_rd != 0) && (mem_wb_rd == id_ex_rs_src))
            forward_b = 2'b01; 
        else
            forward_b = 2'b00; 
    end
endmodule
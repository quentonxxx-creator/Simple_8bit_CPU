`timescale 1ns / 1ps

// 1. IF/ID 階段暫存器
module IF_ID_reg(
    input clk, input reset, input flush,
    input [7:0] pc_in, input [15:0] instr_in,
    output reg [7:0] pc_out, output reg [15:0] instr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin // 如果發生跳躍，清空(Flush)這個階段的指令
            pc_out <= 8'b0;
            instr_out <= 16'hF000; // 預設塞入 NOP (4'hF)
        end else begin
            pc_out <= pc_in;
            instr_out <= instr_in;
        end
    end
endmodule

// 2. ID/EX 階段暫存器
module ID_EX_reg(
    input clk, input reset, input flush,
    // 控制訊號
    input reg_write_in, mem_to_reg_in, mem_read_in, mem_write_in, branch_in, alu_src_in,
    input [2:0] alu_op_in, input [1:0] branch_type_in,
    // 資料訊號
    input [7:0] pc_in, input [7:0] reg_data1_in, input [7:0] reg_data2_in, input [7:0] imm_in,
    // 目的與來源暫存器位址 (供 Hazard Unit 使用)
    input [3:0] rs_addr_in, input [3:0] rd_addr_in,
    
    // 輸出
    output reg reg_write_out, mem_to_reg_out, mem_read_out, mem_write_out, branch_out, alu_src_out,
    output reg [2:0] alu_op_out, output reg [1:0] branch_type_out,
    output reg [7:0] pc_out, output reg [7:0] reg_data1_out, output reg [7:0] reg_data2_out, output reg [7:0] imm_out,
    output reg [3:0] rs_addr_out, output reg [3:0] rd_addr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            reg_write_out <= 0; mem_to_reg_out <= 0; mem_read_out <= 0; mem_write_out <= 0;
            branch_out <= 0; alu_src_out <= 0; alu_op_out <= 0; branch_type_out <= 0;
            pc_out <= 0; reg_data1_out <= 0; reg_data2_out <= 0; imm_out <= 0;
            rs_addr_out <= 0; rd_addr_out <= 0;
        end else begin
            reg_write_out <= reg_write_in; mem_to_reg_out <= mem_to_reg_in; 
            mem_read_out <= mem_read_in; mem_write_out <= mem_write_in;
            branch_out <= branch_in; alu_src_out <= alu_src_in; 
            alu_op_out <= alu_op_in; branch_type_out <= branch_type_in;
            pc_out <= pc_in; reg_data1_out <= reg_data1_in; 
            reg_data2_out <= reg_data2_in; imm_out <= imm_in;
            rs_addr_out <= rs_addr_in; rd_addr_out <= rd_addr_in;
        end
    end
endmodule

// 3. EX/MEM 階段暫存器
module EX_MEM_reg(
    input clk, input reset,
    input reg_write_in, mem_to_reg_in, mem_read_in, mem_write_in,
    input [7:0] alu_result_in, input [7:0] write_data_in, input [3:0] rd_addr_in,
    
    output reg reg_write_out, mem_to_reg_out, mem_read_out, mem_write_out,
    output reg [7:0] alu_result_out, output reg [7:0] write_data_out, output reg [3:0] rd_addr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_write_out <= 0; mem_to_reg_out <= 0; mem_read_out <= 0; mem_write_out <= 0;
            alu_result_out <= 0; write_data_out <= 0; rd_addr_out <= 0;
        end else begin
            reg_write_out <= reg_write_in; mem_to_reg_out <= mem_to_reg_in; 
            mem_read_out <= mem_read_in; mem_write_out <= mem_write_in;
            alu_result_out <= alu_result_in; write_data_out <= write_data_in; rd_addr_out <= rd_addr_in;
        end
    end
endmodule

// 4. MEM/WB 階段暫存器
module MEM_WB_reg(
    input clk, input reset,
    input reg_write_in, mem_to_reg_in,
    input [7:0] mem_read_data_in, input [7:0] alu_result_in, input [3:0] rd_addr_in,
    
    output reg reg_write_out, mem_to_reg_out,
    output reg [7:0] mem_read_data_out, output reg [7:0] alu_result_out, output reg [3:0] rd_addr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_write_out <= 0; mem_to_reg_out <= 0;
            mem_read_data_out <= 0; alu_result_out <= 0; rd_addr_out <= 0;
        end else begin
            reg_write_out <= reg_write_in; mem_to_reg_out <= mem_to_reg_in;
            mem_read_data_out <= mem_read_data_in; alu_result_out <= alu_result_in; rd_addr_out <= rd_addr_in;
        end
    end
endmodule
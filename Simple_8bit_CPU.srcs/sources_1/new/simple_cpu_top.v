module simple_cpu_top(
    input clk,
    input reset,
    output [7:0] alu_result_out
);
    wire [7:0] pc_to_imem;
    wire [15:0] instr;
    wire [7:0] reg_data1, reg_data2;
    wire [7:0] alu_result;
    
    // 簡單的解碼邏輯 (Decode)
    wire [3:0] opcode = instr[15:12];
    wire [4:0] rd_addr = instr[11:8];
    wire [4:0] rs_addr = instr[7:4];
    wire [4:0] rt_addr = instr[3:0];

    // 1. 實體化 PC
    pc my_pc (
        .clk(clk), 
        .reset(reset), 
        .pc_out(pc_to_imem)
    );

    // 2. 實體化指令記憶體
    instruction_mem my_imem (
        .addr(pc_to_imem), 
        .instr(instr)
    );

    
    register_file my_reg_file (
        .clk(clk),
        .reset(reset),
        .write_en(opcode == 4'h1 || opcode == 4'h2), 
        .write_reg(rd_addr),                       
        .write_data(alu_result),                   
        .read_reg1(rs_addr),                        
        .read_reg2(rt_addr),                        
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );

    
    alu my_alu (
        .src_a(reg_data1),
        .src_b(reg_data2),
        .alu_op(opcode[2:0]),  
        .alu_out(alu_result),  
        .zero()               
    );

    assign alu_result_out = alu_result;

endmodule

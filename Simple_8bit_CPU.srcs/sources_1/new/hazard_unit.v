`timescale 1ns / 1ps

module hazard_unit(
    input [3:0] id_rd_src,       // ID 階段需要的第一運算元
    input [3:0] id_rs_src,       // ID 階段需要的第二運算元
    input [3:0] ex_rd,           // EX 階段指令的目的地
    input       ex_mem_read,     // EX 階段是不是 Load 指令
    input       ex_branch_taken, // 分支跳躍是否真的發生
    
    output reg pc_write,         // 0: 凍結 PC
    output reg if_id_write,      // 0: 凍結 IF/ID 暫存器
    output reg flush_id_ex,      // 1: 清空 ID/EX 暫存器 (塞 NOP)
    output reg flush_if_id       // 1: 清空 IF/ID 暫存器 (跳躍時用)
);

    always @(*) begin
        // 預設全部綠燈放行
        pc_write = 1'b1;
        if_id_write = 1'b1;
        flush_id_ex = 1'b0;
        flush_if_id = 1'b0;

        // 1. Load-Use Hazard (要用的資料還在記憶體裡，只能 Stall 停等一回合)
        if (ex_mem_read && (ex_rd != 0) && ((ex_rd == id_rd_src) || (ex_rd == id_rs_src))) begin
            pc_write = 1'b0;      // 凍結 PC，不要抓新指令
            if_id_write = 1'b0;   // 凍結 ID，剛剛的指令再解碼一次
            flush_id_ex = 1'b1;   // 往 EX 塞入一個空氣 (NOP)
        end

        // 2. Control Hazard (真的發生跳躍了，把後面抓錯的指令全部洗掉)
        if (ex_branch_taken) begin
            flush_if_id = 1'b1;   
            flush_id_ex = 1'b1;   
        end
    end
endmodule
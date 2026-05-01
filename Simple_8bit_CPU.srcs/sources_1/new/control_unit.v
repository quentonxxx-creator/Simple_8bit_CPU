`timescale 1ns / 1ps

module control_unit(
    input  [3:0] opcode,
    output reg       reg_write,
    output reg       alu_src,
    output reg       branch,
    output reg [1:0] branch_type,  //  新增：告訴 Top Module 是哪種跳躍 (01: BNE, 10: BLT)
    output reg       mem_read,
    output reg       mem_write,
    output reg       mem_to_reg,
    output reg [2:0] alu_op
);
    always @(*) begin
        // 預設值 (避免產生 Latch)
        reg_write   = 1'b0;
        alu_src     = 1'b0;
        branch      = 1'b0;
        branch_type = 2'b00;       // 預設不跳躍
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        mem_to_reg  = 1'b0;
        alu_op      = 3'b000;

        case (opcode)
            4'h0: begin reg_write=1; alu_src=0; alu_op=3'b000; end // ADD 等運算
            4'h1: begin reg_write=1; alu_src=0; alu_op=3'b001; end // SUB
            4'h2: begin reg_write=1; alu_src=0; alu_op=3'b010; end
            4'h3: begin reg_write=1; alu_src=0; alu_op=3'b011; end
            4'h4: begin reg_write=1; alu_src=0; alu_op=3'b100; end
            4'h5: begin reg_write=1; alu_src=0; alu_op=3'b101; end
            4'h6: begin reg_write=1; alu_src=1; alu_op=3'b000; end // I-Type
            4'h7: begin reg_write=1; alu_src=1; alu_op=3'b000; end
            
            //  擴充的分支指令區段
            4'h8: begin // BNE (Branch if Not Equal)
                branch      = 1'b1;  
                branch_type = 2'b01; // 設定代碼 01 為 BNE
                alu_src     = 1'b0; 
                alu_op      = 3'b001; // 利用減法觸發 ALU 的 Zero Flag
            end
            
            4'hB: begin // BLT (Branch if Less Than) - 使用空缺的 4'hB
                branch      = 1'b1;  
                branch_type = 2'b10; // 設定代碼 10 為 BLT
                alu_src     = 1'b0; 
                alu_op      = 3'b001; // 利用減法觸發 ALU 的 Negative Flag
            end

            // 記憶體存取區段
            4'h9: begin 
                reg_write=1; alu_src=1; alu_op=3'b000;
                mem_read=1;  mem_to_reg=1; 
            end
            4'hA: begin 
                alu_src=1; alu_op=3'b000;
                mem_write=1; 
            end
            
            4'hF: begin /* HALT 或 NOP */ end
            default: begin end
        endcase
    end
endmodule
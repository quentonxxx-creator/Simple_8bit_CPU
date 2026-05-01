`timescale 1ns / 1ps

module instruction_mem(
    input  [7:0]  addr,
    output [15:0] instr
);
    reg [15:0] rom [255:0];

    initial begin
        // 先全部設為 NOP
    rom[0]  = 16'hF000; rom[1]  = 16'hF000; rom[2]  = 16'hF000; rom[3]  = 16'hF000;
    rom[4]  = 16'hF000; rom[5]  = 16'hF000; rom[6]  = 16'hF000; rom[7]  = 16'hF000;
    rom[8]  = 16'hF000; rom[9]  = 16'hF000; rom[10] = 16'hF000; rom[11] = 16'hF000;
    rom[12] = 16'hF000; rom[13] = 16'hF000; rom[14] = 16'hF000; rom[15] = 16'hF000;
    rom[16] = 16'hF000; rom[17] = 16'hF000; rom[18] = 16'hF000; rom[19] = 16'hF000;
    rom[20] = 16'hF000; rom[21] = 16'hF000; rom[22] = 16'hF000; rom[23] = 16'hF000;
    rom[24] = 16'hF000; rom[25] = 16'hF000; rom[26] = 16'hF000; rom[27] = 16'hF000;
    rom[28] = 16'hF000; rom[29] = 16'hF000; rom[30] = 16'hF000; rom[31] = 16'hF000;

    // 實際程式
    rom[0]  = 16'h710A; // LI   R1, 10
    rom[1]  = 16'h7203; // LI   R2, 3
    rom[2]  = 16'h0312; // ADD  R3, R1, R2 → 13
    rom[3]  = 16'h1412; // SUB  R4, R1, R2 → 7
    rom[4]  = 16'h5521; // SLT  R5, R2, R1 → 1
    rom[5]  = 16'h6615; // ADDI R6, R1, 5  → 15
    rom[6]  = 16'h8001; // BEQ  R0, R0, +1 → 跳到 addr 8
    rom[7]  = 16'hF000; // NOP (被跳過)
    rom[8]  = 16'h2712; // AND  R7, R1, R2 → 2
    rom[9]  = 16'h3812; // OR   R8, R1, R2 → 11
    rom[10] = 16'h4912; // XOR  R9, R1, R2 → 9
    rom[11] = 16'hF000; // NOP
    end

    assign instr = rom[addr];
endmodule
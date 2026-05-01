`timescale 1ns / 1ps


module instruction_mem(
    input [7:0] addr,
    output [15:0] instr
);
    reg [15:0] rom [255:0];

    initial begin
        
        
        rom[0] = 16'h1100; 
        rom[1] = 16'h1200;
        rom[2] = 16'h0312; 
         
    end

    assign instr = rom[addr];
endmodule
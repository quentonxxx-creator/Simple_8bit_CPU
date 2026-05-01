`timescale 1ns / 1ps

module instruction_mem(
    input  [7:0]  addr,
    output [15:0] instr
);
    reg [15:0] rom [255:0];
    
    integer i; 
    initial begin
        
        for (i = 0; i < 256; i = i + 1) begin
            rom[i] = 16'hF000;
        end
        
        
        $readmemb("C:/Users/quent/Simple_8bit_CPU/tools/inst.mem", rom);
    end

    assign instr = rom[addr];
endmodule
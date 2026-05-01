`timescale 1ns / 1ps
module register_file(
    input        clk,
    input        reset,
    input  [3:0] read_reg1,
    input  [3:0] read_reg2,
    input  [3:0] read_reg3,
    input  [3:0] write_reg,
    input  [7:0] write_data,
    input        write_en,
    output [7:0] read_data1,
    output [7:0] read_data2,
    output [7:0] read_data3
);
    reg [7:0] rf [15:0];
    assign read_data1 = (read_reg1 == 4'b0) ? 8'b0 : rf[read_reg1];
    assign read_data2 = (read_reg2 == 4'b0) ? 8'b0 : rf[read_reg2];
    assign read_data3 = (read_reg3 == 4'b0) ? 8'b0 : rf[read_reg3];
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1)
                rf[i] <= 8'b0;
        end else if (write_en && write_reg != 4'b0) begin
            rf[write_reg] <= write_data;
        end
    end
endmodule
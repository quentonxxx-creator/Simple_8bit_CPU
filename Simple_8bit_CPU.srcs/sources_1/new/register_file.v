module register_file(
      input clk,
      input reset,
      input [4:0] read_reg1,
      input [4:0] read_reg2,
      input [4:0] write_reg,
      input [7:0] write_data,
      input write_en,
      output [7:0] read_data1,
      output [7:0] read_data2
    );

   
    reg [7:0] rf [31:0];

    
    assign read_data1 = (read_reg1 == 5'b0) ? 8'b0 : rf[read_reg1];
    assign read_data2 = (read_reg2 == 5'b0) ? 8'b0 : rf[read_reg2];

    integer i;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                rf[i] <= 8'b0; 
            end
        end 
        else if (write_en && write_reg != 5'b0) begin
            rf[write_reg] <= write_data;
        end
    end 

endmodule
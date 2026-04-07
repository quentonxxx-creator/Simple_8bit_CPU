`timescale 1ns / 1ps

module tb_register_file( );
    reg clk;
    reg reset;
    reg [4:0] read_reg1,read_reg2,write_reg;
    reg [7:0] write_data;
    reg write_en;
    wire[7:0] read_data1,read_data2;
    //單元測試
    register_file uut (
        .clk(clk),
        .reset(reset),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .write_en(write_en),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    initial begin
        clk=0;
        forever #5 clk=~clk;
    end
    initial begin 
        //初始狀態
        reset = 1; write_en = 0; write_data = 0;
        read_reg1 = 0; read_reg2 = 0; write_reg = 0;
        #15 reset=0;//十五秒後開始
        #10;
        //first
        write_reg = 5'd1;     
        write_data = 8'hA5;//1號reg存入data   
        write_en = 1;//寫入         
        #10;//等上升                  
        write_en = 0;// 存好後關掉開關        

        //second
        #10;
        read_reg1 = 5'd1;//應該8'hA5     
        read_reg2 = 5'd2;//應該8'd0
        #50 $stop;            
    end
        
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/04 10:00:43
// Design Name: 
// Module Name: minisys_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module minisys_sim(  );
    // input
    reg clk = 0;
    reg rst = 1;
    reg [23:0] switch2N4 = 24'h5a078f;
    
    //  output  
    wire [23:0] led2N4;
    
    minisys u (
        .fpga_clk(clk),
        .fpga_rst(rst),
        .led2N4(led2N4),
        .switch2N4(switch2N4),
        .start_pg(0),
        .rx(1),
        .tx());
    initial begin
        #7000 rst = 0;
    end
    always #10 clk=~clk;
   endmodule

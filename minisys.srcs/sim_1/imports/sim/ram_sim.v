`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/08 14:26:34
// Design Name: 
// Module Name: ram_sim
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


module ram_sim ();

    // input
    reg[31:0] address = 32'h00000010;     //来自memorio模块，源头是来自执行单元算出的alu_result
    reg[31:0] write_data = 32'ha0000000;  //来自译码单元的read_data2
    reg  Memwrite = 1'b0;         //来自控制单元
    reg  clock = 1'b0; 
    reg  zero =1'b0;
    reg[31:0] zero32= 32'h00000000;
    reg one = 1'b1;   
    // output
    wire[31:0] read_data;

    dmemory32 Uram (
	    .ram_clk_i	(clock),
		.ram_wen_i	(Memwrite),		// 来自控制单元
		.ram_adr_i	(address[15:2]),// 来自memorio模块，源头是来自执行单元算出的alu_result
		.ram_dat_i	(write_data),	// 来自译码单元的read_data2
		.ram_dat_o	(read_data),		// 从存储器中获得的数据
			// UART Programmer Pinouts
        .upg_rst_i  (zero),      // UPG reset (Active High)
        .upg_clk_i  (zero),      // UPG ram_clk_i (10MHz)
	    .upg_wen_i  (zero),		// UPG write enable
        .upg_adr_i   (zero32),		// UPG write address
        .upg_dat_i   (zero32),		// UPG write data
        .upg_done_i         (one)     // 1 if programming is finished
	);

    initial begin
      #200 begin write_data = 32'hA00000F5;Memwrite = 1'b1; end
      #200 Memwrite = 1'b0;
    end
    always #50 clock = ~clock;
	
endmodule

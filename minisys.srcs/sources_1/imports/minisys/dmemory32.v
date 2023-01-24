`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module dmemory32 (
    input			ram_clk_i,
    input			ram_wen_i,		// 来自控制单元
    input	[13:0]	ram_adr_i,		// 来自memorio模块，源头是来自执行单元算出的alu_result
    input	[31:0]	ram_dat_i,		// 来自译码单元的read_data2
    output	[31:0]	ram_dat_o,		// 从存储器中获得的数据
	// UART Programmer Pinouts
	input           upg_rst_i,      // UPG reset (Active High)
	input           upg_clk_i,      // UPG ram_clk_i (10MHz)
	input           upg_wen_i,		// UPG write enable
	input	[13:0]	upg_adr_i,		// UPG write address
	input	[31:0]	upg_dat_i,		// UPG write data
	input           upg_done_i      // 1 if programming is finished
);
    
    wire ram_clk = !ram_clk_i;	// 因为使用Block ram的固有延迟，RAM的地址线来不及在时钟上升沿准备好,
								// 使得时钟上升沿数据读出有误，所以采用反相时钟，使得读出数据比地址准
								// 备好要晚大约半个时钟，从而得到正确地址。
							 
	// kickOff = 1的时候CPU 正常工作，否则就是串口下载程序。
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
    
    // 分配64KB RAM，编译器实际只用 64KB RAM
	ram ram (
        .clka	(kickOff ?	ram_clk		: upg_clk_i),
        .wea	(kickOff ?	ram_wen_i	: upg_wen_i),
        .addra	(kickOff ?	ram_adr_i	: upg_adr_i),
        .dina	(kickOff ?	ram_dat_i	: upg_dat_i),
        .douta	(ram_dat_o)
    );
	
endmodule

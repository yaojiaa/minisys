`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/07 21:00:51
// Design Name: 
// Module Name: ifetc32_sim
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


module ifetc32_sim ();
    // input
    reg[31:0]  Add_result = 32'h00000000;
    reg[31:0]  Read_data_1 = 32'h00000000;
    reg        Branch = 1'b0;
    reg        nBranch = 1'b0;
    reg        Jmp = 1'b0;
    reg        Jal = 1'b0;
    reg        Jrn = 1'b0;
    reg        Zero = 1'b0;
    reg        clock = 1'b0,reset = 1'b1;

    // output
    wire [31:0] Instruction;            // 输出指令
    wire [31:0] PC_plus_4_out;
    wire [31:0] opcplus4;
	wire [13:0] rom_adr;
	wire [31:0] Jpadr;
	
	Ifetc32 Uif (
		.reset			(reset),			// 复位(高电平有效)
		.clock			(clock),			// CPU时钟
		.Instruction	(Instruction),		// 输出指令到其他模块
		.PC_plus_4_out	(PC_plus_4_out),	// (pc+4)送执行单元
		.Add_result		(Add_result),		// 来自执行单元,算出的跳转地址
		.Read_data_1	(Read_data_1),		// 来自译码单元，jr指令用的地址
		.Branch			(Branch),			// 来自控制单元
		.nBranch		(nBranch),			// 来自控制单元
		.Jmp			(Jmp),				// 来自控制单元
		.Jal			(Jal),				// 来自控制单元
		.Jrn			(Jrn),				// 来自控制单元
		.Zero			(Zero),				// 来自执行单元
		.opcplus4		(opcplus4),			// JAL指令专用的PC+4
		// ROM Pinouts
		.rom_adr_o		(rom_adr),			// 给程序ROM单元的取指地址
		.Jpadr			(Jpadr)				// 从程序ROM单元中获取的指令
	);

	// 分配64KB ROM, 编译器实际只用 64KB ROM
    prgrom instmem (
        .clka	(clock),
		//.wea	(0),
        .addra	(rom_adr),
		//.dina	(0),
        .douta	(Jpadr)
    );
	
    initial begin
        #100   reset = 1'b0;
        #100   Jal = 1;
        #100   begin Jrn = 1;Jal = 0; Read_data_1 = 32'h0000019c;end;
        #100   begin Jrn = 0;Branch = 1'b1; Zero = 1'b1; Add_result = 32'h00000020;end;        
        #100   begin Branch = 1'b0; Zero = 1'b0; end;        
    end
    always #50 clock = ~clock;
endmodule

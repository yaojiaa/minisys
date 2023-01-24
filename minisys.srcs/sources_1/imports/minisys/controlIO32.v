`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module controlIO32 (
    input	[5:0]	Opcode,				// 来自取指单元instruction[31..26]
    input	[21:0]	Alu_resultHigh,		// 来自执行单元Alu_Result[31..10]
    input	[5:0]	Function_opcode,	// 来自取指单元r-类型 instructions[5..0]
    output			Jrn,				// 为1表明当前指令是jr
    output			RegDST,				// 为1表明目的寄存器是rd，否则目的寄存器是rt
    output			ALUSrc,				// 为1表明第二个操作数是立即数（beq，bne除外）
    output			MemorIOtoReg,		// 为1表明需要从存储器或I/O读数据到寄存器
    output			RegWrite,			// 为1表明该指令需要写寄存器
    output			MemRead,			// 为1表明是存储器读
    output			MemWrite,			// 为1表明该指令需要写存储器
    output			IORead,				// 为1表明是I/O读
    output			IOWrite,			// 为1表明是I/O写
    output			Branch,				// 为1表明是Beq指令
    output			nBranch,			// 为1表明是Bne指令
    output			Jmp,				// 为1表明是J指令
    output			Jal,				// 为1表明是Jal指令
    output			I_format,			// 为1表明该指令是除beq，bne，LW，SW之外的其他I-类型指令
    output			Sftmd,				// 为1表明是移位指令
    output	[1:0]	ALUOp				// 是R-类型或I_format=1时位1为1, beq、bne指令则位0为1
);

    wire R_format,Lw,Sw;
  //……
endmodule
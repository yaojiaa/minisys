`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/07/28 21:56:12
// Design Name: 
// Module Name: control32_sim
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


module control32_sim(
    );
        // input
        reg[5:0]   Opcode = 6'b000000;            // 来自取指单元instruction[31..26]
        reg[5:0]   Function_opcode  = 6'b100000;      // r-form instructions[5..0]  //ADD
        // output
        wire       Jrn;
        wire       RegDST;
        wire       ALUSrc;            // 决定第二个操作数是寄存器还是立即数
        wire       MemtoReg;
        wire       RegWrite;
        wire       MemWrite;
        wire       Branch;
        wire       nBranch;
        wire       Jmp;
        wire       Jal;
        wire       I_format;
        wire       Sftmd;
        wire[1:0]  ALUOp;
        
     control32  Uctrl(
        .Opcode     (Opcode),	     // 来自取指单元instruction[31..26]
        .Function_opcode(Function_opcode),	// 来自取指单元r-类型 instructions[5..0]
        .Jrn             (Jrn),				// 为1表明当前指令是jr
        .RegDST     (RegDST),	// 为1表明目的寄存器是rd，否则目的寄存器是rt
        .ALUSrc     (ALUSrc),		// 为1表明第二个操作数是立即数（beq，bne除外）
        .MemtoReg(MemtoReg),	// 为1表明需要从存储器读数据到寄存器
        .RegWrite   (RegWrite),	// 为1表明该指令需要写寄存器
        .MemWrite   (MemWrite),	// 为1表明该指令需要写存储器
        .Branch         (Branch),		// 为1表明是Beq指令
        .nBranch       (nBranch),	// 为1表明是Bne指令
        .Jmp              (Jmp),			// 为1表明是J指令
        .Jal                (Jal),			// 为1表明是Jal指令
        .I_format       (I_format),			// 为1表明该指令是除beq，bne，LW，SW之外的其他I-类型指令
        .Sftmd          (Sftmd),				// 为1表明是移位指令
        .ALUOp	    (ALUOp)			// 是R-类型或I_format=1时位1为1, beq、bne指令则位0为1
);
                     
    initial begin
        #200     Function_opcode  = 6'b001000;               // JR
        #200    Opcode = 6'b001000;                         //  ADDI
        #200    Opcode = 6'b100011;                         //  LW
        #200    Opcode = 6'b101011;                         //  SW
        #250    Opcode = 6'b000100;                         //  BEQ
        #200    Opcode = 6'b000101;                         //  BNE
        #250    Opcode = 6'b000010;                         //  JMP
        #200    Opcode = 6'b000011;                         //  JAL
        #250    begin Opcode = 6'b000000; Function_opcode  = 6'b000010; end;//  SRL
    end         
endmodule

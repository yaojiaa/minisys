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
        reg[5:0]   Opcode = 6'b000000;            // ����ȡָ��Ԫinstruction[31..26]
        reg[5:0]   Function_opcode  = 6'b100000;      // r-form instructions[5..0]  //ADD
        // output
        wire       Jrn;
        wire       RegDST;
        wire       ALUSrc;            // �����ڶ����������ǼĴ�������������
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
        .Opcode     (Opcode),	     // ����ȡָ��Ԫinstruction[31..26]
        .Function_opcode(Function_opcode),	// ����ȡָ��Ԫr-���� instructions[5..0]
        .Jrn             (Jrn),				// Ϊ1������ǰָ����jr
        .RegDST     (RegDST),	// Ϊ1����Ŀ�ļĴ�����rd������Ŀ�ļĴ�����rt
        .ALUSrc     (ALUSrc),		// Ϊ1�����ڶ�������������������beq��bne���⣩
        .MemtoReg(MemtoReg),	// Ϊ1������Ҫ�Ӵ洢�������ݵ��Ĵ���
        .RegWrite   (RegWrite),	// Ϊ1������ָ����Ҫд�Ĵ���
        .MemWrite   (MemWrite),	// Ϊ1������ָ����Ҫд�洢��
        .Branch         (Branch),		// Ϊ1������Beqָ��
        .nBranch       (nBranch),	// Ϊ1������Bneָ��
        .Jmp              (Jmp),			// Ϊ1������Jָ��
        .Jal                (Jal),			// Ϊ1������Jalָ��
        .I_format       (I_format),			// Ϊ1������ָ���ǳ�beq��bne��LW��SW֮�������I-����ָ��
        .Sftmd          (Sftmd),				// Ϊ1��������λָ��
        .ALUOp	    (ALUOp)			// ��R-���ͻ�I_format=1ʱλ1Ϊ1, beq��bneָ����λ0Ϊ1
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module controlIO32 (
    input	[5:0]	Opcode,				// ����ȡָ��Ԫinstruction[31..26]
    input	[21:0]	Alu_resultHigh,		// ����ִ�е�ԪAlu_Result[31..10]
    input	[5:0]	Function_opcode,	// ����ȡָ��Ԫr-���� instructions[5..0]
    output			Jrn,				// Ϊ1������ǰָ����jr
    output			RegDST,				// Ϊ1����Ŀ�ļĴ�����rd������Ŀ�ļĴ�����rt
    output			ALUSrc,				// Ϊ1�����ڶ�������������������beq��bne���⣩
    output			MemorIOtoReg,		// Ϊ1������Ҫ�Ӵ洢����I/O�����ݵ��Ĵ���
    output			RegWrite,			// Ϊ1������ָ����Ҫд�Ĵ���
    output			MemRead,			// Ϊ1�����Ǵ洢����
    output			MemWrite,			// Ϊ1������ָ����Ҫд�洢��
    output			IORead,				// Ϊ1������I/O��
    output			IOWrite,			// Ϊ1������I/Oд
    output			Branch,				// Ϊ1������Beqָ��
    output			nBranch,			// Ϊ1������Bneָ��
    output			Jmp,				// Ϊ1������Jָ��
    output			Jal,				// Ϊ1������Jalָ��
    output			I_format,			// Ϊ1������ָ���ǳ�beq��bne��LW��SW֮�������I-����ָ��
    output			Sftmd,				// Ϊ1��������λָ��
    output	[1:0]	ALUOp				// ��R-���ͻ�I_format=1ʱλ1Ϊ1, beq��bneָ����λ0Ϊ1
);

    wire R_format,Lw,Sw;
  //����
endmodule
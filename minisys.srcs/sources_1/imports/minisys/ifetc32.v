`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Ifetc32 (
	input			reset,				// ��λ�ź�(�ߵ�ƽ��Ч)
    input			clock,				// ʱ��(23MHz)
	output	[31:0]	Instruction,		// ���ָ�����ģ��
    output	[31:0]	PC_plus_4_out,		// (pc+4)��ִ�е�Ԫ
    input	[31:0]	Add_result,			// ����ִ�е�Ԫ,�������ת��ַ
    input	[31:0]	Read_data_1,		// �������뵥Ԫ��jrָ���õĵ�ַ
    input			Branch,				// ���Կ��Ƶ�Ԫ
    input			nBranch,			// ���Կ��Ƶ�Ԫ
    input			Jmp,				// ���Կ��Ƶ�Ԫ
    input			Jal,				// ���Կ��Ƶ�Ԫ
    input			Jrn,				// ���Կ��Ƶ�Ԫ
    input			Zero,				// ����ִ�е�Ԫ
    output	[31:0]	opcplus4,			// JALָ��ר�õ�PC+4
    // ROM Pinouts
	output	[13:0]	rom_adr_o,			// ������ROM��Ԫ��ȡָ��ַ
	input	[31:0]	Jpadr				// �ӳ���ROM��Ԫ�л�ȡ��ָ��
);
    
    wire [31:0] PC_plus_4;
    reg [31:0] PC;
    reg [31:0] next_PC;		// ����ָ���PC����һ����PC+4)
    reg [31:0] opcplus4;
    
	// ROM Pinouts
	assign rom_adr_o = PC[15:2];
	assign Instruction = Jpadr;
    

	assign PC_plus_4[31:2] = PC[31:2] + 1'b1;
	assign PC_plus_4[1:0] = PC[1:0]; 
	assign PC_plus_4_out = PC_plus_4; 

    always @* begin  // beq $n ,$m if $n=$m branch   bne if $n /=$m branch jr
                                 // �뿼����������ָ����ж�������
                                // �Լ�����ָ���ִ�иø�next_PC��ʲôֵ
        if (Branch==1'b1 & Zero==1'b1)
			next_PC = Add_result;
		else if (nBranch==1'b1 & Zero==1'b0)
			next_PC = Add_result;
		else if (Jrn==1'b1)
			next_PC = Read_data_1;
		else
			next_PC = PC_plus_4;
    end
    
   always @(negedge clock) begin  //����J��Jalָ���reset�Ĵ���
      if (reset)
		begin
			PC = 32'd0;
			opcplus4 = 32'd0;
		end
		else
		begin
			if (Jmp==1'b1)
			begin
				PC = Instruction[25:0]<<2;
			end
			else if (Jal==1'b1)
			begin
				opcplus4 = PC_plus_4;
				PC = Instruction[25:0]<<2;
			end
			else
			begin
				PC = next_PC;
			end
		end 
   end
endmodule

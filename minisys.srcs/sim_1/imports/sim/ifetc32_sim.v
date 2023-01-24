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
    wire [31:0] Instruction;            // ���ָ��
    wire [31:0] PC_plus_4_out;
    wire [31:0] opcplus4;
	wire [13:0] rom_adr;
	wire [31:0] Jpadr;
	
	Ifetc32 Uif (
		.reset			(reset),			// ��λ(�ߵ�ƽ��Ч)
		.clock			(clock),			// CPUʱ��
		.Instruction	(Instruction),		// ���ָ�����ģ��
		.PC_plus_4_out	(PC_plus_4_out),	// (pc+4)��ִ�е�Ԫ
		.Add_result		(Add_result),		// ����ִ�е�Ԫ,�������ת��ַ
		.Read_data_1	(Read_data_1),		// �������뵥Ԫ��jrָ���õĵ�ַ
		.Branch			(Branch),			// ���Կ��Ƶ�Ԫ
		.nBranch		(nBranch),			// ���Կ��Ƶ�Ԫ
		.Jmp			(Jmp),				// ���Կ��Ƶ�Ԫ
		.Jal			(Jal),				// ���Կ��Ƶ�Ԫ
		.Jrn			(Jrn),				// ���Կ��Ƶ�Ԫ
		.Zero			(Zero),				// ����ִ�е�Ԫ
		.opcplus4		(opcplus4),			// JALָ��ר�õ�PC+4
		// ROM Pinouts
		.rom_adr_o		(rom_adr),			// ������ROM��Ԫ��ȡָ��ַ
		.Jpadr			(Jpadr)				// �ӳ���ROM��Ԫ�л�ȡ��ָ��
	);

	// ����64KB ROM, ������ʵ��ֻ�� 64KB ROM
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

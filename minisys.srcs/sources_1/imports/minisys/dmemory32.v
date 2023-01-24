`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module dmemory32 (
    input			ram_clk_i,
    input			ram_wen_i,		// ���Կ��Ƶ�Ԫ
    input	[13:0]	ram_adr_i,		// ����memorioģ�飬Դͷ������ִ�е�Ԫ�����alu_result
    input	[31:0]	ram_dat_i,		// �������뵥Ԫ��read_data2
    output	[31:0]	ram_dat_o,		// �Ӵ洢���л�õ�����
	// UART Programmer Pinouts
	input           upg_rst_i,      // UPG reset (Active High)
	input           upg_clk_i,      // UPG ram_clk_i (10MHz)
	input           upg_wen_i,		// UPG write enable
	input	[13:0]	upg_adr_i,		// UPG write address
	input	[31:0]	upg_dat_i,		// UPG write data
	input           upg_done_i      // 1 if programming is finished
);
    
    wire ram_clk = !ram_clk_i;	// ��Ϊʹ��Block ram�Ĺ����ӳ٣�RAM�ĵ�ַ����������ʱ��������׼����,
								// ʹ��ʱ�����������ݶ����������Բ��÷���ʱ�ӣ�ʹ�ö������ݱȵ�ַ׼
								// ����Ҫ���Լ���ʱ�ӣ��Ӷ��õ���ȷ��ַ��
							 
	// kickOff = 1��ʱ��CPU ����������������Ǵ������س���
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
    
    // ����64KB RAM��������ʵ��ֻ�� 64KB RAM
	ram ram (
        .clka	(kickOff ?	ram_clk		: upg_clk_i),
        .wea	(kickOff ?	ram_wen_i	: upg_wen_i),
        .addra	(kickOff ?	ram_adr_i	: upg_adr_i),
        .dina	(kickOff ?	ram_dat_i	: upg_dat_i),
        .douta	(ram_dat_o)
    );
	
endmodule

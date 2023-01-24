`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module switchs (
    input			switrst,		// ��λ�ź�
    input			switclk,		// ʱ���ź�
    input			switchcs,		// ��memorio���ģ��ɵ�����λ�γɵ�switchƬѡ�ź�  !!!!!!!!!!!!!!!!!
    input	[1:0]	switchaddr,		// ��switchģ��ĵ�ַ�Ͷ�  !!!!!!!!!!!!!!!
    input			switchread,		// ���ź�
    output	[15:0]	switchrdata,	// �͵�CPU�Ĳ��뿪��ֵע����������ֻ��16��
    input	[23:0]	switch_i		// �Ӱ��϶���24λ��������
);

    reg [15:0] switchrdata;
    always@(negedge switclk or posedge switrst) begin
        if (switrst) begin
			switchrdata <= 16'd0;
		end else begin
		    if (switchcs == 1'b1) begin
				if (switchread==1'b1) begin
				    if (switchaddr == 2'b00)
					   switchrdata <= switch_i[15:0];
					else
					   switchrdata[7:0] <= switch_i[23:16];
				end else
					switchrdata <= 16'd0;
			end
		end		     
    end
endmodule

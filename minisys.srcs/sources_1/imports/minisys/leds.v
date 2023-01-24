`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module leds (
    input			ledrst,		// ��λ�ź�
    input			led_clk,	// ʱ���ź�
    input			ledwrite,	// д�ź�
    input			ledcs,		// ��memorio���ģ��ɵ�����λ�γɵ�LEDƬѡ�ź�   !!!!!!!!!!!!!!!!!
    input	[1:0]	ledaddr,	// ��LEDģ��ĵ�ַ�Ͷ�  !!!!!!!!!!!!!!!!!!!!
    input	[15:0]	ledwdata,	// д��LEDģ������ݣ�ע��������ֻ��16��
    output	[23:0]	ledout		// ������������24λLED�ź�
);
  
    reg [23:0] ledout;
    
    always@(posedge led_clk or posedge ledrst) begin
        if (ledrst) begin
			ledout <= 24'd0;
		end else begin
		    if (ledcs==1'b1) begin
				if (ledwrite==1'b1)
				    if (ledaddr == 2'b00) begin 
					   ledout[15:0] <= ledwdata[15:0];
					end else begin
					   ledout[23:16] <= ledwdata[7:0];
					end
				else
					ledout <= ledout;
			end	else begin
				ledout <= 24'd0;
			end
		end
    end
endmodule

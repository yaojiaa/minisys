`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module switchs (
    input			switrst,		// 复位信号
    input			switclk,		// 时钟信号
    input			switchcs,		// 从memorio来的，由低至高位形成的switch片选信号  !!!!!!!!!!!!!!!!!
    input	[1:0]	switchaddr,		// 到switch模块的地址低端  !!!!!!!!!!!!!!!
    input			switchread,		// 读信号
    output	[15:0]	switchrdata,	// 送到CPU的拨码开关值注意数据总线只有16根
    input	[23:0]	switch_i		// 从板上读的24位开关数据
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

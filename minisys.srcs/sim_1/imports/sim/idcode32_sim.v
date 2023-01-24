`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/07 10:27:17
// Design Name: 
// Module Name: idcode32_sim
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


module idcode32_sim ();

    // input 
    reg[31:0]  Instruction = 32'b000000_00010_00011_00111_00000_100000; //add $7,$2,$3
    reg[31:0]  read_data = 32'h00000000;                    //  从DATA RAM or I/O port取出的数据
    reg[31:0]  ALU_result = 32'h00000005;                   //  需要扩展立即数到32位
    reg        Jal = 1'b0; 
    reg        RegWrite = 1'b1;
    reg        MemtoReg = 1'b0;
    reg        RegDst = 1'b1;
    reg         clock = 1'b0 ,reset = 1'b1;
    reg[31:0]  opcplus4 = 32'h00000004;                 // 来自取指单元，JAL中用
    // output
    wire[31:0] read_data_1;
    wire[31:0] read_data_2;
    wire[31:0] Sign_extend;
    
	Idecode32 Uid (
		.reset			(reset),		// 复位(高电平有效)
		.clock			(clock),		// CPU时钟
		.read_data_1	(read_data_1),	// 输出的第一操作数
		.read_data_2	(read_data_2),	// 输出的第二操作数
		.Instruction	(Instruction),	// 取指单元来的指令
		.read_data		(read_data),	// 从DATA RAM or I/O port取出的数据
		.ALU_result		(ALU_result),	// 从执行单元来的运算的结果，需要扩展立即数到32位
		.Jal			(Jal),			// 来自控制单元，说明是JAL指令 
		.RegWrite		(RegWrite),		// 来自控制单元
		.MemtoReg	(MemtoReg),		// 来自控制单元
		.RegDst			(RegDst),		// 来自控制单元
		.Sign_extend	(Sign_extend),	// 扩展后的32位立即数
		.opcplus4		(opcplus4)		// 来自取指单元，JAL中用
	);

    initial begin
        #200   reset = 1'b0;
        #200   begin Instruction = 32'b001000_00111_00011_1000000000110111;  //addi $3,$7,0X8037
                    read_data = 32'h00000000; 
                    ALU_result = 32'hFFFF803C;
                    Jal = 1'b0;
                    RegWrite = 1'b1;
                    MemtoReg = 1'b0;
                    RegDst = 1'b0;
                    opcplus4 = 32'h00000008; 
               end
        #200   begin Instruction = 32'b001100_00010_00100_1000000010010111;  //andi $4,$2,0X8097
                           read_data = 32'h00000000; 
                           ALU_result = 32'h00000002;
                           Jal = 1'b0;
                           RegWrite = 1'b1;
                           MemtoReg = 1'b0;
                           RegDst = 1'b0;
                           opcplus4 = 32'h0000000c; 
                end
        #200   begin Instruction = 32'b000000_00000_00001_00101_00010_000000;  //sll $5,$1,2
                                   read_data = 32'h00000000; 
                                   ALU_result = 32'h00000004;
                                   Jal = 1'b0;
                                   RegWrite = 1'b1;
                                   MemtoReg = 1'b0;
                                   RegDst = 1'b1;
                                   opcplus4 = 32'h00000010; 
               end
        #200   begin Instruction = 32'b100011_00000_00110_0000000100000000;  //LW $6,0(0X100)
                                          read_data = 32'h0000007B; 
                                          ALU_result = 32'h00000054;
                                          Jal = 1'b0;
                                          RegWrite = 1'b1;
                                          MemtoReg = 1'b1;
                                          RegDst = 1'b0;
                                          opcplus4 = 32'h00000014; 
               end
        #200   begin Instruction = 32'b000011_00000000000000000000000000;  //JAL 0000
                                          read_data = 32'h00000000; 
                                          ALU_result = 32'h00000004;
                                          Jal = 1'b1;
                                          RegWrite = 1'b1;
                                          MemtoReg = 1'b0;
                                          RegDst = 1'b0;
                                          opcplus4 = 32'h00000018; 
               end
    end 
    always #50 clock = ~clock;            
endmodule

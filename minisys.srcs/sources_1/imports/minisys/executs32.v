`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Executs32 (
    input	[31:0]	Read_data_1,		// 从译码单元的Read_data_1中来
    input	[31:0]	Read_data_2,		// 从译码单元的Read_data_2中来
    input	[31:0]	Sign_extend,		// 从译码单元来的扩展后的立即数
    input	[5:0]	Function_opcode,	// 取指单元来的r-类型指令功能码,r-form instructions[5:0]
    input	[5:0]	Exe_opcode,			// 取指单元来的操作码
    input	[1:0]	ALUOp,				// 来自控制单元的运算指令控制编码
    input	[4:0]	Shamt,				// 来自取指单元的instruction[10:6]，指定移位次数
    input			Sftmd,				// 来自控制单元的，表明是移位指令
    input			ALUSrc,				// 来自控制单元，表明第二个操作数是立即数（beq，bne除外）
    input			I_format,			// 来自控制单元，表明是除beq, bne, LW, SW之外的I-类型指令
    input			Jrn,				// 来自控制单元，书名是JR指令
    output			Zero,				// 为1表明计算值为0 
    output	[31:0]	ALU_Result,			// 计算的数据结果
    output	[31:0]	Add_Result,			// 计算的地址结果        
    input	[31:0]	PC_plus_4			// 来自取指单元的PC+4
);
    
    reg[31:0] ALU_Result;
    wire[31:0] Ainput,Binput;
    reg[31:0] Cinput,Dinput;
    reg[31:0] Einput,Finput;
    reg[31:0] Ginput,Hinput;
    reg[31:0] Sinput;
    reg[31:0] ALU_output_mux;
    wire[2:0] ALU_ctl;
    wire[5:0] Exe_code;
    wire[2:0] Sftm;
    
    assign Sftm = Function_opcode[2:0];   // 实际有用的只有低三位(移位指令）
    assign Exe_code = (I_format==0) ? Function_opcode : {3'b000,Exe_opcode[2:0]};
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0]; //R/LW,SW  sft  else的时候含LW和SW
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];      //24H AND 
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
 


	always @* begin  // 6种移位指令
       if(Sftmd)
        case(Sftm[2:0])
            3'b000:Sinput = Binput << Shamt;   //Sll rd,rt,Shamt  00000
            3'b010:Sinput = Binput >> Shamt;   //Srl rd,rt,Shamt  00010
            3'b100:Sinput = Binput << Ainput;  //Sllv rd,rt,rs 000100
            3'b110:Sinput = Binput >> Ainput;  //Srlv rd,rt,rs 000110
            3'b011:Sinput = ({32{Binput[31]}} << ~Shamt) | (Binput >> Shamt);         		//Sra rd,rt,shamt 00011
            3'b111:Sinput = ({32{Binput[31]}} << ~Ainput) | (Binput >> Ainput);		        //Srav rd,rt,rs 00111
            default:Sinput = Binput;
        endcase
       else Sinput = Binput;
    end
 
    always @* begin
        if(((ALU_ctl==3'b111) && (Exe_code[3]==1))||((ALU_ctl[2:1]==2'b11) && (I_format==1))) //slti(sub)  处理所有SLT类的问题
            ALU_Result = (Ainput < Binput)? 1'b1: 1'b0;
        else if((ALU_ctl==3'b101) && (I_format==1)) ALU_Result[31:0] = (Binput<<16)&32'hFFFF0000;   //lui data
        else if(Sftmd==1) ALU_Result = Sinput;   //  移位
        else  ALU_Result = ALU_output_mux[31:0];   //otherwise
    end
 
    assign Add_Result = PC_plus_4[31:0] + {Sign_extend[29:0],2'b00};    // 给取指单元作为beq和bne指令的跳转地址 
    
    assign Zero = (ALU_output_mux[31:0]== 32'h00000000) ? 1'b1 : 1'b0;
    
    always @(ALU_ctl or Ainput or Binput) begin
        case(ALU_ctl)
            3'b000:ALU_output_mux = Ainput & Binput;
            3'b001:ALU_output_mux = Ainput | Binput;
            3'b010:ALU_output_mux = Ainput + Binput;
            3'b011:ALU_output_mux = Ainput + Binput;
            3'b100:ALU_output_mux = Ainput ^ Binput;
            3'b101:ALU_output_mux = ~(Ainput|Binput);
            3'b110:ALU_output_mux = Ainput - Binput;
            3'b111:ALU_output_mux = Ainput - Binput;
            default:ALU_output_mux = 32'h00000000;
        endcase
    end
endmodule

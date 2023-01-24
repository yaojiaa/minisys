`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module minisys ( 
    input			fpga_rst,	        // ���ϵ�Reset�źţ��ߵ�ƽ��λ
    input			fpga_clk,	    // ���ϵ�100MHzʱ���ź�
    input	[23:0]	switch2N4,	// ���뿪������
    output	[23:0]	led2N4,		// LED������������
	// UART Programmer Pinouts
	input           start_pg,           // �Ӱ��ϵ�S3����������������
	input           rx,                      // UART����
	output          rx_led,
	output          tx                      // UART����
);
    
    assign rx_led = rx;
    
    wire clock;				            //clock: ��Ƶ��ʱ�ӹ���ϵͳ
    wire iowrite,ioread;	        //I/O��д�ź�
    wire [31:0] write_data;	    //дRAM��IO������
    wire [31:0] rdata;		        //��RAM��IO������
    wire [15:0] ioread_data;	//��IO������
    wire [31:0] pc_plus_4;	    //PC+4
    wire [31:0] read_data_1;	
    wire [31:0] read_data_2;	
    wire [31:0] sign_extend;	//������չ
    wire [31:0] add_result;	
    wire [31:0] alu_result;	
    wire [31:0] read_data;	    //RAM�ж�ȡ������
    wire [31:0] address;
    wire alusrc;
    wire branch;
    wire nbranch,jmp,jal,jrn,i_format;
    wire regdst;
    wire regwrite;
    wire zero;
    wire memwrite;
    wire memread;
    wire memoriotoreg;
    wire memreg;
    wire sftmd;
    wire[1:0] aluop;
    wire[31:0] instruction;
    wire[31:0] opcplus4;
	wire [13:0] rom_adr;
	wire [31:0] rom_dat;
    wire ledctrl,switchctrl;
    wire[15:0] ioread_data_switch;
    wire rst;
	// UART Programmer Pinouts
	wire upg_clk, upg_clk_o, upg_wen_o, upg_done_o;
	wire [14:0] upg_adr_o;
	wire [31:0] upg_dat_o;

	wire spg_bufg;
	BUFG U1(.I(start_pg), .O(spg_bufg));	    // S3����ȥ��
    
	// Generate UART Programmer reset signal
	reg upg_rst;
	always @ (posedge fpga_clk) begin
		if (spg_bufg)	upg_rst = 0;
		if (fpga_rst)	upg_rst = 1;
	end
	
	assign rst = fpga_rst | !upg_rst;
	 
    cpuclk cpuclk (
        .clk_in1		    (fpga_clk),	    // 100MHz, ����ʱ��
        .clk_out1		(clock)    	    // CPU Clock (23MHz), ��ʱ��
		//.clk_out2		(upg_clk)		// UPG Clock (10MHz), ���ڴ�������
    );
	
	/*uart_bmpg_0 uartpg (                // ��ģ���Ѿ��Ӻã�ֻ��Ϊ�������صĸ������ɲ�ȥ��ע
		.upg_clk_i		(upg_clk),		// 10MHz   
		.upg_rst_i		(upg_rst),		// �ߵ�ƽ��Ч
		// blkram signals
		.upg_clk_o		(upg_clk_o),
		.upg_wen_o		(upg_wen_o),
		.upg_adr_o		(upg_adr_o),
		.upg_dat_o		(upg_dat_o),
		.upg_done_o		(upg_done_o),
		// uart signals
		.upg_rx_i		(rx),
		.upg_tx_o		(tx)
	);*/
	
	programrom ROM (
		// Program ROM Pinouts
		.rom_clk_i		(clock),		    // ��CPU��23MHz����ʱ��
		.rom_adr_i		(rom_adr),		// ȡָ��Ԫ��ROM�ĵ�ַ��PC��
		.Jpadr			(rom_dat),		    // ROM�ж������ݣ�ָ�
		// UART Programmer Pinouts, �����Ǵ����������ã��ɲ��ع�ע
		.upg_rst_i		(upg_rst),		// UPG reset (�ߵ�ƽ��Ч)
		.upg_clk_i		(upg_clk_o),	// UPG clock (10MHz)
		.upg_wen_i		(upg_wen_o & !upg_adr_o[14]),	// UPG write enable
		.upg_adr_i		(upg_adr_o[13:0]),	// UPG write address
		.upg_dat_i		(upg_dat_o),	            // UPG write data
		.upg_done_i		(upg_done_o)	    // 1 if programming is finished
	);
    
    Ifetc32 ifetch(
        .reset(rst),
        .clock(clock),
        .Instruction	(instruction),
        .PC_plus_4_out	(pc_plus_4),
        .Add_result(add_result),
		.Read_data_1(read_data_1),
		.Branch(branch),
		.nBranch(nbranch),
		.Jmp(jmp),
		.Jal(jal),
		.Jrn(jrn),
		.Zero(zero),
		.opcplus4(opcplus4),
		// ROM Pinouts
		.rom_adr_o		(rom_adr),
		.Jpadr			(rom_dat)
    );
    
    Idecode32 idecode(
        .read_data_1	(read_data_1),
        .read_data_2	(read_data_2),
        .Instruction(instruction),
		.read_data(rdata),
		.ALU_result(alu_result),
		.Jal(jal),
		.RegWrite(regwrite),
		.MemtoReg(memoriotoreg),
		.RegDst(regdst),
		.Sign_extend(sign_extend),
		.clock(clock),
		.reset(rst),
		.opcplus4(opcplus4)
		
    );
    
    control32 control(
        .Opcode			(instruction[31:26]),
        .Function_opcode(instruction[5:0]),
        .Alu_resultHigh(alu_result[31:10]),
		.Jrn(jrn),
		.RegDST(regdst),
		.ALUSrc(alusrc),
		.MemorIOtoReg(memoriotoreg),
		.RegWrite(regwrite),
		.MemRead(memread),
		.MemWrite(memwrite),
		.IORead(ioread),
		.IOWrite(iowrite),
		.Branch(branch),
		.nBranch(nbranch),
        .Jmp(jmp),
		.Jal(jal),
		.I_format(i_format),
		.Sftmd(sftmd),
		.ALUOp(aluop)
    );
	
    Executs32 execute(
        .Read_data_1	(read_data_1),
        .Read_data_2	(read_data_2),
        .Sign_extend(sign_extend),
		.Function_opcode(instruction[5:0]),
		.Exe_opcode(instruction[31:26]),				
		.ALUOp(aluop),
        .Shamt(instruction[10:6]),
		.ALUSrc(alusrc),
		.I_format(i_format),
		.Zero(zero),
		.Sftmd(sftmd),
		.ALU_Result(alu_result),
		.Add_Result(add_result),
		.PC_plus_4(pc_plus_4)
	);
    
    dmemory32 memory (
        .ram_clk_i		(clock),
        .ram_wen_i	(memwrite),			    // ���Կ��Ƶ�Ԫ
        .ram_adr_i		(address[15:2]),	        // ����memorioģ�飬Դͷ������ִ�е�Ԫ�����alu_result
        .ram_dat_i		(write_data),		        // �������뵥Ԫ��read_data2
        .ram_dat_o		(read_data),		        // �Ӵ洢���л�õ�����
		// UART Programmer Pinouts
		.upg_rst_i		(upg_rst),			// UPG reset (Active High)
		.upg_clk_i		(upg_clk_o),		// UPG clock (10MHz)
		.upg_wen_i		(upg_wen_o & upg_adr_o[14]),	// UPG write enable
		.upg_adr_i		(upg_adr_o[13:0]),	// UPG write address
		.upg_dat_i		(upg_dat_o),		// UPG write data
		.upg_done_i		(upg_done_o)		// 1 if programming is finished
    );
	
    memorio memio(
        .caddress		(alu_result),
        .address		(address),
        .memread		(memread),
        .memwrite		(memwrite),
        .ioread			(ioread),
        .iowrite		(iowrite),
        .mread_data		(read_data),
        .ioread_data	(ioread_data),
        .wdata			(read_data_2),
        .rdata			(rdata),
        .write_data		(write_data),
        .LEDCtrl		(ledctrl),
        .SwitchCtrl		(switchctrl)
    );
    
    ioread multiioread(
        .reset				(rst),
        .ior				(ioread),
        .switchctrl			(switchctrl),
        .ioread_data		(ioread_data),
        .ioread_data_switch	(ioread_data_switch)
    );
	
    leds led24(
        .ledrst	        (rst),
        .led_clk        (clock),
        .ledwrite       (ledctrl),
        .ledaddr        (address[1:0]),
		.ledcs          (1'b1),
		.ledwdata       (write_data),
		.ledout         (led2N4)
	);
	
	switchs switch24(
        .switrst		(rst),
		.switclk		(clock),
        .switchread     (switchctrl),
        .switchaddr     (address[1:0]),
		.switchcs       (1'b1),
		.switchrdata    (ioread_data_switch),
		.switch_i       (switch2N4)
	);
endmodule

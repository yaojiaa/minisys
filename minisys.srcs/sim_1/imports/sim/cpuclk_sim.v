`timescale 1ns / 1ps

module cpuclk_sim ();

    //  INPUT
    reg pclk = 0;
    //output
    wire clock, uclk;
    
    cpuclk Uclk (
        .clk_in1	(pclk),		// 100MHz
        .clk_out1	(clock)	// CPU Clock
		//.clk_out2	(uclk)		// UART Programmer Clock
    );
    
    always #5 pclk = ~pclk;
	
endmodule

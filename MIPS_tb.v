`timescale 1ns/1ps
module MIPS_tb;
    reg clk;
    integer i;
    // Instantiate the MIPS processor
    MIPS uut (
        .clk(clk)
    );
    
    // Clock generation (100MHz clock, 5ns period)
    always begin
        #5 clk = ~clk;
    end
    
    // Test memory initialization
    initial begin
	uut.pc.current_instruction = 32'h0000000;
        // Initialize instruction memory with machine code instructions
        // For simplicity, we'll encode instructions in hex directly here
        // Example instructions (in hex):
        // lw $1, 0($0)       --> 0x8C010000
        // lw $2, 4($0)       --> 0x8C020004
        // add $3, $1, $2     --> 0x00028020
        // sub $4, $1, $2     --> 0x00028022
        // sw $3, 8($0)       --> 0xAD030008
        // sw $4, 12($0)      --> 0xAD04000C
	// lw $5, 12($0)      --> 0x8D05000C
	// add $2, $2, $5     --> 0x00451020
        // beq $1, $2, 16     --> 0x1022000F

        // lw $1, 0($0)
	uut.imem.IM[0] = 8'h8C;    // First byte of instruction (0x8C)
	uut.imem.IM[1] = 8'h01;    // Second byte (0x01)
	uut.imem.IM[2] = 8'h00;    // Third byte (0x00)
	uut.imem.IM[3] = 8'h00;    // Fourth byte (0x00)
	
	// lw $2, 4($0)
	uut.imem.IM[4] = 8'h8C;    // First byte (0x8C)
	uut.imem.IM[5] = 8'h02;    // Second byte (0x02)
	uut.imem.IM[6] = 8'h00;    // Third byte (0x00)
	uut.imem.IM[7] = 8'h04;    // Fourth byte (0x04)
	
	// add $3, $1, $2
	uut.imem.IM[8] = 8'h00;    // First byte (0x00)
	uut.imem.IM[9] = 8'h22;    // Second byte (0x22)
	uut.imem.IM[10] = 8'h18;   // Third byte (0x18)
	uut.imem.IM[11] = 8'h20;   // Fourth byte (0x20)

	// sub $4, $1, $2
	uut.imem.IM[12] = 8'h00;   // First byte (0x00)
	uut.imem.IM[13] = 8'h22;   // Second byte (0x22)
	uut.imem.IM[14] = 8'h20;   // Third byte (0x20)
	uut.imem.IM[15] = 8'h22;   // Fourth byte (0x22)
	
	// sw $3, 8($0)
	uut.imem.IM[16] = 8'hAD;   // First byte (0xAD)
	uut.imem.IM[17] = 8'h03;   // Second byte (0x03)
	uut.imem.IM[18] = 8'h00;   // Third byte (0x00)
	uut.imem.IM[19] = 8'h08;   // Fourth byte (0x08)
	
	// sw $4, 12($0)
	uut.imem.IM[20] = 8'hAD;   // First byte (0xAD)
	uut.imem.IM[21] = 8'h04;   // Second byte (0x04)
	uut.imem.IM[22] = 8'h00;   // Third byte (0x00)
	uut.imem.IM[23] = 8'h0C;   // Fourth byte (0x0C)
	
	// lw $5, 12($0)
	uut.imem.IM[24] = 8'h8D;   // First byte (0x8D)
	uut.imem.IM[25] = 8'h05;   // Second byte (0x05)
	uut.imem.IM[26] = 8'h00;   // Third byte (0x00)
	uut.imem.IM[27] = 8'h0C;   // Fourth byte (0x0C)

	// add $2, $2, $5     --> 0x00451020
	uut.imem.IM[28] = 8'h00;   // First byte (0x00)
	uut.imem.IM[29] = 8'h45;   // Second byte (0x45)
	uut.imem.IM[30] = 8'h10;   // Third byte (0x10)
	uut.imem.IM[31] = 8'h20;   // Fourth byte (0x20)
	
	// beq $1, $2, 16
	uut.imem.IM[32] = 8'h10;   // First byte (0x10)
	uut.imem.IM[33] = 8'h22;   // Second byte (0x22)
	uut.imem.IM[34] = 8'h00;   // Third byte (0x00)
	uut.imem.IM[35] = 8'h10;   // Fourth byte (0x10)

	// Add jump instruction    (jumps to address 0x28)
	uut.imem.IM[100] = 8'h08;   // First byte (opcode for j)
	uut.imem.IM[101] = 8'h00;   // Second byte
	uut.imem.IM[102] = 8'h00;   // Third byte
	uut.imem.IM[103] = 8'h19;   // Fourth byte (target address = 0xA)

	// Data at address 0: 5
    	uut.dmem.dmem[0] = 8'h00;    // First byte (0x00)
    	uut.dmem.dmem[1] = 8'h00;    // Second byte (0x00)
    	uut.dmem.dmem[2] = 8'h00;    // Third byte (0x00)
    	uut.dmem.dmem[3] = 8'h05;    // Fourth byte (0x05)
	
    	// Data at address 4: 3
    	uut.dmem.dmem[4] = 8'h00;    // First byte (0x00)
    	uut.dmem.dmem[5] = 8'h00;    // Second byte (0x00)
    	uut.dmem.dmem[6] = 8'h00;    // Third byte (0x00)
    	uut.dmem.dmem[7] = 8'h03;    // Fourth byte (0x03)
	
    	// Data at address 8: 0 (for sw)
    	uut.dmem.dmem[8] = 8'h00;    // First byte (0x00)
    	uut.dmem.dmem[9] = 8'h00;    // Second byte (0x00)
    	uut.dmem.dmem[10] = 8'h00;   // Third byte (0x00)
    	uut.dmem.dmem[11] = 8'h00;   // Fourth byte (0x00)
	
    	// Data at address 12: 0 (for sw)
    	uut.dmem.dmem[12] = 8'h00;   // First byte (0x00)
    	uut.dmem.dmem[13] = 8'h00;   // Second byte (0x00)
    	uut.dmem.dmem[14] = 8'h00;   // Third byte (0x00)
    	uut.dmem.dmem[15] = 8'h00;   // Fourth byte (0x00)

        // Initialize the program counter to start from the first instruction
        uut.pc.current_instruction = 32'b0;

        for(i = 0; i<32; i = i+1) begin
		uut.rf.RF[i] = 32'b0;
	end
	
        // Start the clock
	#5
        clk = 0;
    end
    
    // Run for a set amount of time (e.g., 1000ns or 200 cycles)
    initial begin
        #200;
        $finish;
    end
    
    // Display messages for debugging purposes
    initial begin
        $monitor("Time: %0t, PC: %h, instruction: %h, Reg[1]: %h, Reg[2]: %h, Reg[3]: %h, Reg[4]: %h, Mem[8]: %h, Mem[12]: %h", 
                  $time, uut.pc.current_instruction, uut.instruction, uut.rf.RF[1], uut.rf.RF[2], uut.rf.RF[3], uut.rf.RF[4],
		  {uut.dmem.dmem[8],uut.dmem.dmem[9],uut.dmem.dmem[10],uut.dmem.dmem[11]}, {uut.dmem.dmem[12],uut.dmem.dmem[13],uut.dmem.dmem[14],uut.dmem.dmem[15]});
    end
    
endmodule


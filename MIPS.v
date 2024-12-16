module MIPS(
    input clk
);
    // Wires for the modules
    wire [31:0] instruction, read_data1, read_data2, ALUResult, data_mem_out;
    wire [31:0] next_PC, current_PC, extended_immediate;
    wire [3:0] ALUControl;
    wire [1:0] ALUOp;
    wire Zero, RegWrite, MemRead, MemWrite, Branch, MemtoReg, ALUSrc, RegDst, Jump;
    wire [4:0] write_register;
    wire [31:0] write_data; // For the MemtoReg mux output
    wire [31:0] alu_input_b; // For the ALUSrc mux output
    wire [31:0] jump_address; // Jump target address

    // Instantiate the modules
    Program_Counter pc (
        .clk(clk),
        .next_instruction(next_PC),
        .current_instruction(current_PC)
    );

    Instruction_Memory imem (
        .read_address(current_PC[11:0]), // Use the 12 least significant bits of PC
        .instruction(instruction)
    );

    CTRL control (
        .opcode(instruction[31:26]),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump), // New jump signal
        .ALUOp(ALUOp)
    );

    ALUControl alu_control (
        .ALUOp(ALUOp),
        .funct(instruction[5:0]),
        .ALUControl(ALUControl)
    );

    // Multiplexor for Write Register
    assign write_register = RegDst ? instruction[15:11] : instruction[20:16];

    Register_File rf (
        .read_address1(instruction[25:21]),
        .read_address2(instruction[20:16]),
        .write_data(write_data),
        .write_address(write_register),
        .CTRL_RegWrite(RegWrite),
        .clk(clk),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Sign extension for lw, sw, beq instructions
    Sign_Extend sign_ext (
        .imm_in(instruction[15:0]),
        .imm_out(extended_immediate)
    );

    // Multiplexor for ALU Input B
    assign alu_input_b = ALUSrc ? extended_immediate : read_data2;

    ALU alu (
        .A(read_data1),
        .B(alu_input_b),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .Zero(Zero)
    );

    Data_Memory dmem (
        .clk(clk),
        .address(ALUResult),
        .write_data(read_data2),
        .CTRL_MemWrite(MemWrite),
        .CTRL_MemRead(MemRead),
        .read_data(data_mem_out)
    );

    // Multiplexor for Write Data to Register File
    assign write_data = MemtoReg ? data_mem_out : ALUResult;

    // Compute Jump Address
    assign jump_address = {current_PC[31:28], instruction[25:0], 2'b00};

    // Multiplexor for Next PC
    assign next_PC = Jump ? (jump_address) :
                     (Branch && Zero ? (current_PC + 4 + (extended_immediate << 2)) :
                     current_PC + 4);

endmodule


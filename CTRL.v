module CTRL(
    input [5:0] opcode,        // Opcode field from instruction[31:26]
    output reg RegDst,         // Selects destination register for R-type instructions
    output reg ALUSrc,         // Selects ALU input (register or immediate)
    output reg MemtoReg,       // Selects data to write to register (ALU result or memory)
    output reg RegWrite,       // Enables writing to the register file
    output reg MemRead,        // Enables reading from data memory
    output reg MemWrite,       // Enables writing to data memory
    output reg Branch,         // Indicates a branch instruction
    output reg Jump,           // Indicates a jump instruction (new signal)
    output reg [1:0] ALUOp     // Encodes ALU operation
);

    always @(*) begin
        // Default control signals
        RegDst   = 0;
        ALUSrc   = 0;
        MemtoReg = 0;
        RegWrite = 0;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 0;
        Jump     = 0; // New default value
        ALUOp    = 2'b00;

        case (opcode)
            6'b000000: begin // R-type (e.g., add, sub)
                RegDst   = 1;
                ALUSrc   = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                Jump     = 0;
                ALUOp    = 2'b10; // ALU operation determined by funct field
            end
            6'b100011: begin // lw (load word)
                RegDst   = 0;
                ALUSrc   = 1;
                MemtoReg = 1;
                RegWrite = 1;
                MemRead  = 1;
                MemWrite = 0;
                Branch   = 0;
                Jump     = 0;
                ALUOp    = 2'b00; // ALU performs addition for address calculation
            end
            6'b101011: begin // sw (store word)
                RegDst   = 0; // Don't care
                ALUSrc   = 1;
                MemtoReg = 0; // Don't care
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 1;
                Branch   = 0;
                Jump     = 0;
                ALUOp    = 2'b00; // ALU performs addition for address calculation
            end
            6'b000100: begin // beq (branch equal)
                RegDst   = 0; // Don't care
                ALUSrc   = 0;
                MemtoReg = 0; // Don't care
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 1;
                Jump     = 0;
                ALUOp    = 2'b01; // ALU performs subtraction for comparison
            end
            6'b000010: begin // j (jump)
                RegDst   = 0; // Don't care
                ALUSrc   = 0; // Don't care
                MemtoReg = 0; // Don't care
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                Jump     = 1; // Set Jump high
                ALUOp    = 2'b00; // ALU not used
            end
            default: begin // Default case for unsupported opcodes
                RegDst   = 0;
                ALUSrc   = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                Jump     = 0;
                ALUOp    = 2'b00;
            end
        endcase
    end
endmodule


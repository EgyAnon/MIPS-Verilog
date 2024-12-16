module ALU(
    input [31:0] A,            // First operand
    input [31:0] B,            // Second operand
    input [3:0] ALUControl,    // ALU control signals
    output reg [31:0] Result,  // ALU result
    output Zero                // Zero flag
);

    assign Zero = (Result == 0); // Zero flag is high if the result is zero

    always @(*) begin
        case (ALUControl)
            4'b0010: Result = A + B;        // Addition (used for lw, sw)
            4'b0110: Result = A - B;        // Subtraction (used for beq, sub)
            4'b0000: Result = A & B;        // Bitwise AND
            4'b0001: Result = A | B;        // Bitwise OR
            4'b0111: Result = (A < B) ? 1 : 0;  // Set Less Than (SLT)
            default: Result = 0;           // Default case (undefined behavior)
        endcase
    end
endmodule

module ALUControl (
    input [1:0] ALUOp,          // ALU operation from the Control unit
    input [5:0] funct,          // Funct field from R-type instruction
    output reg [3:0] ALUControl    // ALU control signals
);

    // ALU operation codes
    parameter ADD  = 4'b0010;    // ADD operation
    parameter SUB  = 4'b0110;    // SUB operation
    parameter AND  = 4'b0000;    // AND operation
    parameter OR   = 4'b0001;    // OR operation
    parameter SLT  = 4'b0111;    // SLT operation (Set Less Than)

    always @(*) begin
        case(ALUOp)
            2'b00: ALUControl = ADD;       // lw and sw: ALU performs addition (address calculation)
            2'b01: ALUControl = SUB;       // beq: ALU performs subtraction (comparison)
            2'b10: begin                 // R-type instructions (funct field determines operation)
                case(funct)
                    6'b100000: ALUControl = ADD;    // ADD
                    6'b100010: ALUControl = SUB;    // SUB
                    6'b100100: ALUControl = AND;    // AND
                    6'b100101: ALUControl = OR;     // OR
                    6'b101010: ALUControl = SLT;    // SLT (Set Less Than)
                    default: ALUControl = ADD;      // Default to ADD
                endcase
            end
            default: ALUControl = ADD;     // Default operation (shouldn't happen)
        endcase
    end
endmodule


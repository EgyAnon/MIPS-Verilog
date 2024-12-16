module Program_Counter(
    input wire        clk,
    input wire [31:0] next_instruction,   // Address of the next instruction
    output reg [31:0] current_instruction // Address of the current instruction
);

    always @(posedge clk) begin
            current_instruction <= next_instruction;
    end   
endmodule


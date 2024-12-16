module Instruction_Memory(
    input wire [11:0] read_address,  // 4KB instruction memory
    output reg [31:0] instruction  // 32-bit instruction
);

    reg [7:0] IM [0:4095];  // 4KB memory, each location is 1 byte

    always @* begin
        instruction = {IM[read_address], IM[read_address+1], IM[read_address+2], IM[read_address+3]};
    end
endmodule


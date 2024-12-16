module Data_Memory(
    input wire        clk,
    input wire [31:0] address,
    input wire [31:0] write_data,
    output reg [31:0] read_data,
    input wire        CTRL_MemWrite,
    input wire        CTRL_MemRead
);

    reg [7:0] dmem [0:16383];  // 16KB memory, byte-addressable

    // Combinational Read
    always @* begin
        if (CTRL_MemRead) begin
            read_data = {dmem[address], dmem[address + 1], dmem[address + 2], dmem[address + 3]};
        end else begin
            read_data = 32'b0;  // Default to zero when not reading
        end
    end

    // Synchronous Write
    always @(posedge clk) begin
        if (CTRL_MemWrite) begin
            dmem[address]     <= write_data[31:24];
            dmem[address + 1] <= write_data[23:16];
            dmem[address + 2] <= write_data[15:8];
            dmem[address + 3] <= write_data[7:0];
        end
    end
endmodule


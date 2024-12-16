module Register_File(
read_address1,
read_address2,
write_address,
write_data,
read_data1,
read_data2,
CTRL_RegWrite,
clk
);
input wire[4:0] read_address1;
input wire[4:0] read_address2;
input wire[31:0] write_data;
input wire[4:0] write_address;
input wire 	 CTRL_RegWrite;
input wire 	 clk;
output reg[31:0] read_data1;
output reg[31:0] read_data2;


//internals
reg [31:0] RF [31:0]; // 32 registers, each 32 bits wide
always @ (*) begin
	read_data1 = RF[read_address1];
	read_data2 = RF[read_address2];
end


always @(posedge clk) begin
    if (CTRL_RegWrite) 
        RF[write_address] <= write_data;
end
endmodule
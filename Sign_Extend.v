module Sign_Extend(
    input [15:0] imm_in,      // 16-bit immediate input
    output reg [31:0] imm_out  // 32-bit extended immediate output
);

    always @(*) begin
        // If the 16-bit immediate is negative, extend with 1s; otherwise, extend with 0s
        if (imm_in[15] == 1) 
            imm_out = {16'b1111111111111111, imm_in};  // Sign-extend with 1s for negative values
        else
            imm_out = {16'b0000000000000000, imm_in};  // Sign-extend with 0s for positive values
    end

endmodule
// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c);

// a is unsigned
// b is signed

parameter bw = 4;
parameter psum_bw = 16;

output reg [psum_bw - 1 : 0] out;
input signed [bw - 1 : 0] a;
input unsigned [bw - 1 : 0] b;
input [psum_bw - 1 : 0] c;
input clk;

always @ (posedge clk) begin
    output <= a * b + c
end

endmodule

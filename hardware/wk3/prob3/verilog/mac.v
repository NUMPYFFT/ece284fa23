// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c);

// a is unsigned
// b is signed

parameter bw = 4;
parameter psum_bw = 16;

output signed [psum_bw - 1 : 0] out;
input unsigned [bw - 1 : 0] a;
input signed [bw - 1 : 0] b;
input signed [psum_bw - 1 : 0] c;
input clk;

wire signed [2 * bw - 1 : 0] product;
assign product = $signed({1'b0, a}) * b;
assign out = product + c;

endmodule
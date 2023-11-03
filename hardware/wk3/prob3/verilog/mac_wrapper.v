// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_wrapper (clk, out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out;
input  [bw-1:0] a;
input  [bw-1:0] b;
input  [psum_bw-1:0] c;
input  clk;

reg    [bw-1:0] a_q;
reg    [bw-1:0] b_q;
reg    [psum_bw-1:0] c_q;

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance (
        .a(a_q), 
        .b(b_q),
        .c(c_q),
	.out(out)
); 

always @ (posedge clk) begin
        b_q  <= b;
        a_q  <= a;
        c_q  <= c;
end

endmodule

module mac_array (
    input clk,
    input [3:0][3:0] x,  // Four 4-bit numbers x0 to x3
    input [3:0][3:0] w,  // Four 4-bit numbers w0 to w3
    input signed [15:0] psum_in,
    output signed [15:0] psum_out
);

    wire [15:0] product0, product1, product2, product3;
    wire [15:0] sum0, sum1;

    mac_wrapper #(.bw(4), .psum_bw(16)) u1 (
        .clk(clk),
        .a(x[0]),
        .b(w[0]),
        .c(16'd0),
        .out(product0)
    );

    mac_wrapper #(.bw(4), .psum_bw(16)) u2 (
        .clk(clk),
        .a(x[1]),
        .b(w[1]),
        .c(16'd0),
        .out(product1)
    );

    mac_wrapper #(.bw(4), .psum_bw(16)) u3 (
        .clk(clk),
        .a(x[2]),
        .b(w[2]),
        .c(16'd0),
        .out(product2)
    );

    mac_wrapper #(.bw(4), .psum_bw(16)) u4 (
        .clk(clk),
        .a(x[3]),
        .b(w[3]),
        .c(16'd0),
        .out(product3)
    );

    assign sum0 = product0 + product1;
    assign sum1 = product2 + product3;
    assign psum_out = sum0 + sum1 + psum_in;

endmodule

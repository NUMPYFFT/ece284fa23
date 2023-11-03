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

module mac_array (
    input clk,
    input [3:0][3:0] x,  // Four 4-bit numbers x0 to x3
    input [3:0][3:0] w,  // Four 4-bit numbers w0 to w3
    input signed [15:0] psum_in,
    output signed [15:0] psum_out
);

    wire signed [7:0] product0, product1, product2, product3;
    wire signed [15:0] sum0, sum1;

    mac u1 (
        .a(x[0]),
        .b(w[0]),
        .c(16'd0),
        .clk(clk),
        .out(product0)
    );

    mac u2 (
        .a(x[1]),
        .b(w[1]),
        .c(16'd0),
        .clk(clk),
        .out(product1)
    );

    mac u3 (
        .a(x[2]),
        .b(w[2]),
        .c(16'd0),
        .clk(clk),
        .out(product2)
    );

    mac u4 (
        .a(x[3]),
        .b(w[3]),
        .c(16'd0),
        .clk(clk),
        .out(product3)
    );

    assign sum0 = product0 + product1;
    assign sum1 = product2 + product3;
    assign psum_out = sum0 + sum1 + psum_in;

endmodule

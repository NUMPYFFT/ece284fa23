// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_tile (clk, out_s, in_w, out_e, in_n, inst_w, inst_e, reset);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out_s;
input  [bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
output [bw-1:0] out_e; 
input  [1:0] inst_w;
output [1:0] inst_e;
input  [psum_bw-1:0] in_n;
input  clk;
input  reset;

reg [1:0] inst_q;
reg [bw-1:0] a_q; // activation
reg [bw-1:0] b_q; // weight
reg [psum_bw-1:0] c_q; // psum
reg load_ready_q;
wire [psum_bw-1:0] mac_out;

assign out_e = a_q;
assign inst_e = inst_q;
assign mac_out = out_s;

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance (
        .a(a_q), 
        .b(b_q),
        .c(c_q),
	.out(mac_out)
); 

always @ (posedge clk) begin
        if (reset) begin
                inst_q <= 0;
                load_ready_q <= 1;
        end

        else begin
                inst_q[1] <= inst_w[1];
                if (inst_w[0] || inst_w[1]) begin // accept activations
                        a_q <= in_w;
                end

                if (inst_w[0] && load_ready_q) begin // accept weights
                        b_q <= in_w;
                        load_ready_q <= 0;
                end

                if (!load_ready_q) begin
                        inst_q <= inst_w[0];
                end
        end
end

endmodule
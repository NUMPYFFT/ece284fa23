// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module sfp (out, in, thres, acc, relu, clk, reset);

parameter bw = 4;
parameter psum_bw = 16;

input clk;
input acc;
input relu;
input reset;

input signed [bw-1:0] in;
input signed [psum_bw-1:0] thres;

output  signed [psum_bw-1:0] out;

reg  signed [psum_bw-1:0] psum_q;

// Your code goes here
// Input: 8-bit, output: 16-bit
// Control bits: acc, relu, reset
// psum_q: register to store partial sum
// If reset, the internal latch “psum_q” becomes zero (reset is synchronous).
// If acc == 1, psum_q will be updated with “psum_q + In” in the next rising edge
// If relu == 1 and psum_q is smaller than “thres”, psum_q will be updated to be zero in the next
// rising edge
// out port is just connected to the psum_q.
// Please only edit the portion of the code that you are asked to.
// Sample vcd file is attached in git.
// sfp_tb.v file is also attached. Once you run sfp_tb.v file with your completed sfp.v file, the output waveform should be identical to the sample vcd file.

always @ (posedge clk) begin
    if (reset) begin
        psum_q <= 0;
    end
    else begin
        if (acc) begin
            psum_q <= psum_q + in;
        end
        else if (relu && psum_q < thres) begin
            psum_q <= 0;
        end
    end
end 
assign out = psum_q;

endmodule

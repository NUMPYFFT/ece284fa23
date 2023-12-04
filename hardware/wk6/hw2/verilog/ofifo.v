// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 

module ofifo (
    input  clk,
    input  [col-1:0] wr,
    input  rd,
    input  reset,
    input  [col*bw-1:0] in,
    output [col*bw-1:0] out,
    output o_full,
    output o_ready,
    output o_valid
);

    parameter col = 8;
    parameter bw = 4;

    wire [col-1:0] empty;
    wire [col-1:0] full;
    reg rd_en;
    genvar i;

    // Status assignments
    assign o_ready = !full[0] && !full[1] && !full[2] && !full[3] && 
                     !full[4] && !full[5] && !full[6] && !full[7]; // Not ready if any column is full
    assign o_full = (|full) ? 1'b1 : 1'b0; // Full if any column is full
    assign o_valid = (|empty) ? 1'b0 : 1'b1; // Valid if no column is empty

    // Instantiate FIFOs
    for (i = 0; i < col; i = i + 1) begin : col_num
        fifo_depth64 #(.bw(bw)) fifo_instance (
            .rd_clk(clk),
            .wr_clk(clk),
            .rd(rd_en),
            .wr(wr[i]),
            .o_empty(empty[i]),
            .o_full(full[i]),
            .in(in[bw*(i+1)-1 : bw*i]),
            .out(out[bw*(i+1)-1 : bw*i]),
            .reset(reset)
        );
    end

    // Read enable logic
    always @(posedge clk) begin
        if (reset) begin
            rd_en <= 0;
        end else begin
            rd_en <= rd;
        end
    end

endmodule

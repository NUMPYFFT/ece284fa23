// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 

// - o_ready signal outputs to inform that there is at least a room to receive a new vector
// - o_full signal is enabled if any of the slots are full
// - o_empty port from FIFO is not needed to use.
// - Create two different versions:
//   1. Version 1: Read all rows at a time.
//      a. Verify your read values are correct.
//      b. Verify your full and empty signals are working fine.
//   2. Version 2: Read 1 row at a time.
//      a. When rd = 1, row0 enabled, then row1, then row2, ...
//      b. When rd = 0, row0 disabled, then row1, then row2, ...

module l0 (
    input clk,
    input wr,
    input rd,
    input reset,
    input [row*bw-1:0] in,
    output [row*bw-1:0] out,
    output o_full,
    output o_ready
);

    parameter row = 8;
    parameter bw = 4;

    wire [row-1:0] empty;
    wire [row-1:0] full;
    reg [row-1:0] rd_en;
  
    genvar i;

    // Status signals
    // assign o_ready = (|empty) ? 1'b1 : 1'b0;
    assign o_ready = !full[0] && !full[1] && !full[2] && !full[3] && 
                     !full[4] && !full[5] && !full[6] && !full[7];
    assign o_full = (|full) ? 1'b1 : 1'b0;

    // Instantiate FIFOs
    for (i = 0; i < row; i = i + 1) begin : row_num
        fifo_depth64 #(.bw(bw)) fifo_instance (
            .rd_clk(clk),
            .wr_clk(clk),
            .rd(rd_en[i]),
            .wr(wr),
            .o_empty(empty[i]),
            .o_full(full[i]),
            .in(in[bw*(i+1)-1:bw*i]),
            .out(out[bw*(i+1)-1:bw*i]),
            .reset(reset)
        );
    end

    // Read enable logic
    always @(posedge clk) begin
        if (reset) begin
            rd_en <= 8'b00000000;
        end else begin
            // Version 1: Read all rows at a time
            if (o_ready) begin
                rd_en <= 8'b11111111;
            end else begin
                rd_en <= 8'b00000000;
            end

            // Version 2: Read 1 row at a time
            if (o_ready) begin
                if (rd_en[0] == 1'b1) begin
                    rd_en <= 8'b00000001;
                end else if (rd_en[1] == 1'b1) begin
                    rd_en <= 8'b00000010;
                end else if (rd_en[2] == 1'b1) begin
                    rd_en <= 8'b00000100;
                end else if (rd_en[3] == 1'b1) begin
                    rd_en <= 8'b00001000;
                end else if (rd_en[4] == 1'b1) begin
                    rd_en <= 8'b00010000;
                end else if (rd_en[5] == 1'b1) begin
                    rd_en <= 8'b00100000;
                end else if (rd_en[6] == 1'b1) begin
                    rd_en <= 8'b01000000;
                end else if (rd_en[7] == 1'b1) begin
                    rd_en <= 8'b10000000;
                end
            end
        end
    end

endmodule

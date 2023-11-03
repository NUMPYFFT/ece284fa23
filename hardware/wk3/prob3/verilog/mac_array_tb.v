// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 

module mac_array_tb;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

reg  [3:0][bw-1:0] x;  // Four 4-bit numbers x0 to x3
reg  [3:0][bw-1:0] w;  // Four 4-bit numbers w0 to w3
reg  [psum_bw-1:0] psum_in;
wire [psum_bw-1:0] psum_out;

integer w_file ; // file handler
integer w_scan_file ; // file handler

integer x_file ; // file handler
integer x_scan_file ; // file handler

integer x_dec[3:0];
integer w_dec[3:0];
integer i; 
integer u; 

function [3:0] w_bin ;
  input integer  weight ;
  begin

    if (weight>-1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end

    if (weight>3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end
    else 
     w_bin[2] = 0;

    if (weight>1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end
    else 
     w_bin[1] = 0;

    if (weight>0) 
     w_bin[0] = 1;
    else 
     w_bin[0] = 0;

  end
endfunction


/// unsigned
function [3:0] x_bin;
  input integer activation;
  begin
    if (activation > 7) begin
      x_bin[3] = 1;
      activation = activation - 8;
    end
    else
      x_bin[3] = 0;
    
    if (activation > 3) begin
      x_bin[2] = 1;
      activation = activation - 4;
    end
    else
      x_bin[2] = 0;

    if (activation > 1) begin
      x_bin[1] = 1;
      activation = activation - 2;
    end
    else
      x_bin[1] = 0;

    if (activation > 0) begin
      x_bin[0] = 1;
      activation = activation - 1;
    end
    else
      x_bin[0] = 0;
  end
endfunction


// Below function is for verification
function [psum_bw-1:0] mac_predicted;
  input unsigned [bw-1:0] a;
  input signed [bw-1:0] b;
  input signed [psum_bw-1:0] c;
  reg signed [2*bw-1:0] product;
  reg signed [psum_bw-1:0] psum;

  begin
    product = {{bw{1'b0}}, a} * {{bw{b[bw-1]}}, b};
    mac_predicted = product + c;
  end
endfunction

mac_array mac_array_instance (
    .clk(clk),
    .x(x),
    .w(w),
    .psum_in(psum_in),
    .psum_out(psum_out)
);

initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data, signed
  x_file = $fopen("a_data.txt", "r");  //activation, unsigned

  $dumpfile("mac_array_tb.vcd");
  $dumpvars(0,mac_array_tb);
 
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  $display("-------------------- Computation start --------------------");
  
  psum_in = 0;
  for (i=0; i<10; i=i+1) begin  // Data length is 10 in the data files
     #1 clk = 1'b1;
     #1 clk = 1'b0;

     for (u=0; u<4; u=u+1) begin
        w_scan_file = $fscanf(w_file, "%d\n", w_dec[u]);
        x_scan_file = $fscanf(x_file, "%d\n", x_dec[u]);

        x[u] = x_bin(x_dec[u]); // unsigned number
        w[u] = w_bin(w_dec[u]); // signed number
     end
     psum_in = psum_out;
  end

  #1 clk = 1'b1;
  #1 clk = 1'b0;

  $display("-------------------- Computation completed --------------------");

  #10 $finish;
end

endmodule

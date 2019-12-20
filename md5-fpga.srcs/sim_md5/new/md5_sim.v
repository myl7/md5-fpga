`timescale 1ns / 1ps

module md5_sim();
  reg clk = 0;
  wire [3:0] in_addr, out_addr;
  reg [31:0] in_val, out_val;
  wire [31:0] a, b, c, d;

  always #10 begin
    clk <= ~clk;
  end

  md5 md5_test(.in_addr(in_addr), .in_val(in_val), .out_addr(out_addr), .out_val(out_val),
               .a(a), .b(b), .c(c), .d(d), .clk(clk));

  initial begin
    out_val = 1;
    in_val = 32'h11111111;
    #1000;
    in_val = 32'h12345678;
    #1000;
    in_val = 32'h00000000;
    #1000;
    $finish;
  end
endmodule

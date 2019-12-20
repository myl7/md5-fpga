`timescale 1ns / 1ps

module md5(
  input clk,
  input [6:0] comp_step,
  output reg [3:0] in_addr = 0,
  input [31:0] in_val,
  input [127:0] out_buf,
  output reg [31:0] a, b, c, d);

  function [31:0] f;
    input [31:0] a, b, c, d, m, t;
    input [5:0] s;
    f = b + ((a + (b & c) | (~b & d) + m + t) << s);
  endfunction

  function [31:0] g;
    input [31:0] a, b, c, d, m, t;
    input [5:0] s;
    g = b + ((a + (b & d) | (c & ~d) + m + t) << s);
  endfunction

  function [31:0] h;
    input [31:0] a, b, c, d, m, t;
    input [5:0] s;
    h = b + ((a + b ^ c ^ d + m + t) << s);
  endfunction

  function [31:0] i;
    input [31:0] a, b, c, d, m, t;
    input [5:0] s;
    i = b + ((a + c ^ (b | ~d) + m + t) << s);
  endfunction

  always @(posedge clk) begin
    case (comp_step)
      0: begin
        a <= f(out_buf[31:0], out_buf[63:32], out_buf[95:64], out_buf[127:96], in_val, 7, 32'hd76aa478);
        b <= out_buf[63:32];
        c <= out_buf[95:64];
        d <= out_buf[127:96];
        in_addr <= 1;
      end
      1: begin
        d <= f(d, a, b, c, in_val, 12, 32'he8c7b756);
        in_addr <= 2;
      end
      2: begin
        c <= f(c, d, a, b, in_val, 17, 32'h242070db);
        in_addr <= 3;
      end
      3: begin
        b <= f(b, c, d, a, in_val, 22, 32'hc1bdceee);
        in_addr <= 4;
      end
      4: begin
        a <= f(a, b, c, d, in_val, 7, 32'hf57c0faf);
        in_addr <= 5;
      end
      5: begin
        d <= f(d, a, b, c, in_val, 12, 32'h4787c62a);
        in_addr <= 6;
      end
      6: begin
        c <= f(c, d, a, b, in_val, 17, 32'ha8304613);
        in_addr <= 7;
      end
      7: begin
        b <= f(b, c, d, a, in_val, 22, 32'hfd469501);
        in_addr <= 8;
      end
      8: begin
        a <= f(a, b, c, d, in_val, 7, 32'h698098d8);
        in_addr <= 9;
      end
      9: begin
        d <= f(d, a, b, c, in_val, 12, 32'h8b44f7af);
        in_addr <= 10;
      end
      10: begin
        c <= f(c, d, a, b, in_val, 17, 32'hffff5bb1);
        in_addr <= 11;
      end
      11: begin
        b <= f(b, c, d, a, in_val, 22, 32'h895cd7be);
        in_addr <= 12;
      end
      12: begin
        a <= f(a, b, c, d, in_val, 7, 32'h6b901122);
        in_addr <= 13;
      end
      13: begin
        d <= f(d, a, b, c, in_val, 12, 32'hfd987193);
        in_addr <= 14;
      end
      14: begin
        c <= f(c, d, a, b, in_val, 17, 32'ha679438e);
        in_addr <= 15;
      end
      15: begin
        b <= f(b, c, d, a, in_val, 22, 32'h49b40821);
        in_addr <= 1;
      end
      16: begin
        a <= g(a, b, c, d, in_val ,5, 32'hf61e2562);
        in_addr <= 6;
      end
      17: begin
        d <= g(d, a, b, c, in_val, 9, 32'hc040b340);
        in_addr <= 11;
      end
      18: begin
        c <= g(c, d, a, b, in_val, 14, 32'h265e5a51);
        in_addr <= 0;
      end
      19: begin
        b <= g(b, c, d, a, in_val, 20, 32'he9b6c7aa);
        in_addr <= 5;
      end
      20: begin
        a <= g(a, b, c, d, in_val, 5, 32'hd62f105d);
        in_addr <= 10;
      end
      21: begin
        d <= g(d, a, b, c, in_val, 9, 32'h02441453);
        in_addr <= 15;
      end
      22: begin
        c <= g(c, d, a, b, in_val, 14, 32'hd8a1e681);
        in_addr <= 4;
      end
      23: begin
        b <= g(b, c, d, a, in_val, 20, 32'he7d3fbc8);
        in_addr <= 9;
      end
      24: begin
        a <= g(a, b, c, d, in_val, 5, 32'h21e1cde6);
        in_addr <= 14;
      end
      25: begin
        d <= g(d, a, b, c, in_val, 9, 32'hc33707d6);
        in_addr <= 3;
      end
      26: begin
        c <= g(c, d, a, b, in_val, 14, 32'hf4d50d87);
        in_addr <= 8;
      end
      27: begin
        b <= g(b, c, d, a, in_val, 20, 32'h455a14ed);
        in_addr <= 13;
      end
      28: begin
        a <= g(a, b, c, d, in_val, 5, 32'ha9e3e905);
        in_addr <= 2;
      end
      29: begin
        d <= g(d, a, b, c, in_val, 9, 32'hfcefa3f8);
        in_addr <= 7;
      end
      30: begin
        c <= g(c, d, a, b, in_val, 14, 32'h676f02d9);
        in_addr <= 12;
      end
      31: begin
        b <= g(b, c, d, a, in_val, 20, 32'h8d2a4c8a);
        in_addr <= 5;
      end
      32: begin
        a <= h(a, b, c, d, in_val, 4, 32'hfffa3942);
        in_addr <= 8;
      end
      33: begin
        d <= h(d, a, b, c, in_val, 11, 32'h8771f681);
        in_addr <= 11;
      end
      34: begin
        c <= h(c, d, a, b, in_val, 16, 32'h6d9d6122);
        in_addr <= 14;
      end
      35: begin
        b <= h(b, c, d, a, in_val, 23, 32'hfde5380c);
        in_addr <= 1;
      end
      36: begin
        a <= h(a, b, c, d, in_val, 4, 32'ha4beea44);
        in_addr <= 4;
      end
      37: begin
        d <= h(d, a, b, c, in_val, 11, 32'h4bdecfa9);
        in_addr <= 7;
      end
      38: begin
        c <= h(c, d, a, b, in_val, 16, 32'hf6bb4b60);
        in_addr <= 10;
      end
      39: begin
        b <= h(b, c, d, a, in_val, 23, 32'hbebfbc70);
        in_addr <= 13;
      end
      40: begin
        a <= h(a, b, c, d, in_val, 4, 32'h289b7ec6);
        in_addr <= 0;
      end
      41: begin
        d <= h(d, a, b, c, in_val, 11, 32'heaa127fa);
        in_addr <= 3;
      end
      42: begin
        c <= h(c, d, a, b, in_val, 16, 32'hd4ef3085);
        in_addr <= 6;
      end
      43: begin
        b <= h(b, c, d, a, in_val, 23, 32'h04881d05);
        in_addr <= 9;
      end
      44: begin
        a <= h(a, b, c, d, in_val, 4, 32'hd9d4d039);
        in_addr <= 12;
      end
      45: begin
        d <= h(d, a, b, c, in_val, 11, 32'he6db99e5);
        in_addr <= 15;
      end
      46: begin
        c <= h(c, d, a, b, in_val, 16, 32'h1fa27cf8);
        in_addr <= 2;
      end
      47: begin
        b <= h(b, c, d, a, in_val, 23, 32'hc4ac5665);
        in_addr <= 0;
      end
      48: begin
        a <= i(a, b, c, d, in_val, 6, 32'hf4292244);
        in_addr <= 7;
      end
      49: begin
        d <= i(d, a, b, c, in_val, 10, 32'h432aff97);
        in_addr <= 14;
      end
      50: begin
        c <= i(c, d, a, b, in_val, 15, 32'hab9423a7);
        in_addr <= 5;
      end
      51: begin
        b <= i(b, c, d, a, in_val, 21, 32'hfc93a039);
        in_addr <= 12;
      end
      52: begin
        a <= i(a, b, c, d, in_val, 6, 32'h655b59c3);
        in_addr <= 3;
      end
      53: begin
        d <= i(d, a, b, c, in_val, 10, 32'h8f0ccc92);
        in_addr <= 10;
      end
      54: begin
        c <= i(c, d, a, b, in_val, 15, 32'hffeff47d);
        in_addr <= 1;
      end
      55: begin
        b <= i(b, c, d, a, in_val, 21, 32'h85845dd1);
        in_addr <= 8;
      end
      56: begin
        a <= i(a, b, c, d, in_val, 6, 32'h6fa87e4f);
        in_addr <= 15;
      end
      57: begin
        d <= i(d, a, b, c, in_val, 10, 32'hfe2ce6e0);
        in_addr <= 6;
      end
      58: begin
        c <= i(c, d, a, b, in_val, 15, 32'ha3014314);
        in_addr <= 13;
      end
      59: begin
        b <= i(b, c, d, a, in_val, 21, 32'h4e0811a1);
        in_addr <= 4;
      end
      60: begin
        a <= i(a, b, c, d, in_val, 6, 32'hf7537e82);
        in_addr <= 11;
      end
      61: begin
        d <= i(d, a, b, c, in_val, 10, 32'hbd3af235);
        in_addr <= 2;
      end
      62: begin
        c <= i(c, d, a, b, in_val, 15, 32'h2ad7d2bb);
        in_addr <= 9;
      end
      63: begin
        b <= i(b, c, d, a, in_val, 21, 32'heb86d391);
        in_addr <= 0;
      end
      default: in_addr <= 0;
    endcase
  end
endmodule

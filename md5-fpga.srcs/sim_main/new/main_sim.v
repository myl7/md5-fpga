`timescale 1ns / 1ps

module main_sim();
  reg clk = 0;
  reg rst = 1;
  reg rx;
  wire tx;

  always #5 begin
    clk <= ~clk;
  end

  main main_test(.clk(clk), .rst(rst), .rx(rx), .tx(tx));

  integer i;

  initial begin
    #9000;
    rst = 0;
    for (i = 0; i < 128; i = i + 1) begin
      #9000;
      rx = 0;
      #9000;
      rx = 1;
      #9000;
      rx = 0;
      #9000;
      rx = 1;
      #9000;
      rx = 0;
      #9000;
      rx = 1;
      #9000;
      rx = 1;
      #9000;
      rx = 0;
      #9000;
      rx = 0;
      #9000;
      rx = 1;
    end
    #9000000;
    $finish;
  end
endmodule

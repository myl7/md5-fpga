`timescale 1ns / 1ps

module out_uart_sim();
  reg clk = 0;

  wire tx;
  wire tx_rd;
  reg [7:0] tx_data;
  reg tx_ready = 0;

  always #5 begin
    clk <= ~clk;
  end

  out_uart out_uart_test(.clk(clk), .tx_ready(tx_ready), .tx_data(tx_data), .tx(tx), .tx_rd(tx_rd));

  initial begin
    #10000;
    tx_data = 8'ha7;
    #10000;
    tx_ready = 1;
    #100
    tx_ready = 0;
    #100000;
    $finish;
  end
endmodule

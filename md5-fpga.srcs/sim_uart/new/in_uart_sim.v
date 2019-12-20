`timescale 1ns / 1ps

module in_uart_sim();
  reg clk = 0;

  always #5 begin
    clk <= ~clk;
  end

  reg rx = 1;
  wire rx_vld;
  wire [7:0] rx_data;
  wire on_rx;

  in_uart in_uart_test(.clk(clk), .rx(rx), .rx_vld(rx_vld), .rx_data(rx_data), .on_rx(on_rx));

  initial begin
    #10000;
    rx = 0;
    #8800;
    rx = 1;
    #8800;
    rx = 0;
    #8800;
    rx = 1;
    #8800;
    rx = 0;
    #8800;
    rx = 1;
    #8800;
    rx = 1;
    #8800;
    rx = 0;
    #8800;
    rx = 0;
    #8800;
    rx = 1;
    #8800;
    rx = 1;
    #10000;
    $finish;
  end
endmodule

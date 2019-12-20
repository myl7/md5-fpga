`timescale 1ns / 1ps

module in_uart(
  input clk, rst,
  input rx,
  output reg rx_vld,
  output reg [7:0] rx_data,
  output on_rx);

  parameter DIV_C = 867;
  parameter HDIV_C = 433;
  parameter RX_C = 8;

  parameter S_IDLE = 0;
  parameter S_RX = 1;
  reg curr_s = S_IDLE;
  reg next_s;

  assign on_rx = curr_s;

  reg [9:0] div_c = 0;
  reg [3:0] rx_c = 0;

  wire rx_pulse;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      curr_s <= S_IDLE;
    end else begin
      curr_s <= next_s;
    end
  end

  always @(*) begin
    case (curr_s)
      S_IDLE: begin
        if (div_c == HDIV_C) begin
          next_s <= S_RX;
        end else begin
          next_s <= S_IDLE;
        end
      end
      S_RX: begin
        if ((div_c == DIV_C) && (rx_c >= RX_C)) begin
          next_s <= S_IDLE;
        end else begin
          next_s <= S_RX;
        end
      end
    endcase
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      div_c <= 0;
    end else if (curr_s == S_IDLE) begin
      if (rx == 1) begin
        div_c <= 0;
      end else if (div_c < HDIV_C) begin
        div_c <= div_c + 1;
      end else begin
        div_c <= 0;
      end
    end else if (curr_s == S_RX) begin
      if (rx_c >= DIV_C) begin
        div_c <= 0;
      end else begin
        div_c <= div_c + 1;
      end
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      rx_c <= 0;
    end else if (curr_s == S_IDLE) begin
      rx_c <= 0;
    end else if ((div_c == DIV_C) && (rx_c < 4'hf)) begin
      rx_c <= rx_c + 1;
    end
  end

  assign rx_pulse = (curr_s == S_RX) && (div_c == DIV_C);

  always @(posedge clk) begin
    if (rx_pulse) begin
      case (rx_c)
        0: rx_data[0] <= rx;
        1: rx_data[1] <= rx;
        2: rx_data[2] <= rx;
        3: rx_data[3] <= rx;
        4: rx_data[4] <= rx;
        5: rx_data[5] <= rx;
        6: rx_data[6] <= rx;
        7: rx_data[7] <= rx;
      endcase
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      rx_vld <= 0;
      rx_data <= 8'h55;
    end else if ((curr_s == S_RX) && (next_s == S_IDLE)) begin
      rx_vld <= 1;
    end else begin
      rx_vld <= 0;
    end
  end
endmodule

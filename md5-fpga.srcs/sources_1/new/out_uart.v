`timescale 1ns / 1ps

module out_uart(
  input clk, rst,
  input tx_ready,
  input [7:0] tx_data,
  output reg tx,
  output reg tx_rd,
  output on_tx);

  parameter DIV_C = 867;
  parameter HDIV_C = 433;
  parameter TX_C = 9;

  parameter S_IDLE = 0;
  parameter S_TX = 1;
  reg curr_s = S_IDLE;
  reg next_s;

  assign on_tx = curr_s;

  reg [9:0] div_c;
  reg [4:0] tx_c;
  reg [7:0] tx_data_tmp;

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
        if (tx_ready) begin
          next_s <= S_TX;
        end else begin
          next_s <= S_IDLE;
        end
      end
      S_TX: begin
        if ((div_c == DIV_C) && (tx_c >= TX_C)) begin
          next_s <= S_IDLE;
        end else begin
          next_s <= S_TX;
        end
      end
    endcase
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      div_c <= 0;
    end else if (curr_s == S_TX) begin
      if (div_c >= DIV_C) begin
        div_c <= 0;
      end else begin
        div_c <= div_c + 1;
      end
    end else begin
      div_c <= 0;
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      tx_c <= 0;
    end else if (curr_s == S_TX) begin
      if (div_c == DIV_C) begin
        tx_c <= tx_c + 1;
      end
    end else begin
      tx_c <= 0;
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      tx_rd <= 0;
    end else if((curr_s == S_IDLE) && (tx_ready == 1)) begin
      tx_rd <= 1;
    end else begin
      tx_rd <= 0;
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      tx_data_tmp <= 0;
    end else if ((curr_s == S_IDLE) && (tx_ready == 1)) begin
      tx_data_tmp <= tx_data;
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      tx <= 1;
    end else if (curr_s == S_IDLE) begin
      tx <= 1;
    end else if (div_c == 0) begin
      case (tx_c)
        0: tx <= 0;
        1: tx <= tx_data_tmp[0];
        2: tx <= tx_data_tmp[1];
        3: tx <= tx_data_tmp[2];
        4: tx <= tx_data_tmp[3];
        5: tx <= tx_data_tmp[4];
        6: tx <= tx_data_tmp[5];
        7: tx <= tx_data_tmp[6];
        8: tx <= tx_data_tmp[7];
        9: tx <= 1;
      endcase
    end
  end
endmodule

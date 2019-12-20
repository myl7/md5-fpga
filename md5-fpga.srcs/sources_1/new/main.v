`timescale 1ns / 1ps

module main(
  input clk,
  input rst,
  input rx,
  output tx);

  wire tx_rd;

  wire [3:0] in_addr;
  reg [3:0] out_addr;
  wire [31:0] in_val, out_val;
  reg [3:0] in_addr_w, out_addr_w;
  reg [31:0] in_val_w, out_val_w;
  wire [31:0] a, b, c, d;
  reg w_on = 0;
  reg [31:0] out_buf[3:0];
  wire [127:0] out_buf_block;

  reg [6:0] comp_step = -1;

  in_buf in_buf(.addrb(in_addr), .doutb(in_val), .wea(w_on), .clka(clk), .clkb(clk), .addra(in_addr_w), .dina(in_val_w));
  md5 md5(.clk(clk), .in_addr(in_addr), .in_val(in_val), .a(a), .b(b), .c(c), .d(d),
          .out_buf({out_buf[0], out_buf[1], out_buf[2], out_buf[3]}), .comp_step(comp_step));

  wire [7:0] rx_data;
  wire rx_vld;
  reg [7:0] tx_data;
  reg tx_ready;
  wire on_tx;

  in_uart in_uart(.clk(clk), .rst(rst), .rx_data(rx_data), .rx_vld(rx_vld), .rx(rx));
  out_uart out_uart(.clk(clk), .rst(rst), .tx_data(tx_data), .tx_ready(tx_ready),
                    .tx(tx), .on_tx(on_tx), .tx_rd(tx_rd));

  parameter S_IN = 0;
  parameter S_COMP = 1;
  parameter S_ADD = 3;
  parameter S_OUT = 2;
  reg [1:0] curr_s = S_IN;
  reg [1:0] next_s;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      curr_s <= S_IN;
    end else begin
      curr_s <= next_s;
    end
  end

  always @(*) begin
    case (curr_s)
      S_IN: begin
        if (in_step < 16) begin
          next_s <= S_IN;
        end else begin
          next_s <= S_COMP;
        end
      end
      S_COMP: begin
        if (comp_step == 64) begin
          next_s <= S_ADD;
        end else begin
          next_s <= S_COMP;
        end
      end
      S_ADD: next_s <= S_OUT;
      S_OUT: begin
        if (out_ok) begin
          next_s <= S_IN;
        end else begin
          next_s <= S_OUT;
        end
      end
    endcase
  end

  reg [4:0] in_step = 0;
  reg [7:0] in_block_buf[3:0];
  reg [1:0] in_block_c = 0;

  always @(posedge clk) begin
    if (curr_s == S_IN) begin
      w_on <= 1;
      if (rx_vld == 1) begin
        in_block_buf[in_block_c] <= rx_data;
        in_block_c <= in_block_c + 1;
        if (in_block_c == 4 - 1) begin
          in_addr_w <= in_step;
          in_val_w <= {in_block_buf[0], in_block_buf[1], in_block_buf[2], rx_data};
          in_step <= in_step + 1;
        end
      end
    end else begin
      w_on <= 0;
      in_step <= 0;
    end
  end

  always @(posedge clk) begin
    if (curr_s == S_COMP) begin
      comp_step <= comp_step + 1;
    end else begin
      comp_step <= -1;
    end
  end

  reg out_ok;
  wire [7:0] tmp[15:0];

  assign {tmp[0], tmp[1], tmp[2], tmp[3]} = out_buf[0];
  assign {tmp[4], tmp[5], tmp[6], tmp[7]} = out_buf[1];
  assign {tmp[8], tmp[9], tmp[10], tmp[11]} = out_buf[2];
  assign {tmp[12], tmp[13], tmp[14], tmp[15]} = out_buf[3];

  reg [4:0] out_step = 0;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      out_buf[0] <= 32'h67452301;
      out_buf[1] <= 32'hefcdab89;
      out_buf[2] <= 32'h98badcfe;
      out_buf[3] <= 32'h10325476;
    end else if (curr_s == S_ADD) begin
      out_buf[0] <= out_buf[0] + a;
      out_buf[1] <= out_buf[1] + b;
      out_buf[2] <= out_buf[2] + c;
      out_buf[3] <= out_buf[3] + d;
    end
  end

  reg check_on = 1;

  always @(posedge clk) begin
    if (curr_s == S_OUT) begin
      if (!on_tx && check_on) begin
        check_on <= 0;
        tx_data <= tmp[out_step];
        tx_ready <= 1;
        out_step <= out_step + 1;
        if (out_step == 16 - 1) begin
          out_ok <= 1;
        end
      end else begin
        tx_ready <= 0;
        if (!check_on) begin
          check_on <= 1;
        end
      end
    end else begin
      out_ok <= 0;
      check_on = 1;
      out_step <= 0;
    end
  end
endmodule

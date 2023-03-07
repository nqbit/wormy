module user_input(
  input clk,

  input wire [3:0] buttons,

  output reg       button_pushed,
  output reg [1:0] button_state
);

reg [3:0] buttons_r1, buttons_sync;

always @(posedge clk) begin
  buttons_r1 <= buttons;
  buttons_sync <= buttons_r1;
end

always @(posedge clk) begin
  case (buttons_sync)
    4'b1000: begin
      button_state <= 2'b00;
      button_pushed <= 1'b1;
    end
    4'b0100: begin
      button_state <= 2'b01;
      button_pushed <= 1'b1;
    end
    4'b0010: begin
      button_state <= 2'b10;
      button_pushed <= 1'b1;
    end
    4'b0001: begin
      button_state <= 2'b11;
      button_pushed <= 1'b1;
    end
    default: begin
      button_state <= 2'b00;
      button_pushed <= 1'b0;
    end
  endcase
end

endmodule
module multiplexer(
  input clk,
  input rst,

  input wire [15:0] arena_on,

  output reg [3:0] A,
  output reg [3:0] B
);

reg [3:0] location;

always @(posedge clk) begin
  if (rst) begin
    location <= '0;
  end else begin
    location <= location + 1;
  end
end

// Set up port A
always @(posedge clk) begin
  case (location[3:2])
    2'b00: A <= 4'b1000;
    2'b01: A <= 4'b0100;
    2'b10: A <= 4'b0010;
    2'b11: A <= 4'b0001;
  endcase
end

// Set up port B
always @(posedge clk) begin
  if (arena_on[location]) begin
    case (location[1:0])
      2'b00: B <= 4'b0111;
      2'b01: B <= 4'b1011;
      2'b10: B <= 4'b1101;
      2'b11: B <= 4'b1110;
    endcase
  end else begin
    B <= 4'b1111;
  end
end


endmodule
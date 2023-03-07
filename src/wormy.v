module wormy (
  input logic clk,
  input logic rst,

  // User movement input
  //
  // 0b00 - Up
  // 0b01 - Right
  // 0b10 - Down
  // 0b11 - Left
  input logic       button_pushed,
  input logic [1:0] button_state,

  output reg [15:0] arena_on
);

localparam int UpdateRate = 300;
localparam int NumCells = 16;

logic update;
logic [8:0] counter;

// Repeatedly counts from 0 to UpdateRate and pulses update when we reach UpdateRate
always @(posedge clk) begin
  if (rst) begin
    counter <= '0;
    update <= 1'b0;
  end else begin
    if (counter == UpdateRate - 1) begin
      counter <= '0;
      update <= 1'b1;
    end else begin
      counter <= counter + 1;
      update <= 1'b0;
    end
  end
end

reg [1:0] head_x, head_x_new;
reg [1:0] head_y, head_y_new;
reg [1:0] tail_x, tail_x_new;
reg [1:0] tail_y, tail_y_new;
reg [NumCells-1:0] arena_dir0;
reg [NumCells-1:0] arena_dir1;
wire [3:0] head_idx, tail_idx, head_idx_new, tail_idx_new;

assign head_idx = {head_y, head_x};
assign tail_idx = {tail_y, tail_x};
assign head_idx_new = {head_y_new, head_x_new};
assign tail_idx_new = {tail_y_new, tail_x_new};

// logic collision;
reg growing;
reg collision;

always @(*) begin
  head_y_new = head_y;
  head_x_new = head_x;

  case ({arena_dir1[head_idx], arena_dir0[head_idx]})
    2'b00: head_y_new = head_y - 1;
    2'b01: head_x_new = head_x + 1;
    2'b10: head_y_new = head_y + 1;
    2'b11: head_x_new = head_x - 1;
  endcase
end

always @(*) begin
  tail_y_new = tail_y;
  tail_x_new = tail_x;

  if (!growing) begin
    case ({arena_dir1[tail_idx], arena_dir0[tail_idx]})
      2'b00: tail_y_new = tail_y - 1;
      2'b01: tail_x_new = tail_x + 1;
      2'b10: tail_y_new = tail_y + 1;
      2'b11: tail_x_new = tail_x - 1;
    endcase
  end
end

// 0001
// 0000
// 0000
// 0000

// 0000
// 0000
// 0000
// 0001

logic [2:0] count;

always @(posedge clk) begin
  if (rst) begin
    growing <= 1'b0;
  end else begin
    if (update) begin
      // growing <= ~growing;
    end
    //   if (count == '0) begin
    //     growing <= 1'b0;
    //   end else begin
    //     count <= count - 1;
    //   end
    //   // growing <= ~growing;
    // end
  end
end

always @(posedge clk) begin
  if (rst || collision) begin
    head_x <= '0;
    head_y <= '0;
    tail_x <= '0;
    tail_y <= 2'b01;

    arena_dir0 <= '0;
    arena_dir1 <= '0;
    arena_on <= {
      4'b0000,
      4'b0000,
      4'b0001,
      4'b0001
    };

    collision <= 1'b0;
  end else begin
    if (update) begin
      head_x <= head_x_new;
      head_y <= head_y_new;
      tail_x <= tail_x_new;
      tail_y <= tail_y_new;

      // Update head index
      arena_dir0[head_idx_new] <= arena_dir0[head_idx];
      arena_dir1[head_idx_new] <= arena_dir1[head_idx];
      arena_on[head_idx_new] <= arena_on[head_idx];

      // Collisions
      if (head_idx_new != tail_idx || growing) begin
        collision <= arena_on[head_idx_new];
      end

      // Maybe Turn Off
      if (head_idx_new != tail_idx && !growing) begin
        arena_on[tail_idx] <= 1'b0; 
      end
    end else if (button_pushed) begin
      arena_dir0[head_idx] <= button_state[0]; 
      arena_dir1[head_idx] <= button_state[1]; 
    end
  end
end

endmodule
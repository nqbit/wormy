`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb (
    // testbench is controlled by test.py
    input clk,
    input rst,
    
    input [3:0] buttons,

    output [3:0] A,
    output [3:0] B
);

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    wire [7:0] inputs = {2'b0, buttons, rst, clk};
    wire [7:0] outputs;
    assign A = outputs[3:0];
    assign B = outputs[7:4];

    wormy_top wormy_top (
        `ifdef GL_TEST
            .vccd1( 1'b1),
            .vssd1( 1'b0),
        `endif
        .io_in  (inputs),
        .io_out (outputs)        
    );

endmodule

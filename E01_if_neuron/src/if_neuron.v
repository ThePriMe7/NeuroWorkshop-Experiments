`timescale 1ns/1ps
// N1: Integrate-and-Fire (Lapicque 1907)
//   C dV/dt = I            ;  V >= Vth -> spike, V <- Vreset
// Fixed point Q8 (value*256). One Euler step per en pulse.
module if_neuron #(
    parameter integer VTH    = 20*256,   // threshold (20 mV)
    parameter integer VRESET = 0
)(
    input  wire               clk, rst, en,
    input  wire signed [31:0] i_in,      // input current (mV/step, Q8)
    output reg  signed [31:0] v,
    output reg                spike
);
    wire signed [31:0] v_next = v + i_in;
    always @(posedge clk) begin
        if (rst) begin v <= VRESET; spike <= 1'b0; end
        else if (en) begin
            if (v_next >= VTH) begin v <= VRESET; spike <= 1'b1; end
            else               begin v <= v_next; spike <= 1'b0; end
        end else spike <= 1'b0;
    end
endmodule

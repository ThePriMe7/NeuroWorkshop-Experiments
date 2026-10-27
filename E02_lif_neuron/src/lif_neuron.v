`timescale 1ns/1ps
// N2: Leaky Integrate-and-Fire with absolute refractory period
//   tau dV/dt = -(V - Vrest) + R*I
// Euler with dt/tau = 2^-TAU_SHIFT :  V += (R*I - (V - Vrest)) >>> TAU_SHIFT
module lif_neuron #(
    parameter integer VTH       = 20*256,
    parameter integer VREST     = 0,
    parameter integer VRESET    = 0,
    parameter integer TAU_SHIFT = 4,      // tau = 16 steps
    parameter integer T_REF     = 5       // refractory steps
)(
    input  wire               clk, rst, en,
    input  wire signed [31:0] i_in,       // R*I in mV (Q8)
    output reg  signed [31:0] v,
    output reg                spike
);
    reg [7:0] ref_cnt;
    wire signed [31:0] dv     = (i_in - (v - VREST)) >>> TAU_SHIFT;
    wire signed [31:0] v_next = v + dv;
    always @(posedge clk) begin
        if (rst) begin v <= VREST; spike <= 1'b0; ref_cnt <= 0; end
        else if (en) begin
            spike <= 1'b0;
            if (ref_cnt != 0) begin ref_cnt <= ref_cnt - 1'b1; v <= VRESET; end
            else if (v_next >= VTH) begin
                v <= VRESET; spike <= 1'b1; ref_cnt <= T_REF[7:0];
            end else v <= v_next;
        end else spike <= 1'b0;
    end
endmodule

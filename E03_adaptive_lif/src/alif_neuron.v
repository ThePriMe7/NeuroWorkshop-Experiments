`timescale 1ns/1ps
// N3: Adaptive LIF (spike-frequency adaptation), linear form of AdEx
//   (Brette & Gerstner 2005, with the exponential term dropped)
//   tau_v dV/dt = -(V - Vrest) + R*I - w
//   tau_w dw/dt = -w ;  on spike: V <- Vreset, w <- w + B
module alif_neuron #(
    parameter integer VTH     = 20*256,
    parameter integer VREST   = 0,
    parameter integer VRESET  = 0,
    parameter integer TAU_V   = 4,        // tau_v = 16 steps
    parameter integer TAU_W   = 7,        // tau_w = 128 steps
    parameter integer B       = 4*256     // adaptation jump per spike
)(
    input  wire               clk, rst, en,
    input  wire signed [31:0] i_in,
    output reg  signed [31:0] v,
    output reg  signed [31:0] w,
    output reg                spike
);
    wire signed [31:0] v_next = v + ((i_in - w - (v - VREST)) >>> TAU_V);
    wire signed [31:0] w_dec  = w - (w >>> TAU_W);
    always @(posedge clk) begin
        if (rst) begin v <= VREST; w <= 0; spike <= 1'b0; end
        else if (en) begin
            if (v_next >= VTH) begin
                v <= VRESET; w <= w_dec + B; spike <= 1'b1;
            end else begin
                v <= v_next; w <= w_dec; spike <= 1'b0;
            end
        end else spike <= 1'b0;
    end
endmodule

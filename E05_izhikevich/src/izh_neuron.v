`timescale 1ns/1ps
// N4: Izhikevich neuron (Izhikevich 2003, IEEE TNN 14(6))
//   dv/dt = 0.04 v^2 + 5 v + 140 - u + I
//   du/dt = a (b v - u)          ; v >= 30 mV -> v <- c, u <- u + d
// Q8 fixed point. a, b given as Q8 (a*256, b*256); c, d as Q8 mV.
// dt = 2^-DT_SHIFT ms per en pulse (DT_SHIFT=1 -> 0.5 ms, as in the
// original MATLAB code which uses two half steps for v).
//   Regular spiking  RS: a=0.02 b=0.2  c=-65 d=8
//   Intrinsically bursting IB: c=-55 d=4
//   Chattering CH: c=-50 d=2
//   Fast spiking FS: a=0.1  b=0.2 c=-65 d=2
module izh_neuron #(
    parameter integer A        = 5,          // 0.02*256
    parameter integer B        = 51,         // 0.2*256
    parameter integer C        = -65*256,
    parameter integer D        = 8*256,
    parameter integer DT_SHIFT = 1
)(
    input  wire               clk, rst, en,
    input  wire signed [31:0] i_in,          // Q8
    output reg  signed [31:0] v,
    output reg  signed [31:0] u,
    output reg                spike
);
    localparam integer VPEAK = 30*256;
    // 0.04 v^2 in Q8: (v*v)/6400 ; implemented as (v*v*41) >>> 18 (41/2^18 = 1/6394)
    wire signed [63:0] vsq   = v * v;
    wire signed [63:0] quad  = (vsq * 41) >>> 18;
    wire signed [63:0] dv    = quad + 5*v + 140*256 - u + i_in;
    wire signed [63:0] bv    = (B * v) >>> 8;
    wire signed [63:0] du    = (A * (bv - u)) >>> 8;
    wire signed [31:0] v_next = v + (dv >>> DT_SHIFT);
    wire signed [31:0] u_next = u + (du >>> DT_SHIFT);
    always @(posedge clk) begin
        if (rst) begin v <= -65*256; u <= (B * (-65*256)) >>> 8; spike <= 1'b0; end
        else if (en) begin
            if (v_next >= VPEAK) begin
                v <= C; u <= u_next + D; spike <= 1'b1;
            end else begin
                v <= v_next; u <= u_next; spike <= 1'b0;
            end
        end else spike <= 1'b0;
    end
endmodule

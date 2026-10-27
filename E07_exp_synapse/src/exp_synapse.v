`timescale 1ns/1ps
// S2: Exponential (first-order) current synapse  (Dayan & Abbott 2001, ch. 5)
//   tau_s dI/dt = -I + W * sum_k delta(t - t_k)
//   Euler: I <- I - (I >>> TAU_SHIFT) + W*pre
module exp_synapse #(
    parameter integer W         = 4*256,
    parameter integer TAU_SHIFT = 3        // tau_s = 8 steps
)(
    input  wire               clk, rst, en,
    input  wire               pre_spike,
    output reg  signed [31:0] i_syn
);
    always @(posedge clk) begin
        if (rst)     i_syn <= 0;
        else if (en) i_syn <= i_syn - (i_syn >>> TAU_SHIFT) + (pre_spike ? W : 0);
    end
endmodule

// Neuromorphic Bootcamp - Basys 3 experiments
// Author : D. Mohan Reddy, PMRF (Prime Minister's Research Fellow)
//          Department of ECE, NIT Tiruchirappalli (NIT Trichy)
//
`timescale 1ns/1ps
// L1: Pair-based STDP with exponential traces
//   (Bi & Poo 1998; Song, Miller & Abbott 2000; trace form: Morrison et al. 2008)
//   x_pre  decays with tau+, += A_PLUS  on pre spike
//   x_post decays with tau-, += A_MINUS on post spike
//   pre spike : w <- w - x_post        (LTD: post fired before pre)
//   post spike: w <- w + x_pre         (LTP: pre fired before post)
//   w clipped to [0, WMAX]
module stdp_synapse #(
    parameter integer W_INIT   = 128,
    parameter integer WMAX     = 255,
    parameter integer A_PLUS   = 8,
    parameter integer A_MINUS  = 9,      // slightly > A_PLUS for stability
    parameter integer TAU_PLUS = 4,      // 16 steps
    parameter integer TAU_MINUS= 4,
    parameter integer TR_FRAC  = 4       // traces kept with 4 extra fraction bits
)(
    input  wire               clk, rst, en,
    input  wire               pre_spike,
    input  wire               post_spike,
    input  wire               learn,     // gate plasticity on/off
    output reg  signed [31:0] w,
    output reg  signed [31:0] x_pre,
    output reg  signed [31:0] x_post
);
    wire signed [31:0] xpre_d  = x_pre  - (x_pre  >>> TAU_PLUS);
    wire signed [31:0] xpost_d = x_post - (x_post >>> TAU_MINUS);
    wire signed [31:0] ltp = post_spike ? (xpre_d  >>> TR_FRAC) : 0;
    wire signed [31:0] ltd = pre_spike  ? (xpost_d >>> TR_FRAC) : 0;
    wire signed [31:0] w_new = w + ltp - ltd;
    always @(posedge clk) begin
        if (rst) begin w <= W_INIT; x_pre <= 0; x_post <= 0; end
        else if (en) begin
            x_pre  <= xpre_d  + (pre_spike  ? (A_PLUS  << TR_FRAC) : 0);
            x_post <= xpost_d + (post_spike ? (A_MINUS << TR_FRAC) : 0);
            if (learn)
                w <= (w_new < 0) ? 0 : (w_new > WMAX) ? WMAX : w_new;
        end
    end
endmodule

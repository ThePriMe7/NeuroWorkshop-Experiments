// Neuromorphic Bootcamp - Basys 3 experiments
// Author : D. Mohan Reddy, PMRF (Prime Minister's Research Fellow)
//          Department of ECE, NIT Tiruchirappalli (NIT Trichy)
// Copyright (c) 2026 D. Mohan Reddy. SPDX-License-Identifier: MIT (see LICENSE)
//
`timescale 1ns/1ps
// L2: STDP mini-network (after Song, Miller & Abbott 2000)
//   N_IN presynaptic spike trains -> exponential synapses -> one LIF neuron
//   Each synapse weight learns by pair-based STDP (stdp_synapse).
//   Input current = sum_i (w_i * pre_i) * GAIN, filtered by tau_s.
module stdp_network #(
    parameter integer N_IN = 4,
    parameter integer GAIN    = 32,      // current per unit weight (Q8)
    parameter integer A_MINUS = 13       // LTD dominant (A- > A+), as Song et al. 2000 require
)(
    input  wire                clk, rst, en, learn,
    input  wire [N_IN-1:0]     pre,
    output wire                post,
    output wire signed [31:0]  v,
    output wire [32*N_IN-1:0]  w_bus
);
    reg  signed [31:0] i_syn;
    reg  signed [31:0] drive;
    integer k;
    genvar g;
    generate for (g = 0; g < N_IN; g = g + 1) begin : syn
        wire signed [31:0] xp, xq;
        stdp_synapse #(.A_MINUS(A_MINUS)) u_stdp (
            .clk(clk), .rst(rst), .en(en), .pre_spike(pre[g]), .post_spike(post),
            .learn(learn), .w(w_bus[32*g +: 32]), .x_pre(xp), .x_post(xq));
    end endgenerate

    always @(*) begin
        drive = 0;
        for (k = 0; k < N_IN; k = k + 1)
            if (pre[k]) drive = drive + $signed(w_bus[32*k +: 32]) * GAIN;
    end
    always @(posedge clk) begin
        if (rst)     i_syn <= 0;
        else if (en) i_syn <= i_syn - (i_syn >>> 2) + drive;
    end

    lif_neuron #(.TAU_SHIFT(3), .T_REF(3)) u_lif (
        .clk(clk), .rst(rst), .en(en), .i_in(i_syn), .v(v), .spike(post));
endmodule

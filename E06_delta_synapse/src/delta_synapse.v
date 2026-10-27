// Neuromorphic Bootcamp - Basys 3 experiments
// Author : D. Mohan Reddy, PMRF (Prime Minister's Research Fellow)
//          Department of ECE, NIT Tiruchirappalli (NIT Trichy)
// Copyright (c) 2026 D. Mohan Reddy. SPDX-License-Identifier: MIT (see LICENSE)
//
`timescale 1ns/1ps
// S1: Delta (static weighted) synapse
//   I(t) = W * sum_k delta(t - t_k)   -> one-step current pulse of height W
module delta_synapse #(
    parameter integer W = 10*256
)(
    input  wire               clk, rst, en,
    input  wire               pre_spike,
    output reg  signed [31:0] i_syn
);
    always @(posedge clk) begin
        if (rst)     i_syn <= 0;
        else if (en) i_syn <= pre_spike ? W : 0;
    end
endmodule

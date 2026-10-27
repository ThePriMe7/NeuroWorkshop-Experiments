// Neuromorphic Bootcamp - Basys 3 experiments
// Author : D. Mohan Reddy, PMRF (Prime Minister's Research Fellow)
//          Department of ECE, NIT Tiruchirappalli (NIT Trichy)
// Copyright (c) 2026 D. Mohan Reddy. SPDX-License-Identifier: MIT (see LICENSE)
//
`timescale 1ns/1ps
// S4: Tsodyks-Markram dynamic synapse (Tsodyks & Markram 1997; Markram et al. 1998)
//   dx/dt = (1 - x)/tau_rec            x: available resources  (Q16, 1.0 = 65536)
//   du/dt = (U - u)/tau_fac            u: utilisation          (Q16)
//   on pre spike:  u <- u + U(1 - u) ;  r = u*x ;  x <- x - r
//   PSC:  tau_s dI/dt = -I + W*r  (exponential, as S2)
// Depressing:   U high (0.5), tau_rec long, tau_fac short
// Facilitating: U low (0.1),  tau_rec short, tau_fac long
module tm_synapse #(
    parameter integer W       = 16*256,
    parameter integer U       = 32768,   // 0.5
    parameter integer TAU_REC = 7,       // 128 steps
    parameter integer TAU_FAC = 2,       // 4 steps
    parameter integer TAU_S   = 3
)(
    input  wire               clk, rst, en,
    input  wire               pre_spike,
    output reg  signed [31:0] x,
    output reg  signed [31:0] u,
    output reg  signed [31:0] i_syn
);
    localparam integer ONE = 65536;
    wire signed [31:0] x_rec = x + ((ONE - x) >>> TAU_REC);
    wire signed [31:0] u_rel = u + ((U - u) >>> TAU_FAC);
    wire signed [63:0] u_jmp = u_rel + ((U * (ONE - u_rel)) >>> 16);
    wire signed [63:0] r     = (u_jmp * x_rec) >>> 16;            // Q16
    wire signed [63:0] i_add = (W * r) >>> 16;                    // Q8
    always @(posedge clk) begin
        if (rst) begin x <= ONE; u <= U; i_syn <= 0; end
        else if (en) begin
            if (pre_spike) begin
                u     <= u_jmp;
                x     <= x_rec - r;
                i_syn <= i_syn - (i_syn >>> TAU_S) + i_add;
            end else begin
                u     <= u_rel;
                x     <= x_rec;
                i_syn <= i_syn - (i_syn >>> TAU_S);
            end
        end
    end
endmodule

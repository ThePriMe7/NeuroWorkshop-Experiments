// Neuromorphic Bootcamp - Basys 3 experiments
// Author : D. Mohan Reddy, PMRF (Prime Minister's Research Fellow)
//          Department of ECE, NIT Tiruchirappalli (NIT Trichy)
//
`timescale 1ns/1ps
// N5: Quadratic Integrate-and-Fire (Ermentrout 1996; Latham et al. 2000)
//   tau dV/dt = a0 (V - Vrest)(V - Vc) + R*I ; V >= Vpeak -> V <- Vreset
// Vrest = 0, Vc = critical voltage. a0 = 2^-A_SHIFT per mV.
// Rheobase: R*I > a0*Vc^2/4  (=6.25 mV with defaults)
module qif_neuron #(
    parameter integer VC        = 10*256,
    parameter integer VPEAK     = 30*256,
    parameter integer VRESET    = 0,
    parameter integer A_SHIFT   = 2,
    parameter integer TAU_SHIFT = 3
)(
    input  wire               clk, rst, en,
    input  wire signed [31:0] i_in,
    output reg  signed [31:0] v,
    output reg                spike
);
    wire signed [63:0] prod   = v * (v - VC);              // Q16
    wire signed [63:0] quad   = prod >>> (8 + A_SHIFT);    // back to Q8, times a0
    wire signed [63:0] dv     = (quad + i_in) >>> TAU_SHIFT;
    wire signed [31:0] v_next = v + dv;
    always @(posedge clk) begin
        if (rst) begin v <= VRESET; spike <= 1'b0; end
        else if (en) begin
            if (v_next >= VPEAK) begin v <= VRESET; spike <= 1'b1; end
            else                 begin v <= v_next; spike <= 1'b0; end
        end else spike <= 1'b0;
    end
endmodule

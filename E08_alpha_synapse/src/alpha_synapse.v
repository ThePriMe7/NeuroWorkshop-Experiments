`timescale 1ns/1ps
// S3: Alpha synapse (Rall 1967): PSC ~ (t/tau) exp(1 - t/tau)
// Realised as two cascaded first-order filters with equal tau:
//   tau ds/dt = -s + W*pre ;  tau dI/dt = -I + s
module alpha_synapse #(
    parameter integer W         = 4*256,
    parameter integer TAU_SHIFT = 3
)(
    input  wire               clk, rst, en,
    input  wire               pre_spike,
    output reg  signed [31:0] s,           // internal (rise) state
    output reg  signed [31:0] i_syn
);
    always @(posedge clk) begin
        if (rst) begin s <= 0; i_syn <= 0; end
        else if (en) begin
            s     <= s - (s >>> TAU_SHIFT) + (pre_spike ? W : 0);
            i_syn <= i_syn - (i_syn >>> TAU_SHIFT) + (s >>> TAU_SHIFT);
        end
    end
endmodule

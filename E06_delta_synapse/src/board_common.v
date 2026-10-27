// Neuromorphic Bootcamp - Basys 3 experiments
// Author : D. Mohan Reddy, PMRF (Prime Minister's Research Fellow)
//          Department of ECE, NIT Tiruchirappalli (NIT Trichy)
// Copyright (c) 2026 D. Mohan Reddy. SPDX-License-Identifier: MIT (see LICENSE)
//
`timescale 1ns/1ps
// Basys 3 helpers shared by every experiment (copied into each experiment's src/ folder).
//   step_tick     : one-cycle `en` pulse at STEP_HZ, so one model step is slow enough to watch
//   btn_pulse     : push-button -> one pulse aligned with a step (sampling at the step rate debounces it)
//   pulse_stretch : makes a 1-cycle spike visible on an LED
//   bar15         : 15-LED bar graph of a value from 0 to FULL
//   seg7_signed   : 4-digit decimal display of a signed integer (-999 .. 9999), Basys 3 active-low
//   lfsr16        : pseudo-random source for spike trains

module step_tick #(parameter integer CLK_HZ = 100_000_000, parameter integer STEP_HZ = 100)(
    input  wire clk, rst,
    output reg  tick
);
    localparam integer DIV = CLK_HZ / STEP_HZ;
    reg [31:0] c;
    always @(posedge clk) begin
        if (rst) begin c <= 0; tick <= 1'b0; end
        else if (c == DIV - 1) begin c <= 0; tick <= 1'b1; end
        else begin c <= c + 1; tick <= 1'b0; end
    end
endmodule

module btn_pulse (
    input  wire clk, rst, tick, btn,
    output wire pulse          // high for the single clock in which `tick` is high, on a new press
);
    reg [2:0] sync;
    reg       prev;
    always @(posedge clk) begin
        sync <= {sync[1:0], btn};
        if (rst) prev <= 1'b0;
        else if (tick) prev <= sync[2];
    end
    assign pulse = tick & sync[2] & ~prev;
endmodule

module pulse_stretch #(parameter integer CYCLES = 10_000_000)(   // 0.1 s at 100 MHz
    input  wire clk, rst, in,
    output wire out
);
    reg [31:0] c;
    always @(posedge clk) begin
        if (rst) c <= 0;
        else if (in) c <= CYCLES;
        else if (c != 0) c <= c - 1;
    end
    assign out = (c != 0);
endmodule

module bar15 #(parameter integer FULL = 20)(
    input  wire signed [31:0] val,      // integer units (e.g. mV)
    output wire [14:0]        leds
);
    genvar k;
    generate for (k = 0; k < 15; k = k + 1) begin : g
        assign leds[k] = (val * 15 >= FULL * (k + 1));
    end endgenerate
endmodule

module seg7_signed (
    input  wire               clk,
    input  wire signed [15:0] value,    // shown in decimal; minus sign if negative
    output reg  [3:0]         an,       // active low
    output reg  [6:0]         seg       // {g,f,e,d,c,b,a}, active low
);
    reg [15:0] mag;
    reg [15:0] bcd;
    reg [31:0] sh;
    integer i;
    always @(*) begin                    // double dabble: binary -> 4 BCD digits
        mag = value[15] ? -value : value;
        if (mag > 9999) mag = 9999;
        sh = {16'd0, mag};
        for (i = 0; i < 16; i = i + 1) begin
            if (sh[19:16] >= 5) sh[19:16] = sh[19:16] + 3;
            if (sh[23:20] >= 5) sh[23:20] = sh[23:20] + 3;
            if (sh[27:24] >= 5) sh[27:24] = sh[27:24] + 3;
            if (sh[31:28] >= 5) sh[31:28] = sh[31:28] + 3;
            sh = sh << 1;
        end
        bcd = sh[31:16];
    end
    reg [17:0] refresh;
    always @(posedge clk) refresh <= refresh + 1;
    wire [1:0] d = refresh[17:16];       // ~380 Hz per digit
    reg  [4:0] digit;                    // 0-9, 10 = blank, 11 = minus
    always @(*) begin
        an = ~(4'b0001 << d);
        case (d)
            2'd0: digit = {1'b0, bcd[3:0]};
            2'd1: digit = (mag >= 10)   ? {1'b0, bcd[7:4]}   : (value[15] ? 5'd11 : 5'd10);
            2'd2: digit = (mag >= 100)  ? {1'b0, bcd[11:8]}  : (value[15] && mag >= 10 ? 5'd11 : 5'd10);
            default: digit = (mag >= 1000) ? {1'b0, bcd[15:12]} : (value[15] && mag >= 100 ? 5'd11 : 5'd10);
        endcase
        case (digit)
            5'd0: seg = 7'b1000000; 5'd1: seg = 7'b1111001; 5'd2: seg = 7'b0100100; 5'd3: seg = 7'b0110000;
            5'd4: seg = 7'b0011001; 5'd5: seg = 7'b0010010; 5'd6: seg = 7'b0000010; 5'd7: seg = 7'b1111000;
            5'd8: seg = 7'b0000000; 5'd9: seg = 7'b0010000; 5'd11: seg = 7'b0111111; default: seg = 7'b1111111;
        endcase
    end
endmodule

module lfsr16 #(parameter [15:0] SEED = 16'hACE1)(
    input  wire clk, rst, en,
    output reg [15:0] q
);
    always @(posedge clk) begin
        if (rst) q <= SEED;
        else if (en) q <= q[0] ? ((q >> 1) ^ 16'hB400) : (q >> 1);
    end
endmodule

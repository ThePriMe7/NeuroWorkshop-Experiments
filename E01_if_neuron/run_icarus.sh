#!/bin/bash
# Neuromorphic Bootcamp - Basys 3 experiments
# Author : D. Mohan Reddy, PMRF (Prime Minister's Research Fellow)
#          Department of ECE, NIT Tiruchirappalli (NIT Trichy)
#
# Optional open-source check (Icarus Verilog): same testbench, same PASS/FAIL
cd "$(dirname "$0")"
iverilog -g2005 -o /tmp/tb_$$.vvp sim/tb.v src/*.v && vvp -n /tmp/tb_$$.vvp; rm -f /tmp/tb_$$.vvp

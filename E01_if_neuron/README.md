# E01 if_neuron: Integrate-and-Fire neuron

**Author:** D. Mohan Reddy, PMRF (Prime Minister's Research Fellow),
Department of ECE, NIT Tiruchirappalli (NIT Trichy)

**Target:** Digilent Basys 3 (`xc7a35tcpg236-1`), Vivado 2025.2 (any recent version works).

## The physics in one paragraph
A capacitor charged by a constant current: C dV/dt = I, so the voltage rises in a straight line (Q = C·V). Nothing leaks, so any current eventually reaches the threshold.

## Files
- `src/if_neuron.v`
- `src/board_common.v`: step clock, button pulses, LED bar, 7-segment driver, random source
- `src/top_basys3.v`: the board top level (one model step every 1/50 s)
- `sim/tb.v`: self-checking testbench (prints PASS/FAIL, writes a CSV)
- `constr/basys3.xdc`: Basys 3 pins

## Open the ready-made project
**File → Project → Open…** → `vivado/E01_if_neuron.xpr`. It already contains the RTL, the testbench (simulation set)
and the Basys 3 constraints, and it has been synthesized and implemented: the bitstream is
`vivado/E01_if_neuron.runs/impl_1/top_basys3.bit`. (To rebuild everything from scratch: **Tools → Run Tcl Script…** →
`create_project.tcl`.)

## Part A: simulate (no board needed)
1. **Flow Navigator → Run Simulation → Run Behavioral Simulation.**
2. The Tcl console prints each check and **`*** PASS ***`**.
3. In the waveform window, right-click a 32-bit signal (`v`, `i_syn`, `w`) → **Radix → Signed Decimal**,
   then → **Waveform Style → Analog** to see the curve.
4. The CSV is written to `vivado/E01_if_neuron.sim/sim_1/behav/xsim/`.

Expected result: spike every 40 steps at 0.5 mV/step, every ~14 steps at 1.5 mV/step (18 spikes in total).

| check | value |
|---|---|
| spikes | 18 |

## Part B: run it on the Basys 3
1. Connect the board by USB and switch it on.
2. **Flow Navigator → Open Hardware Manager → Open Target → Auto Connect → Program Device**
   (the bitstream `top_basys3.bit` is already selected). If you changed the RTL, first click **Generate Bitstream**.

| control | meaning |
|---|---|
| `sw[7:0]` | input current I (Q8: 128 = 0.5 mV/step) |
| `btnC` | reset |
| `LED14..0` | membrane voltage V (bar, full = threshold 20 mV) |
| `LED15` | spike |
| `7-segment` | V in mV |

What to try:
- sw = 0000 0001: very slow ramp, still fires (no leak!)
- sw = 1000 0000: about one spike per 0.8 s
- double the current: the spike rate doubles

## Exercises
1. Halve VTH in if_neuron.v. Predict the new spike count, then simulate.
2. Why is a neuron without a leak unrealistic? Try I = 1 (Q8).

## Author and license
D. Mohan Reddy, PMRF (Prime Minister's Research Fellow), Department of ECE, NIT Tiruchirappalli (NIT Trichy).

Released under the [MIT License](../LICENSE): free to use, modify and share, keeping the copyright notice.

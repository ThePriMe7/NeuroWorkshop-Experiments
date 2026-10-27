# E06 delta_synapse: Delta synapse

**Target:** Digilent Basys 3 (`xc7a35tcpg236-1`), Vivado 2025.2 (any recent version works).

## The physics in one paragraph
An ideal, instantaneous charge transfer: each spike delivers a fixed packet of charge W at once, with no memory afterwards.

## Files
- `src/delta_synapse.v`
- `src/board_common.v`: step clock, button pulses, LED bar, 7-segment driver, random source
- `src/top_basys3.v`: the board top level (one model step every 1/20 s)
- `sim/tb.v`: self-checking testbench (prints PASS/FAIL, writes a CSV)
- `constr/basys3.xdc`: Basys 3 pins

## Open the ready-made project
**File → Project → Open…** → `vivado/E06_delta_synapse.xpr`. It already contains the RTL, the testbench (simulation set)
and the Basys 3 constraints, and it has been synthesized and implemented: the bitstream is
`vivado/E06_delta_synapse.runs/impl_1/top_basys3.bit`. (To rebuild everything from scratch: **Tools → Run Tcl Script…** →
`create_project.tcl`.)

## Part A: simulate (no board needed)
1. **Flow Navigator → Run Simulation → Run Behavioral Simulation.**
2. The Tcl console prints each check and **`*** PASS ***`**.
3. In the waveform window, right-click a 32-bit signal (`v`, `i_syn`, `w`) → **Radix → Signed Decimal**,
   then → **Waveform Style → Analog** to see the curve.
4. The CSV is written to `vivado/E06_delta_synapse.sim/sim_1/behav/xsim/`.

Expected result: a one-step pulse of height W at every spike, zero otherwise.

| check | value |
|---|---|
| peak_single_Q8 | 2560 |
| peak_burst_Q8 | 2560 |

## Part B: run it on the Basys 3
1. Connect the board by USB and switch it on.
2. **Flow Navigator → Open Hardware Manager → Open Target → Auto Connect → Program Device**
   (the bitstream `top_basys3.bit` is already selected). If you changed the RTL, first click **Generate Bitstream**.

| control | meaning |
|---|---|
| `btnU` | one presynaptic spike |
| `sw[0], sw[3:1]` | random spike train on/off, rate |
| `btnC` | reset |
| `LED14..0` | synaptic current (full = 10 mV) |
| `LED15` | presynaptic spike |
| `7-segment` | I_syn in mV |

What to try:
- press btnU: the bar jumps full for one step only, then empty

## Exercises
1. Change W. What is the largest current this synapse can deliver?

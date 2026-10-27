# E09 tsodyks_markram: Tsodyks-Markram dynamic synapse

**Target:** Digilent Basys 3 (`xc7a35tcpg236-1`), Vivado 2025.2 (any recent version works).

## The physics in one paragraph
A storage tank on the pipe: each spike releases a fraction u of the available resource x, and x refills exponentially (τrec). Fast spiking drains it (depression); a growing release fraction u gives facilitation. Both recover with time.

## Files
- `src/tm_synapse.v`
- `src/board_common.v`: step clock, button pulses, LED bar, 7-segment driver, random source
- `src/top_basys3.v`: the board top level (one model step every 1/50 s)
- `sim/tb.v`: self-checking testbench (prints PASS/FAIL, writes a CSV)
- `constr/basys3.xdc`: Basys 3 pins

## Open the ready-made project
**File → Project → Open…** → `vivado/E09_tsodyks_markram.xpr`. It already contains the RTL, the testbench (simulation set)
and the Basys 3 constraints, and it has been synthesized and implemented: the bitstream is
`vivado/E09_tsodyks_markram.runs/impl_1/top_basys3.bit`. (To rebuild everything from scratch: **Tools → Run Tcl Script…** →
`create_project.tcl`.)

## Part A: simulate (no board needed)
1. **Flow Navigator → Run Simulation → Run Behavioral Simulation.**
2. The Tcl console prints each check and **`*** PASS ***`**.
3. In the waveform window, right-click a 32-bit signal (`v`, `i_syn`, `w`) → **Radix → Signed Decimal**,
   then → **Waveform Style → Analog** to see the curve.
4. The CSV is written to `vivado/E09_tsodyks_markram.sim/sim_1/behav/xsim/`.

Expected result: depressing: the last burst peak is much smaller than the first; facilitating: much larger.

| check | value |
|---|---|
| dep_first_peak_Q8 | 1521 |
| dep_last_peak_Q8 | 612 |
| fac_first_peak_Q8 | 1007 |
| fac_last_peak_Q8 | 1919 |

## Part B: run it on the Basys 3
1. Connect the board by USB and switch it on.
2. **Flow Navigator → Open Hardware Manager → Open Target → Auto Connect → Program Device**
   (the bitstream `top_basys3.bit` is already selected). If you changed the RTL, first click **Generate Bitstream**.

| control | meaning |
|---|---|
| `btnU` | one presynaptic spike |
| `sw[0], sw[3:1]` | regular spike train on/off, period |
| `sw[15]` | 0 = depressing synapse, 1 = facilitating |
| `btnC` | reset |
| `LED14..0` | synaptic current (full = 12 mV) |
| `LED15` | presynaptic spike |
| `7-segment` | I_syn in mV |

What to try:
- sw[15] = 0, train on: the bar gets shorter spike after spike (depression)
- sw[15] = 1: the bar gets taller spike after spike (facilitation)
- train off, wait, press btnU: the full response is back (recovery)

## Exercises
1. Shorten the train period. Does depression get stronger?
2. Swap the parameters of the two synapses.

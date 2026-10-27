# E07 exp_synapse: Exponential synapse

**Author:** D. Mohan Reddy, PMRF (Prime Minister's Research Fellow),
Department of ECE, NIT Tiruchirappalli (NIT Trichy)

**Target:** Digilent Basys 3 (`xc7a35tcpg236-1`), Vivado 2025.2 (any recent version works).

## The physics in one paragraph
A funnel or RC discharge: the outflow is proportional to what is left (dI/dt = −I/τs), so the current falls by the same fraction every step: an exponential. After one τ only 37% remains. Spikes that arrive close together add up (temporal summation).

## Files
- `src/exp_synapse.v`
- `src/board_common.v`: step clock, button pulses, LED bar, 7-segment driver, random source
- `src/top_basys3.v`: the board top level (one model step every 1/20 s)
- `sim/tb.v`: self-checking testbench (prints PASS/FAIL, writes a CSV)
- `constr/basys3.xdc`: Basys 3 pins

## Open the ready-made project
**File → Project → Open…** → `vivado/E07_exp_synapse.xpr`. It already contains the RTL, the testbench (simulation set)
and the Basys 3 constraints, and it has been synthesized and implemented: the bitstream is
`vivado/E07_exp_synapse.runs/impl_1/top_basys3.bit`. (To rebuild everything from scratch: **Tools → Run Tcl Script…** →
`create_project.tcl`.)

## Part A: simulate (no board needed)
1. **Flow Navigator → Run Simulation → Run Behavioral Simulation.**
2. The Tcl console prints each check and **`*** PASS ***`**.
3. In the waveform window, right-click a 32-bit signal (`v`, `i_syn`, `w`) → **Radix → Signed Decimal**,
   then → **Waveform Style → Analog** to see the curve.
4. The CSV is written to `vivado/E07_exp_synapse.sim/sim_1/behav/xsim/`.

Expected result: jump of W at each spike, then exponential decay; peaks build up inside a burst.

| check | value |
|---|---|
| peak_single_Q8 | 1024 |
| peak_burst_Q8 | 2477 |

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
- one press: the bar jumps, then shrinks by the same fraction each step
- press quickly several times: the bar climbs higher (summation)

## Exercises
1. Measure how many steps the current needs to fall to 37% of its peak. Compare with τs = 2^TAU_SHIFT.

## Author and license
D. Mohan Reddy, PMRF (Prime Minister's Research Fellow), Department of ECE, NIT Tiruchirappalli (NIT Trichy).

Released under the [MIT License](../LICENSE): free to use, modify and share, keeping the copyright notice.

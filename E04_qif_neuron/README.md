# E04 qif_neuron: Quadratic Integrate-and-Fire neuron

**Author:** D. Mohan Reddy, PMRF (Prime Minister's Research Fellow),
Department of ECE, NIT Tiruchirappalli (NIT Trichy)

**Target:** Digilent Basys 3 (`xc7a35tcpg236-1`), Vivado 2025.2 (any recent version works).

## The physics in one paragraph
Positive feedback: above the critical voltage Vc the term (V−Vc)·V is positive and grows with V, so the voltage accelerates itself, like a ball rolling over a hilltop. The spike onset comes from the equation, not from a fixed rule.

## Files
- `src/qif_neuron.v`
- `src/board_common.v`: step clock, button pulses, LED bar, 7-segment driver, random source
- `src/top_basys3.v`: the board top level (one model step every 1/50 s)
- `sim/tb.v`: self-checking testbench (prints PASS/FAIL, writes a CSV)
- `constr/basys3.xdc`: Basys 3 pins

## Open the ready-made project
**File → Project → Open…** → `vivado/E04_qif_neuron.xpr`. It already contains the RTL, the testbench (simulation set)
and the Basys 3 constraints, and it has been synthesized and implemented: the bitstream is
`vivado/E04_qif_neuron.runs/impl_1/top_basys3.bit`. (To rebuild everything from scratch: **Tools → Run Tcl Script…** →
`create_project.tcl`.)

## Part A: simulate (no board needed)
1. **Flow Navigator → Run Simulation → Run Behavioral Simulation.**
2. The Tcl console prints each check and **`*** PASS ***`**.
3. In the waveform window, right-click a 32-bit signal (`v`, `i_syn`, `w`) → **Radix → Signed Decimal**,
   then → **Waveform Style → Analog** to see the curve.
4. The CSV is written to `vivado/E04_qif_neuron.sim/sim_1/behav/xsim/`.

Expected result: 5 mV: silent; 7 mV: slow spikes with a long creep before each; 12 mV: regular firing.

| check | value |
|---|---|
| spikes_at_5mV | 0 |
| spikes_at_7mV | 2 |
| spikes_at_12mV | 8 |

## Part B: run it on the Basys 3
1. Connect the board by USB and switch it on.
2. **Flow Navigator → Open Hardware Manager → Open Target → Auto Connect → Program Device**
   (the bitstream `top_basys3.bit` is already selected). If you changed the RTL, first click **Generate Bitstream**.

| control | meaning |
|---|---|
| `sw[4:0]` | R·I in mV (0-31) |
| `btnC` | reset |
| `LED14..0` | V (bar, full = 30 mV peak) |
| `LED15` | spike |
| `7-segment` | V in mV |

What to try:
- sw = 6: V rests (below rheobase 6.25 mV)
- sw = 7: V creeps up slowly, then shoots up: the self-accelerating onset
- sw = 12: regular firing

## Exercises
1. Find the exact switch value where firing starts and compare with a0·Vc²/4.
2. Look at V just before a spike: is the upswing linear or curved? Why?

## Author and license
D. Mohan Reddy, PMRF (Prime Minister's Research Fellow), Department of ECE, NIT Tiruchirappalli (NIT Trichy).

Released under the [MIT License](../LICENSE): free to use, modify and share, keeping the copyright notice.

# E11 stdp_network: STDP network: unsupervised learning

**Author:** D. Mohan Reddy, PMRF (Prime Minister's Research Fellow),
Department of ECE, NIT Tiruchirappalli (NIT Trichy)

**Target:** Digilent Basys 3 (`xc7a35tcpg236-1`), Vivado 2025.2 (any recent version works).

## The physics in one paragraph
Competition through timing: the inputs that fire together make the output neuron fire, so their synapses keep getting the 'cause' credit and grow; random inputs mostly arrive at the wrong time and shrink.

## Files
- `src/stdp_network.v`
- `src/stdp_synapse.v`
- `src/lif_neuron.v`
- `src/board_common.v`: step clock, button pulses, LED bar, 7-segment driver, random source
- `src/top_basys3.v`: the board top level (one model step every 1/1000 s)
- `sim/tb.v`: self-checking testbench (prints PASS/FAIL, writes a CSV)
- `constr/basys3.xdc`: Basys 3 pins

## Open the ready-made project
**File → Project → Open…** → `vivado/E11_stdp_network.xpr`. It already contains the RTL, the testbench (simulation set)
and the Basys 3 constraints, and it has been synthesized and implemented: the bitstream is
`vivado/E11_stdp_network.runs/impl_1/top_basys3.bit`. (To rebuild everything from scratch: **Tools → Run Tcl Script…** →
`create_project.tcl`.)

## Part A: simulate (no board needed)
1. **Flow Navigator → Run Simulation → Run Behavioral Simulation.**
2. The Tcl console prints each check and **`*** PASS ***`**.
3. In the waveform window, right-click a 32-bit signal (`v`, `i_syn`, `w`) → **Radix → Signed Decimal**,
   then → **Waveform Style → Analog** to see the curve.
4. The CSV is written to `vivado/E11_stdp_network.sim/sim_1/behav/xsim/`.

Expected result: correlated inputs 0 and 1 end near 255, independent inputs 2 and 3 near 0.

| check | value |
|---|---|
| (behavioural check) | see expected behaviour |

## Part B: run it on the Basys 3
1. Connect the board by USB and switch it on.
2. **Flow Navigator → Open Hardware Manager → Open Target → Auto Connect → Program Device**
   (the bitstream `top_basys3.bit` is already selected). If you changed the RTL, first click **Generate Bitstream**.

| control | meaning |
|---|---|
| `sw[0]` | inputs on |
| `sw[1]` | inputs 0 and 1 correlated (1) or independent (0) |
| `sw[2]` | learning on |
| `sw[7:4]` | input rate (try 0001) |
| `sw[15:14]` | which weight w0..w3 to show |
| `btnC` | reset all weights to 128 |
| `LED14..0` | selected weight (full = 255) |
| `LED15` | output neuron spike |
| `7-segment` | selected weight |

What to try:
- sw[0]=1, sw[1]=1, sw[2]=1, sw[7:4]=0001: after ~30 s, w0 and w1 near 255, w2 and w3 near 0
- repeat with sw[1]=0: no pair is special, so no clear winner

## Exercises
1. Correlate inputs 2 and 3 instead. Which pair wins now?
2. Set A_MINUS = 8 (no longer LTD-dominant). What happens to all weights?

## Author and license
D. Mohan Reddy, PMRF (Prime Minister's Research Fellow), Department of ECE, NIT Tiruchirappalli (NIT Trichy).

Released under the [MIT License](../LICENSE): free to use, modify and share, keeping the copyright notice.

# E03 adaptive_lif: Adaptive LIF neuron

**Author:** D. Mohan Reddy, PMRF (Prime Minister's Research Fellow),
Department of ECE, NIT Tiruchirappalli (NIT Trichy)  
**Guide:** Dr. G. Lakshminarayanan, Professor (HAG), Department of ECE, NIT Tiruchirappalli (NIT Trichy)

**Slides:** the [workshop deck](../slides/Neuromorphic_Bootcamp_Workshop.pdf) explains the physics of every model and walks through each lab.

**Target:** Digilent Basys 3 (`xc7a35tcpg236-1`), Vivado 2025.2 (any recent version works).

## The physics in one paragraph
Two capacitors with two very different time constants: the membrane (fast, τv) and an adaptation current w (slow, τw). Each spike adds charge to w; w drains slowly and opposes the input, so the neuron 'gets tired'.

## Files
- `src/alif_neuron.v`
- `src/board_common.v`: step clock, button pulses, LED bar, 7-segment driver, random source
- `src/top_basys3.v`: the board top level (one model step every 1/50 s)
- `sim/tb.v`: self-checking testbench (prints PASS/FAIL, writes a CSV)
- `constr/basys3.xdc`: Basys 3 pins

## Open the ready-made project
**File → Project → Open…** → `vivado/E03_adaptive_lif.xpr`. It already contains the RTL, the testbench (simulation set)
and the Basys 3 constraints, and it has been synthesized and implemented: the bitstream is
`vivado/E03_adaptive_lif.runs/impl_1/top_basys3.bit`. (To rebuild everything from scratch: **Tools → Run Tcl Script…** →
`create_project.tcl`.)

## Part A: simulate (no board needed)
1. **Flow Navigator → Run Simulation → Run Behavioral Simulation.**
2. The Tcl console prints each check and **`*** PASS ***`**.
3. In the waveform window, right-click a 32-bit signal (`v`, `i_syn`, `w`) → **Radix → Signed Decimal**,
   then → **Waveform Style → Analog** to see the curve.
4. The CSV is written to `vivado/E03_adaptive_lif.sim/sim_1/behav/xsim/`.

Expected result: the inter-spike interval grows from the first spike pair to the last (spike-frequency adaptation).

| check | value |
|---|---|
| spikes | 13 |
| first_ISI_steps | 13 |
| last_ISI_steps | 30 |

## Part B: run it on the Basys 3
1. Connect the board by USB and switch it on.
2. **Flow Navigator → Open Hardware Manager → Open Target → Auto Connect → Program Device**
   (the bitstream `top_basys3.bit` is already selected). If you changed the RTL, first click **Generate Bitstream**.

| control | meaning |
|---|---|
| `sw[5:0]` | R·I in mV |
| `sw[15]` | 7-segment shows V (0) or adaptation w (1) |
| `btnC` | reset |
| `LED14..0` | V (bar) |
| `LED15` | spike |
| `7-segment` | V or w in mV |

What to try:
- sw = 40: watch the LED15 flashes slow down after the first few
- flip sw[15]: w climbs with every spike, then decays when the input stops

## Exercises
1. Set B = 0. Which experiment's behaviour do you get back?
2. Make TAU_W smaller (faster recovery). How do the ISIs change?

## Author and license
D. Mohan Reddy, PMRF (Prime Minister's Research Fellow), Department of ECE, NIT Tiruchirappalli (NIT Trichy),
under the guidance of Dr. G. Lakshminarayanan, Professor (HAG), Department of ECE, NIT Tiruchirappalli.

Released under the [MIT License](../LICENSE): free to use, modify and share, keeping the copyright notice.

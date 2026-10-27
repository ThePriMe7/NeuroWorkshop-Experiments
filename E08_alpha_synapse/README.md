# E08 alpha_synapse: Alpha synapse

**Author:** D. Mohan Reddy, PMRF (Prime Minister's Research Fellow),
Department of ECE, NIT Tiruchirappalli (NIT Trichy)  
**Guide:** Dr. G. Lakshminarayanan, Professor (HAG), Department of ECE, NIT Tiruchirappalli (NIT Trichy)

**Slides:** the [workshop deck](../slides/Neuromorphic_Bootcamp_Workshop.pdf) explains the physics of every model and walks through each lab.

**Target:** Digilent Basys 3 (`xc7a35tcpg236-1`), Vivado 2025.2 (any recent version works).

## The physics in one paragraph
Two funnels (two RC stages) in series: the first fills instantly and drains into the second, so the current into the neuron first rises, peaks at t = τ, then decays. Real synaptic currents look like this.

## Files
- `src/alpha_synapse.v`
- `src/board_common.v`: step clock, button pulses, LED bar, 7-segment driver, random source
- `src/top_basys3.v`: the board top level (one model step every 1/20 s)
- `sim/tb.v`: self-checking testbench (prints PASS/FAIL, writes a CSV)
- `constr/basys3.xdc`: Basys 3 pins

## Open the ready-made project
**File → Project → Open…** → `vivado/E08_alpha_synapse.xpr`. It already contains the RTL, the testbench (simulation set)
and the Basys 3 constraints, and it has been synthesized and implemented: the bitstream is
`vivado/E08_alpha_synapse.runs/impl_1/top_basys3.bit`. (To rebuild everything from scratch: **Tools → Run Tcl Script…** →
`create_project.tcl`.)

## Part A: simulate (no board needed)
1. **Flow Navigator → Run Simulation → Run Behavioral Simulation.**
2. The Tcl console prints each check and **`*** PASS ***`**.
3. In the waveform window, right-click a 32-bit signal (`v`, `i_syn`, `w`) → **Radix → Signed Decimal**,
   then → **Waveform Style → Analog** to see the curve.
4. The CSV is written to `vivado/E08_alpha_synapse.sim/sim_1/behav/xsim/`.

Expected result: no jump: the current rises, peaks about τ steps after the spike, then decays.

| check | value |
|---|---|
| peak_single_Q8 | 402 |
| peak_burst_Q8 | 2078 |

## Part B: run it on the Basys 3
1. Connect the board by USB and switch it on.
2. **Flow Navigator → Open Hardware Manager → Open Target → Auto Connect → Program Device**
   (the bitstream `top_basys3.bit` is already selected). If you changed the RTL, first click **Generate Bitstream**.

| control | meaning |
|---|---|
| `btnU` | one presynaptic spike |
| `sw[0], sw[3:1]` | random spike train on/off, rate |
| `btnC` | reset |
| `LED14..0` | synaptic current (full = 5 mV) |
| `LED15` | presynaptic spike |
| `7-segment` | I_syn in mV |

What to try:
- one press: the bar grows for a few steps, then shrinks: a smooth rise and fall

## Exercises
1. Find the step of the peak after a single spike and compare with τ.
2. Give the two stages different shifts: the dual-exponential synapse.

## Author and license
D. Mohan Reddy, PMRF (Prime Minister's Research Fellow), Department of ECE, NIT Tiruchirappalli (NIT Trichy),
under the guidance of Dr. G. Lakshminarayanan, Professor (HAG), Department of ECE, NIT Tiruchirappalli.

Released under the [MIT License](../LICENSE): free to use, modify and share, keeping the copyright notice.

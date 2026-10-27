# E02 lif_neuron: Leaky Integrate-and-Fire neuron

**Author:** D. Mohan Reddy, PMRF (Prime Minister's Research Fellow),
Department of ECE, NIT Tiruchirappalli (NIT Trichy)  
**Guide:** Dr. G. Lakshminarayanan, Professor (HAG), Department of ECE, NIT Tiruchirappalli (NIT Trichy)

**Slides:** the [workshop deck](../slides/Neuromorphic_Bootcamp_Workshop.pdf) explains the physics of every model and walks through each lab.

**Target:** Digilent Basys 3 (`xc7a35tcpg236-1`), Vivado 2025.2 (any recent version works).

## The physics in one paragraph
An RC circuit: the membrane capacitor charges through the input and leaks through a resistor. The leak current is proportional to V (Ohm's law), so V approaches R·I exponentially with time constant τ = RC. If R·I is below the threshold, it never fires.

## Files
- `src/lif_neuron.v`
- `src/board_common.v`: step clock, button pulses, LED bar, 7-segment driver, random source
- `src/top_basys3.v`: the board top level (one model step every 1/50 s)
- `sim/tb.v`: self-checking testbench (prints PASS/FAIL, writes a CSV)
- `constr/basys3.xdc`: Basys 3 pins

## Open the ready-made project
**File → Project → Open…** → `vivado/E02_lif_neuron.xpr`. It already contains the RTL, the testbench (simulation set)
and the Basys 3 constraints, and it has been synthesized and implemented: the bitstream is
`vivado/E02_lif_neuron.runs/impl_1/top_basys3.bit`. (To rebuild everything from scratch: **Tools → Run Tcl Script…** →
`create_project.tcl`.)

## Part A: simulate (no board needed)
1. **Flow Navigator → Run Simulation → Run Behavioral Simulation.**
2. The Tcl console prints each check and **`*** PASS ***`**.
3. In the waveform window, right-click a 32-bit signal (`v`, `i_syn`, `w`) → **Radix → Signed Decimal**,
   then → **Waveform Style → Analog** to see the curve.
4. The CSV is written to `vivado/E02_lif_neuron.sim/sim_1/behav/xsim/`.

Expected result: 15 mV: V settles near 15 mV, 0 spikes; 25 mV: regular spikes; 40 mV: faster spikes.

| check | value |
|---|---|
| spikes_at_15mV | 0 |
| vmax_at_15mV_Q8 | 3825 |
| spikes_at_25mV | 4 |
| spikes_at_40mV | 9 |

## Part B: run it on the Basys 3
1. Connect the board by USB and switch it on.
2. **Flow Navigator → Open Hardware Manager → Open Target → Auto Connect → Program Device**
   (the bitstream `top_basys3.bit` is already selected). If you changed the RTL, first click **Generate Bitstream**.

| control | meaning |
|---|---|
| `sw[5:0]` | R·I in mV (0-63) |
| `btnC` | reset |
| `LED14..0` | V (bar, full = 20 mV threshold) |
| `LED15` | spike |
| `7-segment` | V in mV |

What to try:
- sw = 15: the bar stops below the top, no spikes (below rheobase)
- sw = 21: slow firing just above threshold
- sw = 40: fast firing, with a pause after each spike (refractory)

## Exercises
1. Change TAU_SHIFT from 4 to 2 (shorter τ). What happens to the charging curve?
2. Find the smallest switch value that fires. Explain it with V∞ = R·I.

## Author and license
D. Mohan Reddy, PMRF (Prime Minister's Research Fellow), Department of ECE, NIT Tiruchirappalli (NIT Trichy),
under the guidance of Dr. G. Lakshminarayanan, Professor (HAG), Department of ECE, NIT Tiruchirappalli.

Released under the [MIT License](../LICENSE): free to use, modify and share, keeping the copyright notice.

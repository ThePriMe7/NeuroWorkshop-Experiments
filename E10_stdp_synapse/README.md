# E10 stdp_synapse: STDP synapse: learning from spike timing

**Author:** D. Mohan Reddy, PMRF (Prime Minister's Research Fellow),
Department of ECE, NIT Tiruchirappalli (NIT Trichy)  
**Guide:** Dr. G. Lakshminarayanan, Professor (HAG), Department of ECE, NIT Tiruchirappalli (NIT Trichy)

**Slides:** the [workshop deck](../slides/Neuromorphic_Bootcamp_Workshop.pdf) explains the physics of every model and walks through each lab.

**Target:** Digilent Basys 3 (`xc7a35tcpg236-1`), Vivado 2025.2 (any recent version works).

## The physics in one paragraph
Each neuron leaves a decaying trace (an exponential memory, like a wet mark drying). When the post neuron fires while the pre trace is still high, the weight grows (cause before effect); the reverse order shrinks it.

## Files
- `src/stdp_synapse.v`
- `src/board_common.v`: step clock, button pulses, LED bar, 7-segment driver, random source
- `src/top_basys3.v`: the board top level (one model step every 1/25 s)
- `sim/tb.v`: self-checking testbench (prints PASS/FAIL, writes a CSV)
- `constr/basys3.xdc`: Basys 3 pins

## Open the ready-made project
**File → Project → Open…** → `vivado/E10_stdp_synapse.xpr`. It already contains the RTL, the testbench (simulation set)
and the Basys 3 constraints, and it has been synthesized and implemented: the bitstream is
`vivado/E10_stdp_synapse.runs/impl_1/top_basys3.bit`. (To rebuild everything from scratch: **Tools → Run Tcl Script…** →
`create_project.tcl`.)

## Part A: simulate (no board needed)
1. **Flow Navigator → Run Simulation → Run Behavioral Simulation.**
2. The Tcl console prints each check and **`*** PASS ***`**.
3. In the waveform window, right-click a 32-bit signal (`v`, `i_syn`, `w`) → **Radix → Signed Decimal**,
   then → **Waveform Style → Analog** to see the curve.
4. The CSV is written to `vivado/E10_stdp_synapse.sim/sim_1/behav/xsim/`.

Expected result: Δt = +10 (pre first): weight increases; Δt = −10 (post first): weight decreases; the window decays with |Δt|.

| check | value |
|---|---|
| dw_at_plus10 | 40 |
| dw_at_minus10 | -49 |

## Part B: run it on the Basys 3
1. Connect the board by USB and switch it on.
2. **Flow Navigator → Open Hardware Manager → Open Target → Auto Connect → Program Device**
   (the bitstream `top_basys3.bit` is already selected). If you changed the RTL, first click **Generate Bitstream**.

| control | meaning |
|---|---|
| `btnL` | presynaptic spike |
| `btnR` | postsynaptic spike |
| `btnC` | reset (w back to 128) |
| `LED14..0` | synaptic weight w (full = 255) |
| `LED15` | any spike |
| `7-segment` | weight w |

What to try:
- press btnL, then quickly btnR: w goes UP (pre before post, LTP)
- press btnR, then quickly btnL: w goes DOWN (LTD)
- press them far apart in time: w barely changes (traces have dried out)

## Exercises
1. Plot stdp_window.csv: dw against Δt (the learning window).
2. Make A_MINUS equal to A_PLUS. Is the window still asymmetric?

## Author and license
D. Mohan Reddy, PMRF (Prime Minister's Research Fellow), Department of ECE, NIT Tiruchirappalli (NIT Trichy),
under the guidance of Dr. G. Lakshminarayanan, Professor (HAG), Department of ECE, NIT Tiruchirappalli.

Released under the [MIT License](../LICENSE): free to use, modify and share, keeping the copyright notice.

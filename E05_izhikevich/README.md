# E05 izhikevich: Izhikevich neuron: four cell types

**Author:** D. Mohan Reddy, PMRF (Prime Minister's Research Fellow),
Department of ECE, NIT Tiruchirappalli (NIT Trichy)

**Target:** Digilent Basys 3 (`xc7a35tcpg236-1`), Vivado 2025.2 (any recent version works).

## The physics in one paragraph
Two coupled variables: a fast voltage v with a quadratic (self-accelerating) term and a slow recovery u that pulls v back down. Different speeds a and reset values c, d give different rhythms, like springs of different stiffness.

## Files
- `src/izh_neuron.v`
- `src/board_common.v`: step clock, button pulses, LED bar, 7-segment driver, random source
- `src/top_basys3.v`: the board top level (one model step every 1/200 s)
- `sim/tb.v`: self-checking testbench (prints PASS/FAIL, writes a CSV)
- `constr/basys3.xdc`: Basys 3 pins

## Open the ready-made project
**File → Project → Open…** → `vivado/E05_izhikevich.xpr`. It already contains the RTL, the testbench (simulation set)
and the Basys 3 constraints, and it has been synthesized and implemented: the bitstream is
`vivado/E05_izhikevich.runs/impl_1/top_basys3.bit`. (To rebuild everything from scratch: **Tools → Run Tcl Script…** →
`create_project.tcl`.)

## Part A: simulate (no board needed)
1. **Flow Navigator → Run Simulation → Run Behavioral Simulation.**
2. The Tcl console prints each check and **`*** PASS ***`**.
3. In the waveform window, right-click a 32-bit signal (`v`, `i_syn`, `w`) → **Radix → Signed Decimal**,
   then → **Waveform Style → Analog** to see the curve.
4. The CSV is written to `vivado/E05_izhikevich.sim/sim_1/behav/xsim/`.

Expected result: same circuit, four parameter sets, four rhythms; FS fires most, RS adapts, CH fires in bursts.

| check | value |
|---|---|
| spikes_RS | 7 |
| spikes_IB | 10 |
| spikes_CH | 25 |
| spikes_FS | 32 |

## Part B: run it on the Basys 3
1. Connect the board by USB and switch it on.
2. **Flow Navigator → Open Hardware Manager → Open Target → Auto Connect → Program Device**
   (the bitstream `top_basys3.bit` is already selected). If you changed the RTL, first click **Generate Bitstream**.

| control | meaning |
|---|---|
| `sw[4:0]` | input current I (try 10) |
| `sw[15:14]` | cell type: 00 RS, 01 IB, 10 CH, 11 FS |
| `btnC` | reset |
| `LED14..0` | v from -80 mV (empty) to +30 mV (full) |
| `LED15` | spike |
| `7-segment` | v in mV (with minus sign) |

What to try:
- RS: evenly spaced flashes
- IB: a quick burst, then single spikes
- CH: repeated bursts
- FS: rapid, steady flashing

## Exercises
1. Add a fifth cell: a=0.02, b=0.25, c=-65, d=0.05 (low-threshold spiking).
2. Plot v against u from the CSV: the phase plane.

## Author and license
D. Mohan Reddy, PMRF (Prime Minister's Research Fellow), Department of ECE, NIT Tiruchirappalli (NIT Trichy).

Released under the [MIT License](../LICENSE): free to use, modify and share, keeping the copyright notice.

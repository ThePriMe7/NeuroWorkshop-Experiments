# Neuromorphic Bootcamp: From Spikes to Silicon
One-day hands-on workshop on neuromorphic computing, with 11 FPGA experiments on the Digilent Basys 3 (Vivado).

**Author:** D. Mohan Reddy, PMRF (Prime Minister's Research Fellow),
Department of ECE, NIT Tiruchirappalli (NIT Trichy)

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)

**Start with the slides:** [Neuromorphic_Bootcamp_Workshop.pdf](slides/Neuromorphic_Bootcamp_Workshop.pdf) (PDF, 109 pages). They cover the physics behind each
neuron and synapse model, the water-tank analogies, the fixed-point hardware and a lab walk-through for every
experiment, with annotated Vivado waveforms.

## Mission
To make neuromorphic computing accessible to every engineering student, not only those at research labs. Each
model is taught from its physics first, with a water-tank analogy, then built as synthesizable Verilog, simulated
and run on a low-cost FPGA board. Participants leave having built brain-inspired hardware with their own hands.
The workshop is free of cost, conducted as a national service under the Prime Minister's Research Fellowship
(PMRF) external teaching assistantship, to share knowledge with neighbouring colleges.

## Vision
A community of students and teachers who can read a neuron equation, turn it into hardware and reason about its
cost, and who carry spiking neural networks and on-chip learning into their own projects, courses and research.
Every lab here is open source so that any college can run the same workshop on its own Basys 3 boards.

## Course outline (one day, 5 hours)
| Time | Session | Content | Labs |
|---|---|---|---|
| 09:30-09:45 | Welcome and setup | introductions, tool check | |
| 09:45-10:20 | **S1 Basics** | classical vs neuromorphic computing, ANN vs SNN, the water-tank analogy, how a differential equation becomes a clocked circuit | |
| 10:20-11:15 | **S2 Neurons I** | integrate-and-fire and leaky integrate-and-fire: integration, leak, threshold, refractory period | E01, E02 |
| 11:15-11:30 | Break | | |
| 11:30-12:20 | **S3 Neurons II** | adaptive LIF, quadratic IF, Izhikevich: adaptation, bursting, chattering, fast spiking | E03, E04, E05 |
| 12:20-13:10 | **S4 Synapses** | delta, exponential, alpha and Tsodyks-Markram synapses: current shapes, depression vs facilitation | E06-E09 |
| 13:10-13:55 | **S5 Learning** | STDP with traces, a 4-input network that learns correlated inputs without a teacher | E10, E11 |
| 13:55-14:15 | **S6 To the FPGA** | Vivado simulation, RTL schematic, LUT/FF/DSP use, timing, why multipliers limit speed | all |
| 14:15-14:30 | Wrap-up | recap, quiz, feedback, take-home challenge (pipeline a neuron) | |

Each lab session is about 15 minutes of theory and demo, then 30-35 minutes hands-on.

## Concepts covered
- **Neuromorphic basics:** von Neumann bottleneck, event-driven computing, spikes as information, ANN vs SNN
- **Neuron physics:** membrane as a leaky capacitor, the RC time constant and exponential decay, threshold and
  reset, refractory period, spike-frequency adaptation, quadratic (positive-feedback) spike onset
- **Firing patterns:** f-I curve, rheobase, regular spiking, intrinsic bursting, chattering, fast spiking
  (Izhikevich a, b, c, d)
- **Synapses:** instantaneous (delta), exponential and alpha current shapes, short-term depression and
  facilitation (Tsodyks-Markram resources and utilization)
- **Learning:** spike-timing-dependent plasticity, pre/post traces, the STDP window, LTP vs LTD balance,
  unsupervised learning of correlated inputs
- **Hardware mapping:** Q8 fixed-point arithmetic, one clock = one Euler step, dt/tau as a shift instead of a
  divide, saturation, enable-gated models and multicycle timing constraints
- **FPGA flow:** self-checking testbenches, analog waveforms in the Vivado simulator, synthesis, implementation,
  resource and timing reports, bitstream, and running it on the Basys 3 (switches, LEDs, 7-segment display)

## Prerequisites
Basic digital logic and Verilog (modules, `always` blocks, registers). No neuroscience background is needed.
Vivado (any recent version; 2025.2 used here) and optionally Icarus Verilog for a quick open-source check.

## The experiments

Each folder is self-contained. Open `vivado/<Exx>.xpr` in the Vivado GUI: the project already holds the RTL,
the self-checking testbench and the Basys 3 constraints, with the bitstream generated. `create_project.tcl`
rebuilds it from scratch. Every README has the board controls and exercises.

| Experiment | Model | On the board |
|---|---|---|
| [E01_if_neuron](E01_if_neuron/README.md) | Integrate-and-Fire neuron | 1 step = 1/50 s |
| [E02_lif_neuron](E02_lif_neuron/README.md) | Leaky Integrate-and-Fire neuron | 1 step = 1/50 s |
| [E03_adaptive_lif](E03_adaptive_lif/README.md) | Adaptive LIF neuron | 1 step = 1/50 s |
| [E04_qif_neuron](E04_qif_neuron/README.md) | Quadratic Integrate-and-Fire neuron | 1 step = 1/50 s |
| [E05_izhikevich](E05_izhikevich/README.md) | Izhikevich neuron: four cell types | 1 step = 1/200 s |
| [E06_delta_synapse](E06_delta_synapse/README.md) | Delta synapse | 1 step = 1/20 s |
| [E07_exp_synapse](E07_exp_synapse/README.md) | Exponential synapse | 1 step = 1/20 s |
| [E08_alpha_synapse](E08_alpha_synapse/README.md) | Alpha synapse | 1 step = 1/20 s |
| [E09_tsodyks_markram](E09_tsodyks_markram/README.md) | Tsodyks-Markram dynamic synapse | 1 step = 1/50 s |
| [E10_stdp_synapse](E10_stdp_synapse/README.md) | STDP synapse: learning from spike timing | 1 step = 1/25 s |
| [E11_stdp_network](E11_stdp_network/README.md) | STDP network: unsupervised learning | 1 step = 1/1000 s |

Common board conventions: **btnC = reset**, **LED15 = spike**, **LED14..0 = a bar of the main signal**,
**7-segment = the value in decimal**. Folders are generated by `scripts/make_experiments.py`.

## Author and license
D. Mohan Reddy, PMRF (Prime Minister's Research Fellow), Department of ECE, NIT Tiruchirappalli (NIT Trichy).

Released under the [MIT License](LICENSE): free to use, modify and share, keeping the copyright notice.

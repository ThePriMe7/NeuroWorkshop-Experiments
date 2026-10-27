# Neuromorphic Bootcamp - Basys 3 experiments
# Author : D. Mohan Reddy, PMRF (Prime Minister's Research Fellow)
#          Department of ECE, NIT Tiruchirappalli (NIT Trichy)
#
# Vivado: create the project (GUI-ready .xpr), run the self-checking simulation,
# then synthesis + implementation + bitstream for the Basys 3.
#   vivado -mode batch -source create_project.tcl      (or Tools -> Run Tcl Script in the GUI)
set here [file normalize [file dirname [info script]]]
set name [file tail $here]
create_project $name $here/vivado -part xc7a35tcpg236-1 -force
set_property target_language Verilog [current_project]
add_files -norecurse [glob $here/src/*.v]
add_files -fileset constrs_1 -norecurse $here/constr/basys3.xdc
set_property top top_basys3 [get_filesets sources_1]
add_files -fileset sim_1 -norecurse $here/sim/tb.v
set_property top tb [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# 1. behavioural simulation (prints PASS / FAIL)
launch_simulation
close_sim

# 2. synthesis -> implementation -> bitstream
launch_runs synth_1 -jobs 4
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
open_run impl_1
report_utilization -file $here/vivado/utilization.txt
report_timing_summary -file $here/vivado/timing.txt
close_project
puts "DONE: $here/vivado/$name.xpr  bitstream: [glob -nocomplain $here/vivado/$name.runs/impl_1/top_basys3.bit]"

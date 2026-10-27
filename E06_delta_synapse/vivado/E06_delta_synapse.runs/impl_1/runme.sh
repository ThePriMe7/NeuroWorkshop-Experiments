#!/bin/bash

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/ecelab/Xilinx/2025.2/Vitis/bin:/home/ecelab/Xilinx/2025.2/Vivado/ids_lite/ISE/bin/lin64:/home/ecelab/Xilinx/2025.2/Vivado/bin
else
  PATH=/home/ecelab/Xilinx/2025.2/Vitis/bin:/home/ecelab/Xilinx/2025.2/Vivado/ids_lite/ISE/bin/lin64:/home/ecelab/Xilinx/2025.2/Vivado/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/ecelab/neuro_exp_tmp/experiments/E06_delta_synapse/vivado/E06_delta_synapse.runs/impl_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
/bin/touch .init_design.begin.rst
EAStep vivado -log top_basys3.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source top_basys3.tcl -notrace



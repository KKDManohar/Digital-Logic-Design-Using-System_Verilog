vlib work
vdel -all
vlib work

vlog -lint -source "ALU_Packages.sv"
vlog -lint -source "ALU_Design.sv"
vlog -lint -source "uvm_architecture.sv"


vsim -c -voptargs=+acc work.tb

run -all


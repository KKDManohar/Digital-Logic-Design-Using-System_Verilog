vlib work
vdel -all
vlib work

vlog -lint -source "d_ff.sv"
vlog -lint -source "uvm_environment.sv"

vsim -c -voptargs=+acc work.tb

run -all
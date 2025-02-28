vlib work
vdel -all
vlib work

vlog -lint -source "mul.sv"
vlog -lint -source "uvm_architecture.sv"
vlog -lint -source "tb_top.sv"

vsim -c -voptargs=+acc work.tb

#add wave -r *

run -all


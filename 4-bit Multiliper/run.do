vlib work
vdel -all
vlib work

vlog -lint -source "HalfAdder.sv"
vlog -lint -source "FullAdder.sv"
vlog -lint -source "Multplier.sv"
vlog -lint -source "Multiplier_tb.sv"

vsim -c -voptargs=+acc work.tb
vsim -coverage tb -voptargs="+cover=bcesf"

#add wave -r *

run -all
coverage report -code bcesf
coverage report -codeAll
coverage report -assert -binrhs -details -cvg



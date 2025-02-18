vlib work
vdel -all
vlib work 


vlog -lint -source "Full_Adder.sv"
vlog -lint -source "carry_generator.sv"
vlog -lint -source "top.sv"
vlog -lint -source "Carry_tb.sv"

vsim -c -voptargs=+acc work.tb 
vsim -coverage tb -voptargs="+cover=bcesf"

#add wave -r *

run -all
coverage report -code bcesf
coverage report -codeAll
coverage report -assert -binrhs -details -cvg


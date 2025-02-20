vlib work
vdel -all
vlib work

vlog -lint -source "Full_Adder.sv"
vlog -lint -source "Adder_Sub.sv"
vlog -lint -source "adder_sub_tb.sv"

vsim -c -voptargs=+acc work.top
vsim -coverage top -voptargs="+cover=bcesf"

#add wave -r *

run -all 
coverage report -code bcesf
coverage report -codeAll
coverage report -assert -binrhs -details -cvg
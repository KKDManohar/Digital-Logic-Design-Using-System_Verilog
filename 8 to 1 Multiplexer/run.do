vlib work

vlog -lint -source "multiplexer.sv"
vlog -lint -source "mux_tb.sv"

vsim -voptargs=+acc work.top
#vsim -coverage top -voptargs="+cover=bcesf"

#add wave -r *

run -all
#coverage report -code bcesf
#coverage report -codeAll
#coverage report -assert -binrhs -details -cvg
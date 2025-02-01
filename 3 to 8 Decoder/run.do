vlib work
vdel -all
vlib work

vlog -lint -source "3to8decoder.sv"
vlog -lint -source "decoder_tb.sv"

vsim -c -voptargs=+acc work.top
vsim -coverage top -voptargs="+cover=bcesf"

#add wave -r *

run -all

coverage report -code bcesf
coverage report -codeAll
coverage report -assert -binrhs -details -cvg




vlib work
vdel -all
vlib work

vlog -lint -source ALU_Packages.sv
vlog -lint -source ALU_Design.sv
vlog -lint -source tb_ALU.sv


vsim -c -voptargs=+acc work.top

add wave -r *
add wave sim:/top/DUT.mul_done1
add wave sim:/top/DUT.mul_done2

run -all

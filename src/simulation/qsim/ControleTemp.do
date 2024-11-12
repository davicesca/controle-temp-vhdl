onerror {quit -f}
vlib work
vlog -work work ControleTemp.vo
vlog -work work ControleTemp.vt
vsim -novopt -c -t 1ps -L max7000s_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.ControleTemp_vlg_vec_tst
vcd file -direction ControleTemp.msim.vcd
vcd add -internal ControleTemp_vlg_vec_tst/*
vcd add -internal ControleTemp_vlg_vec_tst/i1/*
add wave /*
run -all

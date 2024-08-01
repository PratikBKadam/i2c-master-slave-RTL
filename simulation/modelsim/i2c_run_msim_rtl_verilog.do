transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+G:/pratik/Pratik\ IMP\ documents/COEP/College/VLSI/i2c/i2c_slave {G:/pratik/Pratik IMP documents/COEP/College/VLSI/i2c/i2c_slave/i2c_slave_datapath.v}
vlog -vlog01compat -work work +incdir+G:/pratik/Pratik\ IMP\ documents/COEP/College/VLSI/i2c/i2c_slave {G:/pratik/Pratik IMP documents/COEP/College/VLSI/i2c/i2c_slave/i2c_slave_controlpath.v}
vlog -vlog01compat -work work +incdir+G:/pratik/Pratik\ IMP\ documents/COEP/College/VLSI/i2c/i2c_slave {G:/pratik/Pratik IMP documents/COEP/College/VLSI/i2c/i2c_slave/i2c_slave.v}
vlog -vlog01compat -work work +incdir+G:/pratik/Pratik\ IMP\ documents/COEP/College/VLSI/i2c/i2c_master {G:/pratik/Pratik IMP documents/COEP/College/VLSI/i2c/i2c_master/i2c_master_datapath.v}
vlog -vlog01compat -work work +incdir+G:/pratik/Pratik\ IMP\ documents/COEP/College/VLSI/i2c/i2c_master {G:/pratik/Pratik IMP documents/COEP/College/VLSI/i2c/i2c_master/i2c_master_controlpath.v}
vlog -vlog01compat -work work +incdir+G:/pratik/Pratik\ IMP\ documents/COEP/College/VLSI/i2c/i2c_master {G:/pratik/Pratik IMP documents/COEP/College/VLSI/i2c/i2c_master/i2c_master.v}
vlog -vlog01compat -work work +incdir+G:/pratik/Pratik\ IMP\ documents/COEP/College/VLSI/i2c {G:/pratik/Pratik IMP documents/COEP/College/VLSI/i2c/i2c.v}

vlog -vlog01compat -work work +incdir+G:/pratik/Pratik\ IMP\ documents/COEP/College/VLSI/i2c {G:/pratik/Pratik IMP documents/COEP/College/VLSI/i2c/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all
module i2c(
input rst,clk,
inout sda,
output scl,
input read, // read=1'b1 write=1'b0
input [7:0] data_send_master,
input data_send_master_enable,
input [6:0]slave_address,
output[7:0] data_receive_master,
output data_receive_master_enable,
output error_master,
input [7:0] data_send_slave,
input data_send_slave_enable,
output [7:0] data_receive_slave,
output data_receive_slave_enable,
output error_slave
);

i2c_master 
u1(
	.rst(rst),
	.clk(clk),
	.read(read), 
	.sda(sda),
	.scl(scl),
	.data_send_master(data_send_master),
	.data_send_master_enable(data_send_master_enable),
	.slave_address(slave_address),
	.data_receive_master(data_receive_master),
	.data_receive_master_enable(data_receive_master_enable),
	.error_master(error_master)
);
i2c_slave 
u2(
	.rst(rst),
	.clk(clk),
	.sda(sda),
	.scl(scl),
	.data_send_slave(data_send_slave),
	.data_send_slave_enable(data_send_slave_enable),
	.data_receive_slave(data_receive_slave),
	.data_receive_slave_enable(data_receive_slave_enable),
	.error_slave(error_slave)
);
endmodule

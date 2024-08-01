module tb;
reg rst,clk;
wire sda;
wire scl;
reg read; // read=1'b1 write=1'b0
reg [7:0] data_send_master;
reg data_send_master_enable;
reg [6:0]slave_address;
wire[7:0] data_receive_master;
wire data_receive_master_enable;
wire error_master;
reg [7:0] data_send_slave;
reg data_send_slave_enable;
wire [7:0] data_receive_slave;
wire data_receive_slave_enable;
wire error_slave;
i2c dut(
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
	.error_master(error_master),
	.data_send_slave(data_send_slave),
	.data_send_slave_enable(data_send_slave_enable),
	.data_receive_slave(data_receive_slave),
	.data_receive_slave_enable(data_receive_slave_enable),
	.error_slave(error_slave)
);
initial begin
clk=1;
forever #5 clk=~clk;
end
initial begin
rst=0;
read=0;
data_send_master=8'h00;
slave_address=7'h00;
data_send_master_enable=0;
data_send_slave=8'h00;
data_send_slave_enable=1'b0;
#20;
rst=1'b1;
#20;
data_send_master=8'h93;
slave_address=7'h4b;
data_send_master_enable=1;
#20;
data_send_master=8'h00;
slave_address=7'h00;
data_send_master_enable=0;
#520;
data_send_slave=8'h93;
slave_address=7'h4b;
data_send_slave_enable=1;
read=1;
#20;
data_send_slave=8'h00;
slave_address=7'h00;
data_send_slave_enable=0;
read=0;
#520;
$stop;
end
endmodule

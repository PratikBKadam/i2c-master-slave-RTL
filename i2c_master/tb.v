module tb;
reg rst,clk,read;
reg lane;
wire sda;
wire scl;
reg [7:0] data_send_master;
reg [6:0]slave_address;
reg data_send_master_enable;
wire [7:0] data_receive_master;
wire data_receive_master_enable;
wire error_master;
i2c_master dut(
.rst(rst),
.clk(clk),
.read(read),
.sda(sda),
.scl(scl),
.data_send_master(data_send_master),
.data_send_master_enable(data_send_master_enable),
.data_receive_master(data_receive_master),
.data_receive_master_enable(data_receive_master_enable),
.slave_address(slave_address),
.error_master(error_master)
);
assign sda=lane;
initial begin
	clk<=1'b1;
	forever #5 clk<=~clk;
	#500;
	$stop;
end
initial begin
	rst<=0;
	data_send_master<=8'h00;
	data_send_master_enable<=1'b0;
	slave_address<=7'h00;
	read<=1'b0;
	lane<=1'bz;
	#20;
	rst<=1;
	#20;
	slave_address<=7'b1001011;
	data_send_master<=8'h93;
	data_send_master_enable<=1'b1;
	#20;
	slave_address<=7'h00;
	data_send_master<=8'h00;
	data_send_master_enable<=1'b0;
	#161;
	lane<=1'b0;
	#18;
	lane<=1'bz;
	#162;
	lane<=1'b0;
	#18;
	lane<=1'bz;
	#31;
	#110;
	slave_address<=7'b1001011;
	read<=1'b1;
	#20;
	slave_address<=7'h00;
	read<=1'b0;
	#161;
	lane<=1'b0;
	#18;
	lane<=1'b1;
	#20;
	lane<=1'b0;
	#20;
	lane<=1'b1;
	#20;
	lane<=1'b0;
	#20;
	lane<=1'b1;
	#20;
	lane<=1'b1;
	#20;
	lane<=1'b0;
	#20;
	lane<=1'b1;
	#18;
	lane<=1'bz;
	#500;
	$stop;
end
endmodule

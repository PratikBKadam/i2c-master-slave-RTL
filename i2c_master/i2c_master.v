module i2c_master(
input rst,clk,read, // read=1'b1 write=1'b0
inout sda,
output reg scl,
input [7:0] data_send_master,
input data_send_master_enable,
input [6:0]slave_address,
output [7:0] data_receive_master,
output data_receive_master_enable,
output error_master
);
wire rw;
wire [2:0]count_receive;
wire [2:0]count,state;
wire ack;
wire clk1;

wire sda_out,rstscl;
wire read_data;

wire sda_in;

reg clk_data;
assign sda=rw?1'bz:sda_out;
assign sda_in=sda;
assign clk1=clk_data;
always@(negedge clk or negedge rstscl) 
begin
	if(!rstscl)
	begin
		scl<=1'b1;
	end
	else
	begin
		scl<=~scl;
	end
end
always@(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		clk_data<=1'b0;
	end
	else
	begin
		clk_data<=~clk_data;
	end
end
i2c_master_controlpath u1
(
	.rst(rst),
	.read(read),
	.clk1(clk1),
	.read_data(read_data),
	.data_send_master_enable(data_send_master_enable),
	.count(count),
	.state(state),
	.rw(rw),
	.ack(ack),
	.count_receive(count_receive),
	.error_master(error_master)
);
i2c_master_datapath u2
(
	.rst(rst),
	.clk1(clk1),
	.read(read),
	.data_send_master_enable(data_send_master_enable),
	.data_receive_master_enable(data_receive_master_enable),
	.data_send_master(data_send_master),
	.data_receive_master(data_receive_master),
	.state(state),
	.count(count),
	.read_data(read_data),
	.sda_in(sda_in),
	.sda_out(sda_out),
	.rstscl(rstscl),
	.slave_address(slave_address),
	.ack(ack),
	.count_receive(count_receive)
);

endmodule

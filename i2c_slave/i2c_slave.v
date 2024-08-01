module i2c_slave
(
	input rst,clk,
	inout sda,
	input scl,
	input [7:0] data_send_slave,
	input data_send_slave_enable,
	output [7:0] data_receive_slave,
	output data_receive_slave_enable,
	output error_slave
);

parameter address_slave=7'b1001011;
wire rw;
wire [2:0]state,count,count_receive;
wire clk1,error_detected,ack,master_read;
wire sda_in,sda_out;
reg clk_data;
always @(posedge clk or negedge rst)
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
assign clk1=clk_data;
assign sda=rw?1'bz:sda_out;
assign sda_in=sda;
i2c_slave_datapath u1(
.rst(rst),
.clk1(clk1),
.clk(clk),
.data_send_slave_enable(data_send_slave_enable),
.data_receive_slave_enable(data_receive_slave_enable),
.data_send_slave(data_send_slave),
.data_receive_slave(data_receive_slave),
.state(state),
.count(count),
.count_receive(count_receive),
.sda_in(sda_in),
.sda_out(sda_out),
.ack(ack),
.error_detected(error_detected),
.master_read(master_read)
);
i2c_slave_controlpath u2(
.rst(rst),
.clk1(clk1),
.sda_in(sda_in),
.count(count),
.count_receive(count_receive),
.state(state),
.rw(rw),
.ack(ack),
.error_detected(error_detected),
.master_read(master_read),
.error_slave(error_slave)
);
endmodule

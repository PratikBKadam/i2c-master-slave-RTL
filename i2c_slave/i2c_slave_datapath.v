module i2c_slave_datapath
(
	input rst,clk1,clk,
	input data_send_slave_enable,
	output data_receive_slave_enable,
	input [7:0]data_send_slave,
	output [7:0]data_receive_slave,
	input [2:0]state,
	output [2:0]count,count_receive,
	input sda_in,
	output sda_out,
	output ack,error_detected,master_read
);
reg data_receive_slave_enable_reg,sda_out_reg;
reg [2:0]count_reg,count_receive_reg;
reg [7:0]data_send_slave_reg,data_receive_slave_reg;
reg [6:0]address_received;
reg ack_reg,error_detected_reg,master_read_reg;

parameter idle=3'h0,start=3'h1,address=3'h3,acknowledge1=3'h2,data=3'h6,acknowledge2=3'h7,stop=3'h5;
parameter address_slave=7'b1001011;

assign count=count_reg;
assign count_receive=count_receive_reg;
assign data_receive_slave=data_receive_slave_reg;
assign data_receive_slave_enable=data_receive_slave_enable_reg;
assign sda_out=sda_out_reg;
assign ack=ack_reg;
assign error_detected=error_detected_reg;
assign master_read=master_read_reg;

always@(posedge clk1 or negedge rst)
begin
	if(!rst)
	begin
		sda_out_reg<=1'b0;
		count_reg<=3'h0;
		count_receive_reg<=3'h0;
	end
	else
	begin
		case(state)
		idle:
		begin
			if(sda_in==1'b0)
			begin
				sda_out_reg<=1'b0;
				count_reg<=3'h0;
				count_receive_reg<=3'h0;
			end
			else
			begin
				sda_out_reg<=1'b0;
				count_reg<=3'h0;
				count_receive_reg<=3'h0;
			end
		end
		start:
		begin
		end
		address:
		begin
			case(count_receive_reg)
				3'h0:
				begin
					count_receive_reg<=3'h1;
				end
				3'h1:
				begin
					count_receive_reg<=3'h3;
				end
				3'h3:
				begin
					count_receive_reg<=3'h2;
				end
				3'h2:
				begin
					count_receive_reg<=3'h6;
				end
				3'h6:
				begin
					count_receive_reg<=3'h7;
				end
				3'h7:
				begin
					count_receive_reg<=3'h5;
				end
				3'h5:
				begin
					count_receive_reg<=3'h4;
				end
				3'h4:
				begin
					count_receive_reg<=3'h0;
				end
			endcase
		end
		acknowledge1:
		begin
			if(master_read==1'b1)
			begin
				sda_out_reg<=data_send_slave_reg[7];
				
			end
			else
			begin
				sda_out_reg<=1'b0;
				count_receive_reg<=3'h0;
			end
		end
		data:
		begin
			if(master_read==1'b1)
			begin
				case(count)
				3'h0:
				begin
					sda_out_reg<=data_send_slave_reg[6];
					count_reg<=3'h1;
				end
				3'h1:
				begin
					sda_out_reg<=data_send_slave_reg[5];
					count_reg<=3'h3;
				end
				3'h3:
				begin
					sda_out_reg<=data_send_slave_reg[4];
					count_reg<=3'h2;
				end
				3'h2:
				begin
					sda_out_reg<=data_send_slave_reg[3];
					count_reg<=3'h6;
				end
				3'h6:
				begin
					sda_out_reg<=data_send_slave_reg[2];
					count_reg<=3'h7;
				end
				3'h7:
				begin
					sda_out_reg<=data_send_slave_reg[1];
					count_reg<=3'h5;
				end
				3'h5:
				begin
					sda_out_reg<=data_send_slave_reg[0];
					count_reg<=3'h4;
				end
				3'h4:
				begin
					count_reg<=3'h0;
				end
				endcase
			end
			else
			begin
				case(count_receive_reg)
				3'h0:
				begin
					count_receive_reg<=3'h1;
				end
				3'h1:
				begin
					count_receive_reg<=3'h3;
				end
				3'h3:
				begin
					count_receive_reg<=3'h2;
				end
				3'h2:
				begin
					count_receive_reg<=3'h6;
				end
				3'h6:
				begin
					count_receive_reg<=3'h7;
				end
				3'h7:
				begin
					count_receive_reg<=3'h5;
				end
				3'h5:
				begin
					count_receive_reg<=3'h4;
				end
				3'h4:
				begin
					count_receive_reg<=3'h0;
				end
				endcase
			end
		end
		acknowledge2:
		begin
			sda_out_reg<=1'b0;
			count_receive_reg<=3'h0;
		end
		stop:
		begin
			sda_out_reg<=1'b1;
			count_reg<=3'h0;
			count_receive_reg<=3'h0;
		end
		endcase
	end
end
always@(posedge clk1 or negedge rst)
begin
	if(!rst)
	begin
		data_send_slave_reg<=8'h00;
	end
	else
	begin
		if(data_send_slave_enable==1'b1)
		begin
			data_send_slave_reg<=data_send_slave;
		end
	end
end

always @(negedge clk1 or negedge rst)
begin
	if(!rst)
	begin
		address_received<=7'h00;
		data_receive_slave_reg<=8'h00;
		data_receive_slave_enable_reg<=1'b0;
		master_read_reg<=1'b0;
	end
	else
	begin
		case(state)
		idle:
		begin
			address_received<=7'h00;
			data_receive_slave_reg<=8'h00;
			data_receive_slave_enable_reg<=1'b0;
			master_read_reg<=1'b0;
		end
		start:
		begin
		end
		address:
		begin
			case(count_receive_reg)
				3'h0:
				begin
					address_received[6]<=sda_in;
				end
				3'h1:
				begin
					address_received[5]<=sda_in;
				end
				3'h3:
				begin
					address_received[4]<=sda_in;
				end
				3'h2:
				begin
					address_received[3]<=sda_in;
				end
				3'h6:
				begin
					address_received[2]<=sda_in;
				end
				3'h7:
				begin
					address_received[1]<=sda_in;
				end
				3'h5:
				begin
					address_received[0]<=sda_in;
				end
				3'h4:
				begin
					master_read_reg<=sda_in;
				end
			endcase
		end
		acknowledge1:
		begin
		end
		data:
		begin
			if(master_read==1'b0)
			begin
				case(count_receive_reg)
				3'h0:
				begin
					data_receive_slave_reg[7]<=sda_in;
				end
				3'h1:
				begin
					data_receive_slave_reg[6]<=sda_in;
				end
				3'h3:
				begin
					data_receive_slave_reg[5]<=sda_in;
				end
				3'h2:
				begin
					data_receive_slave_reg[4]<=sda_in;
				end
				3'h6:
				begin
					data_receive_slave_reg[3]<=sda_in;
				end
				3'h7:
				begin
					data_receive_slave_reg[2]<=sda_in;
				end
				3'h5:
				begin
					data_receive_slave_reg[1]<=sda_in;
				end
				3'h4:
				begin
					data_receive_slave_reg[0]<=sda_in;
					data_receive_slave_enable_reg<=1'b1;
				end
				endcase
			end
			else
			begin
				data_receive_slave_reg<=8'h00;
				
			end
		end
		acknowledge2:
		begin
			if(master_read==1'b0)
			begin
				data_receive_slave_reg<=8'h00;
				data_receive_slave_enable_reg<=1'b0;
			end
			else
			begin
				data_receive_slave_reg<=8'h00;
				data_receive_slave_enable_reg<=1'b0;
			end
		end
		stop:
		begin
			address_received<=7'h00;
			data_receive_slave_reg<=8'h00;
			data_receive_slave_enable_reg<=1'b0;
			master_read_reg<=1'b0;
		end
		endcase
	end
end
always @(negedge clk1 or negedge rst)
begin
	if(!rst)
	begin
		ack_reg<=1'b0;
	end
	else
	begin
		if(state==acknowledge1)
		begin
			if(sda_in==1'b0)
			begin
				ack_reg<=1'b1;
			end
			else
			begin
				ack_reg<=1'b0;
			end
		end
		else if(state==acknowledge2 && master_read==1'b1)
		begin
			if(sda_in==1'b0)
			begin
				ack_reg<=1'b1;
			end
			else
			begin
				ack_reg<=1'b0;
			end
		end
		else
		begin
			ack_reg<=1'b0;
		end
	end
end

always @(negedge clk1 or negedge rst)
begin
	if(!rst)
	begin
		error_detected_reg<=1'b0;
	end
	else
	begin
		if(state==data && count==3'h4)
		begin
			if(address_received==address_slave)
			begin
				error_detected_reg<=1'b0;
			end
			else
			begin
				error_detected_reg<=1'b1;
			end
		end
		else
		begin
			error_detected_reg<=1'b0;
		end
	end
end
endmodule
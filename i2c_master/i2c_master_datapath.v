module i2c_master_datapath
(
	input rst,clk1,read,
	input data_send_master_enable,
	input [7:0]data_send_master,
	output [7:0]data_receive_master,
	input [2:0]state,
	output [2:0]count,
	output read_data,
	input sda_in,
	output sda_out,
	output rstscl,
	input [6:0]slave_address,
	output ack,
	output [2:0]count_receive,
	output data_receive_master_enable
);
reg sda_out_reg,rstscl_reg,ack_reg,read_reg,data_receive_master_enable_reg;
reg [7:0]data_send_master_reg,data_receive_master_reg;
reg [6:0]slave_address_reg;
reg [2:0] count_reg,count_receive_reg;
parameter idle=3'h0,start=3'h1,address=3'h3,acknowledge1=3'h2,data=3'h6,acknowledge2=3'h7,stop=3'h5;
assign read_data=read_reg;
assign count=count_reg;
assign data_receive_master=data_receive_master_reg;
assign sda_out=sda_out_reg;
assign rstscl=rstscl_reg;
assign ack=ack_reg;
assign count_receive=count_receive_reg;
assign data_receive_master_enable=data_receive_master_enable_reg;
always@(posedge clk1 or negedge rst)
begin
	if(!rst)
	begin
		read_reg<=1'b0;
		sda_out_reg<=1'b1;
		count_reg<=3'h0;
		slave_address_reg<=7'h00;
		data_send_master_reg<=8'h00;
	end
	else
	begin
		case(state)
			idle:
			begin
				if(data_send_master_enable==1'b1 && read==1'b0)
				begin
					read_reg<=1'b0;
					sda_out_reg<=1'b0;
					count_reg<=3'h0;
					data_send_master_reg<=data_send_master;
					slave_address_reg<=slave_address;
				end
				else if(data_send_master_enable==1'b0 && read==1'b1)
				begin
					read_reg<=1'b1;
					sda_out_reg<=1'b0;
					count_reg<=3'h0;
					slave_address_reg<=slave_address;
					data_send_master_reg<=8'h00;
				end
				else
				begin
					read_reg<=1'b0;
					sda_out_reg<=1'b1;
					count_reg<=3'h0;
					slave_address_reg<=7'h00;
					data_send_master_reg<=8'h00;
				end
			end
			start:
			begin
				sda_out_reg<=slave_address_reg[6];
				count_reg<=3'h0;
			end
			address:
			begin
				case(count)
				3'h0:
				begin
					sda_out_reg<=slave_address_reg[5];
					count_reg<=3'h1;
				end
				3'h1:
				begin
					sda_out_reg<=slave_address_reg[4];
					count_reg<=3'h3;
				end
				3'h3:
				begin
					sda_out_reg<=slave_address_reg[3];
					count_reg<=3'h2;
				end
				3'h2:
				begin
					sda_out_reg<=slave_address_reg[2];
					count_reg<=3'h6;
				end
				3'h6:
				begin
					sda_out_reg<=slave_address_reg[1];
					count_reg<=3'h7;
				end
				3'h7:
				begin
					sda_out_reg<=slave_address_reg[0];
					count_reg<=3'h5;
				end
				3'h5:
				begin
					sda_out_reg<=read_reg;
					count_reg<=3'h4;
				end
				3'h4:
				begin
					count_reg<=3'h0;
				end
				endcase
			end
			acknowledge1:
			begin
				if(!read_reg)
				begin
					sda_out_reg<=data_send_master_reg[7];
					count_reg<=3'h0;
				end
				
			end
			data:
			begin
				if(read_reg)
				begin
					if(count_receive==3'h4)
					begin
						sda_out_reg<=1'b0;
					end
				end
				else
				begin
					case(count)
					3'h0:
					begin
						sda_out_reg<=data_send_master_reg[6];
						count_reg<=3'h1;
					end
					3'h1:
					begin
						sda_out_reg<=data_send_master_reg[5];
						count_reg<=3'h3;
					end
					3'h3:
					begin
						sda_out_reg<=data_send_master_reg[4];
						count_reg<=3'h2;
					end
					3'h2:
					begin
						sda_out_reg<=data_send_master_reg[3];
						count_reg<=3'h6;
					end
					3'h6:
					begin
						sda_out_reg<=data_send_master_reg[2];
						count_reg<=3'h7;
					end
					3'h7:
					begin
						sda_out_reg<=data_send_master_reg[1];
						count_reg<=3'h5;
					end
					3'h5:
					begin
						sda_out_reg<=data_send_master_reg[0];
						count_reg<=3'h4;
					end
					3'h4:
					begin
						count_reg<=3'h0;
					end
					endcase
				end
			end
			acknowledge2:
			begin
				sda_out_reg<=1'b0;
			end	
			stop:
			begin
				read_reg<=1'b0;
				sda_out_reg<=1'b1;
				count_reg<=3'h0;
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
		if((state==acknowledge1) || state==(acknowledge2))
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
always@(negedge clk1 or negedge rst)
begin
	if(!rst)
	begin
		rstscl_reg<=1'b0;
	end
	else
	begin
		if(state==start)
		begin
			rstscl_reg<=1'b1;
		end
		else if(state==stop)
		begin
			rstscl_reg<=1'b0;
		end
		else
		begin
			rstscl_reg<=rstscl_reg;
		end
	end
end
always@(negedge clk1 or negedge rst)
begin
	if(!rst)
	begin
		count_receive_reg<=3'h0;
		data_receive_master_reg<=8'h00;
		data_receive_master_enable_reg<=1'b0;
	end
	else
	begin
		if(read_reg)
		begin
			if(state==acknowledge1)
			begin
				count_receive_reg<=3'h0;
				data_receive_master_enable_reg<=1'b0;
			end
			else if(state==data)
			begin
				case(count_receive)
					3'h0:
					begin
						data_receive_master_reg[7]<=sda_in;
						count_receive_reg<=3'h1;
					end
					3'h1:
					begin
						data_receive_master_reg[6]<=sda_in;
						count_receive_reg<=3'h3;
					end
					3'h3:
					begin
						data_receive_master_reg[5]<=sda_in;
						count_receive_reg<=3'h2;
					end
					3'h2:
					begin
						data_receive_master_reg[4]<=sda_in;
						count_receive_reg<=3'h6;
					end
					3'h6:
					begin
						data_receive_master_reg[3]<=sda_in;
						count_receive_reg<=3'h7;
					end
					3'h7:
					begin
						data_receive_master_reg[2]<=sda_in;
						count_receive_reg<=3'h5;
					end
					3'h5:
					begin
						data_receive_master_reg[1]<=sda_in;
						count_receive_reg<=3'h4;
					end
					3'h4:
					begin
						count_receive_reg<=3'h0;
					end
				endcase
			end
			else if(state==acknowledge2)
			begin
				data_receive_master_reg[0]<=sda_in;
				count_receive_reg<=3'h0;
				data_receive_master_enable_reg<=1'b1;
			end
			else if(state==stop)
			begin
				data_receive_master_reg<=8'h00;
				data_receive_master_enable_reg<=1'b0;
			end
			else
			begin
				data_receive_master_reg<=8'h00;
				count_receive_reg<=3'h0;
				data_receive_master_enable_reg<=1'b0;
			end
		end
		else
		begin
			count_receive_reg<=3'h0;
			data_receive_master_reg<=8'h00;
			data_receive_master_enable_reg<=1'b0;
		end
	end
end
endmodule

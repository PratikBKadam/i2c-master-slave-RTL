module i2c_master_controlpath
(	input read,
	input rst,clk1,read_data,
	input [2:0]count,count_receive,
	input data_send_master_enable,
	output [2:0]state,
	output rw,
	input ack,
	output error_master
);
reg [2:0]present_state;
reg rw_reg,error_master_reg;
parameter idle=3'h0,start=3'h1,address=3'h3,acknowledge1=3'h2,data=3'h6,acknowledge2=3'h7,stop=3'h5;
assign state=present_state;
assign error_master=error_master_reg;
assign rw=rw_reg;
always @(posedge clk1 or negedge rst)
begin
	if(!rst)
	begin
		rw_reg<=1'b0;
		error_master_reg<=1'b0;
		present_state<=idle;
	end
	else
	begin
		case(present_state)
		idle:
		begin
			if(data_send_master_enable==1'b1 ^ read==1'b1)
			begin
				rw_reg<=1'b0;
				error_master_reg<=1'b0;
				present_state<=start;
			end
			else
			begin
				rw_reg<=1'b0;
				error_master_reg<=1'b0;
				present_state<=idle;
			end
		end
		start:
		begin
			present_state<=address;
		end
		address:
		begin
			if(count==3'h4)
			begin	
				rw_reg<=1'b1;
				present_state<=acknowledge1;
			end
			else
			begin
				rw_reg<=1'b0;
				present_state<=address;
			end
		end
		acknowledge1:
		begin
			if(ack)
			begin
				if(read_data)
				begin
					rw_reg<=1'b1;
					error_master_reg<=1'b0;
					present_state<=data;
				end
				else
				begin
					rw_reg<=1'b0;
					error_master_reg<=1'b0;
					present_state<=data;
				end
			end
			else
			begin
				rw_reg<=1'b0;
				error_master_reg<=1'b1;
				present_state<=stop;
			end
		end
		data:
		begin
			if(read_data)
			begin
				if(count_receive==3'h4)
				begin
					rw_reg<=1'b1;
					present_state<=acknowledge2;
				end
				else
				begin
					rw_reg<=1'b1;
					present_state<=data;
				end
			end
			else
			begin
				if(count==3'h4)
				begin
					rw_reg<=1'b1;
					present_state<=acknowledge2;
				end
				else
				begin
					present_state<=data;
				end
			end
		end
		acknowledge2:
		begin
			if(!read_data)
			begin
				if(ack)
				begin
					rw_reg<=1'b0;
					error_master_reg<=1'b0;
					present_state<=stop;
				end
				else
				begin
					rw_reg<=1'b0;
					error_master_reg<=1'b1;
					present_state<=stop;
				end
			end
			else
			begin
				rw_reg<=1'b0;
				present_state<=stop;
			end
		end
		stop:
		begin
			rw_reg<=1'b0;
			present_state<=idle;
		end
		endcase
	end
end
endmodule

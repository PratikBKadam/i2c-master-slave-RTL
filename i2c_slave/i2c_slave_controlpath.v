module i2c_slave_controlpath
(
	input rst,clk1,sda_in,
	input [2:0]count,count_receive,
	output [2:0]state,
	output rw,
	input ack,error_detected,master_read,
	output error_slave
);
reg rw_reg;
reg [2:0] present_state;
reg error_reg;
parameter idle=3'h0,start=3'h1,address=3'h3,acknowledge1=3'h2,data=3'h6,acknowledge2=3'h7,stop=3'h5;
assign error_slave=error_reg;
assign rw=rw_reg;
assign state=present_state;

always@(posedge clk1 or negedge rst)
begin
	if(!rst)
	begin
		rw_reg<=1'b1;
		error_reg<=1'b0;
		present_state<=idle;
	end
	else
	begin
		case(present_state)
		idle:
		begin
			if(sda_in==1'b0)
			begin
				rw_reg<=1'b1;
				error_reg<=1'b0;
				present_state<=address;
			end
			else
			begin
				rw_reg<=1'b1;
				error_reg<=1'b0;
				present_state<=idle;
			end
		end
		start:
		begin
		end
		address:
		begin
			if(count_receive==3'h4)
			begin	
				rw_reg<=1'b0;
				present_state<=acknowledge1;
			end
			else
			begin
				rw_reg<=1'b1;
				present_state<=address;
			end
		end
		acknowledge1:
		begin
			if(error_detected==1'b1)
			begin
				rw_reg<=1'b1;
				error_reg<=1'b1;
				present_state<=stop;
			end
			else
			begin
				if(master_read==1'b1)
				begin
					rw_reg<=1'b0;
					error_reg<=1'b0;
					present_state<=data;
				end
				else
				begin
					rw_reg<=1'b1;
					error_reg<=1'b0;
					present_state<=data;
				end
			end
		end
		data:
		begin
			if(master_read==1'b1)
			begin
				if(count==3'h4)
				begin
					rw_reg<=1'b1;
					present_state<=acknowledge2;
				end
				else
				begin
					rw_reg<=1'b0;
					present_state<=data;
				end
			end
			else
			begin
				if(count_receive==3'h4)
				begin
					rw_reg<=1'b0;
					present_state<=acknowledge2;
				end
				else
				begin
					rw_reg<=1'b1;
					present_state<=data;
				end
			end
		end
		acknowledge2:
		begin
				rw_reg<=1'b1;
				error_reg<=1'b0;
				present_state<=stop;
		end
		stop:
		begin
			if(master_read==1'b1)
			begin
				if(ack)
				begin
					rw_reg<=1'b1;
					error_reg<=1'b0;
					present_state<=idle;
				end
				else
				begin
					rw_reg<=1'b1;
					error_reg<=1'b1;
					present_state<=idle;
				end
			end
			else
			begin
				rw_reg<=1'b1;
				error_reg<=1'b0;
				present_state<=idle;
			end
		end
		endcase
	end
end

endmodule

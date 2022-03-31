/******************************************************************/
//MODULE:		geofence
//FILE NAME:	geofence.v
//VERSION:		1.0
//DATE:			march,2021
//AUTHOR: 		charlotte-mu
//CODE TYPE:	RTL
//DESCRIPTION:	2021 University/College IC Design Contest
//
//MODIFICATION HISTORY:
// VERSION Date Description
// 1.0 03/24/2021 testpattern all pass
/******************************************************************/
module geofence ( clk,reset,X,Y,valid,is_inside);
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
output reg valid;
output is_inside;

reg [9:0]x_data[6:0];
reg [9:0]y_data[6:0];
reg [2:0]data_mode;
reg signed [10:0]ax,ay,bx,by;
reg signed [10:0]ax_next,ay_next,bx_next,by_next;
reg fit,fit_next;

reg signed [21:0]ax_by,ay_bx;
reg signed [21:0]ax_by_next,ay_bx_next;

wire signed [21:0]ans;
reg [4:0]count,count_next;
reg [4:0]fsm,fsm_next;

reg signed [10:0]xinA,xinB;
wire signed [21:0]xans;
assign xans = xinA * xinB;

wire [4:0]count_ans,count2;
assign count_ans = count + 5'd1;
assign count2 = count + 5'd2;

reg [21:0]sainA,sainB;
wire [21:0]saans;
assign saans = sainA - sainB;

reg [9:0]sbinA,sbinB;
wire [10:0]sbans;
assign sbans = sbinA - sbinB;

assign is_inside = ~fit;


always@(posedge clk,posedge reset)
if(reset)
begin
	x_data[0] <= 10'd0;
	x_data[1] <= 10'd0;
	x_data[2] <= 10'd0;
	x_data[3] <= 10'd0;
	x_data[4] <= 10'd0;
	x_data[5] <= 10'd0;
	x_data[6] <= 10'd0;
	y_data[0] <= 10'd0;
	y_data[1] <= 10'd0;
	y_data[2] <= 10'd0;
	y_data[3] <= 10'd0;
	y_data[4] <= 10'd0;
	y_data[5] <= 10'd0;
	y_data[6] <= 10'd0;
	
	ax <= 11'd0;
	ay <= 11'd0;
	bx <= 11'd0;
	by <= 11'd0;
	count <= 5'd0;
	fsm <= 5'd0;
	ax_by <= 22'd0;
	ay_bx <= 22'd0;
	fit <= 1'b0; 
end
else
begin
	ax <= ax_next;
	ay <= ay_next;
	bx <= bx_next;
	by <= by_next;
	count <= count_next;
	fsm <= fsm_next;
	ax_by <= ax_by_next;
	ay_bx <= ay_bx_next;
	fit <= fit_next;
	
	case(data_mode)	//synopsys parallel_case
		default:
		begin
			x_data[0] <= x_data[0];
			x_data[1] <= x_data[1];
			x_data[2] <= x_data[2];
			x_data[3] <= x_data[3];
			x_data[4] <= x_data[4];
			x_data[5] <= x_data[5];
			x_data[6] <= x_data[6];
			             
			y_data[0] <= y_data[0];
			y_data[1] <= y_data[1];
			y_data[2] <= y_data[2];
			y_data[3] <= y_data[3];
			y_data[4] <= y_data[4];
			y_data[5] <= y_data[5];
			y_data[6] <= y_data[6];
		end
		3'd1:
		begin
			x_data[0] <= x_data[1];
			x_data[1] <= x_data[2];
			x_data[2] <= x_data[3];
			x_data[3] <= x_data[4];
			x_data[4] <= x_data[5];
			x_data[5] <= x_data[6];
			x_data[6] <= X;
			
			y_data[0] <= y_data[1];
			y_data[1] <= y_data[2];
			y_data[2] <= y_data[3];
			y_data[3] <= y_data[4];
			y_data[4] <= y_data[5];
			y_data[5] <= y_data[6];
			y_data[6] <= Y;
		end
		3'd2:
		begin
			x_data[0] <= 10'd0;
			x_data[1] <= 10'd0;
			x_data[2] <= 10'd0;
			x_data[3] <= 10'd0;
			x_data[4] <= 10'd0;
			x_data[5] <= 10'd0;
			x_data[6] <= 10'd0;
			             
			y_data[0] <= 10'd0;
			y_data[1] <= 10'd0;
			y_data[2] <= 10'd0;
			y_data[3] <= 10'd0;
			y_data[4] <= 10'd0;
			y_data[5] <= 10'd0;
			y_data[6] <= 10'd0;
		end
		3'd3:
		begin
			x_data[0] <= x_data[0];
			x_data[1] <= x_data[6];
			x_data[2] <= x_data[1];
			x_data[3] <= x_data[2];
			x_data[4] <= x_data[3];
			x_data[5] <= x_data[4];
			x_data[6] <= x_data[5];
			
			y_data[0] <= y_data[0];
			y_data[1] <= y_data[6];
			y_data[2] <= y_data[1];
			y_data[3] <= y_data[2];
			y_data[4] <= y_data[3];
			y_data[5] <= y_data[4];
			y_data[6] <= y_data[5];
		end
		3'd4:
		begin
			x_data[count] <= x_data[count_ans];
			x_data[count_ans] <= x_data[count];
			
			y_data[count] <= y_data[count_ans];
			y_data[count_ans] <= y_data[count];
		end
	endcase
end

always@(*)
begin
	case(fsm)
		5'd0:
		begin
			valid = 1'b0;
			data_mode = 3'd1;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = fsm;
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = 10'd0;
			sbinB = 10'd0;
			
			if(count == 5'd6)
			begin
				fsm_next = 5'd1;
				count_next = 5'd2;
			end
			else
			begin
				count_next = count_ans;
			end
		end
		5'd1:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = sbans;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = 5'd8;
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = x_data[count];
			sbinB = x_data[1];
		end
		5'd8:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = ax;
			ay_next = sbans;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = 5'd9;
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = y_data[count];
			sbinB = y_data[1];
		end
		5'd9:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = ax;
			ay_next = ay;
			bx_next = sbans;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = 5'd10;
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = x_data[count_ans];
			sbinB = x_data[1];
		end
		5'd10:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = sbans;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = 5'd2;
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA =  y_data[count_ans];
			sbinB =  y_data[1];
		end
		5'd2:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = xans;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = 5'd3;
			fit_next = fit;
			xinA = ax;
			xinB = by;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = 10'd0;
			sbinB = 10'd0;
		end
		5'd3:
		begin
			valid = 1'b0;
			data_mode = 2'd0;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = xans;
			count_next = count;
			fsm_next = 5'd4;
			fit_next = fit;
			xinA = ay;
			xinB = bx;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = 10'd0;
			sbinB = 10'd0;
		end
		5'd4:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = fsm;
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = ax_by;
			sainB = ay_bx;
			sbinA = 10'd0;
			sbinB = 10'd0;
			if(saans[21] == 1'b0)
			begin
				fsm_next = 5'd5;
			end
			else
			begin
				fsm_next = 5'd7;
			end
		end
		5'd5:
		begin
			valid = 1'b0;
			data_mode = 3'd4;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = 5'd7;
			fit_next = 1'b1;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = 10'd0;
			sbinB = 10'd0;
		end
		5'd7:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fit_next = fit;
			if(count == 5'd5)
			begin
				if(fit == 1'b1)
				begin
					fsm_next = 5'd1;
					count_next = 5'd2;
					fit_next = 1'b0;
				end
				else
				begin
					count_next = 5'd0;
					fit_next = 1'b0;
					fsm_next = 5'd11;
				end
			end
			else
			begin
				fsm_next = 5'd1;
				count_next = count_ans;
			end
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = 10'd0;
			sbinB = 10'd0;
		end
		//-------------------------------------------------
		5'd11:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = sbans;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = 5'd12;
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = x_data[1];
			sbinB = x_data[0];
		end
		5'd12:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = ax;
			ay_next = sbans;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = 5'd13;
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = y_data[1];
			sbinB = y_data[0];
		end
		5'd13:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = ax;
			ay_next = ay;
			bx_next = sbans;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = 5'd14;
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = x_data[2];
			sbinB = x_data[0];
		end
		5'd14:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = sbans;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = 5'd15;
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA =  y_data[2];
			sbinB =  y_data[0];
		end
		5'd15:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = xans;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = 5'd16;
			fit_next = fit;
			xinA = ax;
			xinB = by;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = 10'd0;
			sbinB = 10'd0;
		end
		5'd16:
		begin
			valid = 1'b0;
			data_mode = 2'd0;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = xans;
			count_next = count;
			fsm_next = 5'd17;
			fit_next = fit;
			xinA = ay;
			xinB = bx;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = 10'd0;
			sbinB = 10'd0;
		end
		5'd17:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = 5'd18;
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = ax_by;
			sainB = ay_bx;
			sbinA = 10'd0;
			sbinB = 10'd0;
			if(saans[21] == 1'b0)
			begin
				fit_next = 1'b1;
			end
		end
		5'd18:
		begin
			valid = 1'b0;
			data_mode = 3'd3;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count_ans;
			if(count == 5'd5)
			begin
				fsm_next = 5'd19;
			end
			else
			begin
				fsm_next = 5'd11;
			end
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = 10'd0;
			sbinB = 10'd0;
		end
		5'd19:
		begin
			valid = 1'b1;
			data_mode = 3'd2;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = 5'd20;
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = 10'd0;
			sbinB = 10'd0;
		end
		5'd20:
		begin
			valid = 1'b0;
			data_mode = 3'd1;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = 5'd1;
			fsm_next = 5'd0;
			fit_next = 1'b0;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = 10'd0;
			sbinB = 10'd0;
		end
		default:
		begin
			valid = 1'b0;
			data_mode = 3'd0;
			ax_next = ax;
			ay_next = ay;
			bx_next = bx;
			by_next = by;
			ax_by_next = ax_by;
			ay_bx_next = ay_bx;
			count_next = count;
			fsm_next = fsm;
			fit_next = fit;
			xinA = 11'd0;
			xinB = 11'd0;
			sainA = 22'd0;
			sainB = 22'd0;
			sbinA = 10'd0;
			sbinB = 10'd0;
		end
	endcase
end




endmodule

                                                                                                                                       
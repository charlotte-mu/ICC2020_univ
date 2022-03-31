/******************************************************************/
//MODULE:		SME
//FILE NAME:	SME.v
//VERSION:		1.0
//DATE:			March,2020
//AUTHOR: 		charlotte-mu
//CODE TYPE:	RTL
//DESCRIPTION:	2020 University/College IC Design Contest
//
//MODIFICATION HISTORY:
// VERSION Date Description
// 1.0 03/25/2020 Cell based undergraduate student ,all pass
/******************************************************************/
module SME(clk,reset,chardata,isstring,ispattern,valid,match,match_index);
input clk;
input reset;
input [7:0] chardata;
input isstring;
input ispattern;
output reg match;
output reg [4:0] match_index;
output reg valid;
// reg match;
// reg [4:0] match_index;
// reg valid;

reg [7:0]string_reg[33:0];
reg [7:0]pattern_reg[7:0];
reg string_reg_e,pattern_reg_e;


reg [3:0]fsm,fsm_next;
reg [5:0]st_conter,st_conter_next;
reg [2:0]pa_conter,pa_conter_next;
reg [5:0]st_conter_reg,st_conter_reg_next;
reg [2:0]pa_conter_reg,pa_conter_reg_next;
reg [5:0]st_reg,st_reg_next;
reg [2:0]pa_reg,pa_reg_next;
reg [5:0]dataA,dataA_next;
reg clear;



always@(posedge clk,posedge reset)
begin
	if(reset)
	begin
		fsm <= 4'd1;
		st_conter <= 6'd0;
		pa_conter <= 3'd0;
		st_reg <= 6'd0;
		pa_reg <= 3'd0;
		st_conter_reg <= 6'd0;
		pa_conter_reg <= 3'd0;
		dataA <= 6'd0;
	end
	else
	begin
		fsm <= fsm_next;
		//st_conter <= st_conter_next;
		//pa_conter <= pa_conter_next;
		st_reg <= st_reg_next;
		pa_reg <= pa_reg_next;
		st_conter_reg <= st_conter_reg_next;
		pa_conter_reg <= pa_conter_reg_next;
		dataA <= dataA_next;
		if(isstring)
		begin
			string_reg[st_conter] <= chardata;
			st_conter <= st_conter + 6'd1;
		end
		if(ispattern)
		begin
			pattern_reg[pa_conter] <= chardata;
			pa_conter <= pa_conter + 3'd1;
		end
		if(clear)
		begin
			st_conter <= 6'd0;
			pa_conter <= 3'd0;
		end
	end
end

always@(*)
begin
	case(fsm)
		4'd1: //read
		begin
			fsm_next = fsm;
			st_reg_next = 6'd0;
			pa_reg_next = 3'd0;
			st_conter_reg_next = st_conter_reg;
			pa_conter_reg_next = pa_conter_reg;
			clear = 1'b0;
			dataA_next = dataA;
			valid = 1'b0;
			match = 1'b0;
			match_index = 5'd0;
			/*if(isstring)
			begin
				st_conter_next = st_conter + 6'd1;
			end
			if(ispattern)
			begin
				pa_conter_next = pa_conter + 3'd1;
			end*/
			if(!(isstring | ispattern))
			begin
				fsm_next = 4'd2;
				if(st_conter != 6'd0)
					st_conter_reg_next = st_conter;
				pa_conter_reg_next = pa_conter;
				clear = 1'b1;
			end
		end
		4'd2:
		begin
			fsm_next = fsm;
			//st_conter_next = st_conter;
			//pa_conter_next = pa_conter;
			st_reg_next = st_reg + 6'd1;
			pa_reg_next = pa_reg;
			st_conter_reg_next = st_conter_reg;
			pa_conter_reg_next = pa_conter_reg;
			clear = 1'b0;
			dataA_next = dataA;
			valid = 1'b0;
			match = 1'b0;
			match_index = 5'd0;
			if(st_reg == st_conter_reg)
			begin
				fsm_next = 4'd10; //unmach
			end
			else
			begin
				if(pattern_reg[pa_reg] == 8'h5E && st_reg == 6'd0)  // ^
				begin
					fsm_next = 4'd3;
					pa_reg_next = pa_reg + 3'd1;
					st_reg_next = st_reg;
					dataA_next = st_reg;
				end
				else if(pattern_reg[pa_reg] == 8'h5E && string_reg[st_reg] == 8'h20)  // ^
				begin
					fsm_next = 4'd3;
					st_reg_next = st_reg + 6'd1;
					pa_reg_next = pa_reg + 3'd1;
					dataA_next = st_reg + 6'd1;
				end
				else if(pattern_reg[pa_reg] == 8'h2E)  // .
				begin
					fsm_next = 4'd3;
					st_reg_next = st_reg;
					dataA_next = st_reg;
				end
				else if(pattern_reg[pa_reg] == string_reg[st_reg])
				begin
					fsm_next = 4'd3;
					st_reg_next = st_reg;
					dataA_next = st_reg;
				end
			end
		end
		4'd3:
		begin
			fsm_next = fsm;
			st_reg_next = st_reg + 6'd1;
			pa_reg_next = pa_reg + 3'd1;
			st_conter_reg_next = st_conter_reg;
			pa_conter_reg_next = pa_conter_reg;
			clear = 1'b0;
			dataA_next = dataA;
			valid = 1'b0;
			match = 1'b0;
			match_index = 5'd0;
			if(pattern_reg[pa_reg] == 8'h24 && st_reg == st_conter_reg)  // $
			begin
				fsm_next = 4'd11; //mach
			end
			else if(pattern_reg[pa_reg] == 8'h24 && string_reg[st_reg] == 8'h20)  // $
			begin
				fsm_next = 4'd11; //mach
			end
			else if(pattern_reg[pa_reg] == 8'h24 && string_reg[st_reg] == 8'h20)  // $
			begin
				fsm_next = 4'd11; //mach
			end
			else if(pattern_reg[pa_reg] == 8'h2E && pa_reg + 3'd1 == pa_conter_reg)  // .
			begin
				fsm_next = 4'd11;
			end
			else if(st_reg == st_conter_reg)
			begin
				fsm_next = 4'd10; //unmach
			end
			else if(pattern_reg[pa_reg] == 8'h2E)  // .
			begin
				fsm_next = fsm;
			end
			else if(pattern_reg[pa_reg] != string_reg[st_reg]) //unmach
			begin
				fsm_next = 4'd2;
				st_reg_next = dataA + 6'd1;
				pa_reg_next = 3'd0;
			end
			else if(pa_reg + 3'd1 == pa_conter_reg)
			begin
				fsm_next = 4'd11;  //mach
			end
		end
		4'd10:		//unmach
		begin
			fsm_next = 4'd1;
			st_reg_next = 6'd0;
			pa_reg_next = 3'd0;
			st_conter_reg_next = st_conter_reg;
			pa_conter_reg_next = pa_conter_reg;
			clear = 1'b0;
			dataA_next = dataA;
			valid = 1'b1;
			match = 1'b0;
			match_index = 5'd0;
		end
		4'd11:		//mach
		begin
			fsm_next = 4'd1;
			st_reg_next = 6'd0;
			pa_reg_next = 3'd0;
			st_conter_reg_next = st_conter_reg;
			pa_conter_reg_next = pa_conter_reg;
			clear = 1'b0;
			dataA_next = dataA;
			valid = 1'b1;
			match = 1'b1;
			match_index = dataA[4:0];
		end
		default:
		begin
			fsm_next = 4'd0;
			//st_conter_next = 6'd0;
			//pa_conter_next = 3'd0;
			st_reg_next = 6'd0;
			pa_reg_next = 3'd0;
			st_conter_reg_next = st_conter_reg;
			pa_conter_reg_next = pa_conter_reg;
			clear = 1'b0;
			dataA_next = dataA;
			valid = 1'b0;
			match = 1'b0;
			match_index = 5'd0;
		end
	endcase
end

endmodule

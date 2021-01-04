module part2 (SW, CLOCK_50, HEX0);
	input [9:0]SW;
	input CLOCK_50;
	output [6:0] HEX0;
	wire [10:0] RateDivider;
	wire Enable;
	reg [10:0]freq;

	wire [3:0] q; 
	
	always @(SW[1:0])
	begin
		case(SW[1:0])
			2'b00: freq[10:0] = 11'b00000000000;
			2'b01: freq[10:0] = 11'b00111110011;
			2'b10: freq[10:0] = 11'b01111100111;
			2'b11: freq[10:0] = 11'b11111001111;
		endcase
	end
	
	
	timer count(freq, CLOCK_50, RateDivider);
	assign Enable = (RateDivider == 0)?1:0;
	counter idk(Enable, SW[9], CLOCK_50, q);
	HEX2disp hex2(q, HEX0);

endmodule 


module timer(freq, clock, q);
	input clock;
	input [10:0]freq;
	output reg [10:0] q = 0;
	
	always @(posedge clock)
	begin
	if (q == 11'b00000000000)
		q <= freq;
	else
		q <= q - 1;
	end
	
endmodule 


module counter(enable, reset, clock, q);
	input enable, reset, clock;
	output reg [3:0] q;
	
	always @(posedge clock) 
	begin
	if (q == 4'b1111)
		q <= 4'b0000;
	else if (reset == 1'b1)
	begin
		q <= 4'b0000;
	end
	else if (enable == 1'b1)
	begin
		q <= q + 1;
	end
	end
endmodule 


module HEX2disp (SW,HEX);
    input [3:0] SW;
    output [6:0] HEX; //output

	assign HEX[0] = (~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&~SW[1]&~SW[0])|(SW[3]&~SW[2]&SW[1]&SW[0])|(SW[3]&SW[2]&~SW[1]&SW[0]);
	
	assign HEX[1] = (~SW[3]&SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&SW[1]&~SW[0])|(SW[3]&~SW[2]&SW[1]&SW[0])|(SW[3]&SW[2]&~SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&SW[0]);
	
	assign HEX[2] = (~SW[3]&~SW[2]&SW[1]&~SW[0])|(SW[3]&SW[2]&~SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&SW[0]);
	
	assign HEX[3] = (~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&~SW[1]&~SW[0])|(~SW[3]&SW[2]&SW[1]&SW[0])|(SW[3]&~SW[2]&SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&SW[0]);
	
	assign HEX[4] = (~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&~SW[2]&SW[1]&SW[0])|(~SW[3]&SW[2]&~SW[1]&~SW[0])|(~SW[3]&SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&SW[1]&SW[0])|(SW[3]&~SW[2]&~SW[1]&SW[0]);

	assign HEX[5] = (~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&~SW[2]&SW[1]&~SW[0])|(~SW[3]&~SW[2]&SW[1]&SW[0])|(~SW[3]&SW[2]&SW[1]&SW[0])|(SW[3]&SW[2]&~SW[1]&SW[0]);
	
	assign HEX[6] = (~SW[3]&~SW[2]&~SW[1]&~SW[0])|(~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&SW[1]&SW[0])|(SW[3]&SW[2]&~SW[1]&~SW[0]);


endmodule 

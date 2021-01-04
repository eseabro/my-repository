module tflipflop (t, q, clock, reset);
	input t, reset, clock;
	output reg q;
	always @(posedge clock)
		begin
		if (reset == 1'b0)
				q <= 0;
		else
			if (t)
				q <= ~q;
			else
				q <= q;
		end
endmodule


module part1 (SW, KEY, HEX0, HEX1);



	input [9:0] SW;
	input [3:0] KEY; 
	output [6:0] HEX0, HEX1;
	wire [7:0] Q;
	wire w1, w2, w3, w4, w5, w6, w7, w8;
	wire [7:0]S;
	wire clock, reset, enable;
	assign clock = KEY[0];
	assign enable = SW[1];
	assign reset = SW[0];


	
	tflipflop F0(.t(enable), .q(S[0]), .clock(clock), .reset(reset));
	assign w2 = enable&S[0];
	
	tflipflop F1(.t(w2), .q(S[1]), .clock(clock), .reset(reset));
	assign w3 = w2&S[1];	
	
	tflipflop F2(.t(w3), .q(S[2]), .clock(clock), .reset(reset));
	assign w4 = w3&S[2];	
	
	tflipflop F3(.t(w4), .q(S[3]), .clock(clock), .reset(reset));
	assign w5 = w4&S[3];	

	tflipflop F4(.t(w5), .q(S[4]), .clock(clock), .reset(reset));
	assign w6 = w5&S[4];	
	
	tflipflop F5(.t(w6), .q(S[5]), .clock(clock), .reset(reset));
	assign w7 = w6&S[5];	
	
	tflipflop F6(.t(w7), .q(S[6]), .clock(clock), .reset(reset));
	assign w8 = w7&S[6];	
	
	tflipflop F7(.t(w8), .q(S[7]), .clock(clock), .reset(reset));
	
	HEXdisp H1(S[3:0], HEX0[6:0]);
	HEXdisp H2(S[7:4] , HEX1[6:0]);
	
endmodule 


module HEXdisp (SW,HEX);
    input [3:0] SW;
    output [6:0] HEX; //output
	//input [6:0] HEX3;

	assign HEX[0] = (~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&~SW[1]&~SW[0])|(SW[3]&~SW[2]&SW[1]&SW[0])|(SW[3]&SW[2]&~SW[1]&SW[0]);
	
	assign HEX[1] = (~SW[3]&SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&SW[1]&~SW[0])|(SW[3]&~SW[2]&SW[1]&SW[0])|(SW[3]&SW[2]&~SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&SW[0]);
	
	assign HEX[2] = (~SW[3]&~SW[2]&SW[1]&~SW[0])|(SW[3]&SW[2]&~SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&SW[0]);
	
	assign HEX[3] = (~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&~SW[1]&~SW[0])|(~SW[3]&SW[2]&SW[1]&SW[0])|(SW[3]&~SW[2]&SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&SW[0]);
	
	assign HEX[4] = (~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&~SW[2]&SW[1]&SW[0])|(~SW[3]&SW[2]&~SW[1]&~SW[0])|(~SW[3]&SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&SW[1]&SW[0])|(SW[3]&~SW[2]&~SW[1]&SW[0]);

	assign HEX[5] = (~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&~SW[2]&SW[1]&~SW[0])|(~SW[3]&~SW[2]&SW[1]&SW[0])|(~SW[3]&SW[2]&SW[1]&SW[0])|(SW[3]&SW[2]&~SW[1]&SW[0]);
	
	assign HEX[6] = (~SW[3]&~SW[2]&~SW[1]&~SW[0])|(~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&SW[1]&SW[0])|(SW[3]&SW[2]&~SW[1]&~SW[0]);

endmodule 
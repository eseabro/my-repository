module flipflop (d, q, clock, reset);
	input d, reset, clock;
	output reg q;
	always @(posedge clock)
		begin
		if (reset == 1'b1)
				q <= 0;
		else
				q <= d;
		end
endmodule

module mux2to1(y,x,s,m);
	input y, x, s;
	output m;
	assign m = (!s&x) | (s&y);
endmodule 


module combination(right, left, LoadLeft, D, Loadn, clock, reset, Q);
	input right, left, LoadLeft, D, Loadn, clock, reset;
	output Q;
	wire w1, w2;
	mux2to1 M1(.y(left), .x(right), .s(LoadLeft), .m(w1));
	mux2to1 M2(.y(w1), .x(D), .s(Loadn), .m(w2));

	flipflop F0(.d(w2), .q(Q), .clock(clock), .reset(reset));
	
endmodule 

module part3(SW, KEY, LEDR);
	input [9:0] SW;
	input [3:0] KEY; 
	output [7:0] LEDR;
	wire w1, w2, w3, w4, w5, w6, w7, w8;
	wire [7:0] Q;
//	mux2to1 M1(.y(Q[7]),.x(Q[0]),.s(!KEY[3]),.m(w1));
	
	reg msb;
	always @(*)
	begin
	if(KEY[3:1]==3'b111)
		msb = Q[7];
	else
		msb = Q[0];
	end
	
	combination comb1(.right(Q[6]), .left(msb), .LoadLeft(!KEY[2]), .D(SW[7]), .Loadn(!KEY[1]), .clock(!KEY[0]), .reset(SW[9]), .Q(Q[7])); 
	combination comb2(.right(Q[5]), .left(Q[7]), .LoadLeft(!KEY[2]), .D(SW[6]), .Loadn(!KEY[1]), .clock(!KEY[0]), .reset(SW[9]), .Q(Q[6])); 
	combination comb3(.right(Q[4]), .left(Q[6]), .LoadLeft(!KEY[2]), .D(SW[5]), .Loadn(!KEY[1]), .clock(!KEY[0]), .reset(SW[9]), .Q(Q[5])); 
	combination comb4(.right(Q[3]), .left(Q[5]), .LoadLeft(!KEY[2]), .D(SW[4]), .Loadn(!KEY[1]), .clock(!KEY[0]), .reset(SW[9]), .Q(Q[4])); 
	combination comb5(.right(Q[2]), .left(Q[4]), .LoadLeft(!KEY[2]), .D(SW[3]), .Loadn(!KEY[1]), .clock(!KEY[0]), .reset(SW[9]), .Q(Q[3])); 
	combination comb6(.right(Q[1]), .left(Q[3]), .LoadLeft(!KEY[2]), .D(SW[2]), .Loadn(!KEY[1]), .clock(!KEY[0]), .reset(SW[9]), .Q(Q[2])); 
	combination comb7(.right(Q[0]), .left(Q[2]), .LoadLeft(!KEY[2]), .D(SW[1]), .Loadn(!KEY[1]), .clock(!KEY[0]), .reset(SW[9]), .Q(Q[1])); 
	combination comb8(.right(Q[7]), .left(Q[1]), .LoadLeft(!KEY[2]), .D(SW[0]), .Loadn(!KEY[1]), .clock(!KEY[0]), .reset(SW[9]), .Q(Q[0])); 
	
	assign LEDR[7:0] = Q[7:0];
	
endmodule 


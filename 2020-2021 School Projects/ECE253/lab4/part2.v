module part2 (SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [7:0] w1;

	wire [3:0]A, B;
	reg [7:0] out;
	wire [7:0] register;
	assign A[3:0] = SW[3:0];
	
	wire [7:0] both = {A,B};
	
	assign B[3:0] = register[3:0];
	assign CLK = KEY[0];

	adder fuadd(A, B, w1[7:0]);

	
	always @(*) // declare always block
	begin
		case (KEY[3:1]) // start case statement
			3'b111: out = w1; //A + B using the adder from Part II of this Lab
			3'b110: out =  A + B;
			3'b101: out = { {4{B[3]}}, B};
			3'b100: out = | both ;
			3'b011: out =  & both;
			3'b010: out = A << B;
			3'b001: out = A*B;
			3'b000: out = register[7:0]; 
			default: out = 8'b00000000;
		endcase
	end
	ebr ere3(out[7:0], SW[9], CLK, register[7:0]);

	assign LEDR[7:0] = register[7:0];
	LEDdisp hex0(SW[3:0],HEX0);
	
	LEDdisp hex1(4'b0000,HEX1);
	LEDdisp hex2(4'b0000,HEX2);
	LEDdisp hex3(4'b0000,HEX3);
	
	LEDdisp hex4(register[3:0],HEX4);
	LEDdisp hex5(register[7:4],HEX5);
endmodule 

module adder(A,B, LEDR);
	input [3:0] A,B; 
	output [7:0] LEDR;
	wire c1, c2, c3;

	
	fulladd FA(A[0], B[0], 0, c1, LEDR[0]);
	fulladd FB(A[1], B[1], c1, c2, LEDR[1]);
	fulladd FC(A[2], B[2], c2, c3, LEDR[2]);
	fulladd FD(A[3], B[3], c3, LEDR[4], LEDR[3]);
	assign LEDR[7:5] = 3'b000;
	
endmodule 

module ebr(Data, resetn, clock, register);
	input [7:0] Data; 
	input resetn, clock;
	output reg [7:0] register;
	
	always @ (posedge clock)
		begin
		if (resetn == 0)
				register = 00000000;
			else 
				register <= Data;
		end
endmodule 


module fulladd(A, B, Ci, Co, S);
	input A, B, Ci; 
	output Co, S;
	

	assign S = A ^ B ^ Ci;
	assign Co = (A&B) + ((A^B)&Ci);
endmodule 


module LEDdisp (SW,HEX);
    input [3:0] SW;
    output [6:0] HEX; 


	assign HEX[0] = (~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&~SW[1]&~SW[0])|(SW[3]&~SW[2]&SW[1]&SW[0])|(SW[3]&SW[2]&~SW[1]&SW[0]);
	
	assign HEX[1] = (~SW[3]&SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&SW[1]&~SW[0])|(SW[3]&~SW[2]&SW[1]&SW[0])|(SW[3]&SW[2]&~SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&SW[0]);
	
	assign HEX[2] = (~SW[3]&~SW[2]&SW[1]&~SW[0])|(SW[3]&SW[2]&~SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&SW[0]);
	
	assign HEX[3] = (~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&~SW[1]&~SW[0])|(~SW[3]&SW[2]&SW[1]&SW[0])|(SW[3]&~SW[2]&SW[1]&~SW[0])|(SW[3]&SW[2]&SW[1]&SW[0]);
	
	assign HEX[4] = (~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&~SW[2]&SW[1]&SW[0])|(~SW[3]&SW[2]&~SW[1]&~SW[0])|(~SW[3]&SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&SW[1]&SW[0])|(SW[3]&~SW[2]&~SW[1]&SW[0]);

	assign HEX[5] = (~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&~SW[2]&SW[1]&~SW[0])|(~SW[3]&~SW[2]&SW[1]&SW[0])|(~SW[3]&SW[2]&SW[1]&SW[0])|(SW[3]&SW[2]&~SW[1]&SW[0]);
	
	assign HEX[6] = (~SW[3]&~SW[2]&~SW[1]&~SW[0])|(~SW[3]&~SW[2]&~SW[1]&SW[0])|(~SW[3]&SW[2]&SW[1]&SW[0])|(SW[3]&SW[2]&~SW[1]&~SW[0]);

endmodule 
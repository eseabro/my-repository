module part3 (SW, KEY, LEDR, CLOCK_50);
	input [2:0] SW;
	input [1:0] KEY;
	input CLOCK_50;
	output [1:0]LEDR;
	
	
	wire reset = KEY[0];
	wire currval, Enable;
	wire [7:0]q;
	reg [11:0] letter =0;
	
	
	always @(*)
	begin
		case(SW[2:0])
		3'b000: letter[11:0] = 12'b010111000000;	//A
		3'b001: letter[11:0] = 12'b011101010100;	//B
		3'b010: letter[11:0] = 12'b011101011101;	//C
		3'b011: letter[11:0] = 12'b011101010000;	//D
		3'b100: letter[11:0] = 12'b010000000000;	//E
		3'b101: letter[11:0] = 12'b010101110100;	//F
		3'b110: letter[11:0] = 12'b011101110100;	//G
		3'b111: letter[11:0] = 12'b010101010000;	//H
		endcase
	end

	
	p3timer halfsec(CLOCK_50, q);
	
	assign Enable = (q == 0)?1:0;
	
	register let(Enable, !KEY[1], reset, letter[11:0], currval);

	assign LEDR[0] = currval;
	
endmodule 


module p3timer(clock, q);
	input clock;
	output reg [7:0] q=0;
	always @(posedge clock)
	begin
	if (q[7:0] == 8'b00000000)
		q <= 8'b11111001;
	else
		q <= q - 1;
	end
endmodule 



	//register let(Enable, !KEY[1] (parload), KEY[0], letter[11:0], q);



module register(clock, enable, reset, letter, Ledval);
	input clock, enable,reset;
	input [11:0] letter;
	output Ledval;
		
	reg [11:0] curlet=0;
	
	always @(clock, posedge enable, negedge reset) 
	begin 
		if (enable)
			curlet <= letter;
		else if (!reset)
			curlet <= 0;
		else if (clock)
		begin
			curlet <= (curlet << 1); 
		end
	end
	assign Ledval = curlet[11];
	
endmodule 




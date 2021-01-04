//SW[3:0] is divisor
//SW[7:4] is dividend
//KEY[0] active synchronous low reset 
//KEY[1] the active low Go
module part3(SW, KEY, CLOCK_50, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    wire resetn;
    wire go;

    wire [7:0] data_result;
    assign go = ~KEY[1];
    assign resetn = KEY[0];
	 

    wrapper3 u0(
        .clk(CLOCK_50),
        .resetn(resetn),
        .go(go),
        .data_in(SW[7:0]),
        .data_result(data_result)
    );
	 
// 	 assign data_result[7:0] = 8'b00000010;

      
    assign LEDR[7:0] = data_result[7:0];
//    assign LEDR[7:0] = 8'b00000010;

    hex_decoder3 H0(
        .hex_digit(SW[3:0]), 
        .segments(HEX0)
        ); //output of divisor
        
		  
    hex_decoder3 H2(
        .hex_digit(SW[7:4]), 
        .segments(HEX2)
        );//dividend
		  

    hex_decoder3 H4(
        .hex_digit(data_result[3:0]), 
        .segments(HEX4)
        ); //quotient
		  
    hex_decoder3 H5(
        .hex_digit(data_result[7:4]), 
        .segments(HEX5)
        ); //remainder


endmodule

module wrapper3(
    input clk,
    input resetn,
    input go,
    input [7:0] data_in,
    output [7:0] data_result
    );

    // lots of wires to connect our datapath and control
    wire ld_a, ld_b, ld_c, ld_x, ld_r, rep;
    wire ld_alu_out;
    wire [1:0]  alu_select_a, alu_select_b;
    wire [1:0] alu_op;
	 wire val1;

    control3 C03(
        .clk(clk),
        .resetn(resetn),
        
        .go(go),
        
        .val1(val1),
		  .ld_alu_out(ld_alu_out), 
        .ld_x(ld_x),
        .ld_a(ld_a),
        .ld_b(ld_b),
        .ld_c(ld_c), 
        .ld_r(ld_r), 
		  .rep(rep),
        
        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),
        .alu_op(alu_op)
    );

    datapath3 D03(
        .clk(clk),
        .resetn(resetn),

        .ld_alu_out(ld_alu_out), 
        .ld_x(ld_x),
        .ld_a(ld_a),
        .ld_b(ld_b),
        .ld_c(ld_c), 
        .ld_r(ld_r), 
		  .rep(rep),

        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),
        .alu_op(alu_op),

        .data_in(data_in),
        .data_result(data_result),
		  .val1(val1)
    );
                
 endmodule        
                

module control3(
    input clk,
    input resetn,
    input go,
	 input val1,

    output reg  ld_a, ld_b, ld_c, ld_x, ld_r, rep,
    output reg  ld_alu_out,
    output reg [1:0]  alu_select_a, alu_select_b,
    output reg [1:0] alu_op
    );

    reg [5:0] current_state, next_state; 
    reg count = 2'b0;
    localparam  S_CYCLE_0        = 5'd0,
                S_CYCLE_1   		= 5'd1,
                S_CYCLE_2        = 5'd2,
                S_CYCLE_3   		= 5'd3,
                S_CYCLE_4        = 5'd4,
					 S_END				= 5'd5;

    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_CYCLE_0: next_state = S_CYCLE_1;
                S_CYCLE_1: next_state = val1 ? S_CYCLE_2 : S_CYCLE_4;
                S_CYCLE_2: next_state = S_CYCLE_3;
                S_CYCLE_3:begin
								count = count + 1;
								next_state = S_END;
							end
                S_CYCLE_4: begin
								count = count + 1;
								next_state = S_END; // we will be done our two operations, start over after
							end	
            default:     next_state = S_CYCLE_0;
        endcase
		  if (count < 2'b00)begin
				current_state = S_END;
		  end
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_alu_out = 1'b0;
        ld_a = 1'b0;
        ld_b = 1'b0;
        ld_c = 1'b0;
        ld_x = 1'b0;
        ld_r = 1'b0;
        alu_select_a = 2'b0;
        alu_select_b = 2'b0;
        alu_op       = 2'b0;

        case (current_state)
            S_CYCLE_0: begin // Do left shift 
                ld_alu_out = 1'b1; ld_a = 1'b1; // store result back into A
                alu_select_a = 2'b00; // Select Register A
                alu_select_b = 2'b01; // Select Dividend
                alu_op = 2'b10; // Do left shift operation
            end
				S_CYCLE_1: begin // Do A <- A-divisor
                ld_alu_out = 1'b1; ld_a = 1'b1; // store result back into A
                alu_select_a = 2'b00; // Select register A
                alu_select_b = 2'b10; // Select divisor
                alu_op = 2'b01; // Do subtract operation
            end
            S_CYCLE_2: begin // Do A <- A + divisor -> do if ==1
                ld_alu_out = 1'b1; ld_a = 1'b1; // store result back into A
                alu_select_a = 2'b00; // Select register A
                alu_select_b = 2'b10; // Select divisor
                alu_op = 2'b00; // Do add operation
            end
				S_CYCLE_3: begin // set q0 to 0
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_r = 1'b1; rep=1'b0;
                alu_select_a = 2'b01; // Select Dividend
                alu_select_b = 2'b11; // Select 0
                alu_op = 2'b11; // Do switch op
            end
				S_CYCLE_4: begin
                ld_alu_out = 1'b1; ld_a = 1'b1; rep=1'b1; // set q0 to 1
                alu_select_a = 2'b01; // Select Dividend
                alu_select_b = 2'b11; // Select Dividend
                alu_op = 2'b11; // Do switch op
            end
				S_END: begin
					ld_r = 1'b1; 
				end

        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_CYCLE_0;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath3(
    input clk,
    input resetn,
    input [7:0] data_in,
    input ld_alu_out, 
    input ld_x, ld_a, ld_b, ld_c,
    input ld_r, rep,
    input [1:0]alu_op, 
    input [1:0] alu_select_a, alu_select_b,
    output reg [7:0] data_result,
	 output reg val1 
    );
    
    // input registers
    reg [7:0] a, b, c, x;

    // output of the alu
    reg [7:0] alu_out;
    // alu input muxes
    reg [7:0] alu_a, alu_b;
    
    // Registers a, b, c, x with respective input logic
    always@(posedge clk) begin
        if(!resetn) begin
            a <= 8'b0;
            b <= 8'b0;
            c <= 8'b0;
            x <= 8'b0;
        end
        else begin
            if(ld_a)
                a <= ld_alu_out ? alu_out : data_in; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            if(ld_b)
                b <= ld_alu_out ? alu_out : data_in; // load alu_out if load_alu_out signal is high, otherwise load from data_in

            if(ld_c)
                c <= data_in;
					 
            if(ld_x)
                x <= data_in;
					 
        end
    end
 

    // The ALU input multiplexers
    always @(*)
    begin
        case (alu_select_a)
            2'd0:
                alu_a = a;
            2'd1:
                alu_a = b;
            2'd2:
                alu_a = c;
            2'd3:
                alu_a = x;
            default: alu_a = 8'b0;
        endcase

        case (alu_select_b)
            2'd0:
                alu_b = a;
            2'd1:
                alu_b = b;
            2'd2:
                alu_b = c;
            2'd3:
                alu_b = rep;
            default: alu_b = 8'b0;
        endcase
    end

    // The ALU 
    always @(*)
    begin : ALU
        // alu
        case (alu_op)
            2'b00: begin
                   alu_out = alu_a + alu_b; //performs addition
//						 data_result <= 8'b11110001;

						end
            2'b01: begin
                   alu_out = alu_a - alu_b; //performs subtraction
						 val1 = alu_out[3];
//						 data_result <= 8'b11110010;

						end
            2'b10: begin
//						 data_result <= 8'b11110100;
                   alu_out = {alu_a, alu_b} << 1; //performs left shift
						end
            2'b11: begin
                   alu_out[3:1] = alu_a[3:1];
//						 data_result <= 8'b11111000;
						 alu_out[0] = alu_b; 

						end
            default: alu_out = 8'b0;
        endcase
    end
	 
	     // Output result register
    always@(posedge clk) begin
        if(!resetn) begin
            data_result <= 8'b0; 
        end
        else 
            if(ld_r)
                data_result <= alu_out;
    end
    
endmodule


module hex_decoder3(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule

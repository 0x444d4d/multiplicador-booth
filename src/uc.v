//vim: set syntax=verilog
`timescale 1 ns / 10 ps
module unidad_control(input wire start, clk, input wire [2:0] q, output wire fin, shift, suma, init, loadA);

reg [3:0] currentstate, nextstate;

//Parameters
parameter S0 = 4'b0000;  ///>
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;
parameter S5 = 4'b0101;
parameter S6 = 4'b0110;
parameter S7 = 4'b0111;
parameter S8 = 4'b1000;
parameter S9 = 4'b1001;
parameter S10 = 4'b1010;
parameter S11 = 4'b1011;
parameter S12 = 4'b1100;
parameter S13 = 4'b1101;
parameter S14 = 4'b1110;

parameter S15 = 4'b1110;
parameter S16 = 4'b1111;
//parameter Reset = 4'b1111;

always @ (posedge clk, posedge start)
begin
	if (start)
	begin
		currentstate <= S0;
	end
	else
		currentstate <= nextstate;
end


always @ (*)
	case (currentstate)

		S0: 
			if (q[1])
				nextstate = S1;
			else
				nextstate = S2;

		S1:
			if ((~q[2] & q[1]) | (q[2] & ~q[1]))
				nextstate = S3;
			else
				nextstate = S4;

		S2:
			if ((~q[2] & q[1]) | (q[2] & ~q[1]))
				nextstate = S3;
			else
				nextstate = S4;

		S3:
			if ((~q[2] & q[1]) | (q[2] & ~q[1]))
				nextstate = S5;
			else
				nextstate = S6;

		S4:
			if ((~q[2] & q[1]) | (q[2] & ~q[1]))
				nextstate = S5;
			else
				nextstate = S6;

		S5:
			nextstate = S7;

		S6:
			nextstate = S7;

		S7:
			nextstate = S7;

		default:
			nextstate = S0;
		endcase


		assign init = (currentstate == (S0)) ? 1:0;
		assign shift = (currentstate == S2 | currentstate == S4 | currentstate == S6) ? 1:0;
		assign loadA = (currentstate == S1| currentstate == S3 | currentstate == S5) ? 1:0;
		assign suma = (~q[1] & q[0]) ? 1:0;
		assign fin = (currentstate == S7) ? 1:0;

endmodule

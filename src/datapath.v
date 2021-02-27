//vim: set syntax=verilog
`timescale 1 ns / 10 ps
`include "componentes.v"

module cd (input wire clk, reset, shift_uc, sum_uc, init_uc, loadA_uc, input wire [2:0] Q_uc, M_uc, output wire [2:0] q_uc, output wire [5:0] result);

wire ground, SalidaQ_1, Carry, Resta;
wire [3:0] SalSum, SalidaA, SalidaM, M_4b;
wire [3:0] SalidaQ;
wire [3:0] a_in, q_in;
wire a_carry_in;

assign M_4b = {M_uc[2], M_uc};
assign ground = 1'b0;
assign Resta = ~sum_uc;
assign q_carry_in = loadA_uc ? SalSum[0] : SalidaA[0];

registro4 A ({SalSum[3], SalSum[3:1]}, SalidaA[3], loadA_uc, shift_uc, clk, reset, SalidaA);
registro4 Q ({Q_uc, 1'b0}, q_carry_in, init_uc, (shift_uc | loadA_uc), clk, reset, SalidaQ);
registro4 M (M_4b, ground, init_uc, ground, clk, reset, SalidaM);

sum_resta4 sumador(SalSum, Carry, SalidaA, SalidaM, Resta);

assign q_uc = SalidaQ[2:0];
assign result = {SalidaA[2:0], SalidaQ[3:1]};

endmodule

`timescale 1 ns / 10	ps
`include "datapath.v"
`include "uc.v"

module mult (input wire[2:0] M_mult, Q_mult, input wire clk, start_mul, output wire[5:0] Result_mul, output wire fin);

wire shift, sum, init, loadA, reset;
wire [2:0] q, q_uc;

assign q_uc = init ? {Q_mult[1:0], 1'b0} : q;

cd camino_datos ( clk, start_mul, shift, sum, init, loadA, Q_mult, M_mult, q, Result_mul);
unidad_control uc ( start_mul, clk, q_uc, fin, shift, sum, init, loadA );

endmodule

`timescale 1ns / 1ps

module ControlLogic_tb();

reg CLK = 1'b0;
always #5 CLK = ~CLK;

reg PWM1 = 1'b1;
reg PWM2 = 1'b0;
reg PWM3 = 1'b1;
reg PWM4 = 1'b0;

always #10 PWM1 = ~PWM1;
always #12 PWM2 = ~PWM2;
always #20 PWM3 = ~PWM3;
always #32 PWM4 = ~PWM4;

wire [3:0] PWM;

assign PWM[0] = PWM1;
assign PWM[1] = PWM2;
assign PWM[2] = PWM3;
assign PWM[3] = PWM4;

wire PWM_master;
wire [1:0] Dir;

integer DutyCycle0 = 32'd21;
integer DutyCycle1 = 32'd20;
integer DutyCycle2 = 32'd10;
integer DutyCycle3 = 32'd2;

ControlLogic uut(
    .PWM(PWM),
    .DutyCycle0(DutyCycle0),
    .DutyCycle1(DutyCycle1),
    .DutyCycle2(DutyCycle2),
    .DutyCycle3(DutyCycle3),
    .PWM_master(PWM_master),
    .DIR(Dir)
);

endmodule

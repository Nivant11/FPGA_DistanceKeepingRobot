`timescale 1ns / 1ps

module PWMController_tb();

//Generate the Clock signal
reg CLK = 1'b0;
always #5 CLK = ~CLK;
wire RESET = 1'b0; //Not used
wire integer DIST = 30;
wire PWM;

PWMController uut(
.CLK(CLK),
.RESET(RESET),
.DIST(DIST),
.PWM(PWM)
);

endmodule

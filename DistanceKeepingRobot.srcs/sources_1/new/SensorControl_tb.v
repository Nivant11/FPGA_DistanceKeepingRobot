`timescale 1ns / 1ps


module SensorControl_tb();

reg CLK;
wire integer DIST;
wire integer PWM;
wire TRIG;

always begin
        CLK = 1; #5;
        CLK = 0; #5;
    end
SensorControl sc (.CLK(CLK),
.EN(1'b1),
.ECHO(1'b1),
.DIST(DIST),
.PWM(PWM),
.TRIG(TRIG));


endmodule

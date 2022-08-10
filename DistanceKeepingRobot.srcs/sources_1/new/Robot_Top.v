`timescale 1ns / 1ps

module Robot_Top(
    output PWM_master,
    output [7:0] DIR_master,
    input CLK,
    input EN,
    input RESET,
    input ECHO0,
    input ECHO1,
    input ECHO2,
    input ECHO3,
    output TRIG0,
    output TRIG1,
    output TRIG2,
    output TRIG3
    );
   
   wire [3:0] PWM_set; //Contains the four PWM signals from the PWM Controllers
   
   //Four Duty Cycles outputted by the PWM Controllers
   wire [31:0] DutyCycle0;
   wire [31:0] DutyCycle1;
   wire [31:0] DutyCycle2;
   wire [31:0] DutyCycle3;
   wire [1:0] DIR; //Final direction output by the control logic
   
   
   ControlLogic Logic(
    .PWM(PWM_set),
    .DutyCycle0(DutyCycle0),
    .DutyCycle1(DutyCycle1),
    .DutyCycle2(DutyCycle2),
    .DutyCycle3(DutyCycle3),
    .DIR(DIR),
    .PWM_master(PWM_master)
   ); 
   
   //Sensor 1
   wire integer DIST0;
   SensorControl sc0(
    .ECHO(ECHO0),
    .TRIG(TRIG0),
    .DIST(DIST0),
    .EN(EN),
    .CLK(CLK),
    .RESET(RESET)
   );
   PWMController PWMCtrl0(
    .DIST(DIST0),
    .CLK(CLK),
    .RESET(RESET),
    .PWM(PWM_set[0]),
    .DutyCycle(DutyCycle0)
   );
   
   //Sensor 2
   wire integer DIST1;
   SensorControl sc1(
    .ECHO(ECHO1),
    .TRIG(TRIG1),
    .DIST(DIST1),
    .EN(EN),
    .CLK(CLK),
    .RESET(RESET)
   );
   PWMController PWMCtrl1(
    .DIST(DIST1),
    .CLK(CLK),
    .RESET(RESET),
    .PWM(PWM_set[1]),
    .DutyCycle(DutyCycle1)
   );
   
   //Sensor 3
   wire integer DIST2;
   SensorControl sc2(
    .ECHO(ECHO2),
    .TRIG(TRIG2),
    .DIST(DIST2),
    .EN(EN),
    .CLK(CLK),
    .RESET(RESET)
   );
   PWMController PWMCtrl2(
    .DIST(DIST2),
    .CLK(CLK),
    .RESET(RESET),
    .PWM(PWM_set[2]),
    .DutyCycle(DutyCycle2)
   );
   
    //Sensor 4
   wire integer DIST3;
   SensorControl sc3(
    .ECHO(ECHO3),
    .TRIG(TRIG3),
    .DIST(DIST3),
    .EN(EN),
    .CLK(CLK),
    .RESET(RESET)
   );
   PWMController PWMCtrl3(
    .DIST(DIST3),
    .CLK(CLK),
    .RESET(RESET),
    .PWM(PWM_set[3]),
    .DutyCycle(DutyCycle3)
   );
   
endmodule

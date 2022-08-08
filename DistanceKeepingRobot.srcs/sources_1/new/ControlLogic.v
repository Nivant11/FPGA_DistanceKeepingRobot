`timescale 1ns / 1ps

module ControlLogic(
    input [3:0] PWM,
    input [31:0] DutyCycle0,
    input [31:0] DutyCycle1,
    input [31:0] DutyCycle2,
    input [31:0] DutyCycle3,
    output PWM_master,
    output [1:0] DIR
    );
   
    localparam FORWARD = 2'b00;
    localparam BACK = 2'b01;
    localparam RIGHT = 2'b10;
    localparam LEFT = 2'b11;
   
   
    //Set the master PWM signal based on the highest Duty cycle
    assign PWM_master = (DutyCycle0 >= DutyCycle1 && DutyCycle0 >= DutyCycle2 && DutyCycle0 >= DutyCycle3) ? PWM[0] :
              (DutyCycle1 >= DutyCycle0 && DutyCycle1 >= DutyCycle2 && DutyCycle1 >= DutyCycle3) ? PWM[1] :
              (DutyCycle2 >= DutyCycle0 && DutyCycle2 >= DutyCycle1 && DutyCycle2 >= DutyCycle3) ? PWM[2] :
              (DutyCycle3 >= DutyCycle0 && DutyCycle3 >= DutyCycle1 && DutyCycle3 >= DutyCycle2) ? PWM[3] : 1'bx;
   
    //Directions are set arbitrarily for now. This will have to be mapped out when the robot is actually built.
    assign DIR = (DutyCycle0 >= DutyCycle1 && DutyCycle0 >= DutyCycle2 && DutyCycle0 >= DutyCycle3) ? FORWARD :
              (DutyCycle1 >= DutyCycle0 && DutyCycle1 >= DutyCycle2 && DutyCycle1 >= DutyCycle3) ? BACK :
              (DutyCycle2 >= DutyCycle0 && DutyCycle2 >= DutyCycle1 && DutyCycle2 >= DutyCycle3) ? RIGHT :
              (DutyCycle3 >= DutyCycle0 && DutyCycle3 >= DutyCycle1 && DutyCycle3 >= DutyCycle2) ? LEFT : 2'bxx;
   
   
endmodule
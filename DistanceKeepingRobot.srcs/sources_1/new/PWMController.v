`timescale 1ns / 1ps


module PWMController(
    input [31:0] DIST,
    input CLK,
    input RESET,
    output PWM,
    output wire integer DutyCycle
    );
    
    wire integer THRESHOLD = 38; //The threshold distance. Any distance below this defines a "trip" of the sensor
    wire integer error;
    wire integer Kp = 4; //Proportional constant
    wire integer i_DutyCycle;
    wire integer pTerm;
    reg [16:0] counter = 0; //Used to set the PWM frequency
    
    
    //PID Control. If the Distance is greater than the threshold (i.e. the sensor has not been "tripped", the DutyCycle is zero
    assign error = (DIST > 38) ? 0 : THRESHOLD - DIST;
    assign pTerm = Kp * error;
    assign i_DutyCycle = (error == 0) ? 0 : (pTerm > 100) ? 100 : pTerm; //Set the duty cycle and clamp it to a range of 0 to 100
    assign DutyCycle = i_DutyCycle;
    
    always @(posedge CLK) begin
        if(counter == 100) counter = 0; 
        else counter = counter + 1;
    end
    
    assign PWM = (DutyCycle == 0) ? 1'b0 : (counter <= DutyCycle) ? 1'b1 : 1'b0;
    
endmodule

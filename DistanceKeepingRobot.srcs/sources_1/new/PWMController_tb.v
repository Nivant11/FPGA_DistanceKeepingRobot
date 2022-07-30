`timescale 1ns / 1ps

module PWMController_tb();

//Generate the Clock signal
reg CLK = 1'b0;
always #5 CLK = ~CLK;
wire RESET = 1'b0; //Not used
wire integer DIST;
wire PWM;
wire integer DutyCycle;
integer PWM_count = 0;
integer test_number = 1;

localparam CHANGING_DISTANCE = 1'b0;
localparam MEASURING_PWM = 1'b1;
reg test_State = CHANGING_DISTANCE;
reg temp = 1'b0;

//Check the pulse width of the PWM signal, should correspond to the Duty Cycle
always @(posedge CLK) begin
    if(~PWM) begin
        PWM_count = 0;
    end
    if(PWM) begin
        PWM_count = PWM_count+1;
    end
   
    //Self-checking test FSM
    if(test_State == CHANGING_DISTANCE) begin
        temp = 1'b0;
        if(PWM) begin
            test_State = MEASURING_PWM;
        end
    end
    else if(test_State == MEASURING_PWM) begin
        if(~PWM) begin
            temp = 1'b1;
            $display("PWM_count: %d", PWM_count);
            if(test_number < 5) begin
                test_number = test_number +1;
            end
            test_State = CHANGING_DISTANCE;
        end
    end
end

assign DIST = (test_number == 1) ? 29 : (test_number == 2) ? 30 : (test_number == 3) ? 21 :
            (test_number == 4) ? 40 : (test_number == 5) ? 37 : 31;

PWMController uut(
.CLK(CLK),
.RESET(RESET),
.DIST(DIST),
.PWM(PWM),
.DutyCycle(DutyCycle)
);

endmodule
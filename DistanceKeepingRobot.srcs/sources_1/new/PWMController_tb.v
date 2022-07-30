`timescale 1ns / 1ps

module PWMController_tb();

//Generate the Clock signal
reg CLK = 1'b0;
always #5 CLK = ~CLK;

wire RESET = 1'b0; //Not used
reg [31:0] DIST = 1; //The test distance
wire PWM;
wire integer DutyCycle;
integer PWM_count = 0; //PWM pulse width counter
integer FAIL = 0; //Indicates how many tests have failed

//States for the PWM test
localparam CHANGING_DISTANCE = 2'b00;
localparam MEASURING_PWM = 2'b11;
localparam FIRST_PULSE = 2'b01;
localparam WAITING_FOR_SECOND_PULSE = 2'b10;
reg [1:0] test_State = CHANGING_DISTANCE;

PWMController uut(
.CLK(CLK),
.RESET(RESET),
.DIST(DIST),
.PWM(PWM),
.DutyCycle(DutyCycle)
);

//Check the pulse width of the PWM signal, should correspond to the Duty Cycle
always @(posedge CLK) begin
    //Self-checking test FSM
    if(test_State == CHANGING_DISTANCE) begin //We are starting a new test with a new distance
        PWM_count = 0; //Reset the PWM counter
        if(PWM) begin
            test_State = FIRST_PULSE; //We have noticed the first PWM pulse
        end
    end
    else if (test_State == FIRST_PULSE) begin //State active for the duration of the first pulse
        if(DutyCycle == 100) begin //If the duty cycle is 100, then there are no PWM pulses. So we'll skip to measuring
            test_State = MEASURING_PWM; 
        end
        else begin
            if(~PWM) begin
                test_State = WAITING_FOR_SECOND_PULSE; //The first PWM pulse has passed
            end
        end
    end
    else if (test_State == WAITING_FOR_SECOND_PULSE) begin //We are waiting for the second pulse to come in before we start measuring
        if(PWM) begin
            test_State = MEASURING_PWM;
        end
    end
    else if(test_State == MEASURING_PWM) begin //We are measuring the second pulse
        if(DutyCycle == 100) begin //We'll check Duty Cycles of 100 differently than others
            if(PWM_count == 100) begin
                if(PWM) begin //Once the counter reaches 100, the PWM signal must NOT be low. If such is true, the test passes
                    $display("PASS: PWM Test Distance = %d ---- PWM pulse width: %d, DUTY CYCLE: %d", DIST, PWM_count, DutyCycle);
                    DIST = DIST + 1;
                    test_State = CHANGING_DISTANCE;
                end
                else begin $display("FAIL: PWM Test Distance = %d ---- PWM pulse width: %d, DUTY CYCLE: %d", DIST, PWM_count, DutyCycle); FAIL = FAIL + 1; end
            end
            else begin //If we haven't reached 100 yet, increment the counter.
                PWM_count = PWM_count + 1;
            end
        end
        else begin //Checking Duty Cycles != 100
            if(PWM) begin //As the pulse comes in, increment the counter
                PWM_count = PWM_count + 1;
            end
            else if(~PWM) begin
                if(PWM_count == DutyCycle) begin //Once the pulse comes through, the counter must be equal to the Duty cycle. If not, the test fails.
                    $display("PASS: PWM Test Distance = %d ---- PWM pulse width: %d, DUTY CYCLE: %d", DIST, PWM_count, DutyCycle);
                end
                else begin $display("FAIL: PWM Test Distance = %d ---- PWM pulse width: %d, DUTY CYCLE: %d", DIST, PWM_count, DutyCycle); FAIL = FAIL + 1; end
                if(DIST < 37) begin //As long as the distance hasn't met the threshold, we are still testing.
                    DIST = DIST + 1;
                end
                else begin //Now that all possible distances within the threshold have been tested, display the result of the overall test.
                    if(FAIL == 0) begin $display("PWM Test PASSED"); end //Indicates all tests have passed and the PWM Controller is working correctly 
                    else begin $display("PWM Test FAILED"); end //Indicates that at least one test has failed
                end
                test_State = CHANGING_DISTANCE;
            end //PWM
        end //Duty Cycles != 100
    end //Test state
end //Always block

endmodule
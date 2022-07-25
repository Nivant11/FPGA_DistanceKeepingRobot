`timescale 1ns / 1ps


module SensorControl_tb();

reg CLK;
wire integer DIST;
wire TRIG;
wire RESET;
integer CLK_count = 0; //Currently only using this for RESET pulse
wire [2:0] State;
reg ECHO;
integer ECHO_TIMER = 0;

integer test_number = 1;
wire integer ECHO_LENGTH;
reg DIST_MEASURE_TEST_FAIL = 1'b0;

always begin
        CLK = 1; #5;
        CLK = 0; #5;
    end

//Increments CLK_count in order to trigger RESET at the start of the program
always @(posedge CLK) begin
    CLK_count = CLK_count + 1;
    if(CLK_count > 1000) begin CLK_count = 6; end //Just keep the counter from becoming excessively large
   
    if(State == 2'b01) begin //If we are waiting for echo....
        ECHO = 1'b1;
    end
   
    if(State == 2'b10) begin
        if(ECHO_TIMER == ECHO_LENGTH) begin
            ECHO = 1'b0;
            ECHO_TIMER = 0;
            if(test_number <= 12) begin
                test_number = test_number + 1; //We are feeding in 11 different measurements
            end
        end
        else begin
            ECHO_TIMER = ECHO_TIMER + 1;
            ECHO = 1'b1;
        end
    end
   
end

always @(DIST) begin
    if(DIST != "X") begin
        case(test_number) //Self-checking. Note: the test numbers are mismatched because the distance updates AFTER the test has completed
            2: begin if(DIST == 2) begin $display("DISTANCE MEASURE TEST 1: PASS"); end else begin DIST_MEASURE_TEST_FAIL = 1'b1; $display("DISTANCE MEASURE TEST 1: FAIL - EXPECTED DIST = 2, GOT DIST = %d", DIST); end end      
            3: begin if(DIST == 5) begin $display("DISTANCE MEASURE TEST 2: PASS"); end else begin DIST_MEASURE_TEST_FAIL = 1'b1; $display("DISTANCE MEASURE TEST 2: FAIL - EXPECTED DIST = 5, GOT DIST = %d", DIST); end end      
            4: begin if(DIST == 7) begin $display("DISTANCE MEASURE TEST 3: PASS"); end else begin DIST_MEASURE_TEST_FAIL = 1'b1; $display("DISTANCE MEASURE TEST 3: FAIL - EXPECTED DIST = 7, GOT DIST = %d", DIST); end end      
            5: begin if(DIST == 10) begin $display("DISTANCE MEASURE TEST 4: PASS"); end else begin DIST_MEASURE_TEST_FAIL = 1'b1; $display("DISTANCE MEASURE TEST 4: FAIL - EXPECTED DIST = 10, GOT DIST = %d", DIST); end end      
            6: begin if(DIST == 200) begin $display("DISTANCE MEASURE TEST 5: PASS"); end else begin DIST_MEASURE_TEST_FAIL = 1'b1; $display("DISTANCE MEASURE TEST 5: FAIL - EXPECTED DIST = 200, GOT DIST = %d", DIST); end end      
            7: begin if(DIST == 1000) begin $display("DISTANCE MEASURE TEST 6: PASS"); end else begin DIST_MEASURE_TEST_FAIL = 1'b1; $display("DISTANCE MEASURE TEST 6: FAIL - EXPECTED DIST = 1000, GOT DIST = %d", DIST); end end      
            8: begin if(DIST == 2344) begin $display("DISTANCE MEASURE TEST 7: PASS"); end else begin DIST_MEASURE_TEST_FAIL = 1'b1; $display("DISTANCE MEASURE TEST 7: FAIL - EXPECTED DIST = 2344, GOT DIST = %d", DIST); end end      
            9: begin if(DIST == 35) begin $display("DISTANCE MEASURE TEST 8: PASS"); end else begin DIST_MEASURE_TEST_FAIL = 1'b1; $display("DISTANCE MEASURE TEST 8: FAIL - EXPECTED DIST = 35, GOT DIST = %d", DIST); end end      
            10: begin if(DIST == 6) begin $display("DISTANCE MEASURE TEST 9: PASS"); end else begin DIST_MEASURE_TEST_FAIL = 1'b1; $display("DISTANCE MEASURE TEST 9: FAIL - EXPECTED DIST = 6, GOT DIST = %d", DIST); end end      
            11: begin if(DIST == 74) begin $display("DISTANCE MEASURE TEST 10: PASS"); end else begin DIST_MEASURE_TEST_FAIL = 1'b1; $display("DISTANCE MEASURE TEST 10: FAIL - EXPECTED DIST = 74, GOT DIST = %d", DIST); end end      
            12: begin if(DIST == 12) begin $display("DISTANCE MEASURE TEST 11: PASS"); end else begin DIST_MEASURE_TEST_FAIL = 1'b1; $display("DISTANCE MEASURE TEST 11: FAIL - EXPECTED DIST = 12, GOT DIST = %d", DIST); end end
            13: begin if(DIST_MEASURE_TEST_FAIL == 1'b1) begin $display("DISTANCE MEASUREMENT TEST FAILED"); end else begin $display("DISTANCE MEASUREMENT TEST PASSED"); end end      
        endcase
    end
end

assign RESET = (CLK_count < 5) ? 1'b1 : 1'b0; //Assert a Reset for 5 clock cycles

assign ECHO_LENGTH = (test_number == 1) ? 11662 :
                    (test_number == 2) ? 29155 : (test_number == 3) ? 40816 :
                    (test_number == 4) ? 58309 : (test_number == 5) ? 1166181 :
                    (test_number == 6) ? 5830904 : (test_number == 7) ? 13667638 :
                    (test_number == 8) ? 204082 : (test_number == 9) ? 34985 :
                    (test_number == 10) ? 431487 : (test_number == 11) ? 69971 :
                    198251; //Run 11 different measurments

SensorControl sc (.CLK(CLK),
.EN(1'b1),
.ECHO(ECHO),
.DIST(DIST),
.PWM(PWM),
.TRIG(TRIG),
.RESET(RESET),
.State(State));


endmodule
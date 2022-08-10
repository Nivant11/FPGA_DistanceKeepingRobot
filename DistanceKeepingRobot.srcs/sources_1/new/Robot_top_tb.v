`timescale 1ns / 1ps

module Robot_top_tb();

//Generate the Clock signal
reg CLK = 1'b0;
always #5 CLK = ~CLK;

wire RESET;
integer CLK_count = 0;

//Sensor Signals
wire TRIG0;
wire TRIG1;
wire TRIG2;
wire TRIG3;

//For test FSM purposes
reg s_TRIG0;
reg s_TRIG1;
reg s_TRIG2;
reg s_TRIG3;

reg ECHO0;
reg ECHO1;
reg ECHO2;
reg ECHO3;
integer ECHO_LENGTH0 = 29155;
integer ECHO_LENGTH1 = 40816;
integer ECHO_LENGTH2 = 58309;
integer ECHO_LENGTH3 = 1166181;
integer ECHO_TIMER0;
integer ECHO_TIMER1;
integer ECHO_TIMER2;
integer ECHO_TIMER3;
wire PWM_master;

//Increments CLK_count in order to trigger RESET at the start of the program
always @(posedge CLK) begin
    CLK_count = CLK_count + 1;
    if(CLK_count > 1000) begin CLK_count = 6; end //Just keep the counter from becoming excessively large
end

assign RESET = (CLK_count <= 5) ? 1'b1 : 1'b0;

localparam WAIT_FOR_TRIG = 1'b0;
localparam SENDING_ECHO = 1'b1;
reg test_State;

always @(posedge CLK) begin
    if(RESET == 1'b1) begin
        test_State = WAIT_FOR_TRIG;
        s_TRIG0 = 1'b0;
        s_TRIG1 = 1'b0;
        s_TRIG2 = 1'b0;
        s_TRIG3 = 1'b0;
        ECHO_TIMER0 = 0;
        ECHO_TIMER1 = 0;
        ECHO_TIMER2 = 0;
        ECHO_TIMER3 = 0;
    end
    
    case(test_State) 
       WAIT_FOR_TRIG: begin
        if(TRIG0) begin s_TRIG0 = 1'b1; end
        if(TRIG1) begin s_TRIG1 = 1'b1; end
        if(TRIG2) begin s_TRIG2 = 1'b1; end
        if(TRIG3) begin s_TRIG3 = 1'b1; end
        if(s_TRIG0 == 1'b1 && s_TRIG1 == 1'b1 && s_TRIG2 == 1'b1 && s_TRIG3 == 1'b1) begin
            #10000 test_State = SENDING_ECHO; //Wait 10 us to make sure all TRIGs have gone low
        end
       end
       SENDING_ECHO: begin
       //First Echo
        if(ECHO_TIMER0 == ECHO_LENGTH0) begin
            ECHO0 = 1'b0;
            ECHO_TIMER0 = 0;
        end
        else begin
            ECHO_TIMER0 = ECHO_TIMER0 + 1;
            ECHO0 = 1'b1;
        end
        //Second Echo
        if(ECHO_TIMER1 == ECHO_LENGTH1) begin
            ECHO1 = 1'b0;
            ECHO_TIMER1 = 0;
        end
        else begin
            ECHO_TIMER1 = ECHO_TIMER1 + 1;
            ECHO1 = 1'b1;
        end
        //Third Echo
        if(ECHO_TIMER2 == ECHO_LENGTH2) begin
            ECHO2 = 1'b0;
            ECHO_TIMER2 = 0;
        end
        else begin
            ECHO_TIMER2 = ECHO_TIMER2 + 1;
            ECHO2 = 1'b1;
        end
        //Fourth Echo
        if(ECHO_TIMER3 == ECHO_LENGTH3) begin
            ECHO3 = 1'b0;
            ECHO_TIMER3 = 0;
        end
        else begin
            ECHO_TIMER3 = ECHO_TIMER3 + 1;
            ECHO3 = 1'b1;
        end
       end 
    endcase
    
end

Robot_top uut(
    .PWM_master(PWM_master),
    .ECHO0(ECHO0),
    .ECHO1(ECHO1),
    .ECHO2(ECHO2),
    .ECHO3(ECHO3),
    .TRIG0(TRIG0),
    .TRIG1(TRIG1),
    .TRIG2(TRIG2),
    .TRIG3(TRIG3),
    .CLK(CLK),
    .RESET(RESET),
    .EN(1'b1)
);

endmodule

module SensorControl(CLK, EN, DIST, PWM, TRIG, ECHO, RESET, State);
input CLK;
input RESET;
input EN;
input ECHO;
output integer DIST;
output wire integer PWM;
output wire TRIG;
output reg [2:0] State;

//Keep an internal signal to control the trig. This is so that the user does not have to worry about the trig pulse width
reg i_TRIG = 1'b0;
assign TRIG = i_TRIG;

integer ECHO_COUNT = 0;

localparam TRIGGER = 3'b000; //This state pull TRIG high and then, after 10 us, pull it low again
localparam WAITING_FOR_ECHO = 3'b001; //This state will wait for echo to come through
localparam COUNTING = 3'b010; //This state will count the number of clock cycles that echo is high and then return a distance

integer TEN_US_CLK_COUNT = 0;
reg ten_us;
always @(posedge CLK or ECHO) begin
if (EN == 1) begin
    if(TEN_US_CLK_COUNT == 1000) begin
        ten_us = 1'b1;
        TEN_US_CLK_COUNT = 0;
    end
    else begin
        TEN_US_CLK_COUNT = TEN_US_CLK_COUNT + 1;
        ten_us = 1'b0;
    end //TEN US
   
    if(RESET == 1'b1) begin
        State = TRIGGER;
        TEN_US_CLK_COUNT = 0;
        ten_us = 1'b0;      
    end //RESET
    else begin
        case(State)
            TRIGGER: begin
                ECHO_COUNT = 0;
                if(ten_us == 1'b0) begin
                    i_TRIG <= 1'b1;
                end
                else begin
                    i_TRIG <= 1'b0;
                    State = WAITING_FOR_ECHO;
                end
            end //TRIGGER State
            WAITING_FOR_ECHO: begin
                if(ECHO == 1'b1) begin
                    ECHO_COUNT = ECHO_COUNT + 1;
                    State = COUNTING;
                end
            end //WAITING_FOR_ECHO State
            COUNTING: begin
                if(ECHO == 1'b1) begin
                    ECHO_COUNT = ECHO_COUNT + 1;
                end
                else begin
                    DIST = ((ECHO_COUNT * 0.00000001) * 34300) / 2;
                    State = TRIGGER;
                end
            end //COUNTING State
        endcase
       
    end//FSM
    end //Enable
end //Always block


endmodule

`timescale 1ns / 1ps

module ControlLogic_tb();

reg CLK = 1'b0;
always #5 CLK = ~CLK;

reg PWM1 = 1'b1;
reg PWM2 = 1'b0;
reg PWM3 = 1'b1;
reg PWM4 = 1'b0;

always #10 PWM1 = ~PWM1;
always #12 PWM2 = ~PWM2;
always #20 PWM3 = ~PWM3;
always #32 PWM4 = ~PWM4;

wire [3:0] PWM;

assign PWM[0] = PWM1;
assign PWM[1] = PWM2;
assign PWM[2] = PWM3;
assign PWM[3] = PWM4;

wire PWM_master;
wire [1:0] Dir;

reg [31:0] DutyCycle0 = 32'd20;
reg [31:0] DutyCycle1 = 32'd20;
reg [31:0] DutyCycle2 = 32'd10;
reg [31:0] DutyCycle3 = 32'd2;

localparam setDutyCycle = 1'b0;
localparam checkDutyCycle = 1'b1;
reg [1:0] test_Count = 2'b00;
reg test_State = setDutyCycle;
reg [4:0] CLK_Count = 5'b00000;
reg [6:0] FAIL = 7'd0;
always@(posedge CLK) begin
    if(test_State == setDutyCycle) begin
        case(test_Count) 
        2'b00 : begin DutyCycle0 = 32'd20; DutyCycle1 = 32'd10; DutyCycle2 = 32'd1; DutyCycle3 = 32'd12; test_State = checkDutyCycle; end
        2'b01 : begin DutyCycle0 = 32'd10; DutyCycle1 = 32'd20; DutyCycle2 = 32'd1; DutyCycle3 = 32'd12; test_State = checkDutyCycle; end 
        2'b10 : begin DutyCycle0 = 32'd10; DutyCycle1 = 32'd15; DutyCycle2 = 32'd30; DutyCycle3 = 32'd12; test_State = checkDutyCycle; end
        2'b11 : begin DutyCycle0 = 32'd10; DutyCycle1 = 32'd15; DutyCycle2 = 32'd1; DutyCycle3 = 32'd25; test_State = checkDutyCycle; end 
        endcase
    end
    else if(test_State == checkDutyCycle) begin
         if(CLK_Count < 5'd21) begin
                case(test_Count)
                    2'b00: begin
                        if(PWM_master != PWM[0]) begin
                            FAIL = FAIL + 1;
                            $display("FAIL: Control Logic w/ Duty Cycle 0 highest");
                        end
                    end
                     2'b01: begin
                        if(PWM_master != PWM[1]) begin
                            FAIL = FAIL + 1;
                            $display("FAIL: Control Logic w/ Duty Cycle 1 highest");
                        end
                    end
                     2'b10: begin
                        if(PWM_master != PWM[2]) begin
                            FAIL = FAIL + 1;
                            $display("FAIL: Control Logic w/ Duty Cycle 2 highest");
                        end
                    end
                     2'b11: begin
                        if(PWM_master != PWM[3]) begin
                            FAIL = FAIL + 1;
                            $display("FAIL: Control Logic w/ Duty Cycle 3 highest");
                        end
                    end
                    
                endcase
                CLK_Count = CLK_Count + 1;
         end
         else if (CLK_Count == 5'd21) begin
            if(test_Count != 2'b11) begin
                test_Count = test_Count + 1;
                CLK_Count = 0;
                test_State = setDutyCycle;
            end
            else if(test_Count == 2'b11) begin
                if(FAIL == 0) begin $display("PASS: Control Logic Test"); end
                else begin $display("FAIL: Control Logic Test"); end
            end
         end   
    end
end

ControlLogic uut(
    .PWM(PWM),
    .DutyCycle0(DutyCycle0),
    .DutyCycle1(DutyCycle1),
    .DutyCycle2(DutyCycle2),
    .DutyCycle3(DutyCycle3),
    .PWM_master(PWM_master),
    .DIR(Dir)
);

endmodule

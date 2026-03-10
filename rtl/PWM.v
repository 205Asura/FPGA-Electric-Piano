module PWM(
    input clk_fpga,       // 100MHz FPGA Bays 3 Board Clock
    input wire signed [3:0] octave_shift,
    input wire [7:0] data,
    input wire note_active,
    output wire buzzer
);

    // PWM for Audio
    parameter [26:0] clk_freq = 100_000_000;
    reg [31:0] pwm_counter = 0;
    reg [31:0] freq_div = 0;
    reg [31:0] base_div = 0;
    reg pwm_out = 0;
    
    
    
    // Map scan codes to frequencies
    always @(posedge clk_fpga)
    begin
        case (data)
            2:  base_div <= 47716; // C6
            3:  base_div <= 45091;
            4:  base_div <= 42586;
            5:  base_div <= 40198;
            6:  base_div <= 37936;
            7:  base_div <= 35794;
            8:  base_div <= 33778;
            9:  base_div <= 31888;
            10: base_div <= 30098;
            11: base_div <= 28409;
            12: base_div <= 26815;
            13: base_div <= 25302;
            
            default: base_div <= 0; // No sound
        endcase 
        
        if (octave_shift >= 0)
            freq_div <= base_div >> octave_shift;
        else
            freq_div <= base_div << (-octave_shift);
    end
    

    // PWM Generation - now only when note_active is true
    always @(posedge clk_fpga)
    begin
        if (freq_div != 0 && note_active)
        begin
            pwm_counter <= pwm_counter + 1;
            if (pwm_counter == freq_div)
            begin
                pwm_out <= ~pwm_out;
                pwm_counter <= 0;
            end
        end
        else
        begin
            pwm_out <= 0;
            pwm_counter <= 0;
        end
    end 
    
    assign buzzer = pwm_out;

endmodule
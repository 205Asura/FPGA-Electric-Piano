module Piano
#
(
    parameter duration = 50_000_000 // 0.25s duration (100MHz clock)
)
(
    input clk,       // 100MHz FPGA Bays 3 Board Clock
    input reset,          // reset button
    input RxD,            // input signal wire
    input increase_octave,
    input decrease_octave,
    output reg [3:0] an,
    output reg [6:0] seg,
    output buzzer
);

    // Internal Variables
    
    wire [7:0] data;  // data that we receive at the receiving end, using 8 right most bits
    reg [7:0] last_data; // to detect new notes
    
    // Note duration control
    reg [26:0] timer_count; // 100MHz clock needs 27 bits to count 100,000,000 cycles (1 second)
    reg note_active;
    reg new_note_received; // Flag to indicate new note
    
    reg signed [3:0] octave_shift = 1;
    reg prev_btn_increase;
    reg prev_btn_decrease;
    wire debounced_increase;
    wire debounced_decrease;
    

    debounce inst3(clk, increase_octave, debounced_increase);
    debounce inst4(clk, decrease_octave, debounced_decrease);
    
    always @ (posedge clk)
    begin
        prev_btn_increase <= debounced_increase;
        prev_btn_decrease <= debounced_decrease;
        if (debounced_increase && !prev_btn_increase)
            octave_shift <= octave_shift + 1;
        else if (debounced_decrease && !prev_btn_decrease)
            octave_shift <= octave_shift - 1;
    
    end 
    
    
    UART_Rx inst1(clk, reset, RxD, data);
    PWM inst2(clk, octave_shift, data, note_active, buzzer);
    
    always @ (data)
    begin
        an = 4'b1110;
        case (data)
            2: seg = 7'b1001111;
            3: seg = 7'b0010010;
            4: seg = 7'b0000110;
            5: seg = 7'b1001100;
            6: seg = 7'b0100100;
            7: seg = 7'b0100000;
            8: seg = 7'b0001111;
            9: seg = 7'b0000000;
            10: seg = 7'b0000100;
            11: seg = 7'b0000001;
            default: seg = 7'b1111111;
        endcase
    end
    
    
    always @ (posedge clk)
    begin
    //Detect new note received (edge detection)
        if (data != last_data && data != 0) 
        begin
            new_note_received <= 1;
            last_data <= data;
        end
        
        else
            new_note_received <= 0;
        
        // Note duration control
        if (new_note_received)
        begin
            note_active <= 1;
            timer_count <= 0;
        end
        
        else if (note_active)
        begin
            if (timer_count < duration - 1) 
                timer_count <= timer_count + 1;
            else 
                note_active <= 0;
        end
    end
    
    
    
endmodule
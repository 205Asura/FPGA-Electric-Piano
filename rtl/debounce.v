module debounce(
    input clk,
    input btnC,
    output wire out
    );
    
    reg [31:0] clk_div = 0;
    reg slow_clk = 0;
    
    always @(posedge clk)
    begin
        clk_div <= clk_div + 1;
        if (clk_div == 499_999)
        begin    
            slow_clk <= ~slow_clk;
            clk_div <= 0;
        end
    end
    
    
    wire Q0;
    wire Q1;
    wire Q2;
    wire Q2_bar;
    assign Q2_bar = ~Q2;
    DFF D0(slow_clk, btnC, Q0);
    DFF D1(slow_clk, Q0, Q1);
    DFF D2(slow_clk, Q1, Q2);
    
    assign out = Q1 & Q2_bar;
    
    
endmodule

`timescale 1ns / 1ns

module full_adder (
    input wire clk,      
    input wire key_a,     
    input wire key_b,     
    input wire key_cin,   
    output wire led_s,     
    output wire led_cout   
);

    reg a=1'b0,b=1'b0,cin=1'b0;
    reg key_a_d= 1'b1,key_b_d=1'b1,key_cin_d=1'b1;

    always @(posedge clk) begin
        key_a_d <= key_a;
        if (key_a_d && !key_a) a <= ~a;            
        key_b_d <= key_b;
        if (key_b_d && !key_b) b <= ~b;            
        key_cin_d <= key_cin;
        if (key_cin_d && !key_cin) cin <= ~cin;  
    end

    wire s, cout;
    assign s=a^b^cin;                         
    assign cout=(a&b)|(a&cin)|(b&cin);     
    assign led_s    = ~s;
    assign led_cout = ~cout;

endmodule

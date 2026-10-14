`timescale 1ns / 1ns
module full_adder_tb;

    reg  clk = 0;
    reg  key_a = 1, key_b = 1, key_cin = 1;  
    wire led_s, led_cout;                    

    reg a_t = 0, b_t = 0, c_t = 0;

    integer errors = 0;

    full_adder dut (
        .clk (clk),
        .key_a (key_a),
        .key_b (key_b),
        .key_cin (key_cin),
        .led_s (led_s),
        .led_cout (led_cout)
    );

    always #10 clk = ~clk;  

    task press;
        input [1:0] sel;  
        begin
            case (sel)
                0: key_a = 0;
                1: key_b = 0;
                default: key_cin = 0;
            endcase
            #40;
            case (sel)
                0: key_a = 1;
                1: key_b = 1;
                default: key_cin = 1;
            endcase
            #40;
        end
    endtask

    task set_state;
        input A, B, Cin;   
        begin
            if (a_t !== A) begin press(0); a_t = ~a_t; end
            if (b_t !== B) begin press(1); b_t = ~b_t; end
            if (c_t !== Cin) begin press(2); c_t = ~c_t; end
            #40;
            if ((led_s !== ~(A ^ B ^ Cin)) ||
                (led_cout !== ~((A & B) | (A & Cin) | (B & Cin)))) begin
                $display("FAIL  A=%b B=%b Cin=%b -> S=%b (exp %b), Cout=%b (exp %b)",
                         A, B, Cin, ~led_s, A ^ B ^ Cin,
                         ~led_cout, (A & B) | (A & Cin) | (B & Cin));
                errors = errors + 1;
            end else begin
                $display("PASS  A=%b B=%b Cin=%b -> S=%b, Cout=%b",
                         A, B, Cin, ~led_s, ~led_cout);
            end
        end
    endtask

    initial begin
        $dumpfile("full_adder_tb.vcd");
        $dumpvars(0, full_adder_tb);

        // A=0 B=0 Cin=0 -> S=0 Cout=0   
        set_state(0, 0, 0);
        // A=0 B=0 Cin=1 -> S=1 Cout=0  
        set_state(0, 0, 1);
        // A=0 B=1 Cin=0 -> S=1 Cout=0
        set_state(0, 1, 0);
        // A=0 B=1 Cin=1 -> S=0 Cout=1
        set_state(0, 1, 1);
        // A=1 B=0 Cin=0 -> S=1 Cout=0
        set_state(1, 0, 0);
        // A=1 B=0 Cin=1 -> S=0 Cout=1
        set_state(1, 0, 1);
        // A=1 B=1 Cin=0 -> S=0 Cout=1
        set_state(1, 1, 0);
        // A=1 B=1 Cin=1 -> S=1 Cout=1   
        set_state(1, 1, 1);

        if (errors == 0)
            $display("ALL 8 CASES PASSED");
        else
            $display("%0d CASE(S) FAILED", errors);

        #40 $finish;
    end

endmodule

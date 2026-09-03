`timescale 1ns/1ps

module riscv_top_tb ();
    reg clk;
    reg arstn;
    wire [5:0] led; //output must be wire type

    riscv_top dut (
        .clk(clk),
        .arstn(arstn),
        .led(led)
    );

    //clk generation
    initial begin
        clk = 0;
        forever #18.5185 clk = ~clk; // 27 MHz clock
    end

    initial begin
        $dumpfile("riscv_top_wave_form.vcd");
        $dumpvars(0, riscv_top_tb);
        arstn = 0;
        repeat (5) @(posedge clk);
        arstn = 1;
        repeat (50) @(posedge clk);
        $finish;
    end
endmodule
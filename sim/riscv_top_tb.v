`timescale 1ns/1ps

module riscv_top_tb ();
    reg clk;
    reg arstn;
    wire [5:0] led;

    riscv_top dut (
        .clk(clk),
        .arstn(arstn),
        .led(led)
    );

    // clk generation
    initial begin
        clk = 0;
        forever #18.5185 clk = ~clk; // 27 MHz clock
    end

    initial begin
        $dumpfile("riscv_top_wave_form.vcd");
        $dumpvars(0, riscv_top_tb);
        
        $monitor("Time=%0t | PC = %h | Inst = %h | ALU_Out = %h", 
                  $time, dut.PC_out, dut.inst, dut.alu_result);

        arstn = 0;
        repeat (2) @(posedge clk);
        arstn = 1;
        
        //timeout
        repeat (1000) @(posedge clk);
        $display("\n[TIMEOUT] SIM end.");
        $finish;
    end

    always @(posedge clk) begin
        // Giám sát cổng I/O tại địa chỉ 0x100
        if (dut.mem_write && (dut.alu_result == 32'h0000_0100)) begin
            $display("\n==================================================");
            if (dut.read_data_reg2 == 32'd1) begin
                $display("[ BINGO!!! ] CPU PASSED THE TEST!");
            end else begin
                // Dịch phải 1 bit (>> 1) vì các mã lỗi của riscv-tests được nhân đôi
                $display("[ FATAL ERROR ] CPU FAIL, CHECK THE TEST CASE: %0d", dut.read_data_reg2);
            end
            $display("==================================================\n");
            $finish;
        end
    end

endmodule
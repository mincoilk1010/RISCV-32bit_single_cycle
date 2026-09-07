module riscv_top (
    input wire clk,
    input wire arstn,
    output wire [5:0] led
);
    wire [31:0] PC_next;
    wire [31:0] PC_out;

    PC pc (
        .clk(clk),
        .arstn(arstn),
        .in(PC_next),
        .out(PC_out)
    );

    wire [31:0] inst;
    instruction_mem ins_mem (
        .read_addr(PC_next),
        .instruction(inst)
    );

    register_file rf (
        .clk(clk)
    );

    reg [5:0] led_reg;
    
    always @(posedge clk or negedge arstn) begin
        if (!arstn) begin
            led_reg <= 6'b000000;
        end else begin
            if (mem_write && (alu_result == 32'h0000_0100)) begin
                led_reg <= read_data_reg2[5:0];
            end
        end
    end

    assign led = ~led_reg;

endmodule
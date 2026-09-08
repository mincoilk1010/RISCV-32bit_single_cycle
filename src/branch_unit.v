module branch_unit (
    input wire [31:0] alu_res,
    input wire [2:0] funct3,
    input wire branch_en,
    output reg branch_out
);
    wire is_zero;
    assign is_zero = (alu_res == 32'd0); 

    always @(*) begin
        branch_out = 1'b0;
        if(branch_en) begin
            case(funct3)
                3'b000: branch_out = is_zero; //beq
                3'b001: branch_out = ~is_zero; //bne
                3'b100: branch_out = alu_res[0]; //blt
                3'b101: branch_out = ~alu_res[0]; //bge
                3'b110: branch_out = alu_res[0]; //bltu
                3'b111: branch_out = ~alu_res[0]; //bgeu
                default: branch_out = 1'b0;
            endcase
        end
    end
endmodule
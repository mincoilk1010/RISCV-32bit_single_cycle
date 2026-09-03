module ALU (
    input [3:0] alu_ctrl,
    input [31:0] in1,
    input [31:0] in2,
    output wire zero,
    output reg [31:0] ALU_result
);
    always @(*) begin
        case(alu_ctrl) 
            4'b0000: ALU_result = in1 & in2;
            4'b0001: ALU_result = in1 | in2;
            4'b0010: ALU_result = in1 + in2;
            4'b0110: ALU_result = in1 - in2;
            4'b0111: ALU_result = ($signed(in1) < $signed(in2)) ? 32'd1 : 32'd0;
            default: begin
                ALU_result = 0;
            end 
        endcase
    end

    assign zero = (ALU_result == 0);
endmodule
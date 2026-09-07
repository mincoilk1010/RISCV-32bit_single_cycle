module ALU (
    input [3:0] alu_ctrl,
    input [31:0] in1,
    input [31:0] in2,
    output wire zero,
    output reg [31:0] ALU_result
);
    always @(*) begin
        case(alu_ctrl) 
            //add
            4'b0000: ALU_result = in1 + in2;
            //sub
            4'b1000: ALU_result = in1 - in2;
            //and
            4'b0111: ALU_result = in1 & in2;
            //or
            4'b0110: ALU_result = in1 | in2;
            //shift-left-logical = sll
            4'b0001: ALU_result = in1 << in2[4:0]; //can only shift 32 bit
            //compare less than (signed) = slt
            4'b0010: ALU_result = ($signed(in1) < $signed(in2)) ? 32'b1 : 32'b0;
            //compare less than (unsigned) = sltu
            4'b0011: ALU_result = (in1 < in2) ? 32'b1 : 32'b0;
            //xor 
            4'b0100: ALU_result = in1 ^ in2;
            //shift-right-logical = srl
            4'b0101: ALU_result = in1 >> in2;
            //shift-right-arithmetic = sra
            4'b1101: ALU_result = $signed(in1) >>> in2[4:0]; //can only shift 32 bit
            default: begin
                ALU_result = 0;
            end 
        endcase
    end

    assign zero = (ALU_result == 0);
endmodule
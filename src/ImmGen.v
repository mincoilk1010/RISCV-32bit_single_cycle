module ImmGen (
    input wire signed [31:0] instruction,
    output reg signed [31:0] imm_out
);
    wire [6:0] opcode = instruction[6:0];

    always @(*) begin
        case(opcode) 
            //R-type
            7'b0110011: begin
                imm_out = 32'd0;
            end
            //I-type (only lw)
            7'b0000011: begin
                imm_out = {{20{instruction[31]}},instruction[31:20]};
            end
            //S-type (only sw)
            7'b0100011: begin
                imm_out = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
            end
            //SB-type (beq)
            7'b1100011: begin
                imm_out = {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
            end
            default: begin
                imm_out = 32'd0;
            end
        endcase
    end
endmodule
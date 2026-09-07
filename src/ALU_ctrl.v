module ALU_ctrl (
    input wire [1:0] ALUOp,
    input wire [3:0] funct, 
    output reg [3:0] alu_ctrl
);
    always @(*) begin
        alu_ctrl = 4'b0000;
        //ALUOp = 00 (load/store), 01 (B-type), 10 (R-type or I-type ALU)
        case(ALUOp) 
            2'b00: begin
                alu_ctrl = 4'b0000; //always add for load/store
            end
            2'b01: begin
                alu_ctrl = 4'b1000; //always subtract for B-type
            end
            2'b10: begin
                alu_ctrl = funct;
            end
            default: begin
                alu_ctrl = 4'b0000;
            end
        endcase
    end
endmodule
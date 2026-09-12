module ALU_ctrl (
    input wire inst_30,
    input wire [1:0] ALUOp,
    input wire [3:0] funct, 
    output reg [3:0] alu_ctrl
);
    always @(*) begin
        alu_ctrl = 4'b0000;
        //ALUOp = 00 (load/store), 01 (B-type), 10 (R-type), 11(I-type ALU)
        case(ALUOp) 
            2'b00: begin
                alu_ctrl = 4'b0000; //always add for load/store
            end
            2'b01: begin
                case(funct[2:0]) 
                    3'b000, 3'b001: alu_ctrl = 4'b1000;
                    3'b100, 3'b101: alu_ctrl = 4'b0010;
                    3'b110, 3'b111: alu_ctrl = 4'b0011;
                    default: alu_ctrl = 4'b0;
                endcase
            end
            2'b10: begin
                alu_ctrl = funct;
            end
            2'b11: begin
                case(funct[2:0])
                    3'b000: alu_ctrl = 4'b0000;
                    3'b001: alu_ctrl = 4'b0001;
                    3'b010: alu_ctrl = 4'b0010;
                    3'b011: alu_ctrl = 4'b0011;
                    3'b100: alu_ctrl = 4'b0100;
                    3'b101: begin
                        alu_ctrl = (inst_30) ? 4'b1101 : 4'b0101;
                    end
                    3'b110: alu_ctrl = 4'b0110;
                    3'b111: alu_ctrl = 4'b0111;
                    default: alu_ctrl = 4'b0;
                endcase
            end
            default: begin
                alu_ctrl = 4'b0000;
            end                
        endcase
    end
endmodule
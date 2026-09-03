module ALU_ctrl (
    input wire [1:0] ALUOp,
    input wire [3:0] funct,
    output reg [3:0] alu_ctrl
);
    always @(*) begin
        alu_ctrl = 4'b0000;
        case(ALUOp) 
            2'b00: begin
                alu_ctrl = 4'b0010;
            end
            2'b01: begin
                alu_ctrl = 4'b0110;
            end
            2'b10: begin
                case(funct) 
                    4'b0000: begin
                        alu_ctrl = 4'b0010;
                    end
                    4'b1000: begin
                        alu_ctrl = 4'b0110;
                    end
                    4'b0111: begin
                        alu_ctrl = 4'b0000;
                    end
                    4'b0110: begin
                        alu_ctrl = 4'b0001;
                    end
                    default: begin
                        alu_ctrl = 4'b0000;
                    end
                endcase
            end
            default: begin
                alu_ctrl = 4'b0000;
            end
        endcase
    end
endmodule
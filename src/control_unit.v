module control_unit (
    input wire [6:0] opcode,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [1:0] aluop,
    output reg mem_write,
    output reg alusrc,
    output reg reg_write
);
    always @(*) begin
        case(opcode)
            //R-format 
            7'b0110011: begin
                alusrc = 0;
                mem_to_reg = 0;
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                aluop = 2'b10;
            end

            //I-type (only lw)
            7'b0000011: begin
                alusrc = 1;
                mem_to_reg = 1;
                reg_write = 1;
                mem_read = 1;
                mem_write = 0;
                branch = 0;
                aluop = 2'b00;
            end

            //S-type (only sw)
            7'b0100011: begin
                alusrc = 1;
                mem_to_reg = 0;
                reg_write = 0;
                mem_read = 0;
                mem_write = 1;
                branch = 0;
                aluop = 2'b00;
            end

            //SB-type(beq)
            7'b1100011: begin
                alusrc = 0;
                mem_to_reg = 0;
                reg_write = 0;
                mem_read = 0;
                mem_write = 0;
                branch = 1;
                aluop = 2'b01;
            end
            default: begin
                alusrc = 0;
                mem_to_reg = 0;
                reg_write = 0;
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                aluop = 2'b00;
            end        
        endcase
    end
endmodule
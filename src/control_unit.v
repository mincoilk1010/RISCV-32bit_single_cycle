module control_unit (
    input wire [6:0] opcode,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [1:0] aluop,
    output reg mem_write,
    output reg alusrc1, alusrc2,
    output reg reg_write,
    output reg PcSrc,
    output reg jump,
    output reg lui,
    output reg write_data_reg_src
);
    always @(*) begin
        //avoid latch
        branch = 0;
        mem_read = 0;
        mem_to_reg = 0;
        aluop = 2'b00;
        mem_write = 0;
        alusrc1 = 0;
        alusrc2 = 0;
        reg_write = 0;  
        PcSrc = 0;
        jump = 0;
        lui = 0;
        write_data_reg_src = 0;

        case(opcode)
            //R-type
            7'b0110011: begin
                alusrc2 = 0;
                alusrc1 = 0;
                mem_to_reg = 0;
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                aluop = 2'b10;
                PcSrc = 0;
                jump = 0;
                lui = 0;
                write_data_reg_src = 0;

            end

            //I-type
            //---caculate with constants
            7'b0010011: begin
                alusrc2 = 0;
                alusrc1 = 1;
                mem_to_reg = 0;
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                aluop = 2'b10;
                PcSrc = 0;
                jump = 0;
                lui = 0;
                write_data_reg_src = 0;
            end

            //---load from ram
            7'b0000011: begin
                alusrc2 = 0;
                alusrc1 = 1;
                mem_to_reg = 1;
                reg_write = 1;
                mem_read = 1;
                mem_write = 0;
                branch = 0;
                aluop = 2'b00;
                PcSrc = 0;
                jump = 0;
                lui = 0;
                write_data_reg_src = 0;
            end

            //---unconditional jump through register (jalr)
            7'b1100111: begin
                alusrc2 = 0;
                alusrc1 = 0;
                mem_to_reg = 0;
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                aluop = 2'b00;
                PcSrc = 1;
                jump = 1;
                lui = 0;
                write_data_reg_src = 1;
            end
            
            
            
            //S-type (store) 
            7'b0100011: begin
                alusrc2 = 0;
                alusrc1 = 1;
                mem_to_reg = 0;
                reg_write = 0;
                mem_read = 0;
                mem_write = 1;
                branch = 0;
                aluop = 2'b00;
                PcSrc = 0;
                jump = 0;
                lui = 0;
                write_data_reg_src = 0;
            end

            //B-type(condition branch)
            7'b1100011: begin
                alusrc2 = 0;
                alusrc1 = 0;
                mem_to_reg = 0;
                reg_write = 0;
                mem_read = 0;
                mem_write = 0;
                branch = 1;
                aluop = 2'b01;
                PcSrc = 0;
                jump = 0;
                lui = 0;
                write_data_reg_src = 0;
            end

            //U-type
            //---load upper immediate (lui)
            7'b0110111: begin
                alusrc2 = 0;
                alusrc1 = 0;
                mem_to_reg = 0;
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                aluop = 2'b00; //dont-care
                PcSrc = 0;
                jump = 0;
                lui = 1;
                write_data_reg_src = 0;
            end
            //---add upper immediate to pc (auipc)
            7'b0010111: begin
                alusrc2 = 1;
                alusrc1 = 1;
                mem_to_reg = 0;
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                aluop = 2'b00; 
                PcSrc = 0;
                jump = 0;
                lui = 0;
                write_data_reg_src = 0;
            end

            //J-type
            7'b1101111: begin
                alusrc2 = 0;
                alusrc1 = 0;
                mem_to_reg = 0;
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                aluop = 2'b00;
                PcSrc = 0;
                jump = 1;
                lui = 0;
                write_data_reg_src = 1;   
            end

            default: begin
                alusrc2 = 0;
                alusrc1 = 0;
                mem_to_reg = 0;
                reg_write = 0;
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                aluop = 2'b00; 
                PcSrc = 0;
                jump = 0;
                lui = 0;
                write_data_reg_src = 0;
            end        
        endcase
    end
endmodule
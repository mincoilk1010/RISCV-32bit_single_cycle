module data_memory (
    input wire clk,
    input wire [31:0] addr,
    input wire [31:0] write_data,
    input wire mem_write,
    input wire mem_read,
    input wire [2:0] funct3,
    output reg [31:0] read_data
);
    //reg [31:0] data_mem [0:255];
    reg [31:0] data_mem [0:4095];
    integer i;
    initial begin
        for(i=0; i<4096; i = i+1) begin
            data_mem[i] = 0;
        end
        $readmemh("src/data.hex", data_mem);
    end


    // wire [7:0] word_addr = addr[9:2];
    wire [11:0] word_addr = addr[13:2];
    wire [1:0] byte_offset = addr[1:0];

    wire [31:0] current_word = data_mem[word_addr];

    always @(*) begin
        read_data = 32'b0;
        if(mem_read) begin
            case(funct3) 
                //lb
                3'b000: begin
                    case(byte_offset)
                        2'b00: read_data = {{24{current_word[7]}}, current_word[7:0]};
                        2'b01: read_data = {{24{current_word[15]}}, current_word[15:8]};
                        2'b10: read_data = {{24{current_word[23]}}, current_word[23:16]};
                        2'b11: read_data = {{24{current_word[31]}}, current_word[31:24]};
                        default: read_data = 32'b0;
                    endcase                    
                end

                //lh
                3'b001: begin
                    case(byte_offset) 
                        2'b00: read_data = {{16{current_word[15]}}, current_word[15:0]};
                        2'b10: read_data = {{16{current_word[31]}}, current_word[31:16]};
                        default: read_data = 32'b0;
                    endcase
                end

                //lw
                3'b010: begin
                    read_data = current_word;
                end

                //lbu
                3'b100: begin
                    case(byte_offset) 
                        2'b00: read_data = {24'b0, current_word[7:0]};
                        2'b01: read_data = {24'b0, current_word[15:8]};
                        2'b10: read_data = {24'b0, current_word[23:16]};
                        2'b11: read_data = {24'b0, current_word[31:24]};
                        default: read_data = 32'b0;
                    endcase
                end

                //lhu
                3'b101: begin
                   case(byte_offset) 
                        2'b00: read_data = {16'b0, current_word[15:0]};
                        2'b10: read_data = {16'b0, current_word[31:16]};
                        default: read_data = 32'b0; 
                   endcase 
                end
                default: begin
                    read_data = 32'b0;
                end
            endcase
        end
    end
    
    reg [3:0] we;

    always @(*) begin
        we = 4'b0;
        if(mem_write) begin
            case(funct3)
                //sb 
                3'b000: begin
                    we[byte_offset] = 1'b1;
                end
                //sh
                3'b001: begin
                    if(byte_offset[1]) begin
                        we = 4'b1100;
                    end
                    else begin
                        we = 4'b0011;
                    end
                end
                //sw
                3'b010: begin
                    we = 4'b1111;
                end
                default: begin
                    we = 4'b0000;
                end
            endcase
        end
    end

    reg [31:0] aligned_data;
    //data replication for writting
    always @(*) begin
        aligned_data = 32'b0;
        case(funct3) 
            3'b000: aligned_data = {4{write_data[7:0]}};
            3'b001: aligned_data = {2{write_data[15:0]}};
            3'b010: aligned_data = write_data;
            default: aligned_data = 32'b0;
        endcase
    end

    always @(posedge clk) begin
        if(we[0]) begin
            data_mem[word_addr][7:0] <= aligned_data[7:0];
        end
        if(we[1]) begin
            data_mem[word_addr][15:8] <= aligned_data[15:8];
        end
        if(we[2]) begin
            data_mem[word_addr][23:16] <= aligned_data[23:16];
        end
        if(we[3]) begin
            data_mem[word_addr][31:24] <= aligned_data[31:24];
        end
    end
endmodule
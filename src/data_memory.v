module data_memory (
    input wire clk,
    input wire [31:0] addr,
    input wire [31:0] write_data,
    input wire mem_write,
    input wire mem_read,
    output wire [31:0] read_data
);
    reg [31:0] data_mem [0:255];

    integer i;
    initial begin
        for(i=0; i<256; i = i+1) begin
            data_mem[i] = 0;
        end
        data_mem[0] = 32'd10; 
        data_mem[1] = 32'd5; 
    end

    wire [7:0] word_addr = addr[9:2];

    assign read_data = (mem_read) ? data_mem[word_addr] : 32'd0;

    always @(posedge clk) begin
        if(mem_write) begin
            data_mem[word_addr] <= write_data;
        end
    end
endmodule
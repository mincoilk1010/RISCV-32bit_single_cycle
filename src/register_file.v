module register_file (
    input clk,
    input wire [4:0] read_addr_reg1,
    input wire [4:0] read_addr_reg2,
    input wire [4:0] write_addr_reg,
    input wire [31:0] write_data,
    output wire [31:0] read_data_reg1,
    output wire [31:0] read_data_reg2,
    input wire RegWrite
);
    reg [31:0] registers [0:31];
    
    integer i;
    initial begin
        for(i=0; i<32; i = i+1) begin
            registers[i] = 0;
        end
    end
    
    assign read_data_reg1 = (read_addr_reg1 == 5'd0) ? 32'd0 : registers[read_addr_reg1];
    assign read_data_reg2 = (read_addr_reg2 == 5'd0) ? 32'd0 : registers[read_addr_reg2];

    always @(posedge clk) begin
        if(RegWrite && write_addr_reg != 5'd0) begin
            registers[write_addr_reg] <= write_data;
        end
    end
endmodule 
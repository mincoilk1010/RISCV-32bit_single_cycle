module instruction_mem (
    input wire [31:0] read_addr,
    output wire [31:0] instruction
);
    reg [31:0] rom [0:255];
    // reg [31:0] rom [0:4095];
    wire [7:0] word_addr = read_addr[9:2];
    // wire [11:0] word_addr = read_addr[13:2];

    assign instruction = rom[word_addr];

    initial begin
        $readmemh("/home/minh-bui/Desktop/RISCV_32_Single_Cycle/src/program.hex", rom);  
    end
endmodule
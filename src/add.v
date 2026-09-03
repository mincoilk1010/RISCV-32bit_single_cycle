module add (
    input wire [31:0] in0,
    input wire [31:0] in1,
    output wire [31:0] sum
);
    assign sum = in0 + in1;
endmodule
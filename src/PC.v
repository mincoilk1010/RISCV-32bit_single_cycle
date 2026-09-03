module PC (
    input wire clk,
    input wire arstn,
    input wire [31:0] in,
    output reg [31:0] out
);
    always @(posedge clk or negedge arstn) begin
        if(!arstn) begin
            out <= 32'd0;
        end else begin
            out <= in;
        end
    end

endmodule
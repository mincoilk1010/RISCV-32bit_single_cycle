module riscv_top (
    input wire clk,
    input wire arstn,
    output wire [5:0] led
);
    wire [31:0] pc_next;
    wire [31:0] pc_out;
    wire [31:0] instruction;
    wire reg_write;
    wire [31:0] read_data_reg1;
    wire [31:0] read_data_reg2;

    wire [31:0] imm_out;
    wire [31:0] imm_out_shifted;
    wire alusrc;
    wire [31:0] readdata_or_immgen_out;

    wire [1:0] aluop;
    wire [3:0] alu_ctrl_out;

    wire zero;
    wire [31:0] alu_result;

    wire mem_write;
    wire mem_read;
    wire [31:0] read_data;

    wire mem_to_reg;

    wire [31:0] write_data_to_reg_file;

    wire [31:0] sum0;
    wire [31:0] sum1;

    wire branch;

    

    PC pc (
        .clk(clk),
        .arstn(arstn),
        .in(pc_next),
        .out(pc_out)
    );

    instruction_mem ins_mem (
        .read_addr(pc_out),
        .instruction(instruction)
    );

    control_unit cu (
        .opcode(instruction[6:0]),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .aluop(aluop),
        .mem_write(mem_write),
        .alusrc(alusrc),
        .reg_write(reg_write)
    );

    register_file rf (
        .clk(clk),
        .read_addr_reg1(instruction[19:15]),
        .read_addr_reg2(instruction[24:20]),
        .write_addr_reg(instruction[11:7]),
        .write_data(write_data_to_reg_file),
        .read_data_reg1(read_data_reg1),
        .read_data_reg2(read_data_reg2),
        .RegWrite(reg_write)
    );

    ImmGen imm_gen (
        .instruction(instruction),
        .imm_out(imm_out)
    );

    mux2_1 readdata_or_immgen (
        .in0(read_data_reg2),
        .in1(imm_out),
        .sel(alusrc),
        .out(readdata_or_immgen_out)
    );

    ALU_ctrl alu_ctrl (
        .ALUOp(aluop),
        .funct({instruction[30], instruction[14:12]}),
        .alu_ctrl(alu_ctrl_out)
    );

    ALU alu (
        .alu_ctrl(alu_ctrl_out),
        .in1(read_data_reg1),
        .in2(readdata_or_immgen_out),
        .zero(zero),
        .ALU_result(alu_result)
    );

    data_memory data_mem (
        .clk(clk),
        .addr(alu_result),
        .write_data(read_data_reg2),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(read_data)
    );

    mux2_1 mem_to_reg_mux (
        .in0(alu_result),
        .in1(read_data),
        .sel(mem_to_reg),
        .out(write_data_to_reg_file)
    );

    add pc_adder (
        .in0(pc_out),
        .in1(32'd4),
        .sum(sum0)
    );

    shift_left shift_left_1bit (
        .in(imm_out),
        .out(imm_out_shifted)
    );

    add pc_branch_adder (
        .in0(pc_out),
        .in1(imm_out_shifted),
        .sum(sum1)
    );

    mux2_1 branch_mux (
        .in0(sum0),
        .in1(sum1),
        .sel(branch & zero),
        .out(pc_next)
    );

    reg [5:0] led_reg;
    
    always @(posedge clk or negedge arstn) begin
        if (!arstn) begin
            led_reg <= 6'b000000;
        end else begin
            if (mem_write && (alu_result == 32'h0000_0100)) begin
                led_reg <= read_data_reg2[5:0];
            end
        end
    end

    assign led = ~led_reg;

endmodule
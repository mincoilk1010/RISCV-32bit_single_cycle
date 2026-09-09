`timescale 1ns / 1ps
module riscv_top (
    input wire clk,
    input wire arstn,
    output wire [5:0] led
);
    wire [31:0] PC_next;
    wire [31:0] PC_out;
    wire [31:0] inst;
    wire [31:0] write_data_reg;
    wire [31:0] read_data_reg1;
    wire [31:0] read_data_reg2;
    wire RegWrite;
    wire [31:0] imm_out;
    wire branch;
    wire mem_read;
    wire mem_to_reg;
    wire [1:0] aluop;
    wire mem_write;
    wire alusrc1,alusrc2;
    wire PcSrc;
    wire jump;
    wire lui;
    wire write_data_reg_src;
    wire [3:0] alu_ctrl_out;
    wire [31:0] alu_result;
    wire branch_out;
    wire [31:0] mem_read_data;
    wire [31:0] write_data_reg_in1;

    wire [31:0] alu_in1;
    wire [31:0] alu_in2;
    wire [31:0] alu_result_or_read_data_mem;
    wire [31:0] adder_in0;
    wire [31:0] adder_in1;   
    wire [31:0] write_data_reg_in0;

    PC pc (
        .clk(clk),
        .arstn(arstn),
        .in(PC_next),
        .out(PC_out)
    );


    instruction_mem ins_mem (
        .read_addr(PC_out),
        .instruction(inst)
    );

 
    register_file rf (
        .clk(clk),
        .read_addr_reg1(inst[19:15]),
        .read_addr_reg2(inst[24:20]),
        .write_addr_reg(inst[11:7]),
        .write_data(write_data_reg),
        .read_data_reg1(read_data_reg1),
        .read_data_reg2(read_data_reg2),
        .RegWrite(RegWrite)
    );


    ImmGen imm_gen (
        .instruction(inst),
        .imm_out(imm_out)
    );

    
    control_unit cu (
        .opcode(inst[6:0]),
        .branch(branch),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .aluop(aluop),
        .alusrc1(alusrc1),
        .alusrc2(alusrc2),
        .reg_write(RegWrite),
        .PcSrc(PcSrc),
        .jump(jump),
        .lui(lui),
        .write_data_reg_src(write_data_reg_src)
    );


    ALU_ctrl alu_ctrl (
        .ALUOp(aluop),
        .funct({inst[30], inst[14:12]}),
        .alu_ctrl(alu_ctrl_out)
    );


    ALU alu (
        .alu_ctrl(alu_ctrl_out),
        .in1(alu_in1),
        .in2(alu_in2),
        .ALU_result(alu_result)
    );


    branch_unit branch_inst (
        .alu_res(alu_result),
        .funct3(inst[14:12]),
        .branch_en(branch),
        .branch_out(branch_out)
    );


    data_memory data_mem (
        .clk(clk),
        .addr(alu_result),
        .write_data(read_data_reg2),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .funct3(inst[14:12]),
        .read_data(mem_read_data)
    );

    add adder (
        .in0(adder_in0),
        .in1(adder_in1),
        .sum(PC_next)
    );


    add PC_add_4 (
        .in0(PC_out),
        .in1(32'd4),
        .sum(write_data_reg_in1)
    );

    //all mux

    mux2_1 alusrc2_sel (
        .in0(read_data_reg1),
        .in1(PC_out),
        .sel(alusrc2),
        .out(alu_in1)
    );
    mux2_1 alusrc1_sel (
        .in0(read_data_reg2),
        .in1(imm_out),
        .sel(alusrc1),
        .out(alu_in2)
    );


    mux2_1 MemToReg_sel (
        .in0(alu_result),
        .in1(mem_read_data),
        .sel(mem_to_reg),
        .out(alu_result_or_read_data_mem)
    );


    mux2_1 PcSrc_sel (
        .in0(PC_out),
        .in1(read_data_reg1),
        .sel(PcSrc),
        .out(adder_in0)
    );

       
    mux2_1 Jump_and_Branch_sel (
        .in0(32'd4),
        .in1(imm_out),
        .sel(jump | branch_out),
        .out(adder_in1)
    );
    

    mux2_1 lui_sel (
        .in0(alu_result_or_read_data_mem),
        .in1(imm_out),
        .sel(lui),
        .out(write_data_reg_in0)
    );

    mux2_1 write_data_reg_src_mux (
        .in0(write_data_reg_in0),
        .in1(write_data_reg_in1),
        .sel(write_data_reg_src),
        .out(write_data_reg)
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
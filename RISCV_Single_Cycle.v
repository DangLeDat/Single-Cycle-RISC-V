module RISCV_Single_Cycle (
    input clk,                 // Tín hiệu đồng hồ
    input rst_n,               // Tín hiệu reset mức thấp
    output [31:0] PC_out_top,  // Giá trị PC cho testbench
    output [31:0] Instruction_out_top // Câu lệnh cho testbench
);
    // Các tín hiệu nội bộ
    wire [31:0] curr_pc, next_pc, instruction, imm_val, reg_data1, reg_data2;
    wire [31:0] alu_result, mem_data_out, reg_write_data, alu_src_b;
    wire [31:0] pc_next_4, branch_addr, jalr_addr;
    wire write_reg, read_mem, write_mem, mem_to_reg, src_alu, is_branch, is_jump, is_zero;
    wire [3:0] alu_op;
    wire [1:0] pc_select;
    wire pc_en;

    // Logic cập nhật PC
    assign pc_en = 1'b1; // Luôn cho phép cập nhật PC
    assign pc_next_4 = curr_pc + 4; // PC + 4
    assign branch_addr = curr_pc + imm_val; // Địa chỉ nhảy có điều kiện
    assign jalr_addr = reg_data1 + imm_val; // Địa chỉ nhảy JALR
    assign next_pc = (pc_select == 2'b00) ? pc_next_4 :
                     (pc_select == 2'b01) ? branch_addr :
                     (pc_select == 2'b10) ? jalr_addr : pc_next_4;

    // Bộ đếm chương trình (PC)
    PC pc_inst (
        .clk(clk),
        .rst_n(rst_n),
        .next_pc(next_pc),
        .pc_en(pc_en),
        .curr_pc(curr_pc)
    );

    // Bộ nhớ câu lệnh
    IMEM imem_inst (
        .inst_addr(curr_pc),
        .instruction(instruction)
    );

    // Đơn vị điều khiển
    ControlUnit ctrl_inst (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .write_reg(write_reg),
        .read_mem(read_mem),
        .write_mem(write_mem),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .src_alu(src_alu),
        .is_branch(is_branch),
        .is_jump(is_jump),
        .pc_select(pc_select)
    );

    // Ngân hàng thanh ghi
    RegisterFile reg_file_inst (
        .clk(clk),
        .rst_n(rst_n),
        .src_reg1(instruction[19:15]),
        .src_reg2(instruction[24:20]),
        .dst_reg(instruction[11:7]),
        .data_in(reg_write_data),
        .write_en(write_reg),
        .data_out1(reg_data1),
        .data_out2(reg_data2)
    );

    // Bộ tạo giá trị immediate
    ImmGen imm_gen_inst (
        .instruction(instruction),
        .imm_out(imm_val)
    );

    // ALU
    assign alu_src_b = src_alu ? imm_val : reg_data2;
    ALU alu_inst (
        .src_a(reg_data1),
        .src_b(alu_src_b),
        .operation(alu_op),
        .alu_out(alu_result),
        .is_zero(is_zero)
    );

    // Bộ nhớ dữ liệu
    DMEM dmem_inst (
        .clk(clk),
        .mem_addr(alu_result),
        .data_in(reg_data2),
        .write_en(write_mem),
        .read_en(read_mem),
        .data_out(mem_data_out)
    );

    // Ghi lại vào thanh ghi
    assign reg_write_data = mem_to_reg ? mem_data_out : 
                           (is_jump ? pc_next_4 : alu_result);

    // Đầu ra cho testbench
    assign PC_out_top = curr_pc;
    assign Instruction_out_top = instruction;

    // In thông tin gỡ lỗi
    always @(posedge clk) begin
        $display("Chu kỳ=%0d, PC=%h, Câu lệnh=%h, x3=%h, imm_val=%h, alu_result=%h, write_reg=%b, src_alu=%b, alu_op=%b",
                 $time/10, curr_pc, instruction, reg_file_inst.reg_file[3], imm_val, alu_result,
                 ctrl_inst.write_reg, ctrl_inst.src_alu, ctrl_inst.alu_op);
    end
endmodule

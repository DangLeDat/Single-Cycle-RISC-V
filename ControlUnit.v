module ControlUnit (
    input [6:0] opcode,        // Mã lệnh của câu lệnh
    input [2:0] funct3,        // Mã chức năng 3-bit
    input [6:0] funct7,        // Mã chức năng 7-bit
    output reg write_reg,      // Tín hiệu cho phép ghi thanh ghi
    output reg read_mem,       // Tín hiệu cho phép đọc bộ nhớ
    output reg write_mem,      // Tín hiệu cho phép ghi bộ nhớ
    output reg mem_to_reg,     // Tín hiệu chọn dữ liệu từ bộ nhớ sang thanh ghi
    output reg [3:0] alu_op,   // Mã lệnh điều khiển ALU
    output reg src_alu,        // Tín hiệu chọn nguồn cho ALU
    output reg is_branch,      // Tín hiệu báo lệnh nhảy có điều kiện
    output reg is_jump,        // Tín hiệu báo lệnh nhảy vô điều kiện
    output reg [1:0] pc_select // Tín hiệu chọn nguồn cho PC
);
    // Tạo tín hiệu điều khiển dựa trên câu lệnh
    always @(*) begin
        $display("ControlUnit: Chu kỳ=%0d, opcode=%b, funct3=%b, funct7=%b, write_reg=%b, src_alu=%b, alu_op=%b",
                 $time/10, opcode, funct3, funct7, write_reg, src_alu, alu_op);
        // Khởi tạo tín hiệu điều khiển mặc định
        write_reg = 1'b0;
        read_mem = 1'b0;
        write_mem = 1'b0;
        mem_to_reg = 1'b0;
        alu_op = 4'b0000;
        src_alu = 1'b0;
        is_branch = 1'b0;
        is_jump = 1'b0;
        pc_select = 2'b00; // Mặc định: PC + 4

        case (opcode)
            7'b0110011: begin // Lệnh R-type
                write_reg = 1'b1;
                src_alu = 1'b0;
                case ({funct3, funct7})
                    {3'b000, 7'h00}: alu_op = 4'b0000; // ADD
                    {3'b000, 7'h20}: alu_op = 4'b0001; // SUB
                    {3'b001, 7'h00}: alu_op = 4'b0101; // SLL
                    {3'b010, 7'h00}: alu_op = 4'b1000; // SLT
                    {3'b011, 7'h00}: alu_op = 4'b1001; // SLTU
                    {3'b100, 7'h00}: alu_op = 4'b0100; // XOR
                    {3'b101, 7'h00}: alu_op = 4'b0110; // SRL
                    {3'b101, 7'h20}: alu_op = 4'b0111; // SRA
                    {3'b110, 7'h00}: alu_op = 4'b0011; // OR
                    {3'b111, 7'h00}: alu_op = 4'b0010; // AND
                endcase
            end
            7'b0010011: begin // Lệnh I-type (ADDI, v.v.)
                write_reg = 1'b1;
                src_alu = 1'b1;
                case (funct3)
                    3'b000: alu_op = 4'b0000; // ADDI
                    3'b111: alu_op = 4'b0010; // ANDI
                    3'b110: alu_op = 4'b0011; // ORI
                    3'b100: alu_op = 4'b0100; // XORI
                    3'b001: alu_op = 4'b0101; // SLLI
                    3'b101: alu_op = (funct7 == 7'h00) ? 4'b0110 : 4'b0111; // SRLI, SRAI
                    3'b010: alu_op = 4'b1000; // SLTI
                    3'b011: alu_op = 4'b1001; // SLTIU
                endcase
            end
            7'b0000011: begin // Lệnh Load (LW)
                write_reg = 1'b1;
                read_mem = 1'b1;
                mem_to_reg = 1'b1;
                src_alu = 1'b1;
                alu_op = 4'b0000; // ADD
            end
            7'b0100011: begin // Lệnh Store (SW)
                write_mem = 1'b1;
                src_alu = 1'b1;
                alu_op = 4'b0000; // ADD
            end
            7'b1100011: begin // Lệnh nhảy có điều kiện (BEQ, v.v.)
                is_branch = 1'b1;
                alu_op = 4'b0001; // SUB
                pc_select = 2'b01; // PC + immediate
            end
            7'b1101111: begin // Lệnh JAL
                write_reg = 1'b1;
                is_jump = 1'b1;
                pc_select = 2'b01; // PC + immediate
                alu_op = 4'b0000;
            end
            7'b1100111: begin // Lệnh JALR
                write_reg = 1'b1;
                is_jump = 1'b1;
                pc_select = 2'b10; // rs1 + immediate
                alu_op = 4'b0000;
                src_alu = 1'b1;
            end
            7'b0110111: begin // Lệnh LUI
                write_reg = 1'b1;
                src_alu = 1'b1;
                alu_op = 4'b0000; // Truyền immediate
            end
            7'b0010111: begin // Lệnh AUIPC
                write_reg = 1'b1;
                src_alu = 1'b1;
                alu_op = 4'b0000; // Cộng PC + immediate
            end
            default: begin
                $display("Cảnh báo: Mã opcode không xác định: %b", opcode);
            end
        endcase
    end
endmodule

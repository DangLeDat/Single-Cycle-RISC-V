module ImmGen (
    input [31:0] instruction,  // Câu lệnh đầu vào
    output reg [31:0] imm_out  // Giá trị immediate được tạo
);
    // Tạo giá trị immediate dựa trên loại câu lệnh
    always @(*) begin
        $display("ImmGen: Chu kỳ=%0d, instruction=%h, imm_out=%h",
                 $time/10, instruction, imm_out);
        case (instruction[6:0]) // Mã opcode
            7'b0010011: // I-type (ADDI, v.v.)
                imm_out = {{20{instruction[31]}}, instruction[31:20]};
            7'b0000011: // Load (LW)
                imm_out = {{20{instruction[31]}}, instruction[31:20]};
            7'b0100011: // Store (SW)
                imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            7'b1100011: // Nhảy có điều kiện (BEQ, v.v.)
                imm_out = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            7'b1101111: // JAL
                imm_out = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            7'b0110111: // LUI
                imm_out = {instruction[31:12], 12'h000};
            7'b0010111: // AUIPC
                imm_out = {instruction[31:12], 12'h000};
            default: imm_out = 32'h00000000;
        endcase
    end
endmodule

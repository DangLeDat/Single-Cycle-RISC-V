module ALU (
    input [31:0] src_a,        // Toán hạng thứ nhất
    input [31:0] src_b,        // Toán hạng thứ hai
    input [3:0] alu_ctrl,      // Mã điều khiển ALU
    output reg [31:0] alu_out, // Kết quả ALU
    output reg is_zero         // Cờ báo kết quả bằng 0
);
    // Thực hiện phép toán dựa trên mã điều khiển
    always @(*) begin
        $display("ALU: Chu kỳ=%0d, src_a=%h, src_b=%h, alu_ctrl=%b, alu_out=%h",
                 $time/10, src_a, src_b, alu_ctrl, alu_out);
        case (alu_ctrl)
            4'b0000: alu_out = src_a + src_b;            // Phép cộng
            4'b0001: alu_out = src_a - src_b;            // Phép trừ
            4'b0010: alu_out = src_a & src_b;            // Phép AND bit
            4'b0011: alu_out = src_a | src_b;            // Phép OR bit
            4'b0100: alu_out = src_a ^ src_b;            // Phép XOR bit
            4'b0101: alu_out = src_a << src_b[4:0];      // Dịch trái logic
            4'b0110: alu_out = src_a >> src_b[4:0];      // Dịch phải logic
            4'b0111: alu_out = $signed(src_a) >>> src_b[4:0]; // Dịch phải số học
            4'b1000: alu_out = ($signed(src_a) < $signed(src_b)) ? 32'h1 : 32'h0; // So sánh nhỏ hơn có dấu
            4'b1001: alu_out = (src_a < src_b) ? 32'h1 : 32'h0; // So sánh nhỏ hơn không dấu
            default: alu_out = 32'h00000000;             // Mặc định: kết quả 0
        endcase
        is_zero = (alu_out == 32'h00000000);            // Đặt cờ zero
    end
endmodule

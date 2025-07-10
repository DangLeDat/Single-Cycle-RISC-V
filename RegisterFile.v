module RegisterFile (
    input clk,                 // Tín hiệu đồng hồ
    input rst_n,               // Reset mức thấp
    input [4:0] src_reg1,      // Địa chỉ thanh ghi nguồn 1
    input [4:0] src_reg2,      // Địa chỉ thanh ghi nguồn 2
    input [4:0] dst_reg,       // Địa chỉ thanh ghi đích
    input [31:0] data_in,      // Dữ liệu cần ghi
    input write_en,            // Cho phép ghi
    output [31:0] data_out1,   // Dữ liệu từ thanh ghi nguồn 1
    output [31:0] data_out2    // Dữ liệu từ thanh ghi nguồn 2
);
    reg [31:0] registers [0:31]; // Mảng 32 thanh ghi
    integer idx;

    // Đặt lại thanh ghi khi reset
    always @(negedge rst_n) begin
        for (idx = 0; idx < 32; idx = idx + 1)
            registers[idx] <= 32'h00000000;
    end

    // Ghi dữ liệu vào thanh ghi tại cạnh lên đồng hồ
    always @(posedge clk) begin
        if (write_en && dst_reg != 5'b00000) // Thanh ghi x0 luôn là 0
            registers[dst_reg] <= data_in;
        $display("RegisterFile: Chu kỳ=%0d, dst_reg=%0d, data_in=%h, x3=%h",
                 $time/10, dst_reg, data_in, registers[3]);
    end

    // Đọc dữ liệu từ thanh ghi
    assign data_out1 = (src_reg1 == 5'b00000) ? 32'h00000000 : registers[src_reg1];
    assign data_out2 = (src_reg2 == 5'b00000) ? 32'h00000000 : registers[src_reg2];
endmodule

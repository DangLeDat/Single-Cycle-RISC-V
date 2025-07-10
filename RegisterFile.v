module RegisterFile (
    input clk,                 // Tín hiệu đồng hồ
    input rst_n,               // Tín hiệu reset mức thấp
    input [4:0] src_reg1,      // Địa chỉ thanh ghi nguồn 1
    input [4:0] src_reg2,      // Địa chỉ thanh ghi nguồn 2
    input [4:0] dst_reg,       // Địa chỉ thanh ghi đích
    input [31:0] data_in,      // Dữ liệu cần ghi
    input write_en,            // Tín hiệu cho phép ghi
    output [31:0] data_out1,   // Dữ liệu từ thanh ghi nguồn 1
    output [31:0] data_out2    // Dữ liệu từ thanh ghi nguồn 2
);
    reg [31:0] reg_file [0:31]; // Mảng 32 thanh ghi
    integer idx;

    // Đặt lại tất cả thanh ghi khi reset
    always @(negedge rst_n) begin
        for (idx = 0; idx < 32; idx = idx + 1)
            reg_file[idx] <= 32'h00000000;
    end

    // Ghi dữ liệu vào thanh ghi tại cạnh lên của đồng hồ
    always @(posedge clk) begin
        if (write_en && dst_reg != 5'b00000) // Thanh ghi x0 luôn là 0
            reg_file[dst_reg] <= data_in;
        $display("RegisterFile: Chu kỳ=%0d, dst_reg=%0d, data_in=%h, x3=%h",
                 $time/10, dst_reg, data_in, reg_file[3]);
    end

    // Đọc dữ liệu từ thanh ghi
    assign data_out1 = (src_reg1 == 5'b00000) ? 32'h00000000 : reg_file[src_reg1];
    assign data_out2 = (src_reg2 == 5'b00000) ? 32'h00000000 : reg_file[src_reg2];
endmodule

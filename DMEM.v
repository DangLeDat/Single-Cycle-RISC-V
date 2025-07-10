module DMEM (
    input clk,                 // Tín hiệu đồng hồ
    input [31:0] mem_addr,     // Địa chỉ bộ nhớ
    input [31:0] data_in,      // Dữ liệu cần ghi
    input write_en,            // Tín hiệu cho phép ghi
    input read_en,             // Tín hiệu cho phép đọc
    output reg [31:0] data_out // Dữ liệu đọc từ bộ nhớ
);
    reg [31:0] data_mem [0:255]; // Mảng bộ nhớ 256 từ

    // Ghi dữ liệu vào bộ nhớ tại cạnh lên của đồng hồ
    always @(posedge clk) begin
        if (write_en)
            data_mem[mem_addr[31:2]] <= data_in;
    end

    // Đọc dữ liệu từ bộ nhớ (kết hợp)
    always @(*) begin
        if (read_en)
            data_out = data_mem[mem_addr[31:2]];
        else
            data_out = 32'h00000000;
    end
endmodule
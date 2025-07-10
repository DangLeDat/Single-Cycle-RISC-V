module DMEM (
    input clk,                 // Tín hiệu đồng hồ
    input [31:0] mem_addr,     // Địa chỉ bộ nhớ
    input [31:0] data_in,      // Dữ liệu cần ghi
    input write_en,            // Cho phép ghi
    input read_en,             // Cho phép đọc
    output reg [31:0] data_out // Dữ liệu đọc từ bộ nhớ
);
    reg [31:0] memory [0:255]; // Mảng bộ nhớ 256 từ

    // Ghi dữ liệu vào bộ nhớ tại cạnh lên đồng hồ
    always @(posedge clk) begin
        if (write_en)
            memory[mem_addr[31:2]] <= data_in;
    end

    // Đọc dữ liệu từ bộ nhớ (kết hợp)
    always @(*) begin
        if (read_en)
            data_out = memory[mem_addr[31:2]];
        else
            data_out = 32'h00000000;
    end
endmodule

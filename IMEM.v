module IMEM (
    input [31:0] inst_addr,    // Địa chỉ câu lệnh
    output [31:0] instruction  // Câu lệnh được lấy ra
);
    reg [31:0] memory [0:255]; // Bộ nhớ câu lệnh 256 từ

    // Lấy câu lệnh (địa chỉ căn chỉnh theo từ)
    assign instruction = memory[inst_addr[31:2]];

    // In thông tin gỡ lỗi
    always @(*) begin
        $display("IMEM: Chu kỳ=%0d, inst_addr=%h, instruction=%h",
                 $time/10, inst_addr, instruction);
    end
endmodule

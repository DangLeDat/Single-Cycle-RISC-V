module PC (
    input clk,                 // Tín hiệu đồng hồ
    input rst_n,               // Reset mức thấp
    input [31:0] next_pc,      // Giá trị PC tiếp theo
    input pc_en,               // Cho phép cập nhật PC
    output reg [31:0] curr_pc  // Giá trị PC hiện tại
);
    // Cập nhật PC tại cạnh lên đồng hồ hoặc khi reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            curr_pc <= 32'h00000000; // Đặt PC về 0
        else if (pc_en)
            curr_pc <= next_pc;      // Cập nhật PC
    end
endmodule

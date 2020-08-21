import user_type::sha256in_t;
import user_type::sha256out_t;

module sha256_top
(
    input wire         clk,
    input wire         rst,
    input  sha256in_t  in,
    output sha256out_t out,

    output abcdefgh_t dbg_abcdefgh_in  [63:0],
    output abcdefgh_t dbg_abcdefgh_out [63:0],
    output reg [31:0] dbg_w           [63:0], 
    output reg [31:0] dbg_k           [63:0] 
);

genvar i;

sha256in_t in_r;
sha256out_t out_w;
abcdefgh_t dbg_abcdefgh_in_w  [63:0];
abcdefgh_t dbg_abcdefgh_out_w [63:0];
wire [31:0] dbg_w_w           [63:0];
wire [31:0] dbg_k_w           [63:0]; 

always @(posedge clk) in_r <= in;

sha256 sha256_u
(
    .clk             (clk               ),
    .rst             (rst               ),
    .in              (in_r              ),
    .out             (out_w             ),
    .dbg_abcdefgh_in (dbg_abcdefgh_in_w ),
    .dbg_abcdefgh_out(dbg_abcdefgh_out_w),
    .dbg_w           (dbg_w_w           ),
    .dbg_k           (dbg_k_w           )

);

always @(posedge clk) out <= out_w;

for (i=0;i<64;i=i+1) begin : dbg
    always @(posedge clk) dbg_abcdefgh_in  [i] <= dbg_abcdefgh_in_w [i];
    always @(posedge clk) dbg_abcdefgh_out [i] <= dbg_abcdefgh_out_w[i];
    always @(posedge clk) dbg_w            [i] <= dbg_w_w           [i];
    always @(posedge clk) dbg_k            [i] <= dbg_k_w           [i];
end

endmodule

import user_type::sha256in_t;
import user_type::sha256out_t;
import user_type::abcdefgh_t;

module sha256
(
    input wire clk,
    input wire rst,
    input sha256in_t in,
    output sha256out_t out
    
`ifdef VERILATOR
    ,output abcdefgh_t dbg_abcdefgh_in  [63:0]
    ,output abcdefgh_t dbg_abcdefgh_out [63:0]
    ,output wire [31:0] dbg_w           [63:0] 
    ,output wire [31:0] dbg_k           [63:0] 
`endif     

);

genvar i;

localparam [31:0] k [63:0] = '{
    32'h428A2F98, 32'h71374491, 32'hB5C0FBCF, 32'hE9B5DBA5, 32'h3956C25B, 32'h59F111F1, 32'h923F82A4, 32'hAB1C5ED5,
    32'hD807AA98, 32'h12835B01, 32'h243185BE, 32'h550C7DC3, 32'h72BE5D74, 32'h80DEB1FE, 32'h9BDC06A7, 32'hC19BF174,
    32'hE49B69C1, 32'hEFBE4786, 32'h0FC19DC6, 32'h240CA1CC, 32'h2DE92C6F, 32'h4A7484AA, 32'h5CB0A9DC, 32'h76F988DA,
    32'h983E5152, 32'hA831C66D, 32'hB00327C8, 32'hBF597FC7, 32'hC6E00BF3, 32'hD5A79147, 32'h06CA6351, 32'h14292967,
    32'h27B70A85, 32'h2E1B2138, 32'h4D2C6DFC, 32'h53380D13, 32'h650A7354, 32'h766A0ABB, 32'h81C2C92E, 32'h92722C85,
    32'hA2BFE8A1, 32'hA81A664B, 32'hC24B8B70, 32'hC76C51A3, 32'hD192E819, 32'hD6990624, 32'hF40E3585, 32'h106AA070,
    32'h19A4C116, 32'h1E376C08, 32'h2748774C, 32'h34B0BCB5, 32'h391C0CB3, 32'h4ED8AA4A, 32'h5B9CCA4F, 32'h682E6FF3,
    32'h748F82EE, 32'h78A5636F, 32'h84C87814, 32'h8CC70208, 32'h90BEFFFA, 32'hA4506CEB, 32'hBEF9A3F7, 32'hC67178F2
};

localparam [31:0] h [7:0] = '{
    32'h6A09E667,
    32'hBB67AE85,
    32'h3C6EF372,
    32'hA54FF53A,
    32'h510E527F,
    32'h9B05688C,
    32'h1F83D9AB,
    32'h5BE0CD19
};

abcdefgh_t round_abcdefgh_in [63:0];
abcdefgh_t round_abcdefgh_out[63:0];

wire [31:0] round_w[63:0];
wire [31:0] round_k[63:0];

wire [31:0] w[15:0];
for (i=0;i<16;i=i+1) begin : wassign
    assign w[i] = in.w[((i+1)*32-1):(i*32)];
end

sha256out_t out_r = '0;

for (i=0;i<64;i=i+1) begin : sha256rounds
    wire [31:0] s0;
    wire [31:0] s1;
    wire [31:0] w0;
    wire [31:0] w1;

    assign round_abcdefgh_in[i] = (i==0)?({h[0],h[1],h[2],h[3],h[4],h[5],h[6],h[7]}):(round_abcdefgh_out[i-1]); 

    assign round_k[i] = k[63-i];

    assign w0 = (i<16)?(0):(round_w[i-15]); 
    assign w1 = (i<16)?(0):(round_w[i- 2]); 
    
    assign s0 = (i<16)?(0):({w0[ 6:0],w0[31: 7]} ^ {w0[17:0],w0[31:18]} ^ { 3'd0,w0[31: 3]}); //s0 := (w[i-15] rotr 7) xor (w[i-15] rotr 18) xor (w[i-15] shr 3) 
    assign s1 = (i<16)?(0):({w1[16:0],w1[31:17]} ^ {w1[18:0],w1[31:19]} ^ {10'd0,w1[31:10]}); //s1 := (w[i-2] rotr 17) xor (w[i-2] rotr 19) xor (w[i-2] shr 10) 
    /* verilator lint_off SELRANGE */ 
    assign round_w[i] = (i<16)?(w[i]):(round_w[i-16] + s0 + round_w[i-7] + s1);               //w[i] := w[i-16] + s0 + w[i-7] + s1
    /* verilator lint_on SELRANGE */ 

    round
    #(
        .ABCDEFGH_WIDTH (32),
        .W_WIDTH        (32),
        .K_WIDTH        (32)
    )
    round_u
    (
        .clk          (clk),
        .rst          (rst),
        .abcdefgh_in  (round_abcdefgh_in [i]),
        .abcdefgh_out (round_abcdefgh_out[i]),
        .w            (round_w           [i]),
        .k            (round_k           [i])
    );
end

always @(posedge clk) out_r.hash <= {
    (round_abcdefgh_out[63].h+h[0]),
    (round_abcdefgh_out[63].g+h[1]),
    (round_abcdefgh_out[63].f+h[2]),
    (round_abcdefgh_out[63].e+h[3]),
    (round_abcdefgh_out[63].d+h[4]),
    (round_abcdefgh_out[63].c+h[5]),
    (round_abcdefgh_out[63].b+h[6]),
    (round_abcdefgh_out[63].a+h[7])
};

assign out = out_r;

`ifdef VERILATOR
    for (i=0;i<64;i=i+1) begin : dbg
        assign dbg_abcdefgh_in [i] = round_abcdefgh_in [i];
        assign dbg_abcdefgh_out[i] = round_abcdefgh_out[i];
        assign dbg_w           [i] = round_w           [i];
        assign dbg_k           [i] = round_k           [i];
    end
`endif     

endmodule

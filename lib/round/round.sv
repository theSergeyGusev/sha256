import user_type::abcdefgh_t;

module round
#(
    parameter ABCDEFGH_WIDTH = 32,
    parameter W_WIDTH = 32,
    parameter K_WIDTH = 32
)

(
    input wire clk,
    input wire rst,

    input abcdefgh_t abcdefgh_in,
    output abcdefgh_t abcdefgh_out,
    
    input wire [W_WIDTH-1:0] w,
    input wire [K_WIDTH-1:0] k
);

wire [ABCDEFGH_WIDTH-1:0] a_in = abcdefgh_in.a; 
wire [ABCDEFGH_WIDTH-1:0] b_in = abcdefgh_in.b; 
wire [ABCDEFGH_WIDTH-1:0] c_in = abcdefgh_in.c; 
wire [ABCDEFGH_WIDTH-1:0] d_in = abcdefgh_in.d; 
wire [ABCDEFGH_WIDTH-1:0] e_in = abcdefgh_in.e; 
wire [ABCDEFGH_WIDTH-1:0] f_in = abcdefgh_in.f; 
wire [ABCDEFGH_WIDTH-1:0] g_in = abcdefgh_in.g; 
wire [ABCDEFGH_WIDTH-1:0] h_in = abcdefgh_in.h; 

wire [ABCDEFGH_WIDTH-1:0] sum0 = {a_in[1:0],a_in[ABCDEFGH_WIDTH-1:2]} ^ {a_in[12:0],a_in[ABCDEFGH_WIDTH-1:13]} ^ {a_in[21:0],a_in[ABCDEFGH_WIDTH-1:22]};   //Σ0 := (a rotr 2) xor (a rotr 13) xor (a rotr 22)   
wire [ABCDEFGH_WIDTH-1:0] ma = (a_in&b_in) ^ (a_in&c_in) ^ (b_in&c_in);                                                                                    //Ma := (a and b) xor (a and c) xor (b and c)      
wire [ABCDEFGH_WIDTH-1:0] t2 = sum0+ma;                                                                                                                    //t2 := Σ0 + Ma                                    
wire [ABCDEFGH_WIDTH-1:0] sum1 = {e_in[5:0],e_in[ABCDEFGH_WIDTH-1:6]} ^ {e_in[10:0],e_in[ABCDEFGH_WIDTH-1:11]} ^ {e_in[24:0],e_in[ABCDEFGH_WIDTH-1:25]};   //Σ1 := (e rotr 6) xor (e rotr 11) xor (e rotr 25) 
wire [ABCDEFGH_WIDTH-1:0] ch = (e_in&f_in) ^ ((~e_in)&g_in);                                                                                               //Ch := (e and f) xor ((not e) and g)              
wire [ABCDEFGH_WIDTH-1:0] t1 = h_in + sum1 + ch + k + w;                                                                                                   //t1 := h + Σ1 + Ch + k[i] + w[i]                  

wire [ABCDEFGH_WIDTH-1:0] a1 = t1 + t2;     //a := t1 + t2  
wire [ABCDEFGH_WIDTH-1:0] b1 = a_in;        //b := a       
wire [ABCDEFGH_WIDTH-1:0] c1 = b_in;        //c := b       
wire [ABCDEFGH_WIDTH-1:0] d1 = c_in;        //d := c       
wire [ABCDEFGH_WIDTH-1:0] e1 = d_in + t1;   //e := d + t1  
wire [ABCDEFGH_WIDTH-1:0] f1 = e_in;        //f := e       
wire [ABCDEFGH_WIDTH-1:0] g1 = f_in;        //g := f       
wire [ABCDEFGH_WIDTH-1:0] h1 = g_in;        //h := g       

assign abcdefgh_out.a = a1; 
assign abcdefgh_out.b = b1;
assign abcdefgh_out.c = c1;
assign abcdefgh_out.d = d1;
assign abcdefgh_out.e = e1;
assign abcdefgh_out.f = f1;
assign abcdefgh_out.g = g1;
assign abcdefgh_out.h = h1;

endmodule

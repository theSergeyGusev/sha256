/* verilator lint_off DECLFILENAME */
package user_type;

typedef struct    packed {
    logic         state;
    logic         start;
    logic         stop;
    logic [511:0] w;
} sha256in_t;

typedef struct    packed {
    logic         hash_en;
    logic [255:0] hash;
} sha256out_t;


typedef struct    packed {
    logic [31:0] h;
    logic [31:0] g;
    logic [31:0] f;
    logic [31:0] e;
    logic [31:0] d;
    logic [31:0] c;
    logic [31:0] b;
    logic [31:0] a;
} abcdefgh_t;

endpackage
/* verilator lint_on DECLFILENAME */


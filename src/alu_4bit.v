// N bit alu, but for the purposes of this tutorial, we'll keep it at 4 bits: 
`default_nettype none

module alu_4bit #(
    parameter N = 4
)(
    input wire [N-1:0] a, 
    input wire [N-1:0] b, 
    input wire [2:0] op, 
    output reg [N-1:0] result, 
    output reg          carry_out, // carry
    output wire         zero,   // zero
    output wire         neg,    // negative
    output wire         ov      // overflow
);

    /*
    Opcode Table  for reference: 

    000 - ADD
    001 - SUB
    010 - AND
    011 - OR 
    100 - XOR 
    101 - CMP 
    110 - LSL (logical shift left by )
    111 - LSR (logical shift right) 
    */

    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;
    localparam CMP = 3'b101;
    localparam LSL = 3'b110;    // LSL by 1
    localparam LSR = 3'b111;    // LSR by 1

    // sub and cmp both compute a-b as a + ~b + 1 
    wire sub = (op == SUB) | (op == CMP); 
    wire [N-1:0] b_eff = b ^ {N{sub}}; 

    wire [N-1:0]    sum;
    wire            cout;

    adder_4bit #(.N(N)) u_adder (
        .a      (a), 
        .b      (b_eff), 
        .cin    (sub), 
        .cout   (cout), 
        .sum    (sum)
    );
    // everything in the ALU is combinational, so no flops are required: 

    always @(*) begin 
        result      = {N{1'b0}}; 
        carry_out   = 1'b0; 

        case (op) 
            ADD, 
            SUB: begin 
                result  = sum; 
                carry_out   = cout; 
            end
            AND: result = a & b; 
            OR: result = a | b; 
            XOR: result = a ^ b; 
            CMP: begin 
                result =    {N{1'b0}}; 
                carry_out = cout;   
            end

            LSL: begin 
                result =    a << 1; 
                carry_out = a[N-1];     // MSB shifted out first
            end

            LSR: begin 
                result =    a >> 1; 
                carry_out = a[0];       // LSB shifted out first 
            end

            default: result = {N{1'b0}};
        endcase
    end

    // flags: CMP flags come from the difference: 

    wire [N-1:0]    flag_v = (op == CMP) ? sum : result; 
    wire            is_arith = (op == ADD) | sub; 

    assign zero = (flag_v == {N{1'b0}}); 
    assign neg = flag_v[N-1];              // if MSB if 1, it's a negative 
    assign ov = is_arith & (a[N-1] == b_eff[N-1]) & (sum[N-1] != a[N-1]);

endmodule

`default_nettype wire
// N bit alu, but for the purposes of this tutorial, we'll keep it at 4 bits: 

module alu_4bit #(
    parameter N = 4; 
)(
    input wire [N-1:0] a, 
    input wire [N-1:0] b, 
    input wire [2:0] op, 
    output reg [N-1:0] result, 
    output reg          carry_out, 
    output wire         zero ;
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

endmodule
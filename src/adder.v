// 4 bit ripple carry adder:  

module adder_4bit #(
    parameter N = 4
    )(
        input wire [N-1:0] a, 
        input wire [N-1:0] b, 
        input wire cin, 
        output wire [N-1:0] sum, 
        output wire cout

);

    wire [N:0] carry; 
    
    assign carry[0] = cin; 
    assign cout = carry[N]; 

    genvar i; 
    generate 
        for (i = 0; i < N; i = i + 1) begin : gen_adders
            // if you don't have full_adder submodule, you'd need to implement the logic yourself: 

            // assign sum[i] = a[i] ^ b[i] ^ carry[i]; 
            // assign carry[i+1] = 
            //     (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]); 

            // since we already implemented the full_adder module in another verilog file, we can just call it via instantiation: 

            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

endmodule
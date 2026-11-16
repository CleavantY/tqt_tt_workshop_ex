/*
 * Copyright (c) 2024 
 * SPDX-License-Identifier: Apache-2.0
 */

// project.v is your top module. This is where you would call on any submodules or
// wire your top module's wires to your submodule. 



`default_nettype none

module tt_um_alu_4bit (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  alu_4bit #(.N(4)) u_alu (
      .a         (ui_in[3:0]),
      .b         (ui_in[7:4]),
      .op        (uio_in[2:0]),
      .result    (uo_out[3:0]),
      .carry_out (uo_out[4]),
      .zero      (uo_out[5]),
      .neg       (uo_out[6]),
      .ov        (uo_out[7])
  );

  // All bidirectional pins are inputs
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in[7:3], 1'b0};

endmodule

`default_nettype wire
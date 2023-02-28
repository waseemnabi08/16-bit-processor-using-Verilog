module CPU (
    input clk,
    input reset,
    output reg [15:0] data_out
);
    Control_unit uut ();
    ALU uut1 ();

endmodule


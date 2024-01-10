module ALU (clk, rst, we,status, opcode, REG2, REG3, func, j_address, result, mulres);
input clk, rst, we;
input [8:0] j_address;
input [3:0] opcode;
input [15:0] REG2, REG3, status;
reg [15:0] REG1;
input [2:0] func;
output reg [15:0] result;
output reg [31:0] mulres;
reg Z,N,C,OF;
 
reg [7:0] PC; 

reg [8:0] PC_ext;

always @(j_address) 
begin 
  PC_ext = {PC[7], PC};
end 


always @ (status) begin 
   if(status[0]==1) begin 
       OF=1; end
   if(status[1]==1) begin 
       C=1; end
   if(status[2]==1) begin 
       N=1; end
   if(status[3]==1) begin 
       Z=1; end
    end 
 

integer i;

reg [15:0] MEM[65535:0]; // 16-bit memory with 2^16 memory locations
always @ (posedge clk) begin 
     if(we) 
        for (i=0; i<65535; i=i+1)
           MEM[i]=i;
     end
always @ (posedge clk) begin 
    if(rst) begin
        REG1 <= 16'b0;
        result <= 16'b0;
        mulres <= 32'b0;
    end else if(we) begin
        for (i=0; i<65535; i=i+1)
            MEM[i]=16'd0;
    end
end

always @(*) begin
    case(opcode)
        4'b0000: begin
            case(func)
                3'b000: REG1 <= REG2 + REG3;
                3'b001: REG1 <= REG2 - REG3;
                3'b010: REG1 <= REG2 / REG3;
                default: REG1 <= 16'b0;
            endcase
        end
        4'b0001: REG1 <= REG2 << REG3;
        4'b0010: REG1 <= REG2 >> REG3;
        4'b0011: REG1 <= REG2 | REG3;
        4'b0100: REG1 <= REG2 & REG3;
        4'b0101: REG1 <= REG2 + REG3;
        4'b0110: REG1 <= REG2;
        4'b0111: REG1 <= MEM[REG2 + REG3];
        4'b1000: MEM[REG2 + REG3] = REG1;
        4'b1001: REG1 <= 16'b0;
        4'b1010: mulres <= REG2 * REG3;
        4'b1011: REG1 <= mulres[15:0];
        4'b1100: REG1 <= mulres[31:16];
        4'b1101: 
               if((N==1) | (Z==1)) begin 
                 REG1 <= REG2+REG3; end
               else begin 
                   $finish; end
        4'b1110:
               if ((N==1)|(Z==1)|(C==1)|(OF==1)) begin 
                  PC_ext= PC_ext+j_address; end
               else begin 
                   $finish; end

    endcase
end
   
  
 always @ (PC_ext)  begin 
        PC= PC_ext[8:1]; end
 
     

always @ (REG1) begin 
    result <= REG1;
end
endmodule

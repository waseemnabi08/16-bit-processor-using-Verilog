
module control_unit (clk, rst, op, rd,rs,rt, func, shift_amount,const,adds1, jump_address, result);

input clk, rst;
inout reg [2:0] rs, rt, rd,func, shift_amount;
inout reg [3:0] op;
inout reg [5:0] const, adds1; 
inout reg [7:0] jump_address;
inout reg [15:0] result;


reg [7:0] PC;
counter c1(clk, rst, PC);
   

reg [15:0] inst;

reg [15:0] ROM[0:15]; 
initial 
begin
ROM[0]= 16'b000_010_001_000_0000;
ROM[1]= 16'b000_010_001_000_0001;
ROM[2]= 16'b000_010_001_000_0010;
ROM[3]= 16'b000_010_001_000_0100 ;
end




always @(posedge clk) 
   begin 
      inst =ROM[PC];
   end 

 Decoder D1(inst,op,rd,rs,rt,func,shift_amount, const, jump_address,adds2);

 always @ (posedge clk) begin 
      if(op==9) begin 
        PC=PC+jump_address; end
      else begin
        PC=PC+1; end
     end



Datapath D2(clk,rst,op,rs,rt,rd,func,shift_amount,const,jump_address,PC, result);
  


 
endmodule 




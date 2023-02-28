module Decoder(inst,op,rd,rs,rt,func,shift_amount, const,jump_address,adds2);

input [0:15] inst;
output reg [3:0] op;
output reg [2:0] rd,rs,rt,func,shift_amount ;
output reg [5:0] const, adds2;
output reg [8:0] jump_address;

always @ (inst) begin  
  op=inst[0:3];
  if (op==0) begin
    rd= inst [4:6];
    rs= inst [7:9];
    rt= inst [10:12];
    func=inst[13:15];
  end
  else if ((op==1)|(op==2)) begin 
    rd= inst [4:6];
    rs= inst [7:9];
    rt= 0;
    shift_amount= inst[13:15];
  end 
  else if ((op>2) & (op<5)) begin 
    rd = inst[4:6];
    rs = inst[7:9];
    rt = inst[10:12];
    shift_amount=inst[13:15];
  end 
  else if((op==5)|(op==7)|(op==8)) begin 
    rd= inst [4:6];
    rs= inst [7:9];
    const=inst[10:15];
  end 
  else if(op==6) begin 
    rd = inst[4:6];
    const= inst[10:15];
  end
  else if (op==9) begin 
    jump_address= inst[4:12];
  end
  else begin 
    rd= inst [4:6];
    rs= inst [7:9];
    adds2=inst[10:15];
  end
end

endmodule 
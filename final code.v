module memory(address,readNotwrite,data,cs,clk);
input [15:0] address ; 
inout [7:0] data ;
input readNotwrite,clk ,cs;
reg [7:0] d [0:65455];
reg [7:0] temp;
assign data = temp ;  
always @ (posedge clk)
begin
if (cs)
begin
temp <=  (readNotwrite) ? d[address] : 8'bzzzzzzzz;
d[address] <= (readNotwrite) ? d[address] : data;
end
else temp <= 8'dz;
end
endmodule 

module mem_interface(read,write,address,data,clk);
inout [7:0] data ;
input [15:0] address ; 
reg[15:0] outaddress ;
reg cs,readNotwrite;
input read ,write, clk;
memory m1(outaddress,readNotwrite,data,cs,clk);
always @ (address or read or write or data)
begin
if (address > 79)
begin
outaddress<= address - 80;
cs<=1;
if (read)  readNotwrite<=1; 
if (write) readNotwrite<=0;
end
else cs <=0;
end
endmodule

module IO1(address,readNotwrite,data,cs,clk);
input [15:0] address ; 
inout [7:0] data ;
input readNotwrite,clk ,cs;
reg [7:0] d [0:31];
reg [7:0] temp;
assign data = temp ;  
always @ (posedge clk)
begin
if (cs)
begin
temp <=  (readNotwrite) ? d[address] : 8'bzzzzzzzz;
d[address] <= (readNotwrite) ? d[address] : data;
end
else temp <= 8'dz;
end
endmodule 

module IO1_interface(read,write,address,data,clk);
inout [7:0] data ;
input [15:0] address ; 
reg[15:0] outaddress ;
reg cs,readNotwrite;
input read ,write, clk;
IO1 dev1(outaddress,readNotwrite,data,cs,clk);
always @ (address or read or write or data)
begin
if (address < 80)
begin
if (address > 47)
begin
outaddress<= address - 48;
cs<=1;
if (read)  readNotwrite<=1; 
if (write) readNotwrite<=0;
end
else cs <=0;
end
else cs <=0;
end
endmodule

module IO2(address,readNotwrite,data,cs,clk);
input [15:0] address ; 
inout [7:0] data ;
input readNotwrite,clk ,cs;
reg [7:0] d [0:31];
reg [7:0] temp;
assign data = temp ; 
always @ (posedge clk)
begin
if (cs)
begin
temp <=  (readNotwrite) ? d[address] : 8'bzzzzzzzz;
d[address] <= (readNotwrite) ? d[address] : data;
end
else temp <= 8'dz;
end
endmodule 

module IO2_interface(read,write,address,data,clk);
inout [7:0] data ;
input [15:0] address ; 
reg[15:0] outaddress ;
reg cs,readNotwrite;
input read ,write, clk;
IO2 dev2(outaddress,readNotwrite,data,cs,clk);
always @ (address or read or write or data)
begin
if (address < 48)
begin
if (address > 15)
begin
outaddress<= address - 16;
cs<=1;
if (read)  readNotwrite<=1; 
if (write) readNotwrite<=0;
end
else cs <=0;
end
else cs <=0;
end
endmodule
 
module clockgen( clk );
output reg clk;
initial  clk=0;
always  #100 clk<=~clk;
endmodule

module processor(address,read,write,data,clk,dmar,dmaack,hld,hldack,eop,reset,processor_16bit );
output reg [15:0] address ; 
inout [7:0] data ;
reg [7:0] temp , tempdata ;
output reg read,write,reset,hldack,dmar,eop;
input clk,dmaack,hld ;
integer i;
reg [15:0] tempaddress1 ,tempaddress2;
assign data = temp;
output reg processor_16bit;
initial
begin
processor_16bit =0;
eop<=1'bz;
i=0;
read=0;
temp=8'd0;
write =1;
address = 16'd80;
@(posedge clk)
for(i=0;i<100;i=i+1)
begin
@(posedge clk)
temp = temp+1;
address = address + 1 ;
end
write =0;
read=0;
address = 16'dz;
@(posedge clk)
processor_16bit =1;
@(posedge clk)
i=0;
read=0;
temp=8'd0;
write =1;
address = 16'd280;
@(posedge clk)
for(i=0;i<100;i=i+1)
begin
@(posedge clk)
temp = temp+1;
address = address + 1 ;
end
read=0;
write=0;
processor_16bit =0;
address = 16'dz;
@(posedge clk)
write=1;
@(posedge clk)
address=16'd0;
temp=8'd0;
@(posedge clk)
write=1;
@(posedge clk)
address=16'd2;
temp=8'd110;
@(posedge clk)
address=16'd4;
temp=8'd20;
@(posedge clk)
address = 16'dz;
temp=8'bz;
write=1'bz;
@(posedge clk)
dmar=1;
write=1'bz;
read=1'bz;
@(posedge clk)
dmar=0;
@(posedge clk)
wait (hld) hldack=1;
wait (hld==0) hldack=0;
@(posedge clk)
dmar=0;// 8yrhaaaaaa
read=0;
write=0;
address = 16'dz;
@(posedge clk)
write=1;
@(posedge clk)
address=16'd0;
temp=8'b0010_0010;
@(posedge clk)
write=1;
@(posedge clk)
address=16'd5;
temp=8'd10;
@(posedge clk)
address=16'd2;
temp=8'b0010_0010;
@(posedge clk)
address=16'd7;
temp=8'b0000_0001;
@(posedge clk)
address=16'd4;
temp=8'd35;
@(posedge clk)
address = 16'dz;
temp=8'bz;
write=1'bz;
@(posedge clk)
processor_16bit=1;
dmar=1;
write=1'bz;
read=1'bz;
@(posedge clk)
dmar=0;
@(posedge clk)
wait (hld) hldack=1;
/*#5000 eop<=0;*/
wait (hld==0) hldack=0;
eop<=1'bz;
@(posedge clk)
read=0;
write=0;
address = 16'dz;
processor_16bit=0;
@(posedge clk)
write=1;
@(posedge clk)
address=16'd0;
temp=8'b0000_0100;
@(posedge clk)
address=16'd5;
temp=8'd5;
@(posedge clk)
address=16'd2;
temp=8'd110;
@(posedge clk)
address=16'd4;
temp=8'd60;
@(posedge clk)
write=0;
@(posedge clk)
address = 16'dz;
temp=8'bz;
write=1'bz;
@(posedge clk)
dmar=1;
write=1'bz;
read=1'bz;
@(posedge clk)
wait (hld) hldack=1;
#5000 dmar=0;
wait (hld==0) hldack=0;

end
endmodule

module DMA_interface(io_R,io_W,mem_R,mem_W,cs,address,read,write,dmar0,dmar1,dmar2,dmar3,dmack0,dmack1,dmack2,dmack3,clk,adress1,processor_16bit);
inout io_R,io_W,write,read,processor_16bit;
inout [15:0] address;
inout [3:0] adress1;
input mem_R,mem_W,dmar0,dmar1,dmar2,dmar3,dmack0,dmack1,dmack2,dmack3,clk;
reg [3:0] tempadress1;
reg [3:0] tempaddress;
output reg cs;
reg temp,temp1,tomp,tomp1;
reg [7:0]ad_upper;
assign io_W=temp   ;assign io_R=temp1;  assign write=tomp;   assign read=tomp1;
assign {address[3:0]}=tempaddress;  assign adress1=tempadress1;
assign {address[7:4]}=4'dz;
assign {address[15:8]}=ad_upper;
NOTOR o1(mem_W,io_W,out1);    NOTOR o2(mem_R,io_R,out2);
always @(mem_R,mem_W,dmar0,dmar1,dmar2,dmar3,dmack0,dmack1,dmack2,dmack3,clk,io_R,io_W,write,read,address,adress1,tempaddress,tempadress1,temp,temp1,tomp,tomp1,processor_16bit,out1,out2,processor_16bit)
begin
if (processor_16bit)ad_upper<=8'dz;
else ad_upper<=8'd0;
if(dmar0 ||dmar1 ||dmar2 || dmar3 || dmack0 ||dmack1 ||dmack2 || dmack3)
begin
tempadress1<=4'dz;
tempaddress<=adress1;
temp<=1'bz;  temp1<=1'bz;
//tomp<=((~io_W) || (~mem_W));  tomp1<=((~io_R) || (~mem_R));
tomp<=out1;   tomp1<=out2;
cs<=0;
end
else 
begin
tempaddress=4'dz;
tempadress1=address;
tomp=1'bz; tomp1=1'bz;
temp<=(~write);  temp1<=(~read);
if (address <16) cs<=0;   else cs<=1;
end
end
endmodule

module transfer_process(data,address,dest_address,clk,IOread,IOwrite,memread,memwrite,A03,A47,enable,ack);
output reg IOread,IOwrite,memread,memwrite,ack;
input clk,enable;
input [7:0] address,dest_address;
output reg [3:0] A03,A47;
inout [7:0] data;
reg [7:0] temp , tempdata ; 
assign data =temp;
always@(posedge clk)
begin
if(enable)
begin
ack<=0;
temp<=8'dz;
if(address<80)
begin 
@(posedge clk)
IOwrite<=1;
IOread<=0;
memread<=1;
memwrite<=1;
A03<={address[3:0]};
A47<={address[7:4]};
tempdata<=data;
@(posedge clk)
if(dest_address<80)
begin
IOread<=1;
IOwrite<=0;
memread<=1;
memwrite<=1;
A03<={dest_address[3:0]};
A47<={dest_address[7:4]};
temp<=tempdata;
temp<=8'dz;
end
if(dest_address>80)
begin
memread<=1;
memwrite<=0;
IOread<=1;
IOwrite<=1;
A03<={dest_address[3:0]};
A47<={dest_address[7:4]};
temp<=tempdata;
temp<=8'dz;
end
end
if(address>80)
begin 
@(posedge clk)
memwrite<=1;
memread<=0;
IOread<=1;
IOwrite<=1;
A03<={address[3:0]};
A47<={address[7:4]};
tempdata<=data;
@(posedge clk)
if(dest_address<80)
begin
IOread<=1;
IOwrite<=0;
memread<=1;
memwrite<=1; 
A03<={dest_address[3:0]};
A47<={dest_address[7:4]};
temp<=tempdata;
temp<=8'dz;
end
if(dest_address>80)
begin
memread<=1;
memwrite<=0;
IOread<=1;
IOwrite<=1;
A03<={dest_address[3:0]};
A47<={dest_address[7:4]};
temp<=tempdata;
temp<=8'dz;
end
end
ack<=1;
end
else 
begin
temp<= 8'dz;
ack<=1;
A03<=4'dz;
IOread<=1'bz;
IOwrite<=1'bz;
A47<=4'dz;
end
end
endmodule

module command (comand,auto_initial,mode,assendNotdesnd,priority,sixteenBetAdress);
input [7:0]comand;
output auto_initial,assendNotdesnd,priority,sixteenBetAdress;
output [1:0] mode;
assign auto_initial = {comand[0:0]};
assign mode = {comand[2:1]};
assign assendNotdesnd={comand[3:3]};
assign priority={comand[4:4]};
assign sixteenBetAdress={comand[5:5]};
endmodule

module controller (strobe,add,sub,hrq,REQ_MODE3,mode,hlda,crnt_ad,crnt_dc,crnt_dest,assendNotdesnd,auto_initial,base_ad,base_dest,base_dc,outAdress,outAdress_D,End_p,process_enable,process_ack,clk);
output reg strobe;
output reg [1:0]add,sub;
input REQ_MODE3,hlda,assendNotdesnd,auto_initial,process_ack,clk;
input [1:0]mode;
input [7:0] base_ad,crnt_ad,base_dest,crnt_dest,crnt_dc,base_dc;
output reg  [7:0] outAdress,outAdress_D;
output reg process_enable;
inout End_p;
reg zs ;
assign End_p=zs;
input hrq;
reg [7:0] current ,crntdc,dest;
always @( posedge hrq)
begin
if (mode>0)begin
if(auto_initial)
begin
current<=base_ad;
crntdc<=base_dc;
dest<=base_dest;
end
else 
begin
current<=crnt_ad;
crntdc<=crnt_dc;
dest<=crnt_dest;
end
end
if(mode==0)
begin
if(auto_initial)
begin
current<=base_ad;
crntdc<=1;
dest<=base_dest;
end
else 
begin
current<=crnt_ad;
crntdc<=1;
dest<=crnt_dest;
end
end
end
always @(process_ack ,clk,REQ_MODE3,hlda,End_p)
begin
if(hlda)
begin
if (mode==2'b00)
begin
if(assendNotdesnd)
begin
if(process_ack)
begin
process_enable<=0;
@(posedge clk)
zs <= 1'bz;
if(crntdc==8'b0) begin   zs <= 1'b0; end
else zs <= 1'b1;

if((End_p ===1'bx) || (End_p==1)) begin 
outAdress<=current;
outAdress_D<=dest;
crntdc<=crntdc-1;
process_enable<=1;
wait (process_ack==0)process_enable<=1;@(posedge clk)process_enable<=1;@(posedge clk)process_enable<=1;
if(current==8'b1111_1111)
begin strobe<=1;add<=2'd1; current=8'b0000_0000; end
else current=current+1;
strobe<=0;add<=2'd0;
if(dest==8'b1111_1111) begin strobe<=1;add<=2'd2; dest=8'b0000_0000; end
else
dest=dest+1;
strobe<=0;add<=2'd0;
zs <= 1'bz;
end
end
end
else
begin
if(process_ack)
begin
process_enable<=0;
@(posedge clk)
zs <= 1'bz;
if(crntdc==8'b0) zs <= 1'b0;
else zs <= 1'b1;
if((End_p ===1'bx) || (End_p==1)) begin 
outAdress<=current;
outAdress_D<=dest;
crntdc<=crntdc-1;
process_enable<=1;
wait (process_ack==0)  process_enable<=1;@(posedge clk)process_enable<=1;@(posedge clk)process_enable<=1;
if(current==8'b0000_0000)
begin strobe<=1;sub<=2'd1; current=8'b1111_1111; end
else current=current-1;
strobe<=0;sub<=2'd0;
if(dest==8'b1111_1111) begin strobe<=1;add<=2'd2; dest=8'b0000_0000; end
else
dest=dest+1;
strobe<=0;add<=2'd0;
zs <= 1'bz;
end
end
end
end
if (mode==2'b01)
begin
if(assendNotdesnd)
begin
if(process_ack)
begin
process_enable<=0;
@(posedge clk)
zs <= 1'bz;
if(crntdc==8'b0) zs <= 1'b0;
else zs <= 1'b1;
if((End_p ===1'bx) || (End_p==1)) begin 
outAdress<=current;
outAdress_D<=dest;
crntdc<=crntdc-1;
process_enable<=1;
wait (process_ack==0)process_enable<=1;@(posedge clk)process_enable<=1;@(posedge clk)process_enable<=1;
if(current==8'b1111_1111)
begin strobe<=1;add<=2'd1; current=8'b0000_0000; end
else current=current+1;
strobe<=0;add<=2'd0;
if(dest==8'b1111_1111) begin strobe<=1;add<=2'd2; dest=8'b0000_0000; end
else
dest=dest+1;
strobe<=0;add<=2'd0;
zs <= 1'bz;
end
end
end
else
begin
if(process_ack)
begin
process_enable<=0;
@(posedge clk)
zs <= 1'bz;
if(crntdc==8'b0) zs <= 1'b0;
else zs <= 1'b1;
if((End_p ===1'bx) || (End_p==1)) begin 
outAdress<=current;
outAdress_D<=dest;
crntdc<=crntdc-1;
process_enable<=1;
wait (process_ack==0)process_enable<=1;@(posedge clk)
if(current==8'b0000_0000)
begin strobe<=1;sub<=2'd1; current=8'b1111_1111; end
else current=current-1;
strobe<=0;sub<=2'd0;
if(dest==8'b1111_1111) begin strobe<=1;add<=2'd2; dest=8'b0000_0000; end
else
dest=dest+1;
strobe<=0;add<=2'd0;
zs <= 1'bz;
end
end
end

end
if (mode==2'b10)
begin
if(REQ_MODE3)
begin
if(assendNotdesnd)
begin
if(process_ack)
begin
process_enable<=0;
@(posedge clk)
zs <= 1'bz;
if(crntdc==8'b0) zs <= 1'b0;
else zs <= 1'b1;
if((End_p ===1'bx) || (End_p==1)) begin 
outAdress<=current;
outAdress_D<=dest;
crntdc<=crntdc-1;
process_enable<=1;
wait (process_ack==0)process_enable<=1;@(posedge clk)process_enable<=1;
if(current==8'b1111_1111)
begin strobe<=1;add<=2'd1; current=8'b0000_0000; end
else current=current+1;
strobe<=0;add<=2'd0;
if(dest==8'b1111_1111) begin strobe<=1;add<=2'd2; dest=8'b0000_0000; end
else
dest=dest+1;
strobe<=0;add<=2'd0;
zs <= 1'bz;
end
end
end
else
begin
if(process_ack)
begin
process_enable<=0;
@(posedge clk)
zs <= 1'bz;
if(crntdc==8'b0) zs <= 1'b0;
else zs <= 1'b1;
if((End_p ===1'bx) || (End_p==1)) begin 
outAdress<=current;
outAdress_D<=dest;
crntdc<=crntdc-1;
process_enable<=1;
wait (process_ack==0)process_enable<=1;@(posedge clk)process_enable<=1;
if(current==8'b0000_0000)
begin strobe<=1;sub<=2'd1; current=8'b1111_1111; end
else current=current-1;
strobe<=0;sub<=2'd0;
if(dest==8'b1111_1111) begin strobe<=1;add<=2'd2; dest=8'b0000_0000; end
else
dest=dest+1;
strobe<=0;add<=2'd0;
zs <= 1'bz;
end
end
end
end
end
if (mode==2'b11)
begin
if(REQ_MODE3==0)
zs=0;
else
zs=1'bz;
begin
end
end
end
else zs<=1;
end

endmodule

module prioritycircuit(busy,enable0,enable1,enable2,enable3,priority,dmar0,dmar1,dmar2,dmar3,clk); 
input clk,priority,dmar0,dmar1,dmar2,dmar3,busy;
inout enable0,enable1,enable2,enable3;
reg e1,e2,e3,e0;
reg[2:0] first,sec,thr,frth;
assign enable0 =e0;
assign enable1 =e1;
assign enable2 =e2;
assign enable3 =e3;
initial
begin 
first <= 2'd0;
sec<=2'd1;
thr<=2'd2;
frth<=2'd3;
end
always @(dmar0,dmar1,dmar2,dmar3)
begin
if (priority==0) //fixed
begin
if     ((busy===1'bx) || (busy==0)) begin if(dmar0) e0=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end end
else if((busy===1'bx) || (busy==0)) begin if(dmar1) e1=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end end
else if((busy===1'bx) || (busy==0)) begin if(dmar2) e2=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end end
else if((busy===1'bx) || (busy==0)) begin if(dmar3) e3=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end end
else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
end
if (priority==1)
begin 
if(busy!=1)
begin
if(dmar0)
begin 
 e0=1;
if (first==0) begin first<=sec; sec<=thr;  thr<=frth; frth<=2'd0; end
if (sec==0) begin  sec<=thr;  thr<=frth; frth<=2'd0; end
if (thr==0) begin    thr<=frth; frth<=2'd0; end
end
else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
if(dmar1)
begin 
 e1=1;
if (first==1) begin first<=sec; sec<=thr;  thr<=frth; frth<=2'd1; end
if (sec==1) begin  sec<=thr;  thr<=frth; frth<=2'd1; end
if (thr==1) begin    thr<=frth; frth<=2'd1; end
end
else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
if(dmar2)
 begin 
e2=1;
if (first==2) begin first<=sec; sec<=thr;  thr<=frth; frth<=2'd2; end
if (sec==2) begin  sec<=thr;  thr<=frth; frth<=2'd2; end
if (thr==2) begin    thr<=frth; frth<=2'd2; end
end
else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
if(dmar3)
begin 
 e3=1;
if (first==3) begin first<=sec; sec<=thr;  thr<=frth; frth<=2'd3; end
if (sec==3) begin  sec<=thr;  thr<=frth; frth<=2'd3; end
if (thr==3) begin    thr<=frth; frth<=2'd3; end
end
else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
end
if(busy==1) 
begin
if     (dmar0) if(first==0) wait(busy==0) e0=1;  else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar1) if(first==1) wait(busy==0) e1=1;  else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar2) if(first==2) wait(busy==0) e2=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar3) if(first==3) wait(busy==0) e3=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar0) if(sec==0) wait(busy==0) e0=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar1) if(sec==1) wait(busy==0) e1=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar2) if(sec==2) wait(busy==0) e2=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar3) if(sec==3) wait(busy==0) e3=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar0) if(thr==0) wait(busy==0) e0=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar1) if(thr==1) wait(busy==0) e1=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar2) if(thr==2) wait(busy==0) e2=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar3) if(thr==3) wait(busy==0) e3=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar0) if(frth==0) wait(busy==0) e0=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar1) if(frth==1) wait(busy==0) e1=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar2) if(frth==2) wait(busy==0) e2=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else if(dmar3) if(frth==3) wait(busy==0) e3=1; else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
else begin e0=1'bz; e1=1'bz; e2=1'bz; e3=1'bz; end
if(e0)
begin 
if (first==0) begin first<=sec; sec<=thr;  thr<=frth; frth<=2'd0; end
if (sec==0) begin  sec<=thr;  thr<=frth; frth<=2'd0; end
if (thr==0) begin    thr<=frth; frth<=2'd0; end
end
if(e1)
begin 
if (first==1) begin first<=sec; sec<=thr;  thr<=frth; frth<=2'd1; end
if (sec==1) begin  sec<=thr;  thr<=frth; frth<=2'd1; end
if (thr==1) begin    thr<=frth; frth<=2'd1; end
end
if(e2)
begin 
if (first==2) begin first<=sec; sec<=thr;  thr<=frth; frth<=2'd2; end
if (sec==2) begin  sec<=thr;  thr<=frth; frth<=2'd2; end
if (thr==2) begin    thr<=frth; frth<=2'd2; end
end
if(e3)
begin 
if (first==3) begin first<=sec; sec<=thr;  thr<=frth; frth<=2'd3; end
if (sec==3) begin  sec<=thr;  thr<=frth; frth<=2'd3; end
if (thr==3) begin    thr<=frth; frth<=2'd3; end
end
end
end
end
endmodule
module NOR(in1,in2,out);
input in1,in2;
output reg out;
reg x;
always @(in1,in2)
begin
x<=in1 || in2 ;
out<= ~ x;
end
endmodule

module latch (address1,data,data_out,Aen,Ad_strobe,write,read,add,sub,processor_16bit);
input [1:0]add,sub;
input [7:0]data;
input[3:0]address1;
output reg [7:0] data_out;
input Aen,Ad_strobe,write,read;
reg [7:0] adress,dest;
input processor_16bit;
initial begin  adress=8'd0;dest=8'd0;  end
always @(data,Aen,Ad_strobe,read,write,address1) 
begin 
if((Ad_strobe)&((Aen==0)||(Aen===1'bx)))
begin
if(write)begin
if(address1==4'd7)adress<=data;
if(address1==4'd8)dest<=data;
end
end
 if (Aen==1) 
begin
if(read) data_out<=adress;
if(write) data_out<=dest;
end
if ((Aen==1) &(Ad_strobe))
begin
if(add==2'd1)adress<=adress+1;
if(add==2'd2)dest<=dest+1;
if(sub==2'd1)adress<=adress-1;
if(sub==2'd2)dest<=dest-1;
end
if(Aen==0) 
begin
if (processor_16bit)
data_out <=8'dz;
else
data_out <=8'd0;
end
end
endmodule

module DMA (add,sub,vcc,vss,clk,cs,reset,ready,hlda,dmar0,dmar1,dmar2,dmar3,data,io_R,io_W,End_p,adress1,adress2,hrq,dmack0,dmack1,dmack2,dmack3,Aen,Ad_strobe,mem_R,mem_W,pin5);
output reg [1:0]add,sub;
wire[1:0] w1,w2;
input vcc,vss,clk,cs,reset,ready,hlda,dmar0,dmar1,dmar2,dmar3,pin5;
output  [3:0]adress2;
output reg hrq,dmack0,dmack1,dmack2,dmack3,Aen,Ad_strobe;
output mem_R,mem_W;
inout  [7:0]data;
inout io_R,io_W, End_p ;
inout [3:0] adress1;
reg [7:0] base_ad,crnt_ad,base_dest,crnt_dest,crnt_dc,base_dc,comand,crntUp,curnt_destUp,baseUp,base_destUp;
reg [3:0] zs;
reg[7:0] zss;
reg [1:0] count;
reg z,busy,confz;
wire [1:0] mod;
assign adress1=zs;
assign data=zss;
assign End_p=z;
assign confirm =confz;  // a da
reg  REQ_MODE3;
reg e1,e2,e3,e0;
wire [7:0] outAdress,outAdress_D;
assign enable0 =e0;
assign enable1 =e1;
assign enable2 =e2;
assign enable3 =e3;
initial begin Aen=0;end

command a(comand,auto_initial,mod,assendNotdesnd,priority,sixteenBetAdress);
controller a1 (strobee, w1,w2,hrq,REQ_MODE3,mod,hlda,crnt_ad,crnt_dc,crnt_dest,assendNotdesnd,auto_initial,base_ad,base_dest,base_dc,outAdress,outAdress_D,End_p,process_enable,process_ack,clk);
transfer_process p1(data,outAdress,outAdress_D,clk,io_R,io_W,mem_R,mem_W,adress1,adress2,process_enable,process_ack);
prioritycircuit x1(busy,enable0,enable1,enable2,enable3,priority,dmar0,dmar1,dmar2,dmar3,clk);
always @(clk,adress1,cs,adress2,enable0,enable1,enable2,enable3,e1,e2,e3,e0,io_R,io_W, End_p,io_R,io_W,REQ_MODE3,sixteenBetAdress,dmack0,dmack1,dmack2,dmack3)
begin
add<=w1;sub<=w2;Ad_strobe<=strobee;
if (cs==0)
begin
if((io_W==0)&((hlda==0)||(hlda===1'bx)))begin
if     (adress1==4'd0) comand<=data; 
else if(adress1==4'd1) base_ad<=data;
else if(adress1==4'd2) crnt_ad<=data;
else if(adress1==4'd3) base_dest<=data;
else if(adress1==4'd4) crnt_dest<=data;
else if(adress1==4'd5) crnt_dc<=data;
else if(adress1==4'd6) base_dc<=data;
else if(adress1==4'd7) begin Ad_strobe<=1; @(posedge clk)Ad_strobe<=0; end //adress_upper
else if(adress1==4'd8) begin Ad_strobe<=1; @(posedge clk)Ad_strobe<=0; end//dest_upper
else if(adress1==4'd9) baseUp<=data;
else if(adress1==4'd10) base_destUp<=data;
else if(adress1===4'bz)   // a da 
begin   
zss<=8'dz;
z<=1'bz;
Ad_strobe<=1'bz;
end
else begin 
zss<=8'dz;
z<=1'bz;
Ad_strobe<=1'bz;
end
end
if((io_R==0)&((hlda==0)||(hlda===1'bx)))
begin
if(adress1==4'd0)      zss<=comand;
else if(adress1==4'd1) zss<= base_ad;
else if(adress1==4'd2) zss<=crnt_ad;
else if(adress1==4'd3) zss<=base_dest;
else if(adress1==4'd4) zss<=crnt_dest;
else if(adress1==4'd5) zss<=crnt_dc;
else if(adress1==4'd6) zss<=base_dc;
else if(adress1==4'd7) begin Ad_strobe<=1; @(posedge clk)Ad_strobe<=0; end
else if(adress1==4'd8) begin Ad_strobe<=1; @(posedge clk)Ad_strobe<=0; end
else if(adress1==4'd9) zss<=baseUp;
else if(adress1==4'd10 ) zss<=base_destUp;
else if(adress1===4'bz) 
begin   
zss<=8'dz;
z<=1'bz;
Ad_strobe<=1'bz;
end
else begin 
zss<=8'dz;
z<=1'bz;
Ad_strobe<=1'bz;
end
end
if ((dmar0||dmar1 || dmar2 || dmar3 || dmack1 || dmack0 || dmack1 || dmack2 || dmack3)&(sixteenBetAdress))
begin
Aen<=1;
end
else Aen<=0;
if(End_p ==0 )
begin
dmack0 <= 0;dmack1 <= 0;dmack2 <= 0;dmack3 <= 0;
hrq<= 0;
e0<=0;e1<=0;e2<=0;e3<=0;
REQ_MODE3<=1'bz;
end
if(mod==2'b10)
begin
if(enable0) begin REQ_MODE3<=dmar0;count<=0; end
if(enable1) begin REQ_MODE3<=dmar1;count<=1; end
if(enable2) begin REQ_MODE3<=dmar2;count<=2'd2; end
if(enable3) begin REQ_MODE3<=dmar3;count<=2'd3; end
if((count==0)&(dmar0==0)) begin REQ_MODE3<=0;dmack0 <= 0;hrq<= 0;e0<=0; end
if((count==1)&(dmar1==0))begin REQ_MODE3<=0;dmack1 <= 0;hrq<= 0;e1<=0; end
if((count==2'd2)&(dmar2==0))begin REQ_MODE3<=0;dmack2 <= 0;hrq<= 0;e2<=0; end
if((count==2'd3)&(dmar3==0))begin REQ_MODE3<=0;dmack3<= 0;hrq<= 0;e3<=0; end
end
if (dmar0)  
begin

busy=(dmar1 || dmar2 || dmar3 || dmack1 || dmack2 || dmack3);
if(enable0)  
begin
@(posedge clk)
dmack0 <= 1;
hrq<= 1;
if((End_p ==0 )|| (REQ_MODE3==0))
begin
dmack0 <= 0;
hrq<= 0;
e0<=0;
REQ_MODE3<=1'bz;
end
end 
else 
begin e0<=1'bz;  e1<=1'bz;  e2<=1'bz;  e3<=1'bz; 
end
end
 if (dmar1 )
begin

busy=(dmar0 || dmar2 || dmar3 || dmack0 || dmack2 || dmack3);
if(enable1)
begin
@(posedge clk)
dmack1 <= 1;
hrq<= 1;
if((End_p ==0 )|| (REQ_MODE3==0))
begin
dmack1 <= 0;
if (mod==2'b10)
REQ_MODE3<=0;
hrq<= 0;
e1=0;
REQ_MODE3<=1'bz;
end
end
else begin e0<=1'bz;  e1<=1'bz;  e2<=1'bz;  e3<=1'bz; end
end
 if (dmar2 )
begin

busy=(dmar1 || dmar0 || dmar3 || dmack1 || dmack0 || dmack3);
if(enable2)
begin
@(posedge clk)
dmack2 <= 1;
hrq<= 1;
if((End_p ==0 )|| (REQ_MODE3==0))
begin
dmack2 <= 0;
if (mod==2'b10)
REQ_MODE3<=0;
hrq<= 0;
e2<=0;
REQ_MODE3<=1'bz;
end
end
else begin e0<=1'bz;  e1<=1'bz;  e2<=1'bz;  e3<=1'bz; end
end
 if (dmar3 )
begin

busy=(dmar1 || dmar2 || dmar0 || dmack1 || dmack2 || dmack0);
if(enable3)
begin
@(posedge clk)
dmack3 <=1;
hrq<= 1;
if((End_p ==0 )|| (REQ_MODE3==0))
begin
dmack3 <= 0;
if (mod==2'b10)
REQ_MODE3<=0;
hrq<= 0;
e3<=0;
REQ_MODE3<=1'bz;
end
end
else begin e0<=1'bz;  e1<=1'bz;  e2<=1'bz;  e3<=1'bz; end
end
//else begin e0<=1'bz;  e1<=1'bz;  e2<=1'bz;  e3<=1'bz; end
end
else 
begin 
zs<=4'dz;
zss<=8'dz;
z<=1'bz;

end
end
/*always @(hlda,dmack0,dmack1,dmack2,dmack3,End_p)
begin
if(hlda)
begin
if(sixteenBetAdress)
begin
end
end
end
*/
endmodule

module motherboard();
wire [15:0] address ;
wire [1:0]add,sub;
wire [7:0] data ,data_out;
wire [3:0]  adress1,adress2,addressss;
assign {address[7:4]}=adress2;
assign addressss ={address[3:0]};
assign {address[15:8]}=data_out;
clockgen c1( clk );
processor cpu1(address,read,write,data,clk,dmar0,dmack0,hrq,hlda,End_p,reset,processor_16bit);
DMA DD (add,sub,vcc,vss,clk,cs,reset,ready,hlda,dmar0,dmar1,dmar2,dmar3,data,io_R,io_W,End_p,adress1,adress2,hrq,dmack0,dmack1,dmack2,dmack3,Aen,Ad_strobe,mem_R,mem_W,pin5);
DMA_interface DD2(io_R,io_W,mem_R,mem_W,cs,address,read,write,dmar0,dmar1,dmar2,dmar3,dmack0,dmack1,dmack2,dmack3,clk,adress1,processor_16bit);
mem_interface mm1(read,write,address,data,clk); 
IO1_interface d1(read,write,address,data,clk);
IO2_interface d2(read,write,address,data,clk);
latch l1(addressss,data,data_out,Aen,Ad_strobe,write,read,add,sub,processor_16bit);
endmodule
 
module NOTOR(in1,in2,out);
input in1,in2;
output reg out;
reg notin1,notin2;

always @(in1,in2,notin1,notin2)
begin
if((in1==0)& (in2==1))
begin
notin1<=~in1;
notin2<=~in2;
end
else if ((in1==0)& (in2==0))
begin
notin1<=~in1;
notin2<=~in2;
end
else if ((in1==1)& (in2==0))
begin
notin1<=~in1;
notin2<=~in2;
end
else if ((in1==1)& (in2==1))
begin
notin1<=~in1;
notin2<=~in2;
end
else 
begin
if (in1==1)begin notin1<=~in1;   end
else if(in1==0)begin notin1<=~in1;   end
else begin notin1<=in1;  end
if (in2==1)begin notin2<=~in2;   end
else if(in2==0)begin notin2<=~in2;   end
else begin notin2<=in2;  end
end
if((notin1==0)& (notin2==0))
begin
out<=0;
end
else if ((notin1==0)& (notin2==1))
begin
out<=1;
end
else if ((notin1==1)& (notin2==0))
begin
out<=1;
end
else if ((notin1==1)& (notin2==1))
begin
out<=1;
end
else
begin
if (notin1==1)begin out<=1;   end
else if(notin1==0)begin out<=0;   end
else if (notin2==1)begin out<=1;   end
else if(notin2==0)begin out<=0;   end
else begin out<=1'bz;  end
end 
end
endmodule 



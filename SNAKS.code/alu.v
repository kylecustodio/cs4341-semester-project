//DFF Module

/*** BEGIN MODDED CODE***
*************************
* Note: I'm having trouble getting vscode to run verilog rn so this might
* not work 100%. The code for the adder was taken from Dr. Becker's slides
* & modified slightly for the subtractor and ANDer
*************************
*/

//OpCodes
`define NOOP  '4b0000 
`define DONE  '4b0000
`define RESET '4b0001
`define ADD   '4b0010
`define SUB   '4b0011
`define MULT  '4b0100
`define DIV   '4b0101
`define AND   '4b0110
`define OR    '4b0111
`define NOT   '4b1000
`define XOR   '4b1001

//ADD operation
module ADDER(inputA,inputB,outputC,carry);
//---------------------------------------
input [15:0] inputA;
input [15:0] inputB;
//---------------------------------------
output [31:0] outputC;
output carry;
//---------------------------------------
reg [32:0] result;
//Link the wires between the Adders
assign outputC = result[31:0];
assign carry = result[32];
	
always @(*)
begin
 result=inputA+inputB;
end
endmodule

//SUB operation
module SUBTRACTOR(inputA,inputB,outputC,carry);
//---------------------------------------
input [15:0] inputA;
input [15:0] inputB;
//---------------------------------------
output [31:0] outputC;
output carry;
//---------------------------------------
reg [32:0] result;
//Link the wires between the Adders
assign outputC = result[31:0];
assign carry = result[32];

always @(*)
begin
 result=inputA-inputB;
end
endmodule

//MULT operation
module MULTIPLIER(inputA, inputB, outputC, carry);
//---------------------------------------
input [15:0] inputA;
input [15:0] inputB;
//---------------------------------------
output [31:0] outputC;
output carry;
//---------------------------------------
reg [32:0] result;
//Link the wires between the Adders
assign outputC = result[31:0];
assign carry = result[32];
always @(*)
begin
 result=inputA*inputB;
end
endmodule

//DIV operation
module DIVIDER(inputA, inputB, outputC, carry);
//---------------------------------------
input [15:0] inputA;
input [15:0] inputB;
//---------------------------------------
output [31:0] outputC;
output carry;
//---------------------------------------
reg [32:0] result;
//Link the wires between the Adders
assign outputC = result[31:0];
assign carry = result[32];
always @(*)
begin
 result=inputA/inputB;
end
endmodule
	
//AND operation
module ANDER(inputA,inputB,outputC);
//---------------------------------------
input [15:0] inputA;
input [15:0] inputB;
//---------------------------------------
output [31:0] outputC;
reg [31:0] outputC;
reg [31:0] result;
assign outputC = result[31:0];

always@(*)
begin
	result=inputA&inputB;
end
endmodule

//OR operation
module ORER(inputA, inputB, outputC);
//---------------------------------------
input [15:0] inputA;
input [15:0] inputB;
//---------------------------------------
output [31:0] outputC;
reg [31:0] outputC;
reg [31:0] result;
assign outputC = result[31:0];

always@(*)
begin
	result=inputA|inputB;
end
endmodule
	
//NOT operation
module NOT(inputA, outputB);
//----------------------------------------
input [15:0]inputA; 
//---------------------------------------
output [31:0] outputB;
reg [31:0] outputB;
reg [31:0] result;
assign outputB = result[31:0];

always@(*)
begin
	result = ~inputA;
end
endmodule


//XOR operation
module XORER(inputA, inputB, outputC);
//---------------------------------------
input [15:0] inputA;
input [15:0] inputB;
//---------------------------------------
output [31:0] outputC;
reg [31:0] outputC;
reg [31:0] result;
assign outputC = result[31:0];

always@(*)
begin
	result=inputA^inputB;
end
endmodule
/*****************************
* REST OF THE CODE IS BABY ALU
******************************/

//FLip Flop
module DFF(clk,in,out);
	parameter n=1;//width
	input clk;
	input [n-1:0] in;
	output [n-1:0] out;
	reg [n-1:0] out;

	always @(posedge clk)
	out = in;
endmodule

//Decoder (n to M)
module Dec(a,b);

parameter n=4;
parameter m=16;
input [n-1:0] a;
output [m-1:0] b;

assign  b= 1<<a; //Shift 1 a places. Makes a 1-hot.

endmodule

//HALF-ADDER
module Add_half (input a, b,  output c_out, sum);
   xor G1(sum, a, b);	 
   and G2(c_out, a, b);
endmodule

//FULL-ADDER
module Add_full (input a, b, c_in, output c_out, sum);
   wire w1, w2, w3;	 
   Add_half M1 (a, b, w1, w2);
   Add_half M0 (w2, c_in, w3, sum);
   or (c_out, w1, w3);
endmodule

//Enc 4 to 2
module Enc42(a,b);
input [3:0] a;
output [1:0] b;
assign b={a[3]|a[2],a[3]|a[1]};
endmodule

//Enc 4 to 2
module Enc42a(a,b,c);
input [3:0] a;
output [1:0] b;
output c;
assign b={a[3]|a[2],a[3]|a[1]};
assign c=|a;
endmodule

//Enc 16 to 4
module Enc164(a,b);
input [15:0] a;
output [3:0] b;
wire[7:0] c;
wire[3:0] d;

Enc42a e0(a[ 3: 0],c[1:0],d[0]);
Enc42a e1(a[ 7: 4],c[3:2],d[1]);
Enc42a e2(a[11: 8],c[5:4],d[2]);
Enc42a e3(a[15:12],c[7:6],d[3]);

Enc42 e4(d[3:0],b[3:2]);

endmodule


//MUX Multiplexer 16 by 2
module Mux(channels,select,b);
input [15:0][1:0]channels;
input [3:0] select;
output [15:0] b;
wire[15:0][1:0] channels;
reg [15:0] b;
always @(*)
begin
 b=channels[select]; 
end

endmodule

//Accumulator Register


//Breadboard
module breadboard(clk,rst,A,B,C,opcode);
//----------------------------------
input clk; 
input rst;
input [15:0] A;
input [15:0] B;
input [3:0] opcode;
wire clk;
wire rst;
wire [15:0] A;
wire [15:0] B;
wire [3:0] opcode;
//----------------------------------
output [15:0] C;
reg [15:0] C;
//----------------------------------

wire [15:0][1:0]channels;
wire [15:0] b;
wire [15:0] outputADD;
wire [15:0] outputSUB;
wire [15:0] outputMULT;
wire [15:0] outputDIV;
wire [15:0] outputAND;
wire [15:0] outputOR;
wire [15:0] outputNOT;
wire [15:0] outputXOR;

reg [15:0] regA;
reg [15:0] regB;

reg  [15:0] next;
wire [15:0] cur;

Mux mux1(channels,opcode,b);
ADDER add1(regA,regB,outputADD,carry);
SUBTRACTOR sub1(regA, regB, outputSUB, carry);
MULTIPLIER mult1(regA, regB, outputMULT, carry);
DIVIDER div1(regA, regB, outputDIV, carry);
ANDER and1(regA, regB, outputAND);
ORER or1(regA, regB, outputOR);
NOT not1(regA, outputNOT);
XORER xor1(regA, regB, outputXOR);


DFF ACC1 [15:0] (clk,next,cur);


assign channels[0]=cur;//NO-OP
assign channels[1]=0;//RESET
assign channels[2]=outputADD;//ADD
assign channels[3]=outputSUB;//SUB
assign channels[4]=outputMULT;//MULT
assign channels[5]=outputDIV;//DIV
assign channels[6]=outputAND;//AND
assign channels[7]=outputOR;//OR
assign channels[8]=outputNOT;//NOT
assign channels[9]=outputXOR;//XOR
assign channels[10]=0;//GROUND=0
assign channels[11]=0;//GROUND=0
assign channels[12]=0;//GROUND=0
assign channels[13]=0;//GROUND=0
assign channels[14]=0;//GROUND=0
assign channels[15]=0;//GROUND=0

always @(*)
begin
 regA=A;
 regB=cur;

 assign C=b;
 assign next=b;
end

endmodule


//TEST BENCH
module testbench();

//Local Variables
   reg clk;
   reg rst;
   reg [15:0] inputA;
   reg [15:0] inputB;
   wire [32:0] outputC;
   reg [3:0] opcode;
   reg [15:0] count;

// create breadboard
breadboard bb8(clk,rst,inputA,inputB,outputC,opcode);


   //CLOCK
   initial begin //Start Clock Thread
     forever //While TRUE
        begin //Do Clock Procedural
          clk=0; //square wave is low
          #5; //half a wave is 5 time units
          clk=1;//square wave is high
          #5; //half a wave is 5 time units
        end
    end



    initial begin //Start Output Thread TODO ******************
	forever
         begin
		 $display("(ACC:%2b)(OPCODE:%4b)(IN:%2b)(OUT:%2b)",bb8.cur,opcode,inputA,bb8.b);
		 #10;
		 end
	end

//STIMULOUS
	initial begin//Start Stimulous Thread
	#6;	
	//---------------------------------
	inputA=2'b00;
	opcode=4'b0000;//NO-OP
	#10; 
	//---------------------------------
	inputA=2'b00;
	opcode=4'b0001;//RESET
	#10
	//---------------------------------	
	inputA=2'b00;
	opcode=4'b0000;//NO OP
	#10;
	//---------------------------------	
	inputA=2'b00;
	opcode=4'b0000;//NO OP
	#10;
	//---------------------------------	
	inputA=2'b01;
	opcode=4'b0101;//ADD
	#10;
	//---------------------------------
	inputA=2'b00;
	opcode=4'b0000;//NOOP
	#10;
	//---------------------------------	
	inputA=2'b01;
	opcode=4'b0101;//ADD
	#10
	//---------------------------------	
	inputA=2'b00;
	opcode=4'b0000;//NOOP
	#10;
	//---------------------------------	
	inputA=2'b01;
	opcode=4'b0101;//ADD
	#10
	//---------------------------------	
	inputA=2'b00;
	opcode=4'b0000;//NOOP
	#10;
	//---------------------------------	
	inputA=2'b00;
	opcode=4'b0001;//RESET
	#10;
	//---------------------------------	
	inputA=2'b00;
	opcode=4'b0000;//NOOP
	#10;
	//---------------------------------	
	inputA=2'b11;
	opcode=4'b0101;//ADD
	#10
	//---------------------------------	
	inputA=2'b00;
	opcode=4'b0000;//NOOP
	#10;
	//---------------------------------	
	inputA=2'b10;
	opcode=4'b1001;//AND
	#10;
	//---------------------------------	
	inputA=2'b00;
	opcode=4'b0000;//NOOP
	#10;
	//---------------------------------	
	inputA=2'b00;
	opcode=4'b0001;//Reset
	#10;
	//---------------------------------	
	inputA=2'b00;
	opcode=4'b0000;//NOOP
	#10;
	//---------------------------------	
	inputA=2'b01;
	opcode=4'b0101;//ADD
	
	//Uh-oh...it was left in the ADD operation...its an addtion STATE!
	#10
	#10
	#10
	#10
	#10
	#10
	//---------------------------------	
	inputA=2'b00;
	opcode=4'b0001;//RESET
	#10;
	//---------------------------------	
	inputA=2'b00;
	opcode=4'b0000;//NOOP
	#10
	
	$finish;
	end

endmodule
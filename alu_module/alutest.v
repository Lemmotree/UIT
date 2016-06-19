`timescale 1ns/1ps
module test2;
   alu alu(
           .ALU_B(ALU_B),
           .S0(S0),
           .S1(S1),
           .S2(S2),
           .S3(S3),
           .Cn(Cn),
           .M(M),
           .DR1(DR1),
           .DR2(DR2),
           .AUJ3(AUJ3)
           );

   reg        ALU_B;
   reg        S0,S1,S2,S3;
   reg        Cn,M;
   reg [7:0]  DR1,DR2;
   wire [7:0] AUJ3;
   parameter  times = 50;
   initial
     begin
        ALU_B = 1'b0;
        repeat(times)
          begin
             #100 begin
                S0 = {$random} % 2;
                S1 = {$random} % 2;
                S2 = {$random} % 2;
                S3 = {$random} % 2;
                Cn = {$random} % 2;
                M = {$random} % 2;
                DR1 = 8'h65;
                DR2 = 8'hA7;
             end
             #1 begin
               $display(AUJ3);
             end
          end // repeat (times)
        #100 $finish;
     end // initial begin

   initial
     begin
        $dumpfile("test2.vcd");
        $dumpvars(0,test2);
     end
   endmodule

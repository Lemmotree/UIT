# UIT
alu

* 运算器功能实现
<2016-06-14 二>
    为进行双操作数的运算，运算器的两个数据输入端分别为由两个数据暂存器DR1、DR2来锁存数据。要将内总线上的数据锁存到DR1、DR2中，到锁存器的控制端LDDR1或LDDR2 须为高点平。当T4脉冲到来时，总线上的数据就被锁存进DR1或DR2中。运算器主要实现74LS281逻辑功能表。
    注意：由于iverilog 中命名规则，代码中用‘_’表示‘-’。

** 运算器信号
    
- 运算器控制信号
|--------+----------+----------+-------+------------------------------------------------|
| 信号名 | 信号类型 | 数据类型 | 位宽  | 含义                                           |
|--------+----------+----------+-------+---
---------------------------------------------|
| ALU-B  | 输入信号 | wire     | 1-bit | 运算器控制端，低电平有效，否则为高阻态         |
| S0     | 输入信号 | wire     | 1-bit | 运算器控制端                                   |
| S1     | 输入信号 | wire     | 1-bit | 运算器控制端                                   |
| S2     | 输入信号 | wire     | 1-bit | 运算器控制端                                   |
| S3     | 输入信号 | wire     | 1-bit | 运算器控制端                                   |
| M      | 输入信号 | wire     | 1-bit | 运算器控制端，M = 1，逻辑运算；M = 0，算术运算 |
| Cn     | 输入信号 | wire     | 1-bit | 运算器控制端，Cn = 1，无进位； Cn = 0，有进位  |

- 运算器输入信号
|--------+----------+----------+-------+--------------------|
| 信号名 | 信号类型 | 数据类型 | 位宽  | 含义               |
|--------+----------+----------+-------+--------------------|
| DR1    | 输入信号 | wire     | 8-bit | 运算器数据输入端口 |
| DR1    | 输入信号 | wire     | 8-bit | 运算器数据输入端口 |

- 运算器输出信号
|--------+----------+----------+-------+--------------------|
| 信号名 | 信号类型 | 数据类型 | 位宽  | 含义               |
|--------+----------+----------+-------+--------------------|
| AUJ3   | 输出信号 | reg      | 8-bit | 运算器数据输出端口 |
 
** 运算器设计
    运算器主要实现运算器算术逻辑运算功能表。
    运算器算术逻辑运算功能表如下：

    [[file:~/UIT/LogicTab.png]]

通过观察运算器的逻辑功能表，发现如下规律：
    - 信号S3-S0y变化规律（从0000变换到1111），使用switch-case实现比较简单；
    - 有进位时，输出结果比无进位时结果大1。
根据上述规律，设计过程如下：
    - 判断运算器的控制端（ALU-B）是否有效；
    - 如果无效，将输出端口置为高阻态；
    - 如果有效，首先整合信号S3-S0、Cn,便于后续计算；
    - 利用switch-case语句实现运算器的算术逻辑功能表 。
** 运算器代码实现
#+BEGIN_SRC verilog
module alu(
    input wire       ALU_B,
    input wire       S0,
    input wire       S1,
    input wire       S2,
    input wire       S3,
    input wire       Cn,
    input wire       M,
    input wire [7:0] DR1,
    input wire [7:0] DR2,
    output reg [7:0] AUJ3);
    reg [3:0]        S3_S0;
    reg              CN; 
   always @(*)//*表示无触发条件
       begin
          if(ALU_B == 1)
          begin
               AUJ3 <= 8'hz;
               $display("%d",AUJ3);
            end
          if(ALU_B == 0)
            begin
               S3_S0 = {S3,S2,S1,S0};
               //S3_S0 = S0 + (S1<<1)+ (S2<<2) + (S3<<3);// 出现0000 的结果是因为优先级的原因
               //S3_S0 = S0 +S1*2+ S2*4+Smaster emacs one year3*8;
               // $display("%d",S3_S0);
               begin
                  CN = ~ Cn;
                case(S3_S0)
                  'd0:
                    begin
                       if(M == 0)
                         AUJ3 <= DR1 + CN;
                       
                       if(M == 1)
                         AUJ3 <= ~ DR1;
                    end
                  'd1:
                    begin
                       if(M == 0)
                         AUJ3 <= (DR1 | DR2) + CN;
                       if(M == 1)
                         AUJ3 <= ~ (DR1 | DR2);
                    end
                  'd2:
                    begin
                       if(M == 0)
                         AUJ3 <= (DR1 | (~ DR2)) + CN;
                       if(M == 1)
                         AUJ3 <= (~ DR1) & DR2;
                    end
                  'd3:
                    begin
                       if(M == 0)
                         AUJ3 <= -1 + CN;
                       if(M == 1)
                         AUJ3 <= 0;
                    end
                  'd4:
                    begin
                       if(M == 0)
                         AUJ3 <= ( DR1 + (DR1 & (~ DR2))) + CN;
                       if(M == 1)
                         AUJ3 <= ~ (DR1 & DR2);
                    end
                  'd5:
                    begin
                       if(M == 0)
                         AUJ3 <= ((DR1 & (~ DR2)) + (DR1 | DR2)) + CN;
                       if(M == 1)
                         AUJ3 <= ~ (DR2);
                    end
                  'd6:
                    begin
                       if(M == 0)
                         AUJ3 <= DR1 - DR2 - 1 + CN;
                       if(M == 1)
                         AUJ3 <= DR1 ^ DR2;
                    end
                  'd7:
                    begin
                       if(M == 0)
                         AUJ3 <= DR1 & (~ DR2) - 1 + CN;
                       if(M == 1)
                         AUJ3 <= DR1 & (~ DR2);
                    end
                  'd8:
                    begin
                       if(M == 0)
                         AUJ3 <= (DR1 + (DR1 & (~ DR2))) + CN;
                       if(M == 1)
                         AUJ3 <= (~ DR1) & DR2;
                    end
                  'd9:
                    begin
                       if(M == 0)
                         AUJ3 <= DR1 + DR2 + CN;
                       if(M == 1)
                         AUJ3 <= ~ (DR1 ^ DR2);
                    end
                  'd10:
                    begin
                       if(M == 0)
                         AUJ3 = ((DR1 & DR2 ) + (DR1 & (~ DR2))) + CN;
                       if(M == 1)
                         AUJ3 = DR2;
                    end
                  'd11:
                    begin
                       if(M == 0 )
                         AUJ3 <= (DR1 & DR2) - 1 + CN;
                       if(M == 1)
                         AUJ3 <= DR1 & DR2;
                    end
                  'd12:
                    begin
                       if(M == 0)
                         AUJ3 <= DR1 + DR1 + CN;
                       if(M == 1)
                         AUJ3 <= 1;
                    end
                  'd13:
                    begin
                       if(M == 0)
                         AUJ3 <= (DR1 + (DR1 | DR2)) + CN;
                       if(M == 1)
                         AUJ3 <= DR1 | (~ DR2);
                    end
                  'd14:
                    begin
                       if(M == 0)
                         AUJ3 <= (DR1 + (DR1 | (~ DR2))) + CN;
                       if(M == 1)
                         AUJ3 <= DR1 | DR2;
                    end
                  'd15:
                    begin
                       if(M == 0 && Cn == 0)
                         AUJ3 <= DR1 - 1 + CN;
                       if(M == 1)
                         AUJ3 <= DR1;
                    end
                  default: AUJ3 <= 8'hz;
                endcase // case (S3_S0)
                end//end if (ALU_B == 0)
     end
 end
endmodule
#+END_SRC

**  ALU模块测试代码
#+BEGIN_SRC verilog
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
#+BEGIN_SRC verilog

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
#+END_SRC




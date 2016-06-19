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
                         AUJ3 <= (DR1+(DR1&(~DR2))) + CN;
                       if(M == 1)
                         AUJ3 <= (~DR1) & DR2;
                    end
                  'd9:
                    begin
                       if(M == 0)
                         AUJ3 <= DR1 + DR2 + CN;
                       if(M == 1)
                         AUJ3 <= ~(DR1 ^ DR2);
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

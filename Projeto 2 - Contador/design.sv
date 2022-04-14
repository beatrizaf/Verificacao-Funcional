module contador ( MR, CPU, CPD, PL, P0, P1, P2, P3, TCU, TCD, Q0, Q1, Q2, Q3 );
  
  input  bit   MR, CPU, CPD, PL;
  input  logic P0, P1, P2, P3;
  output logic TCU, TCD;
  output logic Q0, Q1, Q2, Q3; 
  logic [3:0] estadoAtual;

  parameter S0 	= 4'b0000, S1	= 4'b0001, S2 	= 4'b0010, S3 	= 4'b0011,
  			S4	= 4'b0100, S5 	= 4'b0101, S6 	= 4'b0110, S7 	= 4'b0111, 
			S8 	= 4'b1000, S9 	= 4'b1001, S10 	= 4'b1010, S11 	= 4'b1011, 
  			S12 = 4'b1100, S13 	= 4'b1101, S14 	= 4'b1110, S15 	= 4'b1111;
	
  bit up_down;

  
  always @(CPU or CPD) begin
    @(posedge CPU iff CPD) up_down = 1;
    @(posedge CPD iff CPU) up_down = 0;  
  end
  
  always @( posedge MR or negedge PL or (posedge CPD iff CPU) or (posedge CPU iff CPD) ) begin
    
      if (MR)
         estadoAtual = S0;
      else
        if (!PL)
          estadoAtual = {P0, P1, P2, P3};
         else
           begin
             $display($time, "  *** disparo ***   CPU = %b   |   CPD = %b    |  UP_DOWN = %b", CPU, CPD, up_down);
             if(up_down)
                  case (estadoAtual)
                    S0:  estadoAtual = S1;
                    S1:  estadoAtual = S2;
                    S2:  estadoAtual = S3;
                    S3:  estadoAtual = S4;
                    S4:  estadoAtual = S5;
                    S5:  estadoAtual = S6;
                    S6:  estadoAtual = S7;
                    S7:  estadoAtual = S8;
                    S8:  estadoAtual = S9;
                    S9:  estadoAtual = S10;
                    S10: estadoAtual = S11;
                    S11: estadoAtual = S12;
                    S12: estadoAtual = S13;
                    S13: estadoAtual = S14;
                    S14: estadoAtual = S15;
                    S15: estadoAtual = S0;
                  endcase
             else if(!up_down)
                     case (estadoAtual)
                       S0:  estadoAtual = S15;
                       S1:  estadoAtual = S0;
                       S2:  estadoAtual = S1;
                       S3:  estadoAtual = S2;
                       S4:  estadoAtual = S3;
                       S5:  estadoAtual = S4;
                       S6:  estadoAtual = S5;
                       S7:  estadoAtual = S6;
                       S8:  estadoAtual = S7;
                       S9:  estadoAtual = S8;
                       S10: estadoAtual = S9;
                       S11: estadoAtual = S10;
                       S12: estadoAtual = S11;
                       S13: estadoAtual = S12;
                       S14: estadoAtual = S13;
                       S15: estadoAtual = S14;
                     endcase
             	   else 
                      estadoAtual = estadoAtual;
           end
	end
  
  always @ (estadoAtual) begin     
     case (estadoAtual)
       S0:  {Q3, Q2, Q1, Q0} = S0;
       S1:  {Q3, Q2, Q1, Q0} = S1;
       S2:  {Q3, Q2, Q1, Q0} = S2;
       S3:  {Q3, Q2, Q1, Q0} = S3;
       S4:  {Q3, Q2, Q1, Q0} = S4;
       S5:  {Q3, Q2, Q1, Q0} = S5;
       S6:  {Q3, Q2, Q1, Q0} = S6;
       S7:  {Q3, Q2, Q1, Q0} = S7;
       S8:  {Q3, Q2, Q1, Q0} = S8;
       S9:  {Q3, Q2, Q1, Q0} = S9;
       S10: {Q3, Q2, Q1, Q0} = S10;
       S11: {Q3, Q2, Q1, Q0} = S11;
       S12: {Q3, Q2, Q1, Q0} = S12;
       S13: {Q3, Q2, Q1, Q0} = S13;
       S14: {Q3, Q2, Q1, Q0} = S14;
       S15: {Q3, Q2, Q1, Q0} = S15;
     endcase
  end
  
  assign TCU = (~(Q0 & Q1 & Q2 & Q3 & ~CPU));
  assign TCD = (~(~Q0 & ~Q1 & ~Q2 & ~Q3 & ~CPD));
  
endmodule: contador;

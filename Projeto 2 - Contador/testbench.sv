`include "design_ref.sv";

class Random;
  randc logic [3:0] entrada;
endclass

module tb;
  
  bit   mr, cpu, cpd, pl, clk;
  logic [3:0] p, q1, q2;
  logic tcu, tcd;
  
  always #5	 clk = ~clk;
  
  contador cont( .MR(mr),
                 .CPU(cpu),
                 .CPD(cpd),
                 .PL(pl),
                 .P0(p[0]),
                 .P1(p[1]),
                 .P2(p[2]),
                 .P3(p[3]),                
                 .TCU(tcu),
                 .TCD(tcd),
                 .Q0(q1[0]),
                 .Q1(q1[1]),
                 .Q2(q1[2]),
                 .Q3(q1[3]) );
  
  contador_ref cont2( .MR(mr),
                      .CPU(cpu),
                      .CPD(cpd),
                      .PL(pl),
                      .P0(p[0]),
                      .P1(p[1]),
                      .P2(p[2]),
                      .P3(p[3]),                
                      .Q0(q2[0]),
                      .Q1(q2[1]),
                      .Q2(q2[2]),
                      .Q3(q2[3]) );
  
  covergroup CG_P @(posedge clk);
    coverpoint p;
  endgroup
  
  covergroup CG_MR @(posedge clk);
    coverpoint mr;
  endgroup
  
  covergroup CG_PL @(posedge clk);
    coverpoint pl;
  endgroup
  
  covergroup CG_Q @(posedge clk);
    coverpoint q1
    {
      ignore_bins s2 = {16};
    }
  endgroup
  
  initial begin
  
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
     
    $monitor($time, "  P = %d | MR = %d | PL = %d | CPU = %d | CPD = %d | Q = %d | Q_REF = %d | TCU = %d | TCD = %d", p, mr, pl, cpu, cpd, q1, q2, tcu, tcd);
  
  end
             
  initial begin
    
    CG_P   cg_p_inst   = new;
    CG_MR  cg_mr_inst  = new;
    CG_PL  cg_pl_inst  = new;
    CG_Q   cg_q_inst   = new;
    Random randA       = new();
    
    while(cg_q_inst.get_coverage() != 100 || cg_p_inst.get_coverage() != 100) begin
       
       randA.randomize();
       p   =  randA.entrada;       
       mr  =  $urandom_range(1,0); 
       pl  =  $urandom_range(1,0);  
       cpd =  $urandom_range(1,0);   
       cpu = clk;
       
       if( q1 != q2) begin  
          $display("Erro, saidas diferentes! P = %d | MR = %d | PL = %d | CPU = %d | CPD = %d | Q = %d | Q_REF = %d | TCU = %d | TCD = %d", 
                    p, mr, pl, cpu, cpd, q1, q2, tcu, tcd);
          break;  
       end 
      
       #1
      $display($time, " CG_P: %.2f%% | CG_MR: %.2f%% | CG_PL: %.2f%% | CG_Q: %.2f%%",
                 cg_p_inst.get_coverage(),
                 cg_mr_inst.get_coverage(),
                 cg_pl_inst.get_coverage(),
                 cg_q_inst.get_coverage());
    end
    /* teste manual
    p   = 4'b1001;
    cpd = 1;
    mr  = 0;
    pl  = 0; 
    #20 pl = 1;  
    #40 mr = 1;
    #50 mr = 0;
    
    #60
    p   = 4'b0000;
    cpd = 1;
    pl  = 0; #80
    pl  = 1; #100
    mr  = 1; #110
    mr = 0;
    
    #150 */       
    
    $display( "FIM" );
    $finish;
  end
      
endmodule: tb; 

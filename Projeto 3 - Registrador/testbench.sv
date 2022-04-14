`include "design_ref.sv";

module tb;
  
  bit    a, b, clear, clock;
  wire   qa1, qb1, qc1, qd1, qe1, qf1, qg1, qh1; //saídas para design
  wire   qa2, qb2, qc2, qd2, qe2, qf2, qg2, qh2; //saídas para design_ref
  bit    [7:0] saidas1, saidas2, anterior;
  assign saidas1 = {qa1, qb1, qc1, qd1, qe1, qf1, qg1, qh1};
  assign saidas2 = {qa2, qb2, qc2, qd2, qe2, qf2, qg2, qh2};
  
  always #5	 clock = ~clock;
  
  registrador reg1(.A(a),
                   .B(b),
                   .QA(qa1),
                   .QB(qb1),
                   .QC(qc1),
                   .QD(qd1),
                   .QE(qe1),
                   .QF(qf1),                
                   .QG(qg1),
                   .QH(qh1),
                   .CLEAR(clear),
                   .CLOCK(clock));
  
  registrador_ref reg2(.A(a),
                       .B(b),
                       .QA(qa2),
                       .QB(qb2),
                       .QC(qc2),
                       .QD(qd2),
                       .QE(qe2),
                       .QF(qf2),                
                       .QG(qg2),
                       .QH(qh2),
                       .CLEAR(clear),
                       .CLOCK(clock));
  
  //Saídas
  covergroup CG_qa1 @(saidas1);
    coverpoint qa1;
  endgroup
  
  covergroup CG_qb1 @(saidas1);
    coverpoint qb1;
  endgroup
  
  covergroup CG_qc1 @(saidas1);
    coverpoint qc1;
  endgroup
  
  covergroup CG_qd1 @(saidas1);
    coverpoint qd1;
  endgroup
  
  covergroup CG_qe1 @(saidas1);
    coverpoint qe1;
  endgroup
  
  covergroup CG_qf1 @(saidas1);
    coverpoint qf1;
  endgroup
  
  covergroup CG_qg1 @(saidas1);
    coverpoint qg1;
  endgroup
  
  covergroup CG_qh1 @(saidas1);
    coverpoint qh1;
  endgroup
  
  //Entradas
  covergroup CG_a @(a, b, clear, clock);
    coverpoint a;
  endgroup
  
  covergroup CG_b @(a, b, clear, clock);
    coverpoint b;
  endgroup
  
  covergroup CG_clear @(a, b, clear, clock);
    coverpoint clear;
  endgroup
  
  covergroup CG_clock @(a, b, clear, clock);
    coverpoint clock;
  endgroup
  
  covergroup entradas @(a, b, clear, clock);
    A:     coverpoint a;
    B:     coverpoint b;
    CLEAR: coverpoint clear;
    CLOCK: coverpoint clock;
    cross  A, B, CLEAR, CLOCK;
  endgroup
 
  
  initial begin
    
    //Entradas
    CG_a     cg_a_inst     = new;
    CG_b     cg_b_inst     = new;
    CG_clear cg_clear_inst = new;
    CG_clock cg_clock_inst = new;
    entradas crossEntradas = new;
    
    //Saídas
    CG_qa1   cg_qa1_inst   = new;
    CG_qb1   cg_qb1_inst   = new;
    CG_qc1   cg_qc1_inst   = new;
    CG_qd1   cg_qd1_inst   = new;
    CG_qe1   cg_qe1_inst   = new;
    CG_qf1   cg_qf1_inst   = new;
    CG_qg1   cg_qg1_inst   = new;
    CG_qh1   cg_qh1_inst   = new;
    
    
    $monitor($time, " A = %b, B = %b, QA = %b, QB = %b, QC = %b, QD = %b, QE = %b, QF = %b, QG = %b, QH = %b, CLEAR = %b, CLOCK = %b", a, b, qa1, qb1, qc1, qd1, qe1, qf1, qg1, qh1, clear, clock);
    
    
    while(crossEntradas.get_coverage()  < 100 ||
          cg_a_inst.get_coverage()      < 100 ||
          cg_b_inst.get_coverage()      < 100 ||
          cg_clear_inst.get_coverage()  < 100 ||
          cg_clock_inst.get_coverage()  < 100 ||
          cg_qa1_inst.get_coverage()    < 100 ||
          cg_qb1_inst.get_coverage()    < 100 ||
          cg_qc1_inst.get_coverage()    < 100 ||
          cg_qd1_inst.get_coverage()    < 100 ||
          cg_qe1_inst.get_coverage()    < 100 ||
          cg_qf1_inst.get_coverage()    < 100 ||
          cg_qg1_inst.get_coverage()    < 100 ||
          cg_qh1_inst.get_coverage()    < 100) begin
      
      anterior = saidas1;
      
      #2
      a     = $urandom_range(1,0);
      b     = $urandom_range(1,0);
      clear = $urandom_range(1,0);
      
      #10
      if (!clear) begin
        if (saidas1 != 8'b00000000) begin
          $display("Erro encontrado! code 1");
          $display("Esperado: {00000000} - mas ocorreu {%b}", saidas1);
          break;
        end
      end
      
      if (a && b) begin
        if (saidas1[0] != 1 & saidas1[1] != anterior[1] & 
            saidas1[2] != anterior[2] & saidas1[3] != anterior[3] & 
            saidas1[4] != anterior[4] & saidas1[5] != anterior[5] & 
            saidas1[6] != anterior[6] & saidas1[7] != anterior[7]) begin
          $display("Erro encontrado! - code 2");
          break;
        end
      end
      
      if ((!a && b) || (a && !b)) begin
        if (saidas1[0] != 0 & saidas1[1] != anterior[1] & 
            saidas1[2] != anterior[2] & saidas1[3] != anterior[3] & 
            saidas1[4] != anterior[4] & saidas1[5] != anterior[5] & 
            saidas1[6] != anterior[6] & saidas1[7] != anterior[7]) begin
          $display("Erro encontrado! - code 3");
          break;
        end
      end
      
      if(saidas1 != saidas2)begin
        $display("Erro encontrado! - code 4");
        $display("Esperado: {%b} - mas ocorreu {%b}", saidas2, saidas1);
        break;
      end
      
      $display($time, " A: %.2f%% | B: %.2f%% | CLEAR: %.2f%% | CLOCK: %.2f%% | QA: %.2f%% | QB: %.2f%% | QC: %.2f%% | QD: %.2f%% | QE: %.2f%% | QF: %.2f%% | QG: %.2f%% | QH: %.2f%%",
               cg_a_inst.get_coverage(),
               cg_b_inst.get_coverage(),
               cg_clear_inst.get_coverage(),
               cg_clock_inst.get_coverage(),
               cg_qa1_inst.get_coverage(),
               cg_qb1_inst.get_coverage(),
               cg_qc1_inst.get_coverage(),
               cg_qd1_inst.get_coverage(),
               cg_qe1_inst.get_coverage(),
               cg_qf1_inst.get_coverage(),
               cg_qg1_inst.get_coverage(),
               cg_qh1_inst.get_coverage());
      
    end
    /* teste manual
      clear = 1;
      a     = 1; 
      b     = 0; #5 
      clear = 0; #5 
      clear = 1; #20 
      a     = 0;
      b     = 1; #20
      a     = 1; #25
      a     = 0; #10 
      a     = 1; #5
      a     = 0; #30 
      clear = 0;
      
      #200 */
    
      $finish;
  end
  
endmodule: tb;

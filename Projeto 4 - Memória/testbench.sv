`include "design_ref.sv";

module tb;
	
  bit   cs, we, a0, a1, a2, a3, d0, d1, d2, d3;
  logic [3:0] out1, out2;
  
  memoria men1(.A0(a0),
               .A1(a1),
               .A2(a2),
               .A3(a3),
               .D0(d0),
               .D1(d1),
               .D2(d2),
               .D3(d3),                
               .O0(out1[0]),
               .O1(out1[1]),
               .O2(out1[2]),
               .O3(out1[3]),
               .CS(cs),
               .WE(we));
  
  memoria_ref men2(.A0(a0),
                   .A1(a1),
                   .A2(a2),
                   .A3(a3),
                   .D0(d0),
                   .D1(d1),
                   .D2(d2),
                   .D3(d3),                
                   .O0(out2[0]),
                   .O1(out2[1]),
                   .O2(out2[2]),
                   .O3(out2[3]),
                   .CS(cs),
                   .WE(we));
  
  //entradas endereço
  covergroup CG_a0 @(a0);
    coverpoint a0;
  endgroup
  
  covergroup CG_a1 @(a1);
    coverpoint a1;
  endgroup
  
  covergroup CG_a2 @(a2);
    coverpoint a2;
  endgroup
  
  covergroup CG_a3 @(a3);
    coverpoint a3;
  endgroup
  
  //entradas 
  covergroup CG_d0 @(d0);
    coverpoint d0;
  endgroup
  
  covergroup CG_d1 @(d1);
    coverpoint d1;
  endgroup
  
  covergroup CG_d2 @(d2);
    coverpoint d2;
  endgroup
  
  covergroup CG_d3 @(d3);
    coverpoint d3;
  endgroup
  
  covergroup CG_we @(we);
    coverpoint we;
  endgroup
  
  covergroup CG_cs @(cs);
    coverpoint cs;
  endgroup
  
  covergroup entradas @(cs, we, a0, a1, a2, a3, d0, d1, d2, d3);
    CS: coverpoint cs;
    WE: coverpoint we;
    A0: coverpoint a0;
    A1: coverpoint a1;
    A2: coverpoint a2;
    A3: coverpoint a3;
    D0: coverpoint d0;
    D1: coverpoint d1;
    D2: coverpoint d2;
    D3: coverpoint d3;
    cross  CS, WE, A0, A1, A2, A3, D0, D1, D2, D3;
  endgroup
  
  //Saída
  covergroup CG_out @(out1);
    coverpoint out1;
  endgroup
  
  initial begin
    
    //Entradas
    CG_cs  cg_cs_inst   = new;
    CG_we  cg_we_inst   = new;
    CG_a0  cg_a0_inst   = new;
    CG_a1  cg_a1_inst   = new;
    CG_a2  cg_a2_inst   = new;
    CG_a3  cg_a3_inst   = new;
    CG_d0  cg_d0_inst   = new;
    CG_d1  cg_d1_inst   = new;
    CG_d2  cg_d2_inst   = new;
    CG_d3  cg_d3_inst   = new;
    entradas crossEntradas = new;
    
    //Saída
    CG_out cg_out_inst = new;
    
    $monitor($time, " Address = %b%b%b%b, Data = %b%b%b%b, CS = %b, WE = %b, Out = %b", a0, a1, a2, a3, d0, d1, d2, d3, cs, we, out1);
  
    while(cg_cs_inst.get_coverage()    < 100 ||
          cg_we_inst.get_coverage()    < 100 ||
          cg_a0_inst.get_coverage()    < 100 ||
          cg_a1_inst.get_coverage()    < 100 ||
          cg_a2_inst.get_coverage()    < 100 ||
          cg_a2_inst.get_coverage()    < 100 ||
          cg_d0_inst.get_coverage()    < 100 ||
          cg_d1_inst.get_coverage()    < 100 ||
          cg_d2_inst.get_coverage()    < 100 ||
          cg_d3_inst.get_coverage()    < 100 ||
          cg_out_inst.get_coverage()   < 100) begin
      
      #2
      a0  = $urandom_range(1,0);
      a1  = $urandom_range(1,0);
      a2  = $urandom_range(1,0);
      a3  = $urandom_range(1,0);
      d0  = $urandom_range(1,0);
      d1  = $urandom_range(1,0);
      d2  = $urandom_range(1,0);
      d3  = $urandom_range(1,0);
      we  = $urandom_range(1,0);
 
      #10
      if(out1 !== out2) begin
        $display("Erro encontrado! - code 1");
        $display("Esperado: {%b} - mas ocorreu {%b}", out2, out1);
        break;
      end
      
      if(!cs & we) begin
        if (out1[0] != ~d0 & out1[1] != ~d1 & out1[2] != ~d2 & out1[3] != ~d3) begin
          $display("Erro encontrado! - code 2");
          $display("Esperado: {%b%b%b%b} - mas ocorreu {%b}", ~d0, ~d1, ~d2, ~d3, out1);
          break;
        end
      end
      
      if(cs) begin
        if (out1 != 4'bzzzz) begin
          $display("Erro encontrado! - code 3");
          $display("Esperado: {%b} - mas ocorreu {%b}", 4'bzzzz, out1);
          break;
        end
      end
      
      $display($time, " A0: %.2f%% | A1: %.2f%% | A2: %.2f%% | A3: %.2f%% D0: %.2f%% | D1: %.2f%% | D2: %.2f%% | D3: %.2f%% | CS: %.2f%% | WE: %.2f%% | OUT: %.2f%%",
               cg_a0_inst.get_coverage(),
               cg_a1_inst.get_coverage(),
               cg_a2_inst.get_coverage(),
               cg_a3_inst.get_coverage(),
               cg_d0_inst.get_coverage(),
               cg_d1_inst.get_coverage(),
               cg_d2_inst.get_coverage(),
               cg_d3_inst.get_coverage(),
               cg_cs_inst.get_coverage(),
               cg_we_inst.get_coverage(),
               cg_out_inst.get_coverage());
      
    end
    
    $finish;
    
  end
  
  always #5 cs = ~cs;
  
endmodule: tb;

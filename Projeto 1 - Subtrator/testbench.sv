module subtrator_tb;
  logic signed[3:0] A, B;
  logic signed[3:0] SUB;
  bit FLAG;
  
  subtratorcompleto_DUV duv(.a(A), .b(B), .sub(SUB), .flag(FLAG));

  covergroup CG_A @(A);
    coverpoint A;
  endgroup
  
  covergroup CG_B @(B);
    coverpoint B;
  endgroup
  
  covergroup CG_S @(SUB);
    coverpoint SUB
    {
      ignore_bins s1 = {8};
      ignore_bins s2 = {-9};
    }  
  endgroup
  
  covergroup CG_F @(FLAG);
    coverpoint FLAG;
  endgroup
  
  
  initial begin
  
    $monitor($time,"  (%d) - (%d) = %d,  FLAG = %d",A,B,SUB,FLAG);
  
  end
             
  initial begin
    CG_A cg_a_inst = new;
    CG_B cg_b_inst = new;
    CG_S cg_s_inst = new;
    CG_F cg_f_inst = new;
    
    while ( (cg_a_inst.get_coverage() != 100) | (cg_b_inst.get_coverage() != 100) | (cg_s_inst.get_coverage() != 100) | (cg_f_inst.get_coverage() != 100) ) 
      begin 	
       A = $urandom_range(15,0); B = $urandom_range(15,0);
        
       #1
       $display("CG_A = %.2f%%   CG_B = %.2f%%   CG_S = %.2f%%   CG_F = %.2f%%",
                 cg_a_inst.get_coverage(),
                 cg_b_inst.get_coverage(),
                 cg_s_inst.get_coverage(),
                 cg_f_inst.get_coverage());
     end
                 
     $display( "FIM" );
     $finish;
  end
                 
endmodule                 

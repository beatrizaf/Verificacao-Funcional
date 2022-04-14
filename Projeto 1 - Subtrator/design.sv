module subtratorcompleto_DUV( a, b, sub, flag );
  
  input logic signed [3:0] a, b;
  output logic signed [3:0] sub;
  output bit flag;
  
  always_comb begin
    sub = a - b;
    
    if (a >= 0 & b >= 0 & (a > b | a == b) & sub >= 0) //positivo/zero - positivo/zero = positivo ou zero 
      flag = 1;
    else if (a >= 0 & b >= 0 & a < b & sub < 0) //positivo - positivo = negativo
      flag = 1;
    else if (a > 0 & b < 0 & sub > 0) //positivo - negativo = positivo 
      flag = 1;
    else if (a < 0 & b > 0 & sub < 0) //negativo - positivo = negativo
      flag = 1;
    else if (a <= 0 & b <= 0 & (a > b | a == b) & sub >= 0) //negativo/zero - negativo/zero = positivo ou zero
      flag = 1;
    else if (a <= 0 & b <= 0 & a < b & sub < 0) //negativo - negativo = negativo
       flag = 1;
    else
      flag = 0;
    
  end
endmodule: subtratorcompleto_DUV


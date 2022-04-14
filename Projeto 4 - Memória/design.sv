module memoria ( A0, A1, A2, A3, D0, D1, D2, 
                 D3, O0, O1, O2, O3, CS, WE );
  
  input  A0, A1, A2, A3, D0, D1, D2, D3, CS, WE;
  output logic O0, O1, O2, O3;
  
  logic  [3:0] address, data;
  logic  [3:0] mem [0:15];
  
  assign address = {A0, A1, A2, A3};
  assign {O0, O1, O2, O3} = {~D0, ~D1, ~D2, ~D3};
    
  always @(CS or WE or address or data) begin
    
    if(CS)
      data = 4'bzzzz;
    else
      if (!WE)
        mem[address] = data;

      else 
        data = mem[address];
    
  end
  
  always @(data) begin
    data[0] = D0;
    data[1] = D1;
    data[2] = D2;
    data[3] = D3;
  end
  
endmodule: memoria;

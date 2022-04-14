module memoria_ref ( A0, A1, A2, A3, D0, D1, D2, 
                 D3, O0, O1, O2, O3, CS, WE );
  
  input  A0, A1, A2, A3, D0, D1, D2, D3, CS, WE;
  output logic O0, O1, O2, O3;
  
  logic  [3:0] address, data;
  logic  [3:0] mem [0:15];
 
  always @(CS or WE or address or data) begin
    
    if (!CS & !WE)
      mem[address] = data;
    
  end
  
  always @(CS or WE or address or data) begin
    
    if (!CS & WE)
      data = mem[address];
    
  end
  
  
  always @(data) begin
    data[0] = D0;
    data[1] = D1;
    data[2] = D2;
    data[3] = D3;
  end
  
  assign address = {A0, A1, A2, A3};
  assign {O0, O1, O2, O3} = {~D0, ~D1, ~D2, ~D3};  
  
endmodule: memoria_ref;

module registrador ( A, B, QA, QB, QC, QD, QE, QF, QG, QH, CLEAR, CLOCK );
  
  input  bit A, B, CLEAR, CLOCK;
  output reg QA = 0, QB = 0, QC = 0, QD = 0, QE = 0, QF = 0, QG = 0, QH = 0;   
  
  always @(negedge CLEAR or posedge CLOCK) begin
    
    if (CLEAR == 0) begin
      QA = 0;
      QB = 0;
      QC = 0;
      QD = 0;
      QE = 0;
      QF = 0;
      QG = 0;
      QH = 0;
    end
    
    else begin
      
      if (CLOCK) begin
   		if (A && B) begin
            QA <= 1;
            QB <= QA;
            QC <= QB;
            QD <= QC;
            QE <= QD;
            QF <= QE;
            QG <= QF;
            QH <= QG;
          end

          else if ((!A && B) || (A && !B)) begin 
            QA <= 0;
            QB <= QA;
            QC <= QB;
            QD <= QC;
            QE <= QD;
            QF <= QE;
            QG <= QF;
            QH <= QG;
          end 
      end
      
      else begin
        QA <= QA;
        QB <= QB;
        QC <= QC;
        QD <= QD;
        QE <= QE;
        QF <= QF;
        QG <= QG;
        QH <= QH;
      end   
    end
  end
 
endmodule: registrador;

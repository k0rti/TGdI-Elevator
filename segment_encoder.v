module segment_encoder(
      input  wire [13:0]  ssIn,
      output  reg [ 7:0]  asciOutHigh,
      output  reg [ 7:0]  asciOutLow);

   always @(ssIn) begin
      case (ssIn[13:7])
         7'b1111110 : asciOutHigh = 7'h30;
		
         7'b0110000 : asciOutHigh = 7'h31;
		
         7'b1101101 : asciOutHigh = 7'h32;
		
         7'b1111001 : asciOutHigh = 7'h33;
		
         7'b0110011 : asciOutHigh = 7'h34;
		
         7'b1011011 : asciOutHigh = 7'h35;
		
         7'b1011111 : asciOutHigh = 7'h36;
		
         7'b1110000 : asciOutHigh = 7'h37;
		
         7'b1111111 : asciOutHigh = 7'h38;
		
         7'b1111011 : asciOutHigh = 7'h39;
		
         default:     asciOutHigh = 7'h30;	
      endcase

      case (ssIn[6:0])
         7'b1111110 : asciOutLow = 7'h30;
		
         7'b0110000 : asciOutLow = 7'h31;
		
         7'b1101101 : asciOutLow = 7'h32;
		
         7'b1111001 : asciOutLow = 7'h33;
		
         7'b0110011 : asciOutLow = 7'h34;
		
         7'b1011011 : asciOutLow = 7'h35;
		
         7'b1011111 : asciOutLow = 7'h36;
		
         7'b1110000 : asciOutLow = 7'h37;
		
         7'b1111111 : asciOutLow = 7'h38;
		
         7'b1111011 : asciOutLow = 7'h39;
		
         default:     asciOutLow = 7'h30;	
      endcase
   end

endmodule

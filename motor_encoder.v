module motor_encoder(
      input  wire [3:0]  motor_signals,
      output  reg [1:0]  motor_state);

   always @(motor_signals) begin
      case (motor_signals)
         4'b1001: motor_state = 2'b00;
         4'b1100: motor_state = 2'b01;
         4'b0110: motor_state = 2'b10;
         4'b0011: motor_state = 2'b11;
         default: motor_state = 2'b00;
      endcase
   end

endmodule

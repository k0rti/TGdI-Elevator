// ----------------
// Project:
// ESA Elevator
// ----------------
//
// ----------------
// Group: 87
// 2297206: Tim Kornhuber
// 2621416: Marvin Kaiser 
// ----------------
//
// Description:
// ----------------
// display_if.v testbench
//

`timescale 1ns / 1ns

module display_if

          #(parameter FLOOR_BITS       =  7,
                      DISPLAY_SEGMENTS = 14)


          (input  wire [(FLOOR_BITS-1)      :0] CURRENT_FLOOR,

           output wire [(DISPLAY_SEGMENTS-1):0] ENABLE_SEGMENT);  // enable    

/* =============================INSERT CODE HERE======================================*/ 

reg einer;
reg zehner;
 always @ (*)
	begin
		case (CURRENT_FLOOR[FLOOR_BITS-1:0] % 10) //Case für Einerstelle
			7'd0 : einer = 7'b1111110; // 0 
			7'd1 : einer = 7'b0110000; // 1
			7'd2 : einer = 7'b1101101; // 2
			7'd3 : einer = 7'b1111001; // 3
			7'd4 : einer = 7'b0110011; // 4
			7'd5 : einer = 7'b1011011; // 5
			7'd6 : einer = 7'b1011111; // 6
			7'd7 : einer = 7'b1110000; // 7
			7'd8 : einer = 7'b1111111; // 8
			7'd9 : einer = 7'b1111011;  // 9
		default: einer = 7'b1111110; //default 0
		endcase

		case ((CURRENT_FLOOR[FLOOR_BITS-1:0] / 10 ) % 10) //Case für Zehnerstelle
			7'd0 : zehner = 7'b1111110; // 0 
			7'd1 : zehner = 7'b0110000; // 1
			7'd2 : zehner = 7'b1101101; // 2
			7'd3 : zehner = 7'b1111001; // 3
			7'd4 : zehner = 7'b0110011; // 4
			7'd5 : zehner = 7'b1011011; // 5
			7'd6 : zehner = 7'b1011111; // 6
			7'd7 : zehner = 7'b1110000; // 7
			7'd8 : zehner = 7'b1111111; // 8
			7'd9 : zehner = 7'b1111011;  // 9
		default: zehner = 7'b1111110; //default 0
		endcase		


end
assign ENABLE_SEGMENT = {zehner,einer};



/* ====================================================================================*/
  
endmodule

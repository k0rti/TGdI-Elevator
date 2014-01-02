// ----------------
// Project:
// ESA Elevator
// ----------------
//
// ----------------
// Group: 0
// 1234567: Wigald Boning
// 1234567: Oliver Dittrich 
// ----------------
//
// Description:
// ----------------
// elevator next_floor_ctrl
//

`timescale 1ns / 1ns

module next_floor_ctrl

          #(parameter FLOORS     = 99,
                      FLOOR_BITS =  7)


          (input  wire                          CLK,
           input  wire                          RESET,

           input  wire                          HALTED,
           input  wire [(FLOORS-1)          :0] DESTINATIONS,
           input  wire [((FLOORS*2)-1)      :0] FLOOR_REQUEST,
           input  wire [(FLOOR_BITS-1)      :0] CURRENT_FLOOR,
           
           output reg  [(FLOOR_BITS-1)      :0] NEXT_FLOOR);
             
/* =============================INSERT CODE HERE======================================*/ 






/* ====================================================================================*/

endmodule

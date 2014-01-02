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
// floor_request_if.v testbench
//

`timescale 1ns / 1ns

module floor_request_if

          #(parameter FLOORS     = 99,
                      FLOOR_BITS =  7)


          (input  wire                          CLK,
           input  wire                          RESET,    

           input  wire [(FLOOR_BITS-1)      :0] CURRENT_FLOOR,
           input  wire                          HALTED,
           
           output wire [(FLOORS*2)-1:0]         ENLIGHT_BUTTONS, //downgrade to [(n-1)*2]-1
           
           input  wire [(FLOORS*2)-1:0]         FLOOR_REQUEST_IN,
           output wire [(FLOORS*2)-1:0]         FLOOR_REQUEST_OUT); 
      
/* =============================INSERT CODE HERE======================================*/ 






/* ====================================================================================*/

endmodule

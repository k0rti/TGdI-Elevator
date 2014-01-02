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
// elevator user_ctrl
//

`timescale 1ns / 1ns

module user_ctrl

          #(parameter FLOORS     = 99,
                      FLOOR_BITS =  7)


          (input  wire                    CLK,
           input  wire                    RESET,
           
           input  wire [(FLOOR_BITS-1):0] CURRENT_FLOOR_IN,           // cabin stage
           input  wire                    HALTED,
           input  wire [(FLOORS-1)    :0] FLOOR_REQUEST,              // floor button pressed
           input  wire                    MANUAL_DOOR_CLOSE_IN,       // close button pressed  
           input  wire                    MANUAL_DOOR_OPEN_IN,        // open button pressed         
           input  wire                    MANUAL_ALARM_IN,            // alarm button pressed

           output wire [(FLOOR_BITS-1):0] CURRENT_FLOOR_OUT,          // forward to cabin display
           output wire                    MANUAL_DOOR_CLOSE_OUT,      // door close cmd
           output wire                    MANUAL_DOOR_OPEN_OUT,       // door open cmd
           output wire                    MANUAL_ALARM_OUT,           // user alarm         
           output wire [(FLOORS-1)    :0] DESTINATIONS,               // destinations
           output reg  [(FLOOR_BITS-1):0] CLEAR_FLOOR_BUTTON,         // reset_button
           output reg                     CLEAR_FLOOR_BUTTON_VALID);  // validate reset_button

/* =============================INSERT CODE HERE======================================*/ 






/* ====================================================================================*/

endmodule

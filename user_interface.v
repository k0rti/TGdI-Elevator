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
// elevator display interface
//

`timescale 1ns / 1ns

module user_interface
             #(parameter FLOORS           = 99,
                         FLOOR_BITS       =  7,
                         DISPLAY_SEGMENTS = 14)
                      
              (
               input wire               	    CLK,
               input wire                           RESET,
               
               // INPUTS FROM CTRL UNIT                                                     		
               input  wire [(FLOOR_BITS-1)      :0] CURRENT_FLOOR,           
               input  wire                          HALTED,
               // INPUTS FROM BUTTONS
               input  wire [(FLOORS-1)          :0] FLOOR_SELECT,               // REQUESTS FROM CABIN                                  
               input  wire                          CLOSE_DOOR,  
	       input  wire                          OPEN_DOOR,			
               input  wire                          PASSENGER_ALARM,                   		
               input  wire [(FLOORS*2)-1        :0] FLOOR_REQUEST,              // REQUESTS FROM FLOORS
                                   
               output wire [(FLOORS-1)          :0] ENLIGHT_BUTTONS,            // ENLIGHT ELEVATOR BUTTONS
               output wire [(FLOORS*2)-1        :0] ENLIGHT_FLOOR_BUTTONS,      // ENLIGHT FLOOR REQUEST BUTTONS
               output wire [(DISPLAY_SEGMENTS-1):0] ENABLE_SEGMENT,             // SEGMENT DISPLAY
               // OUTPUTS FOR CTRL UNIT
               output wire [(FLOOR_BITS-1)      :0] NEXT_FLOOR,			// DETERMINE NEXT FLOOR
	       output wire [(FLOOR_BITS-1)      :0] CURRENT_FLOOR_OUT);               

/* =============================INSERT CODE HERE======================================*/ 






/* ====================================================================================*/
  
endmodule

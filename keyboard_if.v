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

module keyboard_if

          #(parameter FLOORS     = 99,
                      FLOOR_BITS =  7)


          (input  wire                    CLK,
           input  wire                    RESET,
           
           input  wire [(FLOORS-1)    :0] FLOOR_SELECT,             
           input  wire                    CLOSE_DOOR_IN,            
           input  wire                    OPEN_DOOR_IN,             
           input  wire                    PASSENGER_ALARM_IN,       
           input  wire [(FLOOR_BITS-1):0] CLEAR_FLOOR_BUTTON,       // reset_button
           input  wire                    CLEAR_FLOOR_BUTTON_VALID, 
            
           output wire                    CLOSE_DOOR_OUT,           // close
			  output wire			  				OPEN_DOOR_OUT,	          // open
           output wire                    PASSENGER_ALARM_OUT,      // alarm        
           output wire [(FLOORS-1)    :0] SELECTED_FLOORS,          // floor
           output wire [(FLOORS-1)    :0] ENLIGHT_BUTTONS);         // enlight      
     
/* =============================INSERT CODE HERE======================================*/ 
reg floors_selected; //Enthält alle ausgewählten Stockwerke
reg open_door;
reg close_door; 
reg alarm;

always @ (posedge CLK)
	begin
		if(RESET)
			begin
				floors_selected = FLOORS-0'b0;
				open_door = 1;
				close_door = 0;
				alarm = 0;
			end // IF RESET
		else
			begin
				floors_selected = floors_selected & FLOOR_SELECT;
				if(CLEAR_FLOOR_BUTTON_VALID)
					floors_selected = floors_selected ^ CLEAR_FLOOR_BUTTON;
				
				if(PASSENGER_ALARM_IN)
					begin
						alarm = 1;
					end
				else
					begin
						alarm = 0;
					end
				
				
				if(OPEN_DOOR_IN)
					begin
						open_door = 1;
						close_door = 0;
					end
				else
					begin
						if(CLOSE_DOOR_IN)
						begin
							open_door = 0;
							close_door = 1;
						end
					end //OPEN_DOOR_IN
			end // ELSE RESET	
	end //Always
	
	assign CLOSE_DOOR_OUT = close_door;
	assign OPEN_DOOR_OUT = open_door;
	assign PASSENGER_ALARM_OUT = alarm;
	assign SELECTED_FLOORS = floors_selected;
	assign ENLIGHT_BUTTONS = floors_selected;





/* ====================================================================================*/

endmodule

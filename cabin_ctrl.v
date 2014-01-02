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
// elevator cabin_ctrl
//

`timescale 1ns / 1ns

module cabin_ctrl

          #(parameter FLOOR_BITS             =       99, // 
                      CONTROL_STEP_DISTANCE  =       10, // [mm]
                      DISTANCE_BITS_BUILDING =       19, // 297.000 mm
                      DISTANCE_BITS_FLOORS   =       12, // 12 bits <> 3000mm, required for height counter
                      FLOOR_HEIGHT           =     3000, // [mm]
                      WAIT_CYCLE             = 40000000, // wait 40 Mio cycles for a delay of 2 seconds @ 20 MHz 
                      WAIT_CYCLE_BITS        =       26) // requires 26 bits


          (input  wire                                CLK,
           input  wire                                RESET,
                                                       
           input  wire                                MANUAL_DOOR_CLOSE,     // close
           input  wire                                MANUAL_DOOR_OPEN,      // open
           input  wire                                MANUAL_ALARM,          // alarm
           input  wire                                OBJECT_DETECTED,       // object
           input  wire                                SPEED_OK    ,          // accel_ok
           input  wire                                WEIGHT_OK,             // weight_ok
           input  wire                                SMOKE_DETECTED,        // alarm
           input  wire [(FLOOR_BITS-1)            :0] NEXT_FLOOR,            // next floor to visit
           input  wire                                DOOR_MOTOR_DONE,       // done 
           input  wire                                ELEVATOR_MOTOR_DONE,   // done
           input  wire                                ELEVATOR_MOTOR_TICK,   // Elevatormotor drove 10mm
                      
           output reg  [(FLOOR_BITS-1)            :0] CURRENT_FLOOR,
           output reg                                 HALTED,                // halted at floor
           output wire                                OPEN_DOOR,             // open
           output wire                                CLOSE_DOOR,            // close
           output wire                                ELEVATOR_UP,           // up
           output wire                                ELEVATOR_DOWN,         // down
           output reg  [(DISTANCE_BITS_BUILDING-1):0] DISTANCE,              // go distance in milimeter
           output reg                                 EMERGENCY_BRAKE);      // emergency break cmd

/* =============================INSERT CODE HERE======================================*/ 






/* ====================================================================================*/ 

endmodule

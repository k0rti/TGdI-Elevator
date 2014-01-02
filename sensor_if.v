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
// elevator sensor interface
//

`timescale 1ns / 1ns

module sensor_if

          #(parameter WEIGHT_BITS        =   10,  // weight sensor input bits
                      MAX_WEIGHT         =  500,  // maximum weight [kg]
                      VELOCITY_BITS      =   11,  // velocity sensor input bits
                      VELOCITY_THRESHOLD = 2000)  // velocity threshold [mm/s]


          (input  wire                          CLK,
           input  wire                          RESET,

           input  wire                          DOOR_LIGHT_CURTAIN_IN,         // 1 if object in the way
           input  wire [(VELOCITY_BITS-1)   :0] VELOCITY_SENSOR_IN,            // speed [cm/s]
           input  wire [(WEIGHT_BITS-1)     :0] WEIGHT_SENSOR_IN,              // weight [kg]
           input  wire                          SMOKE_PARTICLE_SENSOR_IN,      // 1 if smoke detected
           
           output reg                           DOOR_LIGHT_CURTAIN_OUT,        // 0 if door is free
           output reg                           VELOCITY_SENSOR_OUT,           // 1 if speed is ok
           output reg                           WEIGHT_SENSOR_OUT,             // 1 if weight is ok
           output reg                           SMOKE_PARTICLE_SENSOR_OUT);    // 0 if smoke is ok

/* =============================INSERT CODE HERE======================================*/ 






/* ====================================================================================*/

endmodule

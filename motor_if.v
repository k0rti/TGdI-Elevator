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
// motor interface (door and elevator)
//

`timescale 1ns / 1ns

module motor_if

         #(parameter INITIAL_POSITION  =       0,      // inital position is at floor 0
                     MOTOR_STEP        =      50,      // [m] (a single motor step is 50m = 0,05mm)
                     CONTROL_STEP      =      10,      // [mm] (a control step is 10mm = 1cm)
                     DISTANCE_BITS     =      14,      // max distance 12m = 12.000 mm
                     CONTROL_STEP_BITS =      11,      // 12m <> 1.200 control steps
                     MOTOR_STEP_BITS   =      18,      // max distance 12m = 240.000 * 50m
                     MOTOR_STEP_BITS2  =      18,      // max distance 12m = 240.000 * 50m
                     MAX_POSITION_R    =    1200,      // [control steps] (1.200 control steps = 240.000 motor steps = 12 m)
                     MAX_POSITION_L    =       0,      // [control steps] (0 control steps = 0 motor steps = 0 m)
                     DELAY_COUNT_BITS  =      17,      // 17 bits required to count up to C_0 = 100.000
                     C_0               =  100000,      // initial counter value <> 100 Hz @ 10 MHz clock
                     C_MIN             =     250)      // minimum counter value <> 40 kHz @ 10 MHz clock

         (input  wire                      CLK,
          input  wire                      RESET,

          input  wire [DISTANCE_BITS-1 :0] DISTANCE,        // levels [mm] / door_width [mm]
          input  wire                      ROTATE_LEFT,     // open or down
          input  wire                      ROTATE_RIGHT,    // close or up
                                            
          output reg                       CTRL_STEP_DONE,  // 10mm distance is a step
          output reg                       DONE,            // motor request executed
          output wire                      A,               // motor coil a output
          output wire                      B,               // motor coil a output
          output wire                      C,               // motor coil a output
          output wire                      D);              // motor coil a output

/* =============================INSERT CODE HERE======================================*/ 






/* ====================================================================================*/
   
endmodule 

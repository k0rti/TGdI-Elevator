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
// elevator toplevel
//

`timescale 1ns / 1ns

module elevator_toplevel

          #(parameter NUM_FLOORS             =   99,    // number of floors
                      DISPLAY_SEGMENTS       =   14,    // segments required to display each of the floors                      
                      FLOOR_HEIGHT           = 3000,    // level height [mm]
                      DOOR_WIDTH             =  160,    // elevator door width [mm]
                                             
                      INIT_POSITION_CABIN    =    0,    // initial door position [mm]     (open)
                      INIT_POSITION_DOOR     =    0,    // initial elevator position [mm] (ground floor)
                                             
                      MOTOR_STEP_CABIN       =   50,    // elevator motor step width [m] (1 mm <> 20 *  50m motor steps)
                      CTRL_STEP_CABIN        =   10,    // elevator control step [mm]
                      MOTOR_STEP_DOOR        =  100,    // door motor step width [m]     (1 mm <> 10 * 100m motor steps)
                      CTRL_STEP_DOOR         =   10,    // door control step [mm]
                                             
                      MIN_MOTOR_FREQ_CABIN   =  100,    // minimum stepper speed [Hz]
                      MAX_MOTOR_FREQ_CABIN   =   40,    // maximum stepper speed [kHz]
                                                                    
                      MIN_MOTOR_FREQ_DOOR    =  100,    // minimum stepper speed [Hz]
                      MAX_MOTOR_FREQ_DOOR    =   10,    // maximum stepper speed [kHz]
                      
                      GLOBAL_CLOCK_FREQUENCY =   20,    // clock frequency [MHz] (solely for computing delay)
                      DOOR_STOP_INTERVAL     =    2,    // delay before door close [s] 
                                             
                      MAX_WEIGHT             =  500,    // maximum cabin load [kg]
                      WEIGHT_SENSOR_BITS     =   10,    // measurement bits received from weight sensor
                      VELOCITY_THRESHOLD     = 2000,    // velocity to apply the emergency break [mm/s]
                      VELOCITY_SENSOR_BITS   =   11)    // measurement bits received from velocity sensor


          (input  wire                              CLK,                      // global clock
           input  wire                              RESET,                    // global reset
                                                                               
           input  wire [((NUM_FLOORS*2)-1)      :0] FLOOR_REQUEST,            // directed elevator request (up/down) from the floors
           input  wire [(NUM_FLOORS-1)          :0] FLOOR_SELECT,             // floor request buttons from the cabin
           input  wire                              CLOSE_DOOR,               // manual close door button
           input  wire                              OPEN_DOOR,               // manual close door button
           input  wire                              PASSENGER_ALARM,          // passenger alarm button                                                                               
                                                                               
           input  wire                              DOOR_LIGHT_CURTAIN_IN,    // light curtain signal
           input  wire [(VELOCITY_SENSOR_BITS-1):0] VELOCITY_SENSOR_IN,       // velocity sensor signal
           input  wire [(WEIGHT_SENSOR_BITS-1)  :0] WEIGHT_SENSOR_IN,         // weight sensor signal
           input  wire                              SMOKE_PARTICLE_SENSOR_IN, // smoke particle sensor signal
                                                                               
                                                                               
           output wire [(NUM_FLOORS-1)          :0] ENLIGHT_SELECT_BUTTONS,   // enlight floor selection buttons in the cabin
           output wire [((NUM_FLOORS*2)-1)      :0] ENLIGHT_REQUEST_BUTTONS,  // enlight floor request buttons at the floors
           output wire [(DISPLAY_SEGMENTS-1)    :0] ENABLE_SEGMENT,           // current floor segment display
           output wire                              DOOR_MOTOR_COIL_A,        // stepper motor coil signal A for open/close door
           output wire                              DOOR_MOTOR_COIL_B,        // stepper motor coil signal A for open/close door
           output wire                              DOOR_MOTOR_COIL_C,        // stepper motor coil signal A for open/close door
           output wire                              DOOR_MOTOR_COIL_D,        // stepper motor coil signal A for open/close door
           output wire                              ELEVATOR_MOTOR_COIL_A,    // stepper motor coil signal A for up/down movement
           output wire                              ELEVATOR_MOTOR_COIL_B,    // stepper motor coil signal B for up/down movement
           output wire                              ELEVATOR_MOTOR_COIL_C,    // stepper motor coil signal C for up/down movement
           output wire                              ELEVATOR_MOTOR_COIL_D,    // stepper motor coil signal D for up/down movement
           output wire                              EMERGENCY_BRAKE);         // apply emergency break
           
  // define bits required to reflect the number of floors 
  // min1() and ceil_log2() function at the end of this module
  localparam FLOOR_BITS            = min_1(ceil_log2(NUM_FLOORS-1)); 
  
  // define cycles to wait the defined door stop interval (factor is required to refelct MHz)
  localparam WAIT_CYCLES_DOOR      = (DOOR_STOP_INTERVAL * GLOBAL_CLOCK_FREQUENCY) * 1000000;
  localparam WAIT_CYCLES_DOOR_BITS = min_1(ceil_log2(WAIT_CYCLES_DOOR));
  
  // define bits required to represent door width
  localparam DISTANCE_DOOR         = DOOR_WIDTH;
  localparam DISTANCE_BITS_DOOR    = min_1(ceil_log2(DOOR_WIDTH));

  // define bits required to represent total height
  localparam DISTANCE_BITS_FLOORS  = min_1(ceil_log2(FLOOR_HEIGHT));
    
  // define bits required to represent total height
  localparam DISTANCE_BUILDING      = ((NUM_FLOORS-1) * FLOOR_HEIGHT);
  localparam DISTANCE_BITS_BUILDING = min_1(ceil_log2(DISTANCE_BUILDING));
    
  // position in control steps
  localparam CONTROL_STEP_BITS_CABIN = min_1(ceil_log2(DISTANCE_BUILDING  / CTRL_STEP_CABIN));
  localparam CONTROL_STEP_BITS_DOOR  = min_1(ceil_log2(DISTANCE_DOOR  / CTRL_STEP_DOOR));
  
  // position in motor steps
  localparam MOTOR_STEP_BITS_CABIN = 20; // min_1(ceil_log2(1000*(DISTANCE_BUILDING / MOTOR_STEP_CABIN))); // 1000 <> mm to m converstion
  localparam MOTOR_STEP_BITS_DOOR  = 20; // min_1(ceil_log2(1000*(DISTANCE_DOOR  / MOTOR_STEP_DOOR)));      // 1000 <> mm to m converstion
  
  // counter to create the necessary delay (divide global clock by two to reflect slower motor_if clock)
  localparam C_0_CABIN          = ((GLOBAL_CLOCK_FREQUENCY/2 * 1000000) / MIN_MOTOR_FREQ_CABIN);
  localparam C_MIN_CABIN        = ((GLOBAL_CLOCK_FREQUENCY/2 * 1000000) / (MAX_MOTOR_FREQ_CABIN * 1000));
   
  localparam C_0_DOOR           = ((GLOBAL_CLOCK_FREQUENCY/2 * 1000000) / MIN_MOTOR_FREQ_DOOR);
  localparam C_MIN_DOOR         = ((GLOBAL_CLOCK_FREQUENCY/2 * 1000000) / (MAX_MOTOR_FREQ_DOOR * 1000));
  
  // counter_bits required to create the delay in between motor pulses
  localparam DELAY_COUNTER_BITS_CABIN = min_1(ceil_log2(C_0_CABIN));
  localparam DELAY_COUNTER_BITS_DOOR  = min_1(ceil_log2(C_0_DOOR));
  
  // max right / max left position given in ctrl steps
  localparam MAX_POSITION_R_CABIN     = (DISTANCE_BUILDING / CTRL_STEP_CABIN);
  localparam MAX_POSITION_L_CABIN     = 0;

  localparam MAX_POSITION_R_DOOR      = (DISTANCE_DOOR / CTRL_STEP_DOOR);
  localparam MAX_POSITION_L_DOOR      = 0;
  
  
  // interconnection wire definition
  
  wire [(NUM_FLOORS-1)          :0] floor_buttons_selected;               // selected floor buttons from the keyboard interface
  
  wire [(NUM_FLOORS-1)          :0] selected_floors;                      // floors selected from inside the cabin (user control)
  wire [(2*NUM_FLOORS-1)        :0] requested_floors;                     // elevator request from the floors (floor request interface)
  wire                              halted;                               // indicates, that elevator stopped at current floor
  wire [(FLOOR_BITS-1)          :0] current_floor;                        // the current floor the elevator is in
  wire [(FLOOR_BITS-1)          :0] current_floor_display;                // the current floor to display
  wire [(FLOOR_BITS-1)          :0] next_floor;                           // next floor targeted by the elevator
                                                                          
  wire [(FLOOR_BITS-1)          :0] clear_selected_floors_button;         // resets a selected floor request on fulfillment
  wire                              clear_selected_floors_button_valid;   // validate the reset_floor_button signal
                                                                          
  wire                              object_detected;                      // evaluated light curtain sensor  (1 = door is free  )
  wire                              speed_ok;                             // evaluated velocity sensor       (1 = velocity is ok)
  wire                              weight_ok;                            // evaluated weight sensor         (1 = weight is ok  )
  wire                              smoke_detected;                       // evaluated smoke particle sensor (1 = fire alarm    )
                                                                          
                                                                          
  wire                              alarm_request;                        // user alarm request issued from the keyboard interface
  wire                              door_close_request;                   // door close request issued from the keyboard interface
  wire										door_open_request;						  // door open request issued from the keyboard interface
                                                                          
  wire                              manual_alarm;                         // user alarm from user control
  wire                              manual_door_close;                    // manual door close from user control
                                                                          
  wire                              motor_done_cabin;                     // elevator motor completed last request
  wire                              ctrl_motor_step_cabin;                // indicated a motor control step
  wire                              motor_done_door;                      // door motor completed last request
                                                            
  wire [(DISTANCE_BITS_BUILDING-1):0] cabin_distance_to_go;               // distance to go [mm]
  wire [(DISTANCE_BITS_DOOR-1):0] door_distance_to_go;                // distance to go [mm]
  
   
  reg                               CLK_DIV2;                             // clock signal for motor interfaces 
  
  
  assign door_distance_to_go = DISTANCE_DOOR;
  
 
  reg [15:0] RESET_SR;
  
  assign RESET_INT = RESET_SR[0];
  
  always@(posedge CLK) begin
    if (RESET) begin
      RESET_SR <= 16'hFFFF;
    end
    else begin
      RESET_SR <= RESET_SR >> 1;   
    end
  end 
  /*********** CLOCK DIVIDER BY 2 ***********/
  always@(posedge CLK) begin
    if (RESET) begin
      CLK_DIV2 <= 1'b0;
    end
    else begin
      CLK_DIV2 <= ~CLK_DIV2;    
    end
  end

  
  /***********  USER INTERFACE ***********/
  keyboard_if #(
               .FLOORS     (NUM_FLOORS),
               .FLOOR_BITS (FLOOR_BITS))
               
      KEYBOARD_IF_i (
                    .CLK(CLK),
                    .RESET(RESET_INT),
                    .FLOOR_SELECT(FLOOR_SELECT),
                    .CLOSE_DOOR_IN(CLOSE_DOOR),
                    .OPEN_DOOR_IN(OPEN_DOOR),
                    .PASSENGER_ALARM_IN(PASSENGER_ALARM),
                    .CLEAR_FLOOR_BUTTON(clear_selected_floors_button),
                    .CLEAR_FLOOR_BUTTON_VALID(clear_selected_floors_button_valid),
                    .CLOSE_DOOR_OUT(door_close_request),
		    .OPEN_DOOR_OUT(door_open_request),
                    .PASSENGER_ALARM_OUT(alarm_request),
                    .SELECTED_FLOORS(floor_buttons_selected),
                    .ENLIGHT_BUTTONS(ENLIGHT_SELECT_BUTTONS));

               
  user_ctrl #(
              .FLOORS     (NUM_FLOORS),
              .FLOOR_BITS (FLOOR_BITS))
              
      USER_CTRL_i (
                  .CLK(CLK),
                  .RESET(RESET_INT),
                  .CURRENT_FLOOR_IN(current_floor),
                  .HALTED(halted),                           
                  .FLOOR_REQUEST(floor_buttons_selected),
                  .MANUAL_DOOR_CLOSE_IN(door_close_request),
		  .MANUAL_DOOR_OPEN_IN(door_open_request),
                  .MANUAL_ALARM_IN(alarm_request),
                  
                  .CURRENT_FLOOR_OUT(current_floor_display),
                  .MANUAL_DOOR_CLOSE_OUT(manual_door_close),
                  .MANUAL_DOOR_OPEN_OUT(manual_door_open),
                  .MANUAL_ALARM_OUT(manual_alarm),
                  .DESTINATIONS(selected_floors),
                  .CLEAR_FLOOR_BUTTON(clear_selected_floors_button),
                  .CLEAR_FLOOR_BUTTON_VALID(clear_selected_floors_button_valid));               


  display_if #(
              .FLOOR_BITS       (FLOOR_BITS),
              .DISPLAY_SEGMENTS (DISPLAY_SEGMENTS))     
              
      DISPLAY_IF_i (            
                   .CURRENT_FLOOR  (current_floor_display),
                   .ENABLE_SEGMENT (ENABLE_SEGMENT));


  floor_request_if #(
                    .FLOORS     (NUM_FLOORS), 
                    .FLOOR_BITS (FLOOR_BITS)) 
  
      FLOOR_REQUEST_IF_i (
                         .CLK(CLK),
                         .RESET(RESET_INT),
			 
                         .CURRENT_FLOOR(current_floor),
                         .HALTED(halted),
                         
                         .ENLIGHT_BUTTONS(ENLIGHT_REQUEST_BUTTONS),
                         
                         .FLOOR_REQUEST_IN(FLOOR_REQUEST),
                         .FLOOR_REQUEST_OUT(requested_floors)); 
                
  /********* ELEVATOR MOTOR, DOOR MOTOR *********/           
                                                                                                                               
  motor_if #(
            .INITIAL_POSITION  (INIT_POSITION_DOOR),
            .MOTOR_STEP        (MOTOR_STEP_DOOR),
            .CONTROL_STEP      (CTRL_STEP_DOOR),
            .DISTANCE_BITS     (DISTANCE_BITS_DOOR),     //strange
            .CONTROL_STEP_BITS (CONTROL_STEP_BITS_DOOR),
            .MOTOR_STEP_BITS   (MOTOR_STEP_BITS_CABIN),
            .MOTOR_STEP_BITS2  (MOTOR_STEP_BITS_DOOR),
            .DELAY_COUNT_BITS  (DELAY_COUNTER_BITS_DOOR),
            .MAX_POSITION_R    (MAX_POSITION_R_DOOR), 
            .MAX_POSITION_L    (MAX_POSITION_L_DOOR), 
            .C_0               (C_0_DOOR), 
            .C_MIN             (C_MIN_DOOR))
             
      DOOR_MOTOR_IF_i (
                      .CLK(CLK_DIV2),
                      .RESET(RESET_INT),
                      .DISTANCE(door_distance_to_go),
                      .ROTATE_RIGHT(door_close),
                      .ROTATE_LEFT(door_open),
                      .CTRL_STEP_DONE(ctrl_motor_step_door),
                      .DONE(motor_done_door),
                      .A(DOOR_MOTOR_COIL_A),
                      .B(DOOR_MOTOR_COIL_B),
                      .C(DOOR_MOTOR_COIL_C),
                      .D(DOOR_MOTOR_COIL_D));


                       
  motor_if #(
            .INITIAL_POSITION (INIT_POSITION_CABIN),
            .MOTOR_STEP       (MOTOR_STEP_CABIN),
            .CONTROL_STEP     (CTRL_STEP_CABIN),
            .DISTANCE_BITS    (DISTANCE_BITS_BUILDING),
            .CONTROL_STEP_BITS(CONTROL_STEP_BITS_CABIN),
            .MOTOR_STEP_BITS  (MOTOR_STEP_BITS_CABIN),
            .DELAY_COUNT_BITS (DELAY_COUNTER_BITS_CABIN),
            .MAX_POSITION_R   (MAX_POSITION_R_CABIN), 
            .MAX_POSITION_L   (MAX_POSITION_L_CABIN), 
            .C_0              (C_0_CABIN), 
            .C_MIN            (C_MIN_CABIN))
             
      ELEVATOR_MOTOR_IF_i (
                          .CLK(CLK_DIV2),
                          .RESET(RESET_INT),
                          .DISTANCE(cabin_distance_to_go),               
                          .ROTATE_RIGHT(elevator_up),
                          .ROTATE_LEFT(elevator_down),
                          .CTRL_STEP_DONE(ctrl_motor_step_cabin),
                          .DONE(motor_done_cabin),
                          .A(ELEVATOR_MOTOR_COIL_A),
                          .B(ELEVATOR_MOTOR_COIL_B),
                          .C(ELEVATOR_MOTOR_COIL_C),
                          .D(ELEVATOR_MOTOR_COIL_D));
    

  /********* NEXT FLOOR CONTROL, SENSOR INTERFACE, ELEVATATOR STATE MACHINE *********/
  next_floor_ctrl #(
                   .FLOORS     (NUM_FLOORS), 
                   .FLOOR_BITS (FLOOR_BITS)) 
  
      NEXT_FLOOR_CTRL_i (
                        .CLK(CLK),
                        .RESET(RESET_INT),
                        
                        .DESTINATIONS(selected_floors),
                        .FLOOR_REQUEST(requested_floors),
                        .HALTED(halted),
                        .CURRENT_FLOOR(current_floor),

                        .NEXT_FLOOR(next_floor));
                 
                 
  sensor_if #(
             .WEIGHT_BITS        (WEIGHT_SENSOR_BITS),
             .MAX_WEIGHT         (MAX_WEIGHT), 
             .VELOCITY_BITS      (VELOCITY_SENSOR_BITS), 
             .VELOCITY_THRESHOLD (VELOCITY_THRESHOLD)) 
  
      SENSOR_IF_i (
                  .CLK(CLK),
                  .RESET(RESET_INT),
                  .DOOR_LIGHT_CURTAIN_IN(DOOR_LIGHT_CURTAIN_IN),
                  .VELOCITY_SENSOR_IN(VELOCITY_SENSOR_IN),
                  .WEIGHT_SENSOR_IN(WEIGHT_SENSOR_IN),
                  .SMOKE_PARTICLE_SENSOR_IN(SMOKE_PARTICLE_SENSOR_IN),
                  
                  .DOOR_LIGHT_CURTAIN_OUT(object_detected),
                  .VELOCITY_SENSOR_OUT(speed_ok),
                  .WEIGHT_SENSOR_OUT(weight_ok),
                  .SMOKE_PARTICLE_SENSOR_OUT(smoke_detected));  
                                                 
                           
  cabin_ctrl #(
              .FLOOR_BITS             (FLOOR_BITS),
              .CONTROL_STEP_DISTANCE  (CTRL_STEP_CABIN),
              .DISTANCE_BITS_BUILDING (DISTANCE_BITS_BUILDING),
              .DISTANCE_BITS_FLOORS   (DISTANCE_BITS_FLOORS),
              .FLOOR_HEIGHT           (FLOOR_HEIGHT),
              .WAIT_CYCLE             (WAIT_CYCLES_DOOR),
              .WAIT_CYCLE_BITS        (WAIT_CYCLES_DOOR_BITS)) 
              
      CABIN_CTRL_i (
                   .CLK(CLK),
                   .RESET(RESET_INT),
                   .MANUAL_DOOR_CLOSE(manual_door_close),
						 .MANUAL_DOOR_OPEN(manual_door_open),
                   .MANUAL_ALARM(manual_alarm),
                   .OBJECT_DETECTED(object_detected),
                   .SPEED_OK(speed_ok),
                   .WEIGHT_OK(weight_ok),
                   .SMOKE_DETECTED(smoke_detected),
                   .NEXT_FLOOR(next_floor),
                   .DOOR_MOTOR_DONE(motor_done_door),
                   .ELEVATOR_MOTOR_DONE(motor_done_cabin),
                   .ELEVATOR_MOTOR_TICK(ctrl_motor_step_cabin),
                   
                   .CURRENT_FLOOR(current_floor),
                   .HALTED(halted),
                   .OPEN_DOOR(door_open),
                   .CLOSE_DOOR(door_close),
                   .ELEVATOR_UP(elevator_up),
                   .ELEVATOR_DOWN(elevator_down),
                   .DISTANCE(cabin_distance_to_go),
                   .EMERGENCY_BRAKE(EMERGENCY_BRAKE));               



  /********* FUNCTIONS *********/
  //ceil of the log base 2
  function integer ceil_log2;
    input [31:0] value;
    for (ceil_log2=0; value>0; ceil_log2=ceil_log2+1)
      value = value>>1;
  endfunction
  
  // value cannot be less than 1
  function integer min_1;
    input [31:0] value;
    if (value == 0)
      min_1 = 1;
    else
      min_1 = value;
  endfunction  
  
               
endmodule               
             

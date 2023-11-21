module control_game(
	input Clock, Resetn, Enable1Frame, start, move, win, done1, done2, done1_new, done2_new, start_graphics, done3, 
	output reg reset_signals, start_race, initial_draw_car, initial_draw_car, draw_car, draw_start_screen, draw_win_screen, move_car, plot);
	
  reg[2:0] current_state, next_state;

	
	localparam  	
    DRAW_GRAPHICS = 0,
    DRAW_CAR		  = 1,
    DRAW_BACKGROUND = 2,
    WAIT_INPUT   = 3,
    RE_DRAW_BACKGROUND          = 4,
    RE_DRAW_CAR     = 5,
    MOVE     = 6,
    DARW_WIN_SCREEN 	  = 7,
    WAIT_FOR_START   = 8,
    
    // Next state logic aka our state table
    always@(*)
    begin: // state_table 
		case (current_state)
			DRAW_GRAPHICS: begin
        if(start_graphics) begin
					next_state = DRAW_BACKGROUND;
				end
				else next_state = DRAW_GRAPHICS;
			end
			DRAW_BACKGROUND: next_state = done1 ? DRAW_CAR : DRAW_BACKGROUND;
			DRAW_CAR: begin
        if(done2) begin
					if(win) next_state = DRAW_WIN_SCREEN;
          else if(move == 1'b1 && Enable1Frame) next_state = RE_DRAW_BACKGROUND;
					else next_state = WAIT_INPUT;
				end
				else next_state = DRAW_CAR;
			end
			WAIT_INPUT: begin
        if(move == 1'b1 && Enable1Frame) next_state = RE_DRAW_BACKGROUND;
				else next_state = WAIT_INPUT;
			end
			RE_DRAW_CAR: begin
        if(done2_new) begin
          if(move == 1'b1) next_state = MOVE_FORWARD;
					else if(left == 1'b1 || right == 1'b1) next_state = RE_DRAW_CAR;
					else next_state = DRAW_CAR;
				end
				else next_state = DRAW_OVER_CAR;
			end
			MOVE_FORWARD: next_state = DRAW_CAR;
			MOVE_LEFT_RIGHT: next_state = DRAW_CAR;
			WAIT_LEFT_RIGHT: next_state = (left == 1'b1 || right == 1'b1) ? WAIT_LEFT_RIGHT : WAIT_FOR_MOVE;
			DRAW_EXPLOSION: begin
				if(DoneDrawExplosion) begin
					if(start) next_state = DRAW_EXPLOSION;
					else next_state = SET_RESET_SIGNALS;
				end
				else next_state = DRAW_EXPLOSION;
			end
			DRAW_WIN_SCREEN: begin
				if(DoneDrawWinScreen) begin
					if(start) next_state = DRAW_WIN_SCREEN;
					else next_state = SET_RESET_SIGNALS;
				end
				else next_state = DRAW_WIN_SCREEN;
			end
			default: next_state = SET_RESET_SIGNALS;
		endcase
    end // state_table

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
	 
		set_reset_signals = 1'b0;
		start_race = 1'b0;
		draw_background = 1'b0;
		draw_car = 1'b0;
		draw_over_car = 1'b0;
		draw_explosion = 1'b0;
		draw_start_screen = 1'b0;
		draw_win_screen = 1'b0;
		move = 1'b0;
		plot = 1'b0;
	 
        case (current_state)
			DRAW_GRAPHICS: begin
				start_graphics = 1'b1;
				plot = 1'b1;
			end
			SET_RESET_SIGNALS: reset_signals = 1'b1;
			DRAW_BACKGROUND: begin
				draw_background = 1'b1;
				plot = 1'b1;
			end
			START_RACE: start_race = 1'b1;
			DRAW_CAR: begin
				if(DoneDrawCar) plot = 1'b0;
				else begin
					draw_car = 1'b1;
					plot = 1'b1;
				end
			end
			DRAW_OVER_CAR: begin
				if(DoneDrawOverCar) plot = 1'b0;
				else begin
					draw_over_car = 1'b1;
					plot = 1'b1;
				end
			end
			MOVE_FORWARD: move = 1'b1;
			MOVE_LEFT_RIGHT: move = 1'b1;
			DRAW_EXPLOSION: begin
				if(DoneDrawExplosion) plot = 1'b0;
				else begin
					draw_explosion = 1'b1;
					plot = 1'b1;
				end
			end
			DRAW_WIN_SCREEN: begin
				draw_win_screen = 1'b1;
				plot = 1'b1;
			end
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge Clock)
    begin: state_FFs
        if(!Resetn)
           current_state <= SET_RESET_SIGNALS;
        else
            current_state <= next_state;
    end // state_FFS
	 
endmodule

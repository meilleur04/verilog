module control_game(
	input Clock, enable, start, left, right, choice_for_path, win, forward, done1, done2, done1_new, done2_new, start_graphics, done3, 
	output reg reset_signals, start_race, initial_draw_car, initial_draw_car, draw_car, draw_start_screen, draw_win_screen, move_car, plot);

	output reg set_reset_signals, start_race, draw_background, draw_car, draw_over_car, draw_explosion, draw_start_screen, draw_win_screen, move, plot);
	
	reg[3:0] current_state, next_state;

	
	localparam  	DRAW_GRAPHICS = 0,
					SET_RESET		  = 1,
					DRAW_BACKGROUND   = 2,
					DRAW_CAR          = 3,
					WAIT     = 4,
					DARW_NEW_BACKGROUND = 5,
					DRAW_NEW_CAR     = 6,
					MOVE_FORWARD 	  = 7,
					SWITCH_PASS   = 8,
					DRAW_WIN_SCREEN	  = 9;
					WAIT_FOR_START = 10;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
		case (current_state)
			DRAW_GRAPHICS: begin
				if(begin_game)begin
					if(start_graphics) next_state = DRAW_BACKGROUND;
					else if(start) next_state = SET_RESET;
					else next_state = DRAW_START_SCREEN;
				end
			end
			SET_RESET: next_state = DRAW_GRAPHICS;
			DRAW_BACKGROUND: next_state = done1 ? DRAW_CAR : DRAW_BACKGROUND;
			DRAW_CAR: begin
				if(done1) begin
					if(win) next_state = DRAW_WIN_SCREEN;
					else if(forward == 1'b1 && enable) next_state = DRAW_NEW_BACKGROUND;
					else if(left == 1'b1 || right == 1'b1) next_state = DRAW_NEW_BACKGROUND;
					else if(start) next_state = SET_RESET;
					else next_state = WAIT;
				end
				else next_state = DRAW_CAR;
			end
			WAIT: begin
				if(forward == 1'b1 && enable) next_state = DRAW_NEW_BACKGROUND;
				else if(left == 1'b1 || right == 1'b1) next_state = DRAW_NEW_BACKGROUND;
				else if(start) next_state = SET_RESET;
				else next_state = WAIT;
			end
			DRAW_NEW_BACKGROUND: begin
				if(done1_new) begin
					if(forward == 1'b1) next_state = DRAW_NEW_CAR;
					else if(left == 1'b1 || right == 1'b1) next_state = LEFT_RIGHT_PATH;
					else if(start) next_state = SET_RESET;
					else next_state = DRAW_CAR;
				end
				else next_state = DRAW_OVER_CAR;
			end
			DRAW_NEW_CAR: begin
				if(done2_new) begin
					if(forward == 1'b1) next_state = MOVE_FORWARD;
					else if(left == 1'b1 || right == 1'b1) next_state = LEFT_RIGHT_PATH;
					else if(start) next_state = SET_RESET;
					else next_state = DRAW_CAR;
				end
				else next_state = DRAW_OVER_CAR;
			end
			MOVE_FORWARD: next_state = DRAW_CAR;
			LEFT_RIGHT_PATH: next_state = DRAW_CAR;
			DRAW_WIN_SCREEN: begin
				if(done3) begin
					if(start) next_state = DRAW_BACKGROUND;
					else next_state = WAIT_FOR_START;
				end
				else next_state = DRAW_WIN_SCREEN;
			end
			WAIT_FOR_START: next_state = start ? DRAW_BACKGROUND : WAIT_FOR_START;
			default: next_state = SET_RESET_SIGNALS;
		endcase
    end // state_table

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
	 
		set_reset_signals = 1'b0;
		draw_background = 1'b0;
		draw_car = 1'b0;
	        draw_new_background = 1'b0;
		draw_new_car = 1'b0;
		draw_win_screen = 1'b0;
		move = 1'b0;
		plot = 1'b0;
	 
        case (current_state)
			DRAW_GRAPHICS: begin
				draw_graphics = 1'b1;
				plot = 1'b1;
			end
			SET_RESET: set_reset_signals = 1'b1;
			DRAW_BACKGROUND: begin
				if(done1) plot = 1'b0;
				else begin
					draw_background = 1'b1;
					plot = 1'b1;
				end
			end
			DRAW_CAR: begin
				if(done2) plot = 1'b0;
				else begin
					draw_car = 1'b1;
					plot = 1'b1;
				end
			end
			DRAW_NEW_BACKGROUND: begin
				if(done1_new) plot = 1'b0;
				else begin
					draw_new_background = 1'b1;
					plot = 1'b1;
				end
			end
			DRAW_NEW_CAR: begin
				if(done2_new) plot = 1'b0;
				else begin
					draw_new_car = 1'b1;
					plot = 1'b1;
				end
			end
			MOVE_FORWARD: move = 1'b1;
			LEFT_RIGHT_PATH: move = 1'b1;
			DRAW_WIN_SCREEN: begin
				draw_win_screen = 1'b1;
				plot = 1'b1;
			end
			WAIT_FOR_START: begin
				if(start) draw_new_background = 1'b1;
			end
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge Clock)
    begin: 
	    if(!start)
           current_state <= SET_RESET_SIGNALS;
        else
            current_state <= next_state;
    end // state_FFS
	 
endmodule

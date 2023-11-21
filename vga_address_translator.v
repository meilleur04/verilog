/* This module converts the output of the FSM (used to select car state) coordinates into a memory address.
 * The output of the module will be used to reset the background image
 */
module vga_address_translator(x, y, mem_address);

	parameter RESOLUTION = "640x480";
  	input [((RESOLUTION == "640x480") ? (9) : (8)):0] x; 
 	input [((RESOLUTION == "640x480") ? (8) : (7)):0] y;	
 	output reg [((RESOLUTION == "640x480") ? (18) : (16)):0] mem_address;
	
	/* The basic formula is address = y*WIDTH + x;
	 * For 320x240 resolution we can write 320 as (256 + 64). Memory address becomes
	 * (y*256) + (y*64) + x;
	 * This simplifies multiplication a simple shift and add operation.
	 * A leading 0 bit is added to each operand to ensure that they are treated as unsigned
	 * inputs. By default the use a '+' operator will generate a signed adder.
	 * Similarly, for 640 x 480 resolution we write 480 as 32 * 16 + 32 * 4 = 512 + 64.
	 */
  	wire [18:0] res_640x480 = ({1'b0, y, 9'd0} + {1'b0, y, 6'd0} + {1'b0, x});
	wire [16:0] res_320x240 = ({1'b0, y, 8'd0} + {1'b0, y, 6'd0} + {1'b0, x});
  
	always @(*)
	begin
    	if (RESOLUTION == "640x480")
		mem_address = res_640x480;
	else
		mem_address = res_320x240;
	end
endmodule


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: ps2_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ps2_controller(
    PS2_CLK,
    PS2_DAT,
    dataOUT,
    CLK5HZ,
    NEWDATA,
    KEYPRESS_SPACE,
    KEYPRESS_W,
    KEYPRESS_ESC
    );
   
    input PS2_CLK;
    input PS2_DAT;
    input CLK5HZ;
    output[7:0] dataOUT;
    output NEWDATA;
    output KEYPRESS_SPACE, KEYPRESS_W, KEYPRESS_ESC;
    
    
    reg NEW_DATA_FLAG = 1'b0;
    
    reg[7:0] DAT_INT_CURRENT  = 8'd0; // internal data register, current data
    reg[7:0] DAT_INT_PREVIOUS = 8'd0; // Internal data register, previous data
    reg[3:0] INDEX_IT         = 4'd1;
    
    reg CLK_INT               = 1'd0; // New data clock
    reg STROBE_INT            = 1'd1;
    
    assign NEWDATA = NEW_DATA_FLAG;
    
    always @ (negedge PS2_CLK)
    begin
        //dataOUT[8] <= ~dataOUT[8];
        case (INDEX_IT)
            2: DAT_INT_CURRENT[0] <= PS2_DAT;
            3: DAT_INT_CURRENT[1] <= PS2_DAT;
            4: DAT_INT_CURRENT[2] <= PS2_DAT;
            5: DAT_INT_CURRENT[3] <= PS2_DAT;
            6: DAT_INT_CURRENT[4] <= PS2_DAT;
            7: DAT_INT_CURRENT[5] <= PS2_DAT;
            8: DAT_INT_CURRENT[6] <= PS2_DAT;
            9: DAT_INT_CURRENT[7] <= PS2_DAT;
            10: CLK_INT <= 1'b1;
            11: 
               begin
                    CLK_INT        <= 1'b0;
                    NEW_DATA_FLAG  <= 1'b0;
               end
            1: NEW_DATA_FLAG <= 1'b1;
            default:;
        endcase
        
        if (INDEX_IT <= 4'd10)
        begin
            INDEX_IT <= INDEX_IT + 1'd1;
        end
        else
        begin
            INDEX_IT <= 4'd1;
        end
    end
    
    assign dataOUT = DAT_INT_PREVIOUS;

    // Assign the output
    assign KEYPRESS_S       = (DAT_INT_PREVIOUS == 8'h1B);
    assign KEYPRESS_R       = (DAT_INT_PREVIOUS == 8'h2D);
    assign KEYPRESS_L       = (DAT_INT_PREVIOUS == 8'h4B);
    assign KEYPRESS_ESC     = (DAT_INT_PREVIOUS == 8'h76);
    
    always @ (posedge CLK_INT)
    begin
        if (DAT_INT_CURRENT == 8'd0)
        begin
            //dataOUT = DAT_INT_PREVIOUS;
            //dataOUT = 8'hFF;
        end
        else
        begin
            //STROBE = 1'b0;//(STROBE ^ (1'b1));
            DAT_INT_PREVIOUS = DAT_INT_CURRENT;
            //dataOUT = 8'hFF;
        end
    end
endmodule

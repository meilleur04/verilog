module FSM_select_car_state (
input Clock,
input Reset,
input w,
output z,
output CurState
) ;
  parameter N = 50;
  [N:0] CurState;
  reg [3:0] y_Q , Y_D ;
  localparam A =4 ’ d0 , B =4 ’ d1 , C =4 ’ d2 , D =4 ’ d3 , E =4 ’ d4 , F =4 ’ d5 , G =4 ’ d6 ;
  // State table
  always@ (*) begin
    case ( y_Q )
      A : 
      begin
        if (! w ) Y_D = A ;
        else   Y_D = B ;
      end
        B : // Complete
        C : // Complete
        D : // Complete
        E : // Complete
        F : // Complete
        G : // Complete
      default : // Complete
    endcase
  end // state_table
    // State Registers
  always @ ( posedge Clock ) begin
  if ( Reset == 1 ’ b1 )
    // Should set reset state to the starting state which is A
  else
    y_Q <= Y_D ;
  end // state flip flops
  assign z = (( y_Q == F ) | ( y_Q == G ) ) ; // Output logic
  assign CurState = y_Q ;
endmodule

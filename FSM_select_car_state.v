module FSM_select_car_state (
  input Clock,
  input Reset,
  input Choice,
  output Result,
  output wire [3:0] CurState 
);

  reg [3:0] y_Q, Y_D;
  localparam A = 4'd0, 
             B = 4'd1, 
             C = 4'd2, 
             D = 4'd3, 
             E = 4'd4, 
             F = 4'd5, 
             G = 4'd6,
             H = 4'd7,
             I = 4'd8,
             J = 4'd9,
             K = 4'd10,
             L = 4'd11,
             M = 4'd12,
             N = 4'd13,
             O = 4'd14;

  // State table
  always @(*) begin
    case (y_Q)
      A: Y_D = B;
      B: Y_D = C;
      C: Y_D = D;
      D: Y_D = E;
      E: Y_D = F;
      F: Y_D = G;
      G: Y_D = H;
      H: begin
        if (!Choice) Y_D = L;
        else Y_D = I;
      end
      I: Y_D = J;
      J: Y_D = K;
      K: begin
        if (Reset) Y_D = A;
        else Y_D = K;
      end
      L: Y_D = M;
      M: Y_D = N;
      N: Y_D = O;
      O: begin
        if (Reset) Y_D = A;
        else Y_D = O;
      end
      default: Y_D = A;
    endcase
  end // state_table

  // State Registers
  always @(posedge Clock) begin
    if (Reset)
      y_Q <= A;
    else
      y_Q <= Y_D;
  end // state flip flops

  assign Result = ((y_Q == K) | (y_Q == O)); // Output logic
  
  assign CurState = y_Q; // changed assign statement
 
endmodule

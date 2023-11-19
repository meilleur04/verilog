module controlpath(matrix, Reset, colour, x, y);
  parameter horizontal = 640;
  parameter vertical = 480;
  input [horizontal*vertical - 1:0] matrix;
  input Reset;
  output [2:0] clour;
  output [horizontal - 1:0] x;
  output [vertical - 1:0] y;
  integer i;
  integer j;
  initial begin 
  for(i = 0; i < horizontal; i = i + 1)begin
    x[i] = i;
    for(j = 0; j < horizontal; j = j + 1)begin
      colour = matrix[horizontal * i + j];
      y[j] = j;
    end
  end
endmodule

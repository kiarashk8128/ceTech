module predictor(input wire request, result, clk, taken, output reg prediction);


  // Declare the input and output signals
  input request; // Input signal representing branch request
  input result; // Input signal representing branch result
  input clk; // Clock signal
  input taken; // Input signal representing branch taken
  output reg prediction; // Output signal representing the predicted outcome

  // Define the saturating counter variable
  reg [1:0] saturating_counter = 0;

  // Implement the saturating counter logic
  always @(posedge clk) begin
    if (result) begin
      if (taken && (saturating_counter < 3))
        saturating_counter <= saturating_counter + 1;
      else if (!taken && (saturating_counter > 0))
        saturating_counter <= saturating_counter - 1;
    end
  end

  // Determine the prediction based on the saturating counter
  always @(posedge clk) begin
    if (request)
      prediction <= saturating_counter[1];
  end

endmodule

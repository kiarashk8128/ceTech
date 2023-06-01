module predictor(input wire request, result, clk, taken, output reg prediction);

  // Define the necessary parameters
  parameter COUNTER_BITS = 2; // Number of bits for the counter
  parameter SATURATION_THRESHOLD = (1 << COUNTER_BITS) - 1; // Threshold for saturation

  // Declare the input and output signals
  input request; // Input signal representing branch request
  input result; // Input signal representing branch result
  input clk; // Clock signal
  input taken; // Input signal representing branch taken
  output reg prediction; // Output signal representing the predicted outcome

  // Define the saturating counter variable
  reg [COUNTER_BITS-1:0] saturating_counter = 0;

  // Implement the saturating counter logic
  always @(posedge clk) begin
    if (result) begin
      if (taken && (saturating_counter < SATURATION_THRESHOLD))
        saturating_counter <= saturating_counter + 1;
      else if (!taken && (saturating_counter > 0))
        saturating_counter <= saturating_counter - 1;
    end
  end

  // Determine the prediction based on the saturating counter
  always @(posedge clk) begin
    if (request)
      prediction <= (saturating_counter >= (SATURATION_THRESHOLD >> 1)) ? 1 : 0;
  end

endmodule

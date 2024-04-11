module ACS		                        // add-compare-select
(
   input       path_0_valid,
   input       path_1_valid,
   input [1:0] path_0_bmc,	            // branch metric computation
   input [1:0] path_1_bmc,				
   input [7:0] path_0_pmc,				// path metric computation
   input [7:0] path_1_pmc,

   output logic        selection,
   output logic        valid_o,
   output      [7:0] path_cost);  

   logic [7:0] path_cost_0;			   // branch metric + path metric
   logic  [7:0] path_cost_1; 

	
	assign path_cost = (valid_o?(selection?path_cost_1:path_cost_0):8'd0);
	assign path_cost_0 = path_0_bmc + path_0_pmc;
	assign path_cost_1 = path_1_bmc + path_1_pmc;
	
	always_comb begin
	valid_o = (!path_0_valid && !path_1_valid) ? 1'b0 : 1'b1;
	 
		if(path_0_valid == 0 && path_1_valid == 0) begin
			selection = 0;
			valid_o = 0;
			
		end

		else if(path_0_valid == 0 && path_1_valid == 1) begin
			selection = 1;
			valid_o = 1;
			
		end
		
		else if(path_0_valid == 1 && path_1_valid == 0) begin
			selection = 0;
		   valid_o = 1;	
			
		end
		
		else if(path_cost_0 > path_cost_1) begin
				selection = 1;
				valid_o = 1;
				
		end
		
		else begin
				selection = 0;
				valid_o = 1;
				
		end
		
		
	end
			
endmodule

module viterbi_tx_rx(
   input    clk,
   input    rst,
   input    encoder_i,
   input    enable_encoder_i,
   output   decoder_o);

   wire  [1:0] encoder_o;

   logic   [3:0] error_counter;
   logic   [1:0] encoder_o_reg;
   
   logic       enable_decoder_in;
   wire        valid_encoder_o;

	//Logic for error for bit 0 and 1
	logic [2:0] error_bit8;
	logic [4:0] error_bit32;
	int bad_bit_ct = 1;
	int word_ct;
	
	
   always @ (posedge clk, negedge rst) 
      if(!rst) begin  
         error_counter  <= 4'd0;
         encoder_o_reg  <= 2'b00;
         enable_decoder_in <= 1'b0;
			error_bit8 <= 3'd0;
			error_bit32 <= 5'd0;
			 word_ct = 0;
      end
      else	   begin   
         enable_decoder_in <= valid_encoder_o; 
         encoder_o_reg  <= 2'b00;
         error_counter  <= error_counter + 4'd1;
			error_bit8 <= error_bit8 + 3'd1;
			error_bit32 <= error_bit32 + 5'd1;
			 word_ct              <= word_ct + 1;
     
			if(error_bit8==3'b111)begin //2a2 # good =         256, bad =           0 , Injected : 32
            encoder_o_reg  <= {~encoder_o[1],encoder_o[0]};	 // inject one bad bit out of every 8
				 if(word_ct<256)begin
					bad_bit_ct     <= bad_bit_ct + 1;
					$display("error_counter = %d",bad_bit_ct);
				 end
			end
		
			else
            encoder_o_reg  <= {encoder_o[1],encoder_o[0]};
      end   

// insert your convolutional encoder here
// change port names and module name as necessary/desired
   encoder encoder1	     (
      .clk(clk),
      .rst(rst),
      .enable_i(enable_encoder_i),
      .d_in(encoder_i),
      .valid_o(valid_encoder_o),
      .d_out(encoder_o)   );

// insert your term project code here 
   decoder decoder1	     (
      .clk(clk),
      .rst(rst),
      .enable(enable_decoder_in),
      .d_in(encoder_o_reg),
      .d_out(decoder_o)
		);

endmodule




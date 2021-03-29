`default_nettype none
module top(
  input  wire 		 clk 		 	       ,
  input  wire        reset_n   	 	       ,
  input  wire [31:0] sw_address  	       ,
  input  wire		 sw_read_en    	       ,
  input  wire		 sw_write_en   	       ,
  input  wire [31:0] sw_datain   	       ,   
  output wire [31:0] sw_dataout   	       ,
  output wire        fpu_fused_m_a         ,  
  output wire        fpu_simd     	       ,
  output wire [2:0 ] fpu_simd_no_op	       
  
    );

wire [1:0]  fpu_format				 	   ;
wire [1:0]  fpu_operation			       ;
wire        fpu_en                   	   ;
wire        fpu_int_en                     ; 
wire        fpu_rst_w                	   ; 
wire  		fpu_doorbell_w			 	   ;
wire  		fpu_doorbell_r			 	   ;
wire  		fpu_interrupt_w			 	   ;
wire  		fpu_ready				 	   ;
wire  		fpu_rst_r				 	   ;
wire [11:0] enable					 	   ;
wire [3:0 ] fpu_flags 				 	   ;
wire [31:0] fpu_operand_a 			 	   ; 
wire [31:0] fpu_operand_b			 	   ;
wire [31:0] fpu_operand_c			 	   ;
wire [31:0] fpu_output			      	   ;
wire [31:0] single_prec_add_out      	   ;
wire [3:0 ] single_prec_add_flags    	   ;  
wire 	    single_prec_add_ready    	   ;
wire [31:0] binary_format_add_out    	   ;
wire [3:0 ] binary_format_add_flags  	   ;
wire 		 binary_format_add_ready  	   ;
wire [31:0] decimal_format_add_out   	   ;
wire [3:0 ] decimal_format_add_flags 	   ;
wire [31:0] decimal_format_add_out_comb    ;
wire [3:0 ] decimal_format_add_flags_comb  ;
wire 	    decimal_format_add_ready  	   ;
wire [31:0] single_prec_sub_out      	   ;
wire [3:0 ] single_prec_sub_flags    	   ;
wire 		 single_prec_sub_ready    	   ;
wire [31:0] binary_format_sub_out    	   ;
wire [3:0 ] binary_format_sub_flags  	   ;
wire 		binary_format_sub_ready  	   ;
wire [31:0] decimal_format_sub_out   	   ;
wire [3:0 ] decimal_format_sub_flags 	   ;
wire 	    decimal_format_sub_ready 	   ;
wire [31:0] single_prec_mul_out      	   ;
wire [3:0 ] single_prec_mul_flags    	   ;
wire 		single_prec_mul_ready    	   ;
wire [31:0] binary_format_mul_out    	   ;
wire [3:0 ] binary_format_mul_flags  	   ;
wire 	    binary_format_mul_ready  	   ;
wire [31:0] decimal_format_mul_out   	   ;
wire [3:0 ] decimal_format_mul_flags 	   ;
wire 	    decimal_format_mul_ready 	   ;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
wire [31:0] single_prec_fma_out      	   ;
wire [3:0 ] single_prec_fma_flags    	   ;
wire 	    single_prec_fma_ready    	   ;
wire [31:0] binary_format_fma_out    	   ;
wire [3:0 ] binary_format_fma_flags  	   ;
wire 	    binary_format_fma_ready   	   ;
wire [31:0] decimal_format_fma_out   	   ;
wire [3:0 ] decimal_format_fma_flags 	   ;
wire 	    decimal_format_fma_ready 	   ;
wire [31:0] operand1_decimal_adder 	 	   ;
wire [31:0] operand2_decimal_adder 	 	   ;
wire        fpu_doorbell_r_i_decimal_adder ;


hci hci (
  .clk(clk) 	,
  .reset_n 				 (reset_n		  ),
  .sw_address 			 (sw_address	  ),
  .sw_read_en 			 (sw_read_en	  ),
  .sw_write_en 			 (sw_write_en	  ),
  .sw_datain 			 (sw_datain	 	  ),   
  .fpu_rst_r 			 (fpu_rst_r	      ),
  .fpu_doorbell_r   	 (fpu_doorbell_r  ),
  .fpu_output 			 (fpu_output	  ),
  .fpu_invalid_op_flag_0 (fpu_flags[3]	  ),
  .fpu_overflow_flag_0   (fpu_flags[2]	  ),
  .fpu_underflow_flag_0  (fpu_flags[1]	  ),
  .fpu_inexact_flag_0    (fpu_flags[0]	  ),  
  .fpu_ready             (fpu_ready  	  ), 
  .sw_dataout 			 (sw_dataout	  ),
  .fpu_rst_w   			 (fpu_rst_w		  ),   
  .fpu_en 				 (fpu_en		  ),
  .fpu_int_en 		     (fpu_int_en	  ),  
  .fpu_doorbell_w 		 (fpu_doorbell_w  ),
  .fpu_format 			 (fpu_format	  ),
  .fpu_operation 	 	 (fpu_operation	  ), 
  .fpu_fused_m_a 	 	 (fpu_fused_m_a	  ),  
  .fpu_simd       		 (fpu_simd 		  ),
  .fpu_simd_no_op	     (fpu_simd_no_op  ),
  .fpu_operand_a 		 (fpu_operand_a	  ),
  .fpu_operand_b 	 	 (fpu_operand_b	  ),
  .fpu_operand_c 		 (fpu_operand_c	  ),
  .fpu_interrupt_w 	 	 (fpu_interrupt_w )   
	);
	
enable_decoder enable_decoder(
  .fpu_format     (fpu_format     ),
  .fpu_operation  (fpu_operation  ),
  .fpu_en         (fpu_en         ), 
  .fpu_rst_w      (fpu_rst_w      ), 	
  .fpu_doorbell_w (fpu_doorbell_w ),   
  .enable         (enable         )   
	);
	
two_input_register two_input_register_decimal_adder(
  .clk              (clk                    		),
  .reset_n   	    (reset_n                		),
  .fpu_rst_w   	    (fpu_rst_w              		),
  .fpu_doorbell_w   (fpu_doorbell_w         		),
  .enable		    (enable[9]              		),  
  .fpu_operand_a    (fpu_operand_a          		),
  .fpu_operand_b    (fpu_operand_b          		),
  .operand1		    (operand1_decimal_adder 		),
  .operand2 	    (operand2_decimal_adder		    ),
  .fpu_doorbell_r_i (fpu_doorbell_r_i_decimal_adder ) 	
	);
	
output_register output_register_decimal_adder(
  .clk 				(clk                    		),
  .reset_n   	    (reset_n                		),
  .result     	    (decimal_format_add_out_comb    ),
  .flags      	    (decimal_format_add_flags_comb  ),
  .fpu_doorbell_r_i (fpu_doorbell_r_i_decimal_adder ),
  .fpu_int_en 		(fpu_int_en					    ),  
  .fpu_interrupt_w  (fpu_interrupt_w				),   
  .fpu_ready		(decimal_format_add_ready       ),
  .fpu_output   	(decimal_format_add_out			), 
  .fpu_output_flags (decimal_format_add_flags       )
    );
output_mux output_mux(
  .fpu_format     			(fpu_format			      ),
  .fpu_operation  			(fpu_operation  		  ),
  .single_prec_add_out      (single_prec_add_out 	  ),
  .single_prec_add_flags    (single_prec_add_flags 	  ),  
  .single_prec_add_ready    (single_prec_add_ready 	  ),  
  .binary_format_add_out    (binary_format_add_out    ),
  .binary_format_add_flags  (binary_format_add_flags  ),
  .binary_format_add_ready  (binary_format_add_ready  ),
  .decimal_format_add_out   (decimal_format_add_out   ),
  .decimal_format_add_flags (decimal_format_add_flags ),
  .decimal_format_add_ready (decimal_format_add_ready ),
  .single_prec_sub_out      (single_prec_sub_out	  ),
  .single_prec_sub_flags    (single_prec_sub_flags    ),
  .single_prec_sub_ready    (single_prec_sub_ready    ),
  .binary_format_sub_out    (binary_format_sub_out    ),
  .binary_format_sub_flags  (binary_format_sub_flags  ),
  .binary_format_sub_ready  (binary_format_sub_ready  ),
  .decimal_format_sub_out   (decimal_format_sub_out   ),
  .decimal_format_sub_flags (decimal_format_sub_flags ),
  .decimal_format_sub_ready (decimal_format_sub_ready ),
  .single_prec_mul_out      (single_prec_mul_out	  ),
  .single_prec_mul_flags    (single_prec_mul_flags    ),
  .single_prec_mul_ready    (single_prec_mul_ready    ),
  .binary_format_mul_out    (binary_format_mul_out    ),
  .binary_format_mul_flags  (binary_format_mul_flags  ),
  .binary_format_mul_ready  (binary_format_mul_ready  ),
  .decimal_format_mul_out   (decimal_format_mul_out   ),
  .decimal_format_mul_flags (decimal_format_mul_flags ),
  .decimal_format_mul_ready (decimal_format_mul_ready ),
  .single_prec_fma_out      (single_prec_fma_out      ),
  .single_prec_fma_flags    (single_prec_fma_flags    ),
  .single_prec_fma_ready    (single_prec_fma_ready    ),
  .binary_format_fma_out    (binary_format_fma_out    ),
  .binary_format_fma_flags  (binary_format_fma_flags  ),
  .binary_format_fma_ready  (binary_format_fma_ready  ),
  .decimal_format_fma_out   (decimal_format_fma_out   ),
  .decimal_format_fma_flags (decimal_format_fma_flags ),
  .decimal_format_fma_ready (decimal_format_fma_ready ),
  .fpu_output  			    (fpu_output               ),
  .fpu_flags                (fpu_flags                ),
  .fpu_ready				(fpu_ready 				  )
	);
	
decimal_adder decimal_adder (
    .operand1 (operand1_decimal_adder        ),
    .operand2 (operand2_decimal_adder        ),
    .E        (enable[9]                     ),
    .Result   (decimal_format_add_out_comb   ),
    .Flags	  (decimal_format_add_flags_comb )
	);

//// ORing of all fpu_doorbell_r_i 	
assign fpu_doorbell_r = ~fpu_doorbell_r_i_decimal_adder ;

//// ANDing of all ready outputs of output register and fpu_rst_w	
assign fpu_rst_r	  = ~(decimal_format_add_ready & fpu_rst_w) ;
endmodule
`resetall
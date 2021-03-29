`default_nettype none
module output_mux(
  input  wire [1:0 ] fpu_format   	       	  ,
  input  wire [1:0 ] fpu_operation 	          ,
  input  wire [31:0] single_prec_add_out      ,
  input  wire [3:0 ] single_prec_add_flags    , 
  input  wire 		 single_prec_add_ready    ,  
  input  wire [31:0] binary_format_add_out    ,
  input  wire [3:0 ] binary_format_add_flags  ,
  input  wire        binary_format_add_ready  ,
  input  wire [31:0] decimal_format_add_out   ,
  input  wire [3:0 ] decimal_format_add_flags ,
  input  wire        decimal_format_add_ready ,
  input  wire [31:0] single_prec_sub_out      ,
  input  wire [3:0 ] single_prec_sub_flags    ,
  input  wire 	 	 single_prec_sub_ready    ,
  input  wire [31:0] binary_format_sub_out    ,
  input  wire [3:0 ] binary_format_sub_flags  ,
  input  wire        binary_format_sub_ready ,
  input  wire [31:0] decimal_format_sub_out   ,
  input  wire [3:0 ] decimal_format_sub_flags ,
  input  wire 		 decimal_format_sub_ready ,
  input  wire [31:0] single_prec_mul_out      ,
  input  wire [3:0 ] single_prec_mul_flags    ,
  input  wire 		 single_prec_mul_ready    ,  
  input  wire [31:0] binary_format_mul_out    ,
  input  wire [3:0 ] binary_format_mul_flags  ,
  input  wire 		 binary_format_mul_ready  ,
  input  wire [31:0] decimal_format_mul_out   ,
  input  wire [3:0 ] decimal_format_mul_flags ,
  input  wire        decimal_format_mul_ready ,
  input  wire [31:0] single_prec_fma_out      ,
  input  wire [3:0 ] single_prec_fma_flags    ,
  input  wire        single_prec_fma_ready    ,
  input  wire [31:0] binary_format_fma_out    ,
  input  wire [3:0 ] binary_format_fma_flags  ,
  input  wire 		 binary_format_fma_ready  ,
  input  wire [31:0] decimal_format_fma_out   ,
  input  wire [3:0 ] decimal_format_fma_flags ,
  input  wire 		 decimal_format_fma_ready ,
  output reg  [31:0] fpu_output  			  ,
  output reg  [3:0 ] fpu_flags 				  ,
  output reg         fpu_ready   
    );
	
localparam SINGLE_PREC_ADD     = 4'b0000 ,
		   BINARY_FORMAT_ADD   = 4'b0001 ,
		   DECIMAL_FORMAT_ADD  = 4'b0010 ,
		   SINGLE_PREC_SUB     = 4'b0100 ,
		   BINARY_FORMAT_SUB   = 4'b0101 ,
		   DECIMAL_FORMAT_SUB  = 4'b0110 ,
		   SINGLE_PREC_MUL     = 4'b1000 ,
		   BINARY_FORMAT_MUL   = 4'b1001 ,
		   DECIMAL_FORMAT_MUL  = 4'b1010 ,
		   SINGLE_PREC_FMA     = 4'b1100 ,
		   BINARY_FORMAT_FMA   = 4'b1101 ,
		   DECIMAL_FORMAT_FMA  = 4'b1110 ;
		   
		   
  always @ (*)
  begin
    fpu_output = 32'h000_0000 ;
	fpu_flags  = 4'b0000      ;
	fpu_ready  = 1'b0    	  ;
	
	case ({fpu_operation, fpu_format})
	  SINGLE_PREC_ADD     :  begin
							   fpu_output = single_prec_add_out   ;
							   fpu_flags  = single_prec_add_flags ; 
							   fpu_ready  = single_prec_add_ready ;
						     end
	  BINARY_FORMAT_ADD   :  begin
							   fpu_output = binary_format_add_out   ;
							   fpu_flags  = binary_format_add_flags ;
							   fpu_ready  = binary_format_add_ready ;
						     end
	  DECIMAL_FORMAT_ADD  :  begin
							   fpu_output = decimal_format_add_out   ;
							   fpu_flags  = decimal_format_add_flags ;
							   fpu_ready  = decimal_format_add_ready ;
						     end
	  SINGLE_PREC_SUB     :  begin
							   fpu_output = single_prec_sub_out   ;     
							   fpu_flags  = single_prec_sub_flags ;
							   fpu_ready  = single_prec_sub_ready ;
						     end							 
	  BINARY_FORMAT_SUB   :  begin
							   fpu_output = binary_format_sub_out   ;
							   fpu_flags  = binary_format_sub_flags ;
							   fpu_ready  = binary_format_sub_ready ;
						     end
	  DECIMAL_FORMAT_SUB  :  begin
							   fpu_output = decimal_format_sub_out   ;
							   fpu_flags  = decimal_format_sub_flags ;
							   fpu_ready  = decimal_format_sub_ready ;
						     end
	  SINGLE_PREC_MUL     :  begin
							   fpu_output = single_prec_mul_out   ;
							   fpu_flags  = single_prec_mul_flags ;
							   fpu_ready  = single_prec_mul_flags ;
						     end
	  BINARY_FORMAT_MUL   :  begin
							   fpu_output = binary_format_mul_out   ;
							   fpu_flags  = binary_format_mul_flags ;
							   fpu_ready  = binary_format_mul_ready ;
						     end
	  DECIMAL_FORMAT_MUL  :  begin
							   fpu_output = decimal_format_mul_out   ; 
							   fpu_flags  = decimal_format_mul_flags ;
							   fpu_flags  = decimal_format_mul_ready ;
						     end
	  SINGLE_PREC_FMA     :  begin
							   fpu_output = single_prec_fma_out   ;
							   fpu_flags  = single_prec_fma_flags ;
							   fpu_ready  = single_prec_fma_ready ;
						     end
	  BINARY_FORMAT_FMA   :  begin
							   fpu_output = binary_format_fma_out   ;
							   fpu_flags  = binary_format_fma_flags ;
							   fpu_ready  = binary_format_fma_ready ;
						     end
	  DECIMAL_FORMAT_FMA  :  begin
							   fpu_output = decimal_format_fma_out   ;  
							   fpu_flags  = decimal_format_fma_flags ;
							   fpu_ready  = decimal_format_fma_ready ;
						     end							 
	 endcase
  end
endmodule
`resetall

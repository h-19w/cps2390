; Name: Wong Kei Wai Hadassah
; Student id: 1308584
; Description: Convert a 2's complement integer from memory location x3200 to a 16-bit floating-
; point representation and store the result in x3201. Output the floating-point number in binary 
; format.


		.ORIG x3000

	;start code	
		LD R0, NUM_LOC      ; Load 2's complement integer from x3200

				    ; get the sign bit
		AND R1, R0, R0      ; Copy R0 to R1 (will be modified to get absolute value)
		BRzp POSITIVE       ; If positive, skip negation
		NOT R1, R1          ; Compute 1's complement
		ADD R1, R1, #1      ; Compute 2's complement (absolute value for negative 					    ; numbers)

POSITIVE	AND R2, R0, #0      ; Clear R2 for sign bit
		BRzp SKIP_SIGN      ; If positive, sign bit remains 0
		ADD R2, R2, #1      ; Set sign bit to 1

		SKIP_SIGN:

	; exponent
		AND R3, R1, R1      ; Copy R1 to R3 for bit-shifting
		AND R4, R4, #0      ; Clear R4
		ADD R4, R4, #15     ; Add 15
		ADD R4, R4, #15     ; Add another 15
		ADD R4, R4, #1      ; Add 1 to make 31 (bias)
		LD R5, ZERO         ; R5 will count shifts

FIND_EXP	ADD R6, R3, R3      ; Shift R3 left by 1 bit
		BRz DONE_EXP        ; Stop when MSB is reached
		ADD R5, R5, #1      ; Increment shift count
		BR FIND_EXP

DONE_EXP	ADD R4, R4, R5      ; Add shift count to bias for exponent
		LD R7, MASK_63      ; Load 63 (x003F) into R7
		AND R4, R4, R7      ; Mask to 6 bits (exponent)

		ADD R6, R3, R3      ; Align MSB to bit 9 position
		LD R7, FRACTION_MASK; Mask for 9 bits
		AND R6, R6, R7      ; Extract fraction bits
		
		ADD R2, R2, R4      ; Add exponent to sign (R2)
		ADD R2, R2, R6      ; Add fraction to result (R2)

		ST R2, RESULT_LOC   ; Store the result at x3201

		LEA R0, OUTPUT_MSG  ; Load message address
		PUTS                ; Output the message
	
		JSR PUSH_REGISTERS  ; Save registers before subroutine
		LD R0, RESULT_LOC   ; Load result
		JSR BIN_OUT         ; Convert to binary and output
		JSR POP_REGISTERS   ; Restore registers after subroutine

		HALT

PUSH_REGISTERS	ADD R6, R6, #-1     ; Decrement stack pointer
		STR R0, R6, #0      ; Save R0 on the stack
		ADD R6, R6, #-1
		STR R1, R6, #0      ; Save R1
		ADD R6, R6, #-1
		STR R2, R6, #0      ; Save R2
		ADD R6, R6, #-1
		STR R7, R6, #0      ; Save R7
		RET

POP_REGISTERS	LDR R7, R6, #0      ; Restore R7
		ADD R6, R6, #1      ; Increment stack pointer
		LDR R2, R6, #0      ; Restore R2
		ADD R6, R6, #1
		LDR R1, R6, #0      ; Restore R1
		ADD R6, R6, #1
		LDR R0, R6, #0      ; Restore R0
		ADD R6, R6, #1
		RET

BIN_OUT	        AND R1, R0, #0      ; Clear R1 (bit index)
		LD R2, NEG_ONE      ; Load -1 for loop

PRINT_BITS	ADD R3, R1, #-16    ; Check if 16 bits are printed
		BRzp DONE_PRINT
		ADD R4, R0, R0      ; Shift left to get MSB
		BRn PRINT_ZERO
		ADD R4, R4, #-1     ; Check if MSB is 1
		BRz PRINT_ONE
		PRINT_ZERO:
		LD R5, CHAR_ZERO
		OUT
		BR NEXT_BIT
PRINT_ONE	LD R5, CHAR_ONE
		OUT

NEXT_BIT	ADD R1, R1, #1      ; Increment bit index
		ADD R0, R0, R0      ; Shift left
		BRnzp PRINT_BITS

DONE_PRINT	RET

	;needed data	
		NUM_LOC .FILL x4000        ; Memory location of input integer
		RESULT_LOC .FILL x4001     ; Memory location for floating-point result
		MASK_63 .FILL x003F        ; Mask for 6 bits (63 in decimal)
		FRACTION_MASK .FILL x01FF  ; Mask for the 9 fraction bits
		ZERO .FILL #0              ; Zero constant
		NEG_ONE .FILL #-1          ; Negative one constant
		CHAR_ZERO .FILL x0030      ; ASCII '0'
		CHAR_ONE .FILL x0031       ; ASCII '1'
		OUTPUT_MSG .STRINGZ "floating point representation is: "

		.END




; Author: Kei Wai Hadassah Wong 
; Description: This program performs a left shift on a bit pattern. It ensures that the
;              range of the left shift is within and inclusive of 0-16
 

.ORIG x3000       ; Program starts at memory location x3000

; RANGE CHECK: Ensure shift amount is in range [0, 16]
	LD R1, SHIFT       ; Load shift amount from memory (x3201) into R1
	AND R2, R2, #0     ; Clear R2 (temporary register)

; Check if R1 is negative
	BRzp CHECK_MAX     ; If R1 >= 0, skip to max check
	AND R1, R1, #0     ; Set R1 to 0 if negative

CHECK_MAX
	ADD R2, R1, #-16   ; Subtract 16 from R1
	BRn DONE           ; If R1 <= 16, it's valid
	LD R1, MAX_VALUE   ; Otherwise, set R1 to 16

DONE
	ST R1, SHIFT       ; Store the adjusted shift amount back to memory (x3201)

; LEFT SHIFT OPERATION
	LD R0, NUM         ; Load bit pattern from memory (x3200) into R0
	AND R2, R2, #0     ; Clear R2 (result register)

SHIFT_LOOP
	ADD R2, R2, R0     ; Add R0 to R2 (shift left by 1 each iteration)
	ADD R1, R1, #-1    ; Decrement shift amount (R1)
	BRp SHIFT_LOOP     ; If R1 > 0, continue shifting

	ST R2, RESULT      ; Store the result in memory (x3202)
	HALT

; DATA
	NUM .FILL x3200     ; Address of the bit pattern
	SHIFT .FILL x3201   ; Address of the shift amount
	RESULT .FILL x3202  ; Address to store the result
	MAX_VALUE .FILL #16 ; Maximum allowed shift amount (16)
.END



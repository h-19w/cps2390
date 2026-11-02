; Author: Kei Wai Hadassah Wong 
; Description: This program performs a left rotation on a bit pattern. It ensures that the
;              range of the left shift is within and inclusive of 0-16
 


.ORIG x3000       ; Program starts at memory location x3000

; RANGE CHECK: Ensure rotate amount is in range [0, 16]
	LD R1, ROTATE      ; Load rotate amount from memory (x3201) into R1
	AND R2, R2, #0     ; Clear R2 (temporary register)

; Check if R1 is negative
	BRzp CHECK_MAX     ; If R1 >= 0, skip to max check
	AND R1, R1, #0     ; Set R1 to 0 if negative

CHECK_MAX
	ADD R2, R1, #-16   ; Subtract 16 from R1
	BRn DONE           ; If R1 <= 16, it's valid
	LD R1, MAX_VALUE   ; Otherwise, set R1 to 16

DONE
	ST R1, ROTATE      ; Store the adjusted rotate amount back to memory (x3201)

; LEFT ROTATION OPERATION
	LD R0, NUM         ; Load bit pattern from memory (x3200) into R0
	AND R2, R2, #0     ; Clear R2 (result register)
	AND R3, R3, #0     ; Clear R3 (temporary register for rotated bits)

ROTATE_LOOP
	ADD R1, R1, #-1    ; Decrement rotate amount (R1)
	BRn FINISH_ROTATE  ; If R1 < 0, finish rotation

	ADD R3, R0, R0     ; Double R0 (equivalent to left shift by 1)
	AND R3, R3, #1     ; Extract the leftmost bit shifted out
	ADD R3, R3, R3     ; Move the bit to the least significant position
	ADD R0, R0, R0     ; Perform the left shift on R0
	ADD R0, R0, R3     ; Add the shifted-out bit back to the least significant position
	BRnzp ROTATE_LOOP  ; Repeat the loop

FINISH_ROTATE
	ST R0, RESULT      ; Store the result in memory (x3202)
	HALT

; DATA
	NUM .FILL x3200     ; Address of the bit pattern
	ROTATE .FILL x3201  ; Address of the rotate amount
	RESULT .FILL x3202  ; Address to store the result
	MAX_VALUE .FILL #16 ; Maximum allowed rotate amount (16)
.END

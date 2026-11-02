; Name: Wong Kei Wai Hadassah
; Student id: 1308584
; Description: encrypting and decrypting an input, storing the various data in the required locations. 

	.ORIG x3000

    		LEA R0, START_PROMPT   ; Load prompt for (E)ncrypt/(D)ecrypt
    		PUTS                   ; Display the prompt
    		TRAP x20               ; Read single character input
		LEA R1, CHOICE
    		STR R0, R1, #0     ; Store input in x3200

    		LEA R0, PROMPT2        ; Load prompt for Encryption Key
    		PUTS                   ; Display the prompt
    		TRAP x20               ; Read single-digit key input
		LEA R1, ENCRYPTION_KEY 
    		STR R0, R1, #0 ; Store input in x3201

    		LEA R0, PROMPT3        ; Load prompt for Input Message
    		PUTS                   ; Display the prompt
    		LEA R1, MESSAGE_BUFFER ; Load address of x3202 (message storage)

INPUT_LOOP	TRAP x20               ; Read a character from the keyboard
    		STR R0, R1, #0         ; Store the character in memory
    		ADD R1, R1, #1         ; Increment buffer pointer
    		AND R2, R0, #0         ; Clear R2
    		LD R2, ENTER           ; Load ASCII value for <ENTER>
    		NOT R2, R2             ; Take NOT for comparison
    		ADD R2, R2, #1         ; Two's complement to get -ASCII_ENTER
    		ADD R2, R2, R0         ; Check if input matches <ENTER>
    		BRz DONE_INPUT         ; If zero flag set, <ENTER> detected, exit loop
    		AND R2, R1, #0         ; Clear R2
    		LD R2, MAX_BUFFER      ; Load max buffer size (x3215)
    		NOT R2, R2             ; -MAX_BUFFER
    		ADD R2, R2, R1         ; Check buffer overflow
    		BRz DONE_INPUT         ; Exit if we've reached buffer limit
    		BRnzp INPUT_LOOP       ; Continue loop if no exit condition met

DONE_INPUT	AND R0, R0, #0         ; Null-terminate the string
    		STR R0, R1, #0         ; Store null terminator at end of message

    		LEA R1 CHOICE
		LDR R0, R1, #0   ; Load Encrypt/Decrypt choice (E or D)
    		LD R1, ASCII_E               ; Load ASCII value for 'E'
    		NOT R1, R1             ; Take NOT for comparison
    		ADD R1, R1, #1         ; Two's complement for comparison
    		ADD R1, R1, R0         ; Check if input is 'E'
    		BRz ENCRYPT		    

    		LD R1, ASCII_D               ; Load ASCII value for 'D'
    		NOT R1, R1             ; Take NOT for comparison
    		ADD R1, R1, #1         ; Two's complement for comparison
    		ADD R1, R1, R0         ; Check if input is 'D'
    		BRz DECRYPT	          

   
	;encryption
ENCRYPT		LEA R1, ENCRYPTION_KEY
		LDR R0, R1, #0 	   	; Load encryption key
    		LD R2, ZERO         	; Load ASCII value for '0'
   		NOT R2, R2             	; Convert to decimal by subtracting '0'
    		ADD R0, R0, R2         	; Get numerical key
    		LEA R1, MESSAGE_BUFFER 	; Start of input message
    		LEA R3, OUTPUT_BUFFER  	; Start of output buffer

ENC_LOOP	LDR R2, R1, #0         	; Load character from input
    		BRz ENC_DONE           	; If null terminator, finish
    		NOT R2, R2             	; Toggle least significant bit
    		ADD R2, R2, #1         	; Complete toggle
   		ADD R2, R2, R0         	; Add encryption key
    		STR R2, R3, #0         	; Store encrypted character in output buffer
    		ADD R1, R1, #1         	; Move to next input character
   		ADD R3, R3, #1         	; Move to next output character
    		BRnzp ENC_LOOP         	; Repeat for all characters

ENC_DONE	AND R2, R2, #0         ; Null-terminate the output buffer
    		STR R2, R3, #0
    		BRnzp OUTPUT_MESSAGE   ; Display the result


	;decryption
DECRYPT	 	LEA R0, ENCRYPTION_KEY
		LDR R0, R1, #0	 	; load encryption key [line 78]
    		LD R2, ZERO         	; load ASCII value for '0'
   		NOT R2, R2             	; convert to decimal by subtracting '0'
   		ADD R0, R0, R2         	; get numerical key
    		LEA R1, MESSAGE_BUFFER 	; start of input message
    		LEA R3, OUTPUT_BUFFER  	; start of output buffer



DEC_LOOP	LDR R2, R1, #0         ; load character from input
    		BRz DEC_DONE           ; if null terminator, finish
    		ADD R2, R2, R0         ; subtract encryption key
    		NOT R2, R2             ; toggle least significant bit
    		ADD R2, R2, #1         ; complete toggle
    		STR R2, R3, #0         ; store decrypted character in output buffer
    		ADD R1, R1, #1         ; move to next input character
    		ADD R3, R3, #1         ; move to next output character
    		BRnzp DEC_LOOP         ; repeat for all characters

DEC_DONE	AND R2, R2, #0         ; null-terminate the output buffer
   		STR R2, R3, #0
 		BRnzp OUTPUT_MESSAGE   ; display the result

OUTPUT_MESSAGE	LEA R0, OUTPUT_PROMPT  ; load prompt
    		PUTS                   ; display the prompt
    		LEA R0, OUTPUT_BUFFER  ; load output message
   		PUTS                   ; display the message
  		HALT


;data
		START_PROMPT    .STRINGZ "IF YOU WANT TO ENCRYPT, TYPE E, IF YOU WANT TO DECRYPT, TYPE D: "
		PROMPT2         .STRINGZ " ENTER THE ENCRYPTION KEY (A SINGLE DIGIT FROM 1 TO 9): "
		PROMPT3         .STRINGZ "INPUT A MESSAGE OF NO MORE THAN 20 CHARACTERS. WHEN DONE, PRESS <ENTER>: "
		OUTPUT_PROMPT   .STRINGZ "Processed Message: "
		ASCII_E       	       .FILL x0045                			; ASCII value for 'E'
		ASCII_D       	       .FILL x0044                			; ASCII value for 'D'
		ENTER    	       .FILL x000A                			; ASCII value for <ENTER>
		ZERO                   .FILL x0000                			; ASCII value for '0'
		CHOICE 	                .BLKW 1                    			; storage for choice (x3200)
		ENCRYPTION_KEY  .BLKW 1                    			; storage for key (x3201)
		MESSAGE_BUFFER  .BLKW 20                   			; storage for input message (x3202–x3215)		OUTPUT_BUFFER   .BLKW 20                   			; storage for output message (x3216–x3229)
		MAX_BUFFER      .FILL x3215               			; address of max buffer location
		

	  .END



























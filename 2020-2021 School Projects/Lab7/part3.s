.global ONES

ONES: 
	push {R4,LR}
	MOV R0, #0 // R0 will hold the result
	MOV R4, #0
LOOP:
	CMP R1, #0 // loop until the data contains no more 1’s
	BEQ ENDSB
	LSR R4, R1, #1 // perform SHIFT, followed by AND
	AND R1, R1, R4
	ADD R0, #1 // count the string lengths so far
	B LOOP
ENDSB:
	pop {R4, PC}

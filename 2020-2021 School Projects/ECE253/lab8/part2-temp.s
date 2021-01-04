.global _start
.global SWAP
LIST: 
	.word 10, 1400, 45, 23, 5, 3, 8, 17, 4, 20, 33
_start:
	ldr r0, =0xfffec600 //processor
	ldr r1, =0xff200020 //HEX DISPLAY
	ldr r2, =1000000 //count down from this number
	str r2, [r0] //puts value of r2 into the processor
	mov r2, #0b11 //puts the number 3 into r2
	str r2, [r0, #8] //stores R2 inot eigth bit of R0
	mov r4, #0 //initialize r4-> the comparer
	mov r6, #0b0111111 //Storing 0 on the hex
	
SWAP:
	str r6, [r1] //change hex display to value at r6
	ldr r5, [r0, #12] // puts into r5 r0->12 is F (whether or not count is done) 
	cmp r5, #1 //see if countdown is done
	bne SWAP //poll until F=1
	str r5, [r0, #12] 
	add r4, r4, #1 // count+1
	cmp r4, #3 // See if r4 ==3
	bne Buble
	mov r4, #0

Buble:
	cmp r4, #0
	bne UNO
	mov r6, #0b0111111
	b SWAP
UNO:
	cmp r4, #1
	bne DOS
	mov r6, #0b0000110
	b SWAP
	
DOS: 
	mov r6, #0b1011011
	B SWAP
	
	

	
	
	
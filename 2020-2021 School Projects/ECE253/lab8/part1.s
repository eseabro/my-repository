.global _start
.global SWAP


_start:
	ldr r0, =LIST //address of the list
	ldr r4, [r0] // the length of the list
	ldr SP, =0x10000 //stack
	add r0,r0,#4 //item number one
	mov r5, r4 //for each loop
	mov r6, r4 //number of swaps per loop
	push {r0} 

	
Main:
	sub r5, r5, #1
	cmp r5, #0 
	beq Outer
	bl SWAP
	add r0, r1, #4
	b Main
	
SWAP: 
	mov r1, r0
	ldr r2, [r1] //r2 holds word 
	ldr r3, [r1, #4] //r3 holds word+1
	cmp r3, r2 
	blt switcharoo // if r3<r2
	mov r0, #0 // correct swap
	b return
	
switcharoo:
	str r2, [r1, #4] 
	str r3, [r1] 
	mov r0, #1 
	b return
return:
	mov PC, LR

Outer:
	pop {r0}
	sub r6, r6, #1 
	cmp r6, #0
	beq done
	mov r5, r4
	push {r0}
	b Main

done:
	b done

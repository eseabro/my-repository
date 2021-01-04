.global _start
.global SWAP

_start:
	ldr sp, =0x10000
	ldr r0, =LIST //address of list
	push {r0}
	b SWAP
SWAP:
	pop {r0}
	ldr r4, [r0] //r4 = nummber of items to be sorted
	sub r5, r4, #0 // number of swaps that need to happen every time
	
buble:
	mov r1, r0 //r1 has the list address
	sub r4,r4,#1
	mov r5, r4
	cmp r4, #0
	beq done
	b inner
	
inner:
	sub r5, r5, #1
	cmp r5, #0
	beq buble // if there are no swaps left to be made
	add r1, r1, #4 //every time this loops through it'll incrememnt by one list item
	str r2, [r1] //first word
	str r3, [r1, #4] // second word
	cmp r3, r2 //see if r3>r2
	blt switcharoo 
	b inner
	
switcharoo:
	mov r6, r2
	mov r2, r3
	mov r3, r6
	b inner
	
done: 
	mov r0, #1
	mov PC, LR
	
LIST: 
.word 10, 1400, 45, 23, 5, 3, 8, 17, 4, 20, 33
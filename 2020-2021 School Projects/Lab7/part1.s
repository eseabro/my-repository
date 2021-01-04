.text
.global _start
_start:
	ldr R0, =TEST_NUM
	mov R7, #0
	mov R1, #0
	mov R8, #0
LOOP:
	ldr R1, [R0]
	cmp R1, #0
	blt END
	add R7, R7, R1
	add R8, R8, #1
	add R0, R0, #4
	b LOOP
END: 
B END

.end
	
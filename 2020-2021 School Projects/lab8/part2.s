.global _start
_start: 
ldr r0, =0xff200000
ldr r1, =0xfffec600
ldr r3, =50000000
ldr r8, =0xff200050

str r3, [r1] 
mov r3, #0x3 
str r3, [r1, #8]
mov r3, #0x200 //LHS
mov r5, #0x001 // RHS


LOOP:
ldr r7, [r8]
cmp r7, #0x8
beq goone
add r2, r3, r5
str r2, [r0] //put contents of r2 into r0


wait:
ldr r4, [r1,#12]
cmp r4, #0
beq wait
str r4, [r1,#12]

nowait:
lsl r5, r5, #1
lsr r3, r3, #1
cmp r3, #0x10
beq nowait
cmp r3, #0x10
beq nowait
cmp r3, #0x1
beq reset 
b LOOP

reset:
mov r3, #0x200 
mov r5, #0x001
b LOOP

goone:
ldr r7, [r8]
cmp r7, #0x0
beq pausetwo
add r2, r3, r5
str r2, [r0] 


wait2:
ldr r4, [r1,#12]
cmp r4, #0
beq wait2
str r4, [r1,#12]

nowait2:
lsl r5, r5, #1
lsr r3, r3, #1
cmp r3, #0x10
beq nowait2
cmp r3, #0x10
beq nowait2
cmp r3, #0x1
beq reset2 
b goone

reset2:
mov r3, #0x200 
mov r5, #0x001
b goone

pausetwo:
ldr r7, [r8]
cmp r7, #0x8
beq pausethree
b pausetwo

pausethree:
ldr r7, [r8]
cmp r7, #0x0
beq wait
b pausethree


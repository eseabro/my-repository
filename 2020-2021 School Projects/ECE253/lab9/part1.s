/* This part provides address values that exist in the system */

/* Memory */
        .equ  DDR_BASE,	            0x00000000
        .equ  DDR_END,              0x3FFFFFFF
        .equ  A9_ONCHIP_BASE,	      0xFFFF0000
        .equ  A9_ONCHIP_END,        0xFFFFFFFF
        .equ  SDRAM_BASE,    	      0xC0000000
        .equ  SDRAM_END,            0xC3FFFFFF
        .equ  FPGA_ONCHIP_BASE,	   0xC8000000
        .equ  FPGA_ONCHIP_END,      0xC803FFFF
        .equ  FPGA_CHAR_BASE,   	   0xC9000000
        .equ  FPGA_CHAR_END,        0xC9001FFF

/* Cyclone V FPGA devices */
        .equ  LEDR_BASE,             0xFF200000
        .equ  HEX3_HEX0_BASE,        0xFF200020
        .equ  HEX5_HEX4_BASE,        0xFF200030
        .equ  SW_BASE,               0xFF200040
        .equ  KEY_BASE,              0xFF200050
        .equ  JP1_BASE,              0xFF200060
        .equ  JP2_BASE,              0xFF200070
        .equ  PS2_BASE,              0xFF200100
        .equ  PS2_DUAL_BASE,         0xFF200108
        .equ  JTAG_UART_BASE,        0xFF201000
        .equ  JTAG_UART_2_BASE,      0xFF201008
        .equ  IrDA_BASE,             0xFF201020
        .equ  TIMER_BASE,            0xFF202000
        .equ  AV_CONFIG_BASE,        0xFF203000
        .equ  PIXEL_BUF_CTRL_BASE,   0xFF203020
        .equ  CHAR_BUF_CTRL_BASE,    0xFF203030
        .equ  AUDIO_BASE,            0xFF203040
        .equ  VIDEO_IN_BASE,         0xFF203060
        .equ  ADC_BASE,              0xFF204000

/* Cyclone V HPS devices */
        .equ   HPS_GPIO1_BASE,       0xFF709000
        .equ   HPS_TIMER0_BASE,      0xFFC08000
        .equ   HPS_TIMER1_BASE,      0xFFC09000
        .equ   HPS_TIMER2_BASE,      0xFFD00000
        .equ   HPS_TIMER3_BASE,      0xFFD01000
        .equ   FPGA_BRIDGE,          0xFFD0501C

/* ARM A9 MPCORE devices */
        .equ   PERIPH_BASE,          0xFFFEC000   /* base address of peripheral devices */
        .equ   MPCORE_PRIV_TIMER,    0xFFFEC600   /* PERIPH_BASE + 0x0600 */

        /* Interrupt controller (GIC) CPU interface(s) */
        .equ   MPCORE_GIC_CPUIF,     0xFFFEC100   /* PERIPH_BASE + 0x100 */
        .equ   ICCICR,               0x00         /* CPU interface control register */
        .equ   ICCPMR,               0x04         /* interrupt priority mask register */
        .equ   ICCIAR,               0x0C         /* interrupt acknowledge register */
        .equ   ICCEOIR,              0x10         /* end of interrupt register */
        /* Interrupt controller (GIC) distributor interface(s) */
        .equ   MPCORE_GIC_DIST,      0xFFFED000   /* PERIPH_BASE + 0x1000 */
        .equ   ICDDCR,               0x00         /* distributor control register */
        .equ   ICDISER,              0x100        /* interrupt set-enable registers */
        .equ   ICDICER,              0x180        /* interrupt clear-enable registers */
        .equ   ICDIPTR,              0x800        /* interrupt processor targets registers */
            .equ   ICDICFR,              0xC00        /* interrupt configuration registers */

/* This part provides interrupt IDs */

/* FPGA interrupts (there are 64 in total; only a few are defined below) */
			.equ	INTERVAL_TIMER_IRQ, 			72
			.equ	KEYS_IRQ, 						73
			.equ	FPGA_IRQ2, 						74
			.equ	FPGA_IRQ3, 						75
			.equ	FPGA_IRQ4, 						76
			.equ	FPGA_IRQ5, 						77
			.equ	AUDIO_IRQ, 						78
			.equ	PS2_IRQ, 						79
			.equ	JTAG_IRQ, 						80
			.equ	IrDA_IRQ, 						81
			.equ	FPGA_IRQ10,						82
			.equ	JP1_IRQ,							83
			.equ	JP2_IRQ,							84
			.equ	FPGA_IRQ13,						85
			.equ	FPGA_IRQ14,						86
			.equ	FPGA_IRQ15,						87
			.equ	FPGA_IRQ16,						88
			.equ	PS2_DUAL_IRQ,					89
			.equ	FPGA_IRQ18,						90
			.equ	FPGA_IRQ19,						91

/* ARM A9 MPCORE devices (there are many; only a few are defined below) */
			.equ	MPCORE_GLOBAL_TIMER_IRQ,	27
			.equ	MPCORE_PRIV_TIMER_IRQ,		29
			.equ	MPCORE_WATCHDOG_IRQ,			30

/* HPS devices (there are many; only a few are defined below) */
			.equ	HPS_UART0_IRQ,   				194
			.equ	HPS_UART1_IRQ,   				195
			.equ	HPS_GPIO0_IRQ,          	196
			.equ	HPS_GPIO1_IRQ,          	197
			.equ	HPS_GPIO2_IRQ,          	198
			.equ	HPS_TIMER0_IRQ,         	199
			.equ	HPS_TIMER1_IRQ,         	200
			.equ	HPS_TIMER2_IRQ,         	201
			.equ	HPS_TIMER3_IRQ,         	202
			.equ	HPS_WATCHDOG0_IRQ,     		203
			.equ	HPS_WATCHDOG1_IRQ,     		204

                
                /* some additional defines for your convenience */

			.equ		EDGE_TRIGGERED,         0x1
			.equ		LEVEL_SENSITIVE,        0x0
			.equ		CPU0,         				0x01	// bit-mask; bit 0 represents cpu0
			.equ		ENABLE, 						0x1

			.equ		KEY0, 						0b0001
			.equ		KEY1, 						0b0010
			.equ		KEY2,							0b0100
			.equ		KEY3,							0b1000

			.equ		RIGHT,						1
			.equ		LEFT,							2

			.equ		USER_MODE,					0b10000
			.equ		FIQ_MODE,					0b10001
			.equ		IRQ_MODE,					0b10010
			.equ		SVC_MODE,					0b10011
			.equ		ABORT_MODE,					0b10111
			.equ		UNDEF_MODE,					0b11011
			.equ		SYS_MODE,					0b11111

			.equ		INT_ENABLE,					0b01000000
			.equ		INT_DISABLE,				0b11000000


/* This part:
 * 1. defines exception vectors for the A9 processor
 * 2. provides code that initializes the generic interrupt controller
*/
// NOTE TO STUDENTS: THIS FILE IS COMPLETE EXCEPT FOR THE TWO LINES THAT SAY FILL IN CODE HERE

    
/*********************************************************************************
 * Initialize the exception vector table
 ********************************************************************************/
				.section .vectors, "ax"

				B 			_start					// reset vector
				B 			SERVICE_UND				// undefined instruction vector
				B 			SERVICE_SVC				// software interrrupt vector
				B 			SERVICE_ABT_INST		// aborted prefetch vector
				B 			SERVICE_ABT_DATA		// aborted data vector
				.word 	0							// unused vector
				B 			IRQ_HANDLER // IRQ interrupt vector
				B 			SERVICE_FIQ				// FIQ interrupt vector

				.text
/*--- IRQ ---------------------------------------------------------------------*/
				.global	IRQ_HANDLER
IRQ_HANDLER:
				/* save R0-R3, because subroutines called from here might modify
				   these registers without saving/restoring them. Save R4, R5
					because we modify them in this subroutine */
    			PUSH		{R0-R5, LR}
    
    			/* Read the ICCIAR from the CPU interface */
    			LDR		R4, =MPCORE_GIC_CPUIF
    			LDR		R5, [R4, #ICCIAR] // read the interrupt ID

PRIV_TIMER_CHECK:
    			cmp r5, #29 //compare r5 with mpcore priv timer irq
				beq TIMER_ISR //If it's a timer interrupt, go to timer ISR
    
KEYS_CHECK:		cmp r5, #73 //Check for key interrupt
				BNE UNKNOWN_IRQ // if no, go to unknown
    			BL KEY_ISR //if yes, do key_isr
				B EXIT_IRQ //branch to exit
				
UNKNOWN_IRQ: B UNKNOWN_IRQ
TIMER_ISR:	BL PRIV_TIMER_ISR //timer interrupt go to PRIV_TIMER_ISR
				

EXIT_IRQ:
    			/* Write to the End of Interrupt Register (ICCEOIR) */
    			STR		R5, [R4, #ICCEOIR]
    
    			POP		{R0-R5, LR}
    			SUBS		PC, LR, #4						// return from interrupt


/*--- Undefined instructions --------------------------------------------------*/
.global	SERVICE_UND
SERVICE_UND:
    			B SERVICE_UND 
 
/*--- Software interrupts -----------------------------------------------------*/
				.global	SERVICE_SVC
SERVICE_SVC:				
    			B			SERVICE_SVC 

/*--- Aborted data reads ------------------------------------------------------*/
				.global	SERVICE_ABT_DATA
SERVICE_ABT_DATA:
    			B			SERVICE_ABT_DATA 

/*--- Aborted instruction fetch -----------------------------------------------*/
				.global	SERVICE_ABT_INST
SERVICE_ABT_INST:
    			B			SERVICE_ABT_INST 
 
/*--- FIQ ---------------------------------------------------------------------*/
				.global	SERVICE_FIQ
SERVICE_FIQ:
    			B			SERVICE_FIQ 

/* 
 * Configure the Generic Interrupt Controller (GIC)
*/
				.global	CONFIG_GIC
CONFIG_GIC:
				PUSH		{LR}
    			/* Configure the A9 Private Timer interrupt and FPGA KEYs
				/* CONFIG_INTERRUPT (int_ID (R0), CPU_target (R1)); */
    			MOV		R0, #MPCORE_PRIV_TIMER_IRQ
    			MOV		R1, #CPU0
    			BL			CONFIG_INTERRUPT
    			MOV		R0, #KEYS_IRQ
    			MOV		R1, #CPU0
    			BL			CONFIG_INTERRUPT

				/* configure the GIC CPU interface */
    			LDR		R0, =0xFFFEC100		// base address of CPU interface
    			/* Set Interrupt Priority Mask Register (ICCPMR) */
    			LDR		R1, =0xFFFF 			// enable interrupts of all priorities levels
    			STR		R1, [R0, #0x04]
    			/* Set the enable bit in the CPU Interface Control Register (ICCICR). This bit
				 * allows interrupts to be forwarded to the CPU(s) */
    			MOV		R1, #1
    			STR		R1, [R0]
    
    			/* Set the enable bit in the Distributor Control Register (ICDDCR). This bit
				 * allows the distributor to forward interrupts to the CPU interface(s) */
    			LDR		R0, =0xFFFED000
    			STR		R1, [R0]    
    
    			POP     	{PC}
/* 
 * Configure registers in the GIC for an individual interrupt ID
 * We configure only the Interrupt Set Enable Registers (ICDISERn) and Interrupt 
 * Processor Target Registers (ICDIPTRn). The default (reset) values are used for 
 * other registers in the GIC
 * Arguments: R0 = interrupt ID, N
 *            R1 = CPU target
*/
CONFIG_INTERRUPT:
    			PUSH		{R4-R5, LR}
    
    			/* Configure Interrupt Set-Enable Registers (ICDISERn). 
				 * reg_offset = (integer_div(N / 32) * 4
				 * value = 1 << (N mod 32) */
    			LSR		R4, R0, #3							// calculate reg_offset
    			BIC		R4, R4, #3							// R4 = reg_offset
				LDR		R2, =0xFFFED100
				ADD		R4, R2, R4							// R4 = address of ICDISER
    
    			AND		R2, R0, #0x1F   					// N mod 32
				MOV		R5, #1								// enable
    			LSL		R2, R5, R2							// R2 = value

				/* now that we have the register address (R4) and value (R2), we need to set the
				 * correct bit in the GIC register */
    			LDR		R3, [R4]								// read current register value
    			ORR		R3, R3, R2							// set the enable bit
    			STR		R3, [R4]								// store the new register value

    			/* Configure Interrupt Processor Targets Register (ICDIPTRn)
     			 * reg_offset = integer_div(N / 4) * 4
     			 * index = N mod 4 */
    			BIC		R4, R0, #3							// R4 = reg_offset
				LDR		R2, =0xFFFED800
				ADD		R4, R2, R4							// R4 = word address of ICDIPTR
    			AND		R2, R0, #0x3						// N mod 4
				ADD		R4, R2, R4							// R4 = byte address in ICDIPTR

				/* now that we have the register address (R4) and value (R2), write to (only)
				 * the appropriate byte */
				STRB		R1, [R4]
    
    			POP		{R4-R5, PC}


/*****************************************************************************
 * MPCORE Private Timer - Interrupt Service Routine                                
 *                                                                          
 * Shifts the pattern being displayed on the LEDR
 * 
******************************************************************************/
.global PRIV_TIMER_ISR
PRIV_TIMER_ISR:	
				LDR		R0, =MPCORE_PRIV_TIMER	// base address of timer
				MOV		R1, #1
				STR		R1, [R0, #0xC]				// write 1 to F bit to reset it
															// and clear the interrupt

/* Move the two LEDS to the centre or away from the centre to the outside. */
SWEEP:            PUSH {R4-R5} //need to use more regs, save them
               LDR        R0, =LEDR_DIRECTION    // put shifting direction into R2
               LDR        R2, [R0]
               LDR        R1, =LEDR_PATTERN        // put LEDR pattern into R3
               LDR        R3, [R1]
               CMP R2,#1 //check which direction
               BNE GOING_C //if not going out, go in
GOING_OUT:
			   LDR R4, =0x201
			   CMP R3, R4	//check if lights reached edges
			   BEQ O_C //Branch to direction change
			   B TOOUTSIDE // Keep going out
GOING_C:
			   CMP R3,#0x30 //check if direction change is needed
			   BEQ C_O //change direction
               
 			
TOCENTRE:		LDR R4,=0x48 //current pattern is 0001001000
				CMP R4,R3
				LDREQ R3,=0x30 //store new pattern 0000110000
				
				LDR R4,=0x84 //current pattern is 0010000100
				CMP R4,R3
				LDREQ R3,=0x48 //store new pattern: 0001001000
				
				LDR R4,=0x102 // current pattern :0100000010
				CMP R4,R3
				LDREQ R3,=0x84 //new pattern:0010000100
				
				LDR R4,=0x201 //current pattern 100000001
				CMP R4,R3
				LDREQ R3,=0x102 //new pattern 0100000010
				B DONE_SWEEP //sweep is done branch 
				

C_O:			MOV		R2, #1 // change direction to outside


TOOUTSIDE:		LDR R4,=0x102 //current pattern 0100000010
				CMP R4,R3
				LDREQ R3,=0x201 //new pattern 1000000001
				
				LDR R4,=0x84 //current pattern 0010000100
				CMP R4,R3
				LDREQ R3,=0x102 //new pattern 0100000010
				
				LDR R4,=0x48 //current pattern 0001001000
				CMP R4,R3
				LDREQ R3,=0x84 //new pattern 0010000100
				
				LDR R4,=0x30 //cuurentt pattern 0000110000
				CMP R4,R3
				LDREQ R3,=0x48 //new pattern 0001001000
				B DONE_SWEEP //done: go to done loop


O_C:			MOV		R2, #0	// change direction to centre
				B	TOCENTRE



DONE_SWEEP:		POP {R4-R5} //restore values
				STR		R2, [R0]					// put shifting direction back into memory
				STR		R3, [R1]					// put LEDR pattern back onto stack
	
END_TIMER_ISR:
				MOV		PC, LR

 
/***************************************************************************************
 * Pushbutton - Interrupt Service Routine                                
 *                                                                          
 * This routine checks which KEY has been pressed.  If KEY3 it stops/starts the timer.
****************************************************************************************/
					.global	KEY_ISR
KEY_ISR: 		LDR		R0, =KEY_BASE			// base address of KEYs parallel port
					LDR		R1, [R0, #0xC]			// read edge capture register
					STR		R1, [R0, #0xC]			// clear the interrupt

CHK_KEY3:		EOR r3,r1,#0b1000 //Check key3
				CMP r3,r1 //
				BLT START_STOP //If key3 was pressed, go to start_stop
				B END_KEY_ISR //else, end

START_STOP:		LDR		R0, =MPCORE_PRIV_TIMER		// timer base address
				LDR		R1, [R0, #0x8]			// read timer control register
				MOV 	R3, #0b001 //timer bit mask
				eor 	r2, r3,r1 //start/stop timer
				STR 	r2, [r0,#0x8] //timer control
				cmp 	r1, r2 //if start sequence
				BGT 	END_KEY_ISR //if greater, go to end key isr
				LDR		R2, =20000000 //reset timer
				str  	r2, [r0] //reset 
				
				
END_KEY_ISR:	MOV	PC, LR 
	
                                                     
/* 
 * This main program demonstrates the use of interrupts using the KEY and timer ports. It
 * 	1. displays a sweeping red light on LEDR, which moves left and right
 * 	2. stops/starts the sweeping motion if KEY3 is pressed
 * Both the timer and KEYs are handled via interrupts
*/
			.global	_start
_start:
			mov r0, #0b11010010 //move to IRQ mode
			msr cpsr,r0
			LDR SP,=0x20000 //set high IRQ stack pointer
			mov r0, #0b11010011 //move to SVC mode
			msr cpsr,r0
			LDR SP,=0xFFF0000 
			
			
			
			

			BL			CONFIG_GIC				// configure the ARM generic interrupt controller
			BL			CONFIG_PRIV_TIMER		// configure the MPCore private timer
			BL			CONFIG_KEYS				// configure the pushbutton KEYs
			
			mov r0, #0b01010011 //move to SVC mode w/ interrupts
			msr cpsr,r0

			LDR		R6, =0xFF200000 		// red LED base address
MAIN:
			LDR		R4, LEDR_PATTERN		// LEDR pattern; modified by timer ISR
			STR 		R4, [R6] 				// write to red LEDs
			B 			MAIN

/* Configure the MPCore private timer to create interrupts every 1/10 second */
CONFIG_PRIV_TIMER:
			LDR		R0, =0xFFFEC600 		// Timer base address
			LDR R2,=20000000 //timer period for 1/10 second
			STR R2,[R0] //store in load value
			MOV R2,#0b111 //sets E,A,I to 1
			STR R2,[R0,#8] //setting E,A,I to 1
			MOV 		PC, LR 					// return

/* Configure the KEYS to generate an interrupt */
CONFIG_KEYS:
			LDR 		R0, =0xFF200050 		// KEYs base address
			MOV R1, #0b1000 //enable key 3 to trigger interrups
			STR R1,[R0,#0b1000] //store r1 at 8th thingy
			MOV 		PC, LR 					// return

			.global	LEDR_DIRECTION
LEDR_DIRECTION:
			.word 	0							// 0 means means moving to centre; 1 means moving to outside

			.global	LEDR_PATTERN
LEDR_PATTERN:
			.word 	0x201	// 1000000001
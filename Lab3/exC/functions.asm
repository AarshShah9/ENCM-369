# stub1.asm
# ENCM 369 Winter 2023
# This program has complete start-up and clean-up code, and a "stub"
# main function.

# BEGINNING of start-up & clean-up code.  Do NOT edit this code.
	.data
exit_msg_1:
	.asciz	"***About to exit. main returned "
exit_msg_2:
	.asciz	".***\n"
main_rv:
	.word	0
	
	.text
	# adjust sp, then call main
	andi	sp, sp, -32		# round sp down to multiple of 32
	jal	main
	
	# when main is done, print its return value, then halt the program
	sw	a0, main_rv, t0	
	la	a0, exit_msg_1
	li      a7, 4
	ecall
	lw	a0, main_rv
	li	a7, 1
	ecall
	la	a0, exit_msg_2
	li	a7, 4
	ecall
        lw      a0, main_rv
	addi	a7, zero, 93	# call for program exit with exit status that is in a0
	ecall
# END of start-up & clean-up code.

# Global variables.
	.data
	.globl	train
train:	.word	0x20000

# Below is the stub for main. Edit it to give main the desired behaviour.
	.text
	.globl	main

main:
	# prologue
	addi 	sp, sp, -12	# Increments the stack pointer down 12 bytes
	sw 	ra, 8(sp)	# Stores return address to stack pointer
	sw	s1, 4(sp)	
	sw	s0, 0(sp)
	
	# body
	li 	s1, 0xa000 	# boat = 40960
	li 	s0, 0x3000	# plane = 12288
	
	# Passing 4 constant arguments to procA
	addi 	a0, zero, 6	# a0 = 6
	addi 	a1, zero, 4	# a1 = 4
	addi 	a2, zero, 3	# a2 = 3
	addi 	a3, zero, 2	# a3 = 2
	jal	procA		# calls procA function
	add	s1, s1, a0	# s1 (boat) += a0 (return value from procA)
	
	sub	t0, s1, s0	# t0 = boat - plane (s1 - s0)
	
	la	t1, train	# load address of train
	lw	t2, (t1)	# load value from t1 address
	
	add	t3, t2, t0	# t1 = t2 + t0
	sw 	t3, (t1)	# train = t1
	
	
	# epilogue
	lw	s0, 0(sp)	# reload the values from the stack
	lw	s1, 4(sp)
	lw	ra, 8(sp)	
	addi 	sp, sp, 12
	
	li      a0, 0   # return value from main = 0
	jr	ra

	.globl	procA
procA:
	# prologue
	addi 	sp, sp, -32	# Increments stack pointer down by 32 bytes
	sw	ra, 28(sp)	# saves ra for return to caller
	sw 	s6, 24(sp)	# saves s6 for main 
	sw 	s5, 20(sp)	# saves s5 for main 
	sw	s4, 16(sp) 	# saves s4 for main
	sw 	s3, 12(sp)	# saves s3 for main 
	sw	s2, 8(sp) 	# saves s2 for main
	sw 	s1, 4(sp)	# saves s1 for main 
	sw	s0, 0(sp) 	# saves s0 for main
	
	add	s0, a0, zero	# copies first from a0 to s0
	add	s1, a1, zero	# copies second from a1 to s1
	add	s2, a2, zero	# copies third from a2 to s2
	add	s3, a3, zero	# copies fourth from a3 to s3
	
	# body
	add	a0, s3, zero	# sets a0 = fourth
	add 	a1, s2, zero	# sets a1 = third
	jal	procB		# calls procB function
	add	s5, a0, zero	# gets return value from procB (s5 = a0)
	
	add	a0, s1, zero	# sets a0 = second
	add 	a1, s0, zero	# sets a1 = first
	jal	procB		# calls procB function
	add	s6, a0, zero	# gets return value from procB (s6 = a0)
	
	add	a0, s2, zero	# sets a0 = third
	add 	a1, s3, zero	# sets a1 = fourth
	jal	procB		# calls procB function
	add	s4, a0, zero	# gets return value from procB (s4 = a0)
	
	add	t0, s5, s6	# t0 = s5 + s6
	add	a0, t0, s4	# a0 = t0 + s4
	
	# Prologue

	lw 	s0, 0(sp)	# loads s0 for main 
	lw	s1, 4(sp) 	# loads s1 for main
	lw 	s2, 8(sp)	# loads s2 for main 
	lw	s3, 12(sp) 	# loads s3 for main
	lw 	s4, 16(sp)	# loads s4 for main 
	lw	s5, 20(sp) 	# loads s5 for main
	lw	s6, 24(sp) 	# loads s6 for main
	lw	ra, 28(sp)	# copy backed-up ra for the correct return location
	addi 	sp, sp, 32	# Increments stack pointer back up by 32 bytes
	
	jr	ra		# Jump back to the return address

	.globl 	procB

procB:
	slli	t0, a0, 8	# t0 = 2^8 (256) * a0
	add	a0, t0, a1	# a0 = t0 + a1
	
	jr 	ra
	

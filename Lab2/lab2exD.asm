# stub1.asm
# ENCM 369 Winter 2023 Lab 2
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

# Global variables
	.data
	.globl	alpha
alpha: 	.word	0xb1, 0xe1, 0x91, 0xc1, 0x81, 0xa1, 0xf1, 0xd1
.globl 	beta
beta: 	.word	0x0, 0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70


# int main(void)
#
# local variable	register
#   int *p		s0
#   int *guard		s1
#   int min		s2
#   int j		s3
#   int k		s4



# Below is the stub for main. Edit it to give main the desired behaviour.
	.text
	.globl	main
main:
	la	s0, alpha	# p = alpha
	addi	s1, s0,	32	# guard = p + 8
	lw	s2, (s0)	# min = *p
	addi	s0, s0, 4	# p++
L1:	
	beq	s0, s1, L3	# if(p == guard) goto L3
	lw	t0, (s0)	# t0 = *p
	bge  	t0, s2, L2	# if (t0 >= min) goto L2
	addi 	s2, t0, 0	# min = t0 + 0
L2:
	addi	s0, s0, 4	# p++
	j	L1
L3:
	la	t5, alpha	# t0 = alpha
	la	t6, beta	# t6 = beta
	add	s3, zero, zero	# j = 0
	addi 	s4, zero, 7 	# k = 7
	addi 	t0, zero, 8	# t0 = 8
L4:
	bge	s3, t0, L5	# if(j >= 8) goto L5
	
	slli	t1, s4, 2	# t1 = k << 2
	add	t2, t6, t1	# t2 = &beta[k]
	lw	t3, (t2)	# t3 = beta[k]
	
	slli	t4, s3, 2	# t4 = j << 2
	add	t2, t5, t4	# t5 = &alpha[j]
	sw	t3, (t2)	# alpha[j] = t3
	
	addi	s3, s3, 1	# j++
	addi	s4, s4, -1	# k--
	j	L4
L5:
	li      a0, 0   	# return value from main = 0
	jr	ra

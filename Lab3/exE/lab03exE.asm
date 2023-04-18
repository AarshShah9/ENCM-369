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


# Global variables
	.data
	# int aaa[] = { 11, 11, 3, -11}
	.globl	aaa
aaa:	.word	11, 11, 3, -11

	# bbb[] = { 200, -300, 400, 500 }
	.globl	bbb
bbb:	.word	200, -300, 400, 500

	# int ccc[] = { -2, -3, 2, 1, 2, 3 }
	.globl	ccc
ccc:	.word	-2, -3, 2, 1, 2, 3

# Below is the stub for main. Edit it to give main the desired behaviour.
	.text
	.globl	main
main:
	# prologue
	addi 	sp, sp, -16	# Increments the stack pointer down 16 bytes
	sw 	ra, 12(sp)	# Stores RA and s-registers on stack
	sw	s2, 8(sp)	
	sw	s1, 4(sp)
	sw	s0, 0(sp)
	
	# body
	li	s2, 1000	# s2 = 1000
	
	addi	a0, zero, 10	# a0 = 10
	la	a1, aaa		# a1 = aaa
	addi	a2, zero, 4	# a2 = 4
	jal	special_sum
	add	s0, zero, a0
	
	addi	a0, zero, 200	# a0 = 200
	la	a1, bbb		# a1 = bbb
	addi	a2, zero, 4	# a2 = 4
	jal	special_sum
	add	s1, zero, a0
	
	addi	a0, zero, 500	# a0 = 500
	la	a1, ccc		# a1 = ccc
	addi	a2, zero, 6	# a2 = 6
	jal	special_sum
	add	t0, a0, s0	# t0 = a0 + s0
	add	t1, t0, s1	# t1 = t0 + s1
	add	s2, s2, t1	# s2 += t1
	
	
	# epilogue
	lw 	s0, 0(sp)	# loads registers back for prodecure call
	lw	s1, 4(sp)
	lw	s2, 8(sp)
	lw	ra, 12(sp)	# loads return address to stack pointer
	addi 	sp, sp, 16	# Increments the stack pointer up 16 bytes
	
	
	li      a0, 0   	# return value from main = 0
	jr	ra

	.globl	clamp
clamp:
	sub 	t0, zero, a0		# t0 = -(a0)
	bge	a1, t0, else_if 	# if (a1 >= t0) goto else_if
	add	a0, zero, t0		# a0 = t0
	j	end_func

else_if:
	ble	a1, a0, end_if 		# if (a1 <= a0) goto end_if
	j	end_func
end_if:
	add	a0, zero, a1		# a0 = a1
	
end_func:
	jr ra


	.globl	special_sum

special_sum:

	# prologue
	addi 	sp, sp, -24	# Increments the stack pointer down 20 bytes
	sw 	ra, 20(sp)	# Stores return address to stack pointer
	sw	s4, 16(sp)
	sw	s3, 12(sp)	
	sw	s2, 8(sp)
	sw	s1, 4(sp)
	sw	s0, 0(sp)
	
	add	s0, zero, a0	# s0 = a0 (bound)
	add	s1, zero, a1	# s1 = a1 (x)
	add	s2, zero, a2	# s2 = a2 (n)
	
	# body
	add	s3, zero, zero	# s3 (result) = 0
	add	s4, zero, zero	# s4 (i) = 0
	
for_start:
	bge	s4, s2, for_end
	
	add	a0, zero, s0
	
	slli	t1, s4, 2	# t1 = i << 2
	add	t2, s1, t1	# t2 = &x[k]
	lw	a1, (t2)	# a1 = x[k]
	jal	clamp
	add	s3, s3, a0	# s3 += a0 (clamp return value)
	
	addi	s4, s4, 1	# i++
	j	for_start
for_end:
	add	a0, s3, zero	# a0 = s3 (result)	
	
	# epilogue
	lw 	s0, 0(sp)	# loads registers back for prodecure call
	lw	s1, 4(sp)
	lw	s2, 8(sp)
	lw	s3, 12(sp)
	lw	s4, 16(sp)
	lw	ra, 20(sp)	# loads return address to stack pointer
	addi 	sp, sp, 24	# Increments the stack pointer up 20 bytes
	
	jr	ra





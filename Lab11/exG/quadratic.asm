# quadratic.asm
# ENCM 369 Winter 2023 Lab 11 Exercise G

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

# int main(void)
	.data
c1pt0:	.double 1.0
c1pt5:	.double 1.5
c2pt0:	.double 2.0
c1pt1:	.double 1.1
cm3pt5:	.double -3.5

	.text
	.globl	main
main:
	addi	sp, sp, -32
	sw	ra, 0(sp)

	fld	f12, c1pt0, t0
	fld	fa1 c1pt5, t0
	fld	fa2, c2pt0, t0
	jal	test_q	      
	fld	f12, c1pt1, t0
	fld	fa1 cm3pt5, t0
	fld	fa2, c2pt0, t0
	jal	test_q	      

	lw	ra, 0(sp)
	addi	sp, sp, 32
	jr	ra


# double result[4] = {0.0, 0.0, 0.0, 0.0};
	.data
	.globl result
result: .double 0.0, 0.0, 0.0, 0.0

# void test_q(double a, double b, double c)
	.data
str01:	.asciz "\ncoefficient a = "
str02:	.asciz "\ncoefficient b = "
str03:	.asciz "\ncoefficient c = "
str04:	.asciz "\nroot: "
str05:	.asciz " + i * ("
str06:	.asciz ")\nroot: "
str07:	.asciz ")\n"

	.text
	.globl	test_q
test_q:
	addi	sp, sp, -32
	sw	ra, 24(sp)
	fsd	fa2, 16(sp)		# copy c to stack
	fsd	fa1,  8(sp)		# copy b to stack
	fsd	fa0,  0(sp)		# copy a to stack
	
	# Note: At this point a, b, and c are still in the appropriate
	# FPRs, so there is no need to recover them from the stack before
	# making the call to quadratic
	la	a3, result		# 4th arg = &result[0]
	jal	quadratic
	
	la	a0, str01
	li	a7, 4			# ecall to print string
	ecall
	fld	fa0, 0(sp)		# fa0 = a
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str02
	li	a7, 4			# ecall to print string
	ecall
	fld	fa0, 8(sp)		# fa0 = b
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str03
	li	a7, 4			# ecall to print string
	ecall
	fld	fa0, 16(sp)		# fa0 = c
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str04
	li	a7, 4			# ecall to print string
	ecall
	fld	fa0, result, t0		# fa0 = result[0]
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str05
	li	a7, 4			# ecall to print string
	ecall
	la	t0, result		# t0 = &result[0]
	fld	fa0, 8(t0)		# fa0 = result[1]
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str06
	li	a7, 4			# ecall to print string
	ecall
	la	t0, result		# t0 = &result[0]
	fld	fa0, 16(t0)		# fa0 = result[2]
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str05
	li	a7, 4			# ecall to print string
	ecall
	la	t0, result		# t0 = &result[0]
	fld	fa0, 24(t0)		# fa0 = result[3]
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str07
	li	a7, 4			# ecall to print string
	ecall

	lw	ra, 24(sp)
	addi	sp, sp, 32
	jr	ra

#  void quadratic(double a, double b, double c, double *roots)
	.text
	.globl	quadratic
quadratic:
	
	# Replace these comments with code that translates the C
	# code.

	# ATTENTION: The C version of quadratic is nonleaf, but you
	# can code the AL version as LEAF by using the RISC-V sqrt.d
	# instruction instead of making a call to a sqrt procedure.
	
	# prologue
	addi	sp, sp, -64
	sw   	ra, 56(sp)
	
	fmv.d	fs0, fa0	# a = fs0
	fmv.d	fs1, fa1	# b = fs1
	fmv.d	fs2, fa2	# c = fs2
	mv	s0, a3		# *roots = s0
	
	# body
	# fs3 = discrim, fs4 = sqrtd, fs5 = two_a 
	
	fmul.d	ft0, fs1, fs1 	# b * b
	fmul.d	ft1, fs0, fs2	# a * c
	
	li		t0, 4
	fcvt.d.w 	ft2, t0
	fmul.d 		ft1, ft1, ft2 	# 4.0 * ft1 (a * c)
	
	fsub.d  fs3, ft0, ft1	# discrim = ...
	
	fadd.d 	fs5, fs0, fs0	# two_a = a + a
	
	li 		t0, 0
	fcvt.d.w 	ft0, t0	
	fge.d		t0, fs3, ft0 # ft1 = (discrim >= 0.0)
	beq		t0, zero, else
	
	fsqrt.d 	fs4, fs3	# sqrtd = sqrt(discrim);
	
	li 		t0, 0
	fcvt.d.w 	ft0, t0		# ft0 = 0
	
	fsub.d 		ft2, ft0, fs1	# ft1 = -b
	
	fadd.d 		ft1, ft2, fs4	# ft1 = -b + sqrtd	
	fsub.d 		ft3, ft2, fs4	# ft3 = -b - sqrtd
	
	fdiv.d 		ft1, ft1, fs5	# ft1 = ft1 / two_a
	fdiv.d 		ft3, ft3, fs5	# ft3 = ft3 / two_a
	
	fsd		ft1, 0(s0)	# roots[0] = ft0
	fsd		ft3, 16(s0)	# roots[2] = ft3
	

	fsd		ft0, 8(s0)	# roots[1] = 0.0
	fsd		ft0, 24(s0)	# roots[3] = 0.0
	

else:
	# add for else block here

	jr	ra

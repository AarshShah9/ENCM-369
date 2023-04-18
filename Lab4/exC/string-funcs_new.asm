# string-funcs.asm
# ENCM 369 Winter 2023 Lab 4 Exercise C

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
	li	a7, 4
	ecall
	lw	a0, main_rv
	li	a7, 1
	ecall
	la	a0, exit_msg_2
	li	a7, 4
	ecall
	lw	a0, main_rv
	addi	a7, zero, 93	# call for program exit with exit status that is in a0
	ecall
# END of start-up & clean-up code.
	

#	void copycat(char *dest, const char *src1, const char *src2)
#
	.text
	.globl	copycat
copycat:

	# Students: Replace this comment with appropriate code.
while1:
	lbu 	t0, (a1)		# t0 = *src1
	beq 	t0, zero, while2	# if (*src1 == zero) goto while2
	sb	t0, (a0)		# *dest = t0
	addi	a0, a0, 1		# dest++
	addi	a1, a1, 1		# src1++
	j	while1
while2:
	lbu 	t3, (a2)		# t0 = *src2
	sb	t3, (a0)		# *dest = c
	addi	a0, a0, 1		# dest++
	addi	a2, a2, 1		# src2++
	bne	t3, zero, while2	# if (c != zero) goto while2
	
	jr	ra
	

#	void lab4reverse(const char *str)
#	
	.text
	.globl	lab4reverse
lab4reverse:

	# Students: Replace this comment with appropriate code.
	# Prologue
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s3, 24(sp)
	sw	s2, 20(sp)
	sw	s1, 16(sp)
	sw	s0, 12(sp)
	
	mv	s0, a0
	
	# Body
	mv	s2, zero		# back = 0

while_start1:
	add	t0, s2, s0		# t0 = &str[back]
	lb	t1, (t0)		# t1 = str[back]
	beq	t1, zero, while_end1	# if (str[back] == zero) goto while_end1
	addi	s2, s2, 1		# back++
	j	while_start1
	
while_end1:
	addi 	s2, s2, -1		# back--
	mv	s1, zero		# front = 0

while_start2:
	ble	s2, s1, while_end2	# if (back <= front) goto while_end2
	add	t0, s2, s0		# t0 = &str[back]
	lb	t1, (t0)		# t1 = str[back]
	
	add	t2, s1, s0		# t2 = &str[front]
	lb	t3, (t2)		# t3 = str[front]
	
	addi	s3, t1, 0		# c = str[back]
	sb	t3, (t0)		# str[back] = str[front]
	sb	s3, (t2)		# str[front] = c;
	
	addi	s2, s2, -1		# back--
	addi	s1, s1, 1		# front++
	j	while_start2		

while_end2:
	# Epilogue
	lw	s0, 12(sp)
	lw	s1, 16(sp)
	lw	s2, 20(sp)
	lw	s3, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	
	jr	ra

	
#	void print_in_quotes(const char *str)
#
	.text
	.globl	print_in_quotes
print_in_quotes:
	add	t0, a0, zero		# copy str to t0	
	
	addi	a0, zero, '"'
	li	a7, 11
	ecall
	mv	a0, t0
	li	a7, 4
	ecall
	li	a0, '"'
	li	a7, 11	     
	ecall
	li	a0, '\n'
	li	a7, 11
	ecall
	jr	ra		
		
#	Global arrays of char for use in testing copycat and lab4reverse.
	.data
	
	.align	5
	# char array1[32] = { '\0', '*', ..., '*' };
array1:	.byte	0, '*', '*', '*', '*', '*', '*', '*'	
	.byte	'*', '*', '*', '*', '*', '*', '*', '*'	
	.byte	'*', '*', '*', '*', '*', '*', '*', '*'	
	.byte	'*', '*', '*', '*', '*', '*', '*', '*'
	
	# char array2[] = "X";	
array2:	.asciz "X"
		
	# char array3[] = "YZ";	
array3:	.asciz "YZ"
		
	# char array4[] = "123456";	
array4:	.asciz "123456"
		
	# char array5[] = "789abcdef";	
array5:	.asciz "789abcdef"
		
#	int main(void)
#
#	string constants used by main
	.data
sc0:	.asciz ""
sc1:	.asciz	"good"
sc2:	.asciz "bye"
sc3:	.asciz "After 1st call to copycat, array1 has "
sc4:	.asciz "After 2nd call to copycat, array1 has "
sc5:	.asciz "After 3rd call to copycat, array1 has "
sc6:	.asciz "After 4th call to copycat, array1 has "
sc7:	.asciz "After use of lab4reverse, array2 has "
sc8:	.asciz "After use of lab4reverse, array3 has "
sc9:	.asciz "After use of lab4reverse, array4 has "
sc10:	.asciz "After use of lab4reverse, array5 has "

	.text
	.globl	main
main:
	# Prologue only needs to save ra
	addi	sp, sp, -32
	sw	ra, 0(sp)
	
	# Body
	# Start tests of copycat.
	la	a0, array1	# a0 = array1
	la	a1, sc0		# a1 = sc0
	la	a2, sc0		# a2 = sc0
	jal	copycat
	la	a0, sc3
	li	a7, 4
	ecall	
	la	a0, array1	# a0 = array1
	jal	print_in_quotes
	
	la	a0, array1	# a0 = array1
	la	a1, sc1		# a1 = sc1
	la	a2, sc0		# a2 = sc0
	jal	copycat
	la	a0, sc4
	li	a7, 4
	ecall	
	la	a0, array1	# a0 = array1
	jal	print_in_quotes
	
	la	a0, array1	# a0 = array1
	la	a1, sc0		# a1 = sc0
	la	a2, sc2		# a2 = sc2
	jal	copycat
	la	a0, sc5
	li	a7, 4
	ecall	
	la	a0, array1	# a0 = array1
	jal	print_in_quotes
	
	la	a0, array1	# a0 = array1
	la	a1, sc1		# a1 = sc1
	la	a2, sc2		# a2 = sc2
	jal	copycat
	la	a0, sc6
	li	a7, 4
	ecall	
	la	a0, array1	# a0 = array1
	jal	print_in_quotes
	
	# End tests of lab4cat; start tests of lab4reverse.
	la	a0, array2	# a0 = array2
	jal	lab4reverse
	la	a0, sc7
	li	a7, 4
	ecall
	la	a0, array2	# a0 = array2
	jal	print_in_quotes
	
	la	a0, array3	# a0 = array3
	jal	lab4reverse
	la	a0, sc8
	li	a7, 4
	ecall
	la	a0, array3	# a0 = array3
	jal	print_in_quotes
	
	la	a0, array4	# a0 = array4
	jal	lab4reverse
	la	a0, sc9
	li	a7, 4
	ecall
	la	a0, array4	# a0 = array4
	jal	print_in_quotes
	
	la	a0, array5	# a0 = array5
	jal	lab4reverse
	la	a0, sc10
	li	a7, 4
	ecall
	la	a0, array5	# a0 = array5
	jal	print_in_quotes
		
	# End tests of lab4reverse.
	
	mv	a0, zero	# r.v. from main = 0
	
	# Epilogue
	lw	ra, 0(sp)
	addi	sp, sp, 32
	jr	ra

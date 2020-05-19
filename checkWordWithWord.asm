# Check the string input with the test string
.data 
	test: .asciiz "hello"
	input:	.asciiz "hel"
	str: .space 50
.text
	la	$a0, input
	la	$a1, test
	jal 	_strcmp
	move	$t0, $v0
	
	li	$v0,1
	move	$a0,$t0
	syscall
	
	jal 	_exit

#	boolean _check_word_with_word(inputWord, testWord)
#	@param	inputWord -> $a0
#	@param	testWord -> $a1
#	@return 0 if $a0 is the same $a1
#	@return 1 if $a0 longer than $a1
#	@return 0 if $a0 shoter than $a1
_strcmp:
	addi	$sp, $sp, -8
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	
	move	$s0, $a0
	move	$s1, $a1
_strcmp.Loop:
	lb 	$t0, 0($s0)
	lb 	$t1, 0($s1)
	bne 	$t0, $t1, _strcmp_ne
	# $t0 == $t1:
	bne 	$t0, $zero, _strcmp.equal.continue
	# $t0 == $t1 == '\0':
	move 	$v0, $zero
	jr 	$ra
_strcmp.equal.continue:
	# $t0 == $t1 != '\0':
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 	_strcmp.Loop
_strcmp.return_equal:
	addi 	$v0, $zero, 0
	jr 	$ra
_strcmp.return_shorter:
	addi 	$v0, $zero, -1
	jr 	$ra
_strcmp.return_longer:
	addi 	$v0, $zero, 1
	jr 	$ra		
_strcmp_ne:
	# $t0 != $t1:
	sub 	$v0, $t0, $t1
	beq	$v0, 0, _strcmp.return_equal
	slt	$t2, $v0, $zero
	beq	$t2, 1, _strcmp.return_longer	
	beq	$t2, 0, _strcmp.return_shorter

# _strlen function
# @param: string input -> $a0
# @return the length of string -> $v0
# ------------------------------------ Start _strlen function	
_strlen:
	addi	$sp, $sp, -8
	sw	$ra, ($sp)
	sw	$s0, 4($sp)	# inputWord	
	sw	$t0, 8($sp)	# count
	
	# initialization
	move 	$s0, $a0	# inputWord
	addi 	$t0, $zero, 0
	
_strlen.Loop:
	addi $s0, $s0, 1
	addi $t0, $t0, 1
_strlen.test:
	lb 	$t1, 0($s0)
	bnez 	$t1,_strlen.Loop
	move 	$v0, $t0
	lw	$ra, ($sp)
	lw	$s0, 4($sp)		
	lw	$t0, 8($sp)	
	addi	$sp, $sp, 8
	jr 	$ra
# ------------------------------------ End _strlen function


# ------------------------------------ Start Exit program function
_exit:
	li	$v0,10
	syscall
# ------------------------------------ End Exit program function

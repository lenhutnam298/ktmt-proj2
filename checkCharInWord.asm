.data
	test:	.asciiz "apple"
	str:	.space	50
.text
	#args
	la	$a0,test		#get test addr
	la	$a1,'a'
	jal	_check_in_word

	#TEST return value: 0/1
	move	$t0,$v0

	li	$v0,1
	move	$a0,$t0
	syscall

	#TODO if return = 1: next input
	#TODO if return = 0: next player state

	li	$v0,10
	syscall
	
#bool checkInWord(word, input char)
_check_in_word:
	addi	$sp,$sp,-32
	sw	$ra,($sp)
	sw	$s0,4($sp)		#word
	sw	$t0,8($sp)		#input char
	sw	$t1,12($sp)		#cur char
	sw	$t2,16($sp)		#cur char index
	sw	$t3,20($sp)		#found?

	#init	
	move	$s0,$a0			#word
	move	$t0,$a1			#input char
	addu	$t2,$t2,0		#i = 0
	addu	$t3,$t3,0		#found = false

_check_in_word.loop:
	lbu	$t1,($s0)
	beq	$t1,'\0',_check_in_word.end_loop
	beq	$t1,$t0,_check_in_word.char_cmpr_true	#curChar == inputChar
	j	_check_in_word.keep_loop		#curChar != inputChar

_check_in_word.char_cmpr_true:
	#Correct char
	addu	$t3,$zero,1		#found = true

	#TODO update guess word: replace '_' with char
		

_check_in_word.keep_loop:
	addu	$s0,$s0,1		#word addr++
	addu	$t2,$t2,1		#i++

	j	_check_in_word.loop

_check_in_word.end_loop:
	#return found? flag
	move	$v0,$t3
	
	#restore
	sw	$ra,($sp)
	sw	$s0,4($sp)		
	sw	$t0,8($sp)		
	sw	$t1,12($sp)		
	sw	$t2,16($sp)
	addi	$sp,$sp,32

	jr 	$ra	
	

.data
	tb_score:	.asciiz "Score: "
	score:	.word	0		# Reset score to 0 if new player
.text
	jal	_update_score


	# TEST: print score	
	li	$v0,4
	la	$a0,tb_score
	syscall

	li	$v0,1
	lw	$a0,score
	syscall

	li	$v0,10
	syscall

# Update score after win
_update_score:
	addi	$sp,$sp,-8
	sw	$ra,($sp)	
	sw	$t0,4($sp)	#score

	lw	$t0,score
	
	#call _strlen
	la	$a0,guessword
	jal	_strlen
	
	add	$t0,$t0,$v0	#score = score + wordLen
	sw	$t0,score
	
	#restore
	lw	$ra,($sp)	
	lw	$t0,4($sp)	#score
	addi	$sp,$sp,8

	jr	$ra
	

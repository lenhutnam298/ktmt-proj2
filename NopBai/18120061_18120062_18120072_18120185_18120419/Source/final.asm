.data
	# file location
	myfin: .asciiz "test.txt"
	myfout: .asciiz "rtest.txt"
	# test case.
	test:	.space 2048
	# Ve bang
	promt_draw0: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	promt_draw01: .asciiz "\n\n\n"
	promt_draw1: .asciiz "\n\nNhap n: "
	promt_draw2: .asciiz "  ______"
	promt_draw3: .asciiz "\n  |  |"
	promt_draw4: .asciiz "\n  |"
	promt_draw5: .asciiz "\n__|______"
	promt_draw6: .asciiz "\n  |  o"
	promt_draw7: .asciiz "\n  |  |"
	promt_draw8: .asciiz "\n  | /|"
	promt_draw9: .asciiz "\n  | /|\\"
	promt_draw10: .asciiz "\n  | /"
	promt_draw11: .asciiz "\n  | / \\"
	promt_draw12: .asciiz "\n\n GAME OVER "
	# Menu
	promt_menu0: .asciiz "		MAIN MENU\n0. Exit\n1. Play\n2. Change name\n3. Show top 10\n"
	promt_menu1: .asciiz "Nhap lua chon: "
	promt_menu2: .asciiz "		\nMENU\n0. Exit\n1. Return to MAIN MENU\n2. Play again\n"
	promt_menu3: .asciiz "		\n TOP 10\n"
	promt_menu4: .asciiz "Return to MAIN MENU(Y/N): "
	# Bang thong bao:
	promt_entername: .asciiz "Nhap ten: "
	promt_name: .asciiz "Ten nguoi choi: "
	promt_scanChar: .asciiz "Nhap ki tu: "
	promt_error.invalid:"\nNhap sai!! Vui long nhap lai:\n"
	promt_error.invalid_guessing: .asciiz "Cach nhap chi co the la\n + 1:Nhap 1 ki tu\n + 2:Nhap 1 chu cai" 
	promt_error.invalid_entername: .asciiz "Ten khong duoc co ki tu dac biet \n{cac ki tu phai nam trong khoang (0-9)(a-z)(A-Z)}" 
	promt_error.invalid_word: .asciiz "Tu khong duoc co ki tu dac biet \n{cac ki tu phai nam trong khoang (0-9)(a-z)(A-Z)}"
	promt_error.invalid_char: .asciiz "Ki tu khong duoc la ki tu dac biet \n{cac ki tu phai nam trong khoang (0-9)(a-z)(A-Z)}"	
	promt_error.invalid_menu: .asciiz "Lua chon chi co the la:\n0. Exit\n1. Return to MAIN MENU\n2. Play again\n"
	promt_error.invalid_mainmenu: .asciiz "lua chon chi co the la: \n0. Exit\n1. Play\n2. Change name\n3. Show top 10\n"
	promt_error.invalid_top: .asciiz "lua chon chi co the la:\nY: co\nN: khong"
	promt_scanWord: .asciiz "Nhap tu: "
	promt_guessing1: .asciiz "1. Doan ky tu\n2. Doan tu\nNhap cach doan tu: "
	promt_score: .asciiz "Score: "
	#
	Score: 		.word 0
	N: 		.word 0
	Nplayer: 	.word 0
	Marked.N: .word 0
	
	buffer: 	.space 1024
	buffer2: 	.space 2048
	score_name:	.space 50
	string: 	.space 50
	str:		.space	50
	guessword: 	.space 50
	inputstr: 	.space 50
	Name: 		.space 30
	guessed: 	.space 50
	temp:		.space 50
	player:		.space 50
	StrScore: 	.space 50
	ArrPosi:	.space	200
	Marked:		.space 100
.text

# ==================== MAIN ============================================================ #
main:	
	li	$v0, 13       	# system call for open file
	la   	$a0, myfout     # board file name
	li   	$a1, 0          # flag for reading
	li   	$a2, 0          # mode is ignored
	syscall            # open a file (file descriptor returned in $v0)
	move 	$s0, $v0      # save the file descriptor 

	li 	$v0, 14 # open file
	move 	$a0,$s0
	la 	$a1, buffer2
	li 	$a2, 1024
	syscall

	li 	$v0, 16 # close file
	move 	$a0, $s0
	syscall	
	
	jal	_enter_player_name	
	li	$v0,11	
	addi	$a0,$zero,'\n'
	syscall
main.menu:

	la	$v0,4
	la	$a0,promt_menu0
	syscall

	la	$v0,4
	la	$a0,promt_menu1
	syscall

	li	$v0,12
	syscall
	move 	$t0,$v0
	
	li	$v0,11	
	addi	$a0,$zero,'\n'
	syscall

	addi	$t1,$zero,'0'
	blt	$t0,$t1,main.error
	addi	$t1,$zero,'3'
	bgt	$t0,$t1,main.error
	j	main.call
main.error:
	li 	$v0,55
	la 	$a0,promt_error.invalid_mainmenu
	li 	$a1 ,1
	syscall

	li 	$v0,4
	la 	$a0,promt_error.invalid
	syscall
	j	main.menu
main.call:
	beq  	$t0,'0',_stop_runing
	beq 	$t0,'1',main.callPlay
	beq 	$t0,'2',main
	beq 	$t0,'3',main.show_top10
	j _stop_runing
main.show_top10:

	li	$v0, 13       	# system call for open file
	la   	$a0, myfout     # board file name
	li   	$a1, 1          # flag for reading
	li   	$a2, 0          # mode is ignored
	syscall            # open a file (file descriptor returned in $v0)
	move 	$s6, $v0      # save the file descriptor 

	la	$a0,buffer2
	jal	_strlen
	move	$t0,$v0

	addi	$t0,$t0,1

	move 	$a0, $s6 
    	li 	$v0, 15
    	la 	$a1, buffer2
    	move 	$a2, $t0 	# length
    	syscall

    	li $v0, 16  
    	syscall

	la	$a0,promt_menu3
	li	$v0,4
	syscall	
	jal	_sort
	jal	_top_10

main.show_top10.exit:
	la	$a0,promt_menu4
	li	$v0,4
	syscall
	
	li	$a0,'\n'
	la	$v0,11
	syscall
	li	$a0,'\n'
	la	$v0,11
	syscall

	la	$v0,12
	syscall

	beq	$v0,'Y',main.menu
	beq	$v0,'N',_stop_runing
main.show_top10.error:
	li 	$v0,55
	la 	$a0,promt_error.invalid_menu
	li 	$a1 ,1
	syscall

	li 	$v0,4
	la 	$a0,promt_error.invalid
	syscall
	j	main.show_top10.exit

main.callPlay:
	jal	Play
	
	lw	$a0,Score
	la	$a1,StrScore
	jal	_to_string

	la	$a0,StrScore
	li	$a1,'-'
	la	$a2,Name
	la	$a3,score_name
	jal	_union_string

	la	$a0,buffer2
	li	$a1,'\0'
	la	$a2,score_name
	la	$a3,buffer2
	jal	_union_string
	
	la	$a0,buffer2
	jal	_strlen
	move	$t0,$v0

	addi	$t1,$zero,'*'
	sb	$t1,buffer2($t0)
	addi	$t0,$t0,1
	addi	$t1,$zero,'\0'
	sb	$t1,buffer2($t0)

	li	$v0,4
	la	$a0,promt_name
	syscall
	li	$v0,4
	la	$a0,Name
	syscall
	li	$v0,11
	li	$a0,'\n'
	syscall
	li	$v0,4
	la	$a0,promt_score
	syscall

	lw	$a0,Score
	li	$v0,1
	syscall
	
main.callPlay.menu:

	li	$v0, 13       	# system call for open file
	la   	$a0, myfout     # board file name
	li   	$a1, 1          # flag for reading
	li   	$a2, 0          # mode is ignored
	syscall            # open a file (file descriptor returned in $v0)
	move 	$s6, $v0      # save the file descriptor 

	la	$a0,buffer2
	jal	_strlen
	move	$t0,$v0

	addi	$t0,$t0,1

	move 	$a0, $s6 
    	li 	$v0, 15
    	la 	$a1, buffer2
    	move 	$a2, $t0 	# length
    	syscall

	la	$v0,4
	la	$a0,promt_menu2
	syscall

	la	$v0,4
	la	$a0,promt_menu1
	syscall

	li	$v0,12
	syscall
	move 	$t0,$v0
	li	$v0,11	
	addi	$a0,$zero,'\n'
	syscall

	addi	$t1,$zero,'0'
	blt	$t0,$t1,main.callPlay.error
	addi	$t1,$zero,'2'
	bgt	$t0,$t1,main.callPlay.error
	
	beq  	$t0,'0',_stop_runing
	beq 	$t0,'1',main.menu
	beq 	$t0,'2',main.callPlay

	j _stop_runing

main.callPlay.error:
	li 	$v0,55
	la 	$a0,promt_error.invalid_top
	li 	$a1 ,1
	syscall

	li 	$v0,4
	la 	$a0,promt_error.invalid
	syscall
	j	main.callPlay.menu

	j _stop_runing
# ==================== UNITY ============================================================ #
 
# -------------------- CHECK ------------------------------------------------------------ #

######################################################################################################
# == bool _check_in_word( string: word, char: input char)------------------------------------------
# 	- input :
#	  + @param  	$a0 = word (string)
#	  + @param  	$a1 = $t0 = input char	
#	- output :
#	  + @return 0: 	if $a0 is in $a1
#	  + @return 1: 	if $a0 is not in $a1
_check_in_word:
	addi	$sp,$sp,-32
	sw	$t9,0($sp)
	sw	$ra,4($sp)
	sw	$s0,8($sp)		# word
	sw	$t0,12($sp)		# input char
	sw	$t1,16($sp)		# cur char
	sw	$t2,20($sp)		# cur char index
	sw	$t3,24($sp)		# found?

	# Load parameter	
	move	$s0,$a0			# word
	move	$t0,$a1			# input char
	# Initialization
	addu	$t2,$t2,0		# i = 0
	addu	$t3,$zero,0		# found = false

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
	lw	$t9,0($sp)
	lw	$ra,4($sp)
	lw	$s0,8($sp)		#word
	lw	$t0,12($sp)		#input char
	lw	$t1,16($sp)		#cur char
	lw	$t2,20($sp)		#cur char index
	lw	$t3,24($sp)		#found?
	addi	$sp,$sp,32
	# 
	jr 	$ra	
######################################################################################################
###########################################################################
# ==	bool _check_Marked(int num) -----------------------------------
# 	- input :
#	  + @param 	$a0 = num (int)
#	- output
#	  + @return 0: num is in Marked
#	  + @return 1: num is not in Marked
_check_Marked:
# DAU THU TUC:
	addi	$sp,$sp,-28
	sw	$t9,0($sp)	# throw
	sw	$ra,4($sp)
	sw	$s0,8($sp) 	# num
	sw	$s1,12($sp)	# Marked
	sw	$t1,16($sp)	# num in Marked
	sw	$s2,20($sp)	# N of Marked (address)
	sw	$t2,24($sp)	# N of Marked (value)
	sw	$t0,28($sp)	# count i

	move	$s0,$a0	
	move	$s1,$a1
	move	$s2,$a2

	lw	$t2,($s2)
	addi	$t0,$zero,0
# THAN THU TUC:
	beq	$t2,0,_check_Marked.false
_check_Marked.loop:
	lw	$t1,($s1)
	beq	$s0,$t1,_check_Marked.true
	addi	$t0,$t0,1
	addi	$s1,$s1,4
	blt	$t0,$t2,_check_Marked.loop
_check_Marked.false:
	addi	$t2,$t2,1
	sw	$t2,($s2)
	sw	$s0,($s1)
	addi	$v0,$zero,0
	j 	_check_Marked.exit	
_check_Marked.true:
	addi	$v0,$zero,1
# CUOI THU TUC:
_check_Marked.exit:	
	lw	$t9,0($sp)	# throw
	lw	$ra,4($sp)
	lw	$s0,8($sp) 	# num
	lw	$s1,12($sp)	# Marked
	lw	$t1,16($sp)	# num in Marked
	lw	$s2,20($sp)	# N of Marked (address)
	lw	$t2,24($sp)	# N of Marked (value)
	lw	$t0,28($sp)	# count i
	addi	$sp,$sp,28
	jr	$ra
####################################################################################

######################################################################################################
# == bool _check_exist(char: char, string: str) ------------------------------------------
# 	- input :
#	  + @param  	$a0 = char (char)
#	  + @param  	$a1 = word (string)
#	- output :
#	  + @return 0: 	if $a0 is in $a1
#	  + @return 1: 	if $a0 is not in $a1
_check_exist:
# DAU THU TUC:
	# Back up
	addi 	$sp,$sp,-12
	sw 	$t9,0($sp)	#throw
	sw	$ra,4($sp)	
	sw	$s0,8($sp)	# char
	sw	$s1,12($sp)	# str
	# Load parameter
	move 	$s0,$a0
	move 	$s1,$a1
	
# THAN THUC TUC:
	move 	$a0,$s1
	move	$a1,$s0
	jal	_check_in_word
# CUOI THU TUC:
	# Restore
	lw 	$t9,($sp)	#throw
	lw	$ra,4($sp)	
	lw	$s0,8($sp)	# char
	lw	$s1,12($sp)	# str
	addi 	$sp,$sp,12
	# Return
	jr 	$ra
######################################################################################################

######################################################################################################
# == bool _check_input_valid(char: char) -------------------------------------------------
# - input :
#	 + @param 	$a0 = char	(char)
# - output:
#	 + @return 0:	$a0 is not valid
#	 + @return 1: 	$a0 is valid   
# - use for:	check  whether or not $a0 is in (0-9)(a-z)(A-Z) 
_check_input_valid:
# DAU THU TUC
	addi	$sp,$sp,-16
	sw	$t9,0($sp)
	sw	$ra,4($sp)
	sw	$s0,8($sp)	# char
	sw	$t0,12($sp)	# temp
	sw	$t1,16($sp)	# temp 2

	move	$s0,$a0
# THAN THU TUC:
	beq 	$t0,'_',_check_input_valid.false

	slti 	$t0,$s0,'0'
	beq 	$t0,1,_check_input_valid.false
	addi	$t1,$zero,'9'
	bgt	$t0,$t1,_check_input_valid.alphabet_caplock
	j	_check_input_valid.true

_check_input_valid.alphabet_caplock:
	slti 	$t0,$s0,'A'
	beq 	$t0,1,_check_input_valid.false
	addi	$t1,$zero,'Z'
	bgt	$t0,$t1,_check_input_valid.alphabet
	j	_check_input_valid.true

_check_input_valid.alphabet:
	slti 	$t0,$s0,'a'
	beq 	$t0,1,_check_input_valid.false
	addi	$t1,$zero,'z'
	bgt	$t0,$t1,_check_input_valid.false

_check_input_valid.true:
	addi	$v0,$zero,1
	j	_check_input_valid.exit	

_check_input_valid.false:
	addi	$v0,$zero,0

_check_input_valid.exit:

# CUOI THU TUC:
	
	lw	$t9,0($sp)
	lw	$ra,4($sp)
	lw	$s0,8($sp)	# char
	lw	$t0,12($sp)	# temp
	lw	$t1,16($sp)	# temp 2
	addi	$sp,$sp,16

	jr	$ra
######################################################################################################

######################################################################################################
# == bool _check_valid_word(string: word) -------------------------------------------------
# - input :
#	 + @param 	$a0 = word	(string)
# - output:
#	 + @return 0:	$a0 is not valid
#	 + @return 1: 	$a0 is valid   
# - use for:	check  whether or not $a0 is in (0-9)(a-z)(A-Z) 
_check_valid_word:
# DAU THU TUC:
	addi	$sp,$sp,-16
	sw	$t9,0($sp)
	sw	$ra,4($sp)
	sw	$s0,8($sp)	# Str (string)
	sw	$t0,12($sp)	
	sw	$t1,16($sp)	# temp
	move	$s0,$a0
# DAU THU TUC:
_check_valid_word.loop:
	lb	$t0,($s0)
	beq	$t0,'\0',_check_valid_word.correct
	
	move	$a0,$t0
	jal	_check_input_valid

	
	beq	$v0,0,_check_valid_word.false
	addi	$s0,$s0,1
	j	_check_valid_word.loop

_check_valid_word.false:
	addi	$v0,$zero,0
	j	_check_valid_word.exit

_check_valid_word.correct:	
	addi	$v0,$zero,1

_check_valid_word.exit:
# CUOI THU TUC:
	lw	$t9,0($sp)
	lw	$ra,4($sp)
	lw	$s0,8($sp)	# Str (string)
	lw	$t0,12($sp)
	lw	$t1,16($sp)	# temp
	addi	$sp,$sp,16
	jr 	$ra
######################################################################################################

# -------------------- STRING AND ARRAY TOOLS ------------------------------------------------------------ #

######################################################################################################
# == int _strcmp(string: inputStr, string: sourceStr) ------------------------------------------
# 	- input :
#	  + @param 	$a0 = inputStr (string)
#	  + @param 	$a1 = sourceStr (string)
#	- output :
#	  + @return -1: if $a0 shorter than $a1 
#	  + @return 0: 	if $a0 is the same $a1
#	  + @return 1: 	if $a0 longer than $a1

_strcmp:
	addi	$sp,$sp,-20
	sw	$t9,0($sp)
	sw	$ra,4($sp)
	sw	$s0,8($sp)	# inputStr
	sw	$s1,12($sp)	# sourceStr
	sw	$t0,16($sp)
	sw	$t1,20($sp)

	move	$s0, $a0
	move	$s1, $a1
_strcmp.Loop:
	lb 	$t0, 0($s0)
	lb 	$t1, 0($s1)
	bne 	$t0, $t1, _strcmp_ne
	# $t0 == $t1:
	bne 	$t0, $zero, _strcmp.equal.continue
	# $t0 == $t1 == '\0':
	addi	$v0,$zero,0
	j 	_strcmp.exit
_strcmp.equal.continue:
	# $t0 == $t1 != '\0':
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 	_strcmp.Loop
_strcmp.return_equal:
	addi 	$v0, $zero, 0
	j	_strcmp.exit	
_strcmp.return_shorter:
	addi 	$v0, $zero, -1
	j	_strcmp.exit
_strcmp.return_longer:
	addi 	$v0, $zero, 1
	j	_strcmp.exit	
_strcmp_ne:
	# $t0 != $t1:
	sub 	$v0, $t0, $t1
	beq	$v0, 0, _strcmp.return_equal
	slt	$t2, $v0, $zero
	beq	$t2, 1, _strcmp.return_longer	
	beq	$t2, 0, _strcmp.return_shorter
_strcmp.exit:
	lw	$t9,0($sp)
	lw	$ra,4($sp)
	lw	$s0,8($sp)	# inputStr
	lw	$s1,12($sp)	# sourceStr
	lw	$t0,16($sp)
	lw	$t1,20($sp)
	addi	$sp,$sp,20
	jr 	$ra
######################################################################################################

######################################################################################################
# == void _union_string(string str1,char char,string str2,string result) -------------------------------------------------

# - input :
#	 + @param 	$a0 = str1 (string)
#	 + @param 	$a1 = char (char)
#	 + @param 	$a2 = str2 (string)
#	 + @param 	$a3 = result (string)
# use for: 	union string and string
_union_string:
# DAU THUC TUC:
	addi	$sp, $sp, -32
	sw	$t9,0($sp)	# throw
	sw	$ra,4($sp)
	sw	$s0,8($sp)	# str1

	sw	$s1,12($sp)	# char
	sw	$s2,16($sp)	# str2
	sw	$s3,20($sp)	# result

	sw	$t0,24($sp)	# byte in $a0
	sw	$t2,28($sp)	# byte in $a2
	sw	$t3,32($sp)	# byte in $a3

	move	$s0,$a0
	move	$s1,$a1
	move	$s2,$a2
	move	$s3,$a3

	lb	$t0,($s0)
	lb	$t2,($s2)

# THAM THUC TUC:
_union_string.specialcase:
	lb	$t0,($s0)
	beqz	$t0,_union_string.loop2
_union_string.loop1:
	lb	$t0,($s0)
	beqz	$t0,_union_string.connect
	sb	$t0,($s3)
	addi	$s0,$s0,1
	addi	$s3,$s3,1
	j	_union_string.loop1
_union_string.connect:	
	beqz	$s1,_union_string.loop2
	sb	$s1,($s3)
	addi	$s3,$s3,1
_union_string.loop2:
	lb	$t2,($s2)
	beqz	$t2,_union_string.exit
	sb	$t2,($s3)
	addi	$s2,$s2,1
	addi	$s3,$s3,1
	j	_union_string.loop2
_union_string.exit:
	addi	$t3,$zero,'\0'
	sb	$t3,($s3)
# CUOI THUC TUC:

	lw	$t9,0($sp)	# throw
	lw	$ra,4($sp)
	lw	$s0,8($sp)	# str1

	lw	$s1,12($sp)	# char
	lw	$s2,16($sp)	# str2
	lw	$s3,20($sp)	# result

	lw	$t0,24($sp)	# byte in $a0
	lw	$t2,28($sp)	# byte in $a2
	lw	$t3,32($sp)	# byte in $a3
	addi	$sp,$sp,32
	jr	$ra
######################################################################################################

######################################################################################################
# == int _str_to_num:(string: str) ------------------------------------------
# 	- input :
#	  + @param 	$a0 = str (string)
#	- output :
#	  + @return int form of string $a0 


_str_to_num:
# DAU THU TUC:
	addi	$sp,$sp,-32
	sw	$t9,0($sp)	# throw
	sw	$ra,4($sp)	
	sw	$s0,8($sp)	# str	(string)
	sw	$s1,12($sp)	# num
	sw	$t0,16($sp)	# byte of $s0
	sw	$t1,20($sp)	# count i = N - 1 with N is the length of $s0
	sw	$t2,24($sp)	# num form of $t0
	sw	$t3,28($sp)	# multiplier
	sw	$t4,32($sp)	# 10
	move	$s0,$a0
	
	addi	$s1,$zero,0
	addi	$t3,$zero,1
	addi	$t4,$zero,10
# THAN THU TUC:
	move	$a0,$s0
	jal	_strlen
	move	$t1,$v0

	addi	$t1,$t1,-1
	add	$s0,$s0,$t1
	
_str_to_num.loop:
	blt	$t1,0,_str_to_num.exit
	lb	$t0,($s0)
	sub	$t2,$t0,'0'
	mult	$t2,$t3
	mflo	$t2
	add	$s1,$s1,$t2

	mult	$t3,$t4
	mflo	$t3

	addi	$t1,$t1,-1
	addi	$s0,$s0,-1
	
	j	_str_to_num.loop

# CUOI THU TUC:
_str_to_num.exit:
	move	$v0,$s1
	lw	$t9,0($sp)	# throw
	lw	$ra,4($sp)	
	lw	$s0,8($sp)	# str	(string)
	lw	$s1,12($sp)	# num
	lw	$t0,16($sp)	# byte of $s0
	lw	$t1,20($sp)	# count i = N - 1 with N is the length of $s0
	lw	$t2,24($sp)	# num form of $t0
	lw	$t3,28($sp)	# multiplier
	lw	$t4,32($sp)	# 10
	addi	$sp,$sp,32
	jr	$ra

######################################################################################################


######################################################################################################
# == void _to_string(int num,string str) -------------------------------------------------

# - input :
#	 + @param 	$a0 = num (int)
# use for: 	take string form of $a0 
# DAU THUC TUC:
_to_string:
	addi	$sp, $sp, -32
	sw	$t9,0($sp)
	sw	$ra,4($sp)
	sw	$s0,8($sp)	# num	
	sw	$s1,12($sp)	# byte
	sw	$t1,16($sp)	# temp
	sw	$t2,20($sp)	# 10	|	byte in $s2
	sw	$t3,24($sp)	# '0'
	sw	$t0,28($sp)	# count i

	sw	$s2,32($sp)	# str

	move	$s0,$a0
	move	$s2,$a1

	addi	$t0,$zero,0
	addi	$t2,$zero,10
	addi	$t3,$zero,'0'
# THAN THUC TUC:
_to_string.specialcase:
	bnez	$s0,_to_string.loop1
	addi	$t1,$zero,'0'
	sb	$t1,($s2)
	addi	$s2,$s2,1
	j	_to_string.exit	
_to_string.loop1:
	beqz	$s0,_to_string.reverse
	div	$s0,$t2
	mfhi	$t1
	mflo	$s0
	add	$s1,$t3,$t1
	sb	$s1,string($t0)
	addi	$t0,$t0,1
	j	_to_string.loop1
_to_string.reverse:	
	addi	$t0,$t0,-1
_to_string.loop2:
	blt 	$t0,0,_to_string.exit
	lb	$t1,string($t0)
	sb	$t1,($s2)
	addi	$t0,$t0,-1
	addi	$s2,$s2,1
	j	_to_string.loop2

_to_string.exit:
# CUOI THUC TUC:
	addi	$t1,$zero,'\0'
	sb	$t1,($s2)

	lw	$t9,0($sp)
	lw	$ra,4($sp)
	lw	$s0,8($sp)	# num	
	lw	$s1,12($sp)	# byte
	lw	$t1,16($sp)	# temp
	lw	$t2,20($sp)	# 10	|	byte in $s2
	lw	$t3,24($sp)	# '0'
	lw	$t0,28($sp)	# count i
	lw	$s2,32($sp)	# str
	addi	$sp, $sp, -32
	jr	$ra

######################################################################################################

######################################################################################################
# == int _strlen(string: inputword) -------------------------------------------------
# 	- input :
#	  + @param 	$a0 = inputword (string)
#	- output :
#	  + @return : 	the length of string (int)

_strlen:
	addi	$sp, $sp, -12
	sw	$t9,0($sp)
	sw	$ra,4($sp)
	sw	$s0,8($sp)	# inputword	
	sw	$t0,12($sp)	# count
	
	# initialization
	move 	$s0, $a0	# inputword
	addi 	$t0, $zero, 0
	lb 	$t1, 0($s0)
	beqz 	$t1,_strlen.exit	
_strlen.Loop:
	addi 	$s0, $s0, 1
	addi 	$t0, $t0, 1
_strlen.test:
	lb 	$t1, 0($s0)
	bnez 	$t1,_strlen.Loop
_strlen.exit:
	move 	$v0, $t0

	lw	$t9,0($sp)
	lw	$ra,4($sp)
	lw	$s0,8($sp)	# inputword	
	lw	$t0,12($sp)	# count
	addi	$sp, $sp, 12
	jr 	$ra

######################################################################################################

######################################################################################################
# == void  _strcopy(string sourceStr, str copyStr) -------------------------------------------------
# 	- input :
#	  + @param 	$a0 = sourceStr (string)
#	  + @param 	$a1 = copyStr (string)
#	- Use for:	Copy   sourceStr to copyStr

_strcopy:
# DAU THU TUC:

	addi	$sp,$sp,-16
	sw	$t9,0($sp)	# throw
	sw	$ra,4($sp)
	sw	$s0,8($sp)	# sourceStr
	sw	$s1,12($sp)	# copyStr
	sw	$t0,16($sp)	# temp	
	
	move	$s0,$a0	# source
	move	$s1,$a1	# copy

# THAN THU TUC:	
_strcopy.loop:
	lb	$t0,($s0)
	sb	$t0,($s1)
	beq	$t0,'\0',_strcopy.exit
	addi	$s0,$s0,1
	addi	$s1,$s1,1
	j	_strcopy.loop

# CUOI THU TUC:
_strcopy.exit:

	lw	$t9,0($sp)	# throw
	lw	$ra,4($sp)
	lw	$s0,8($sp)	# sourceStr
	lw	$s1,12($sp)	# copyStr
	lw	$t0,16($sp)	# temp
	addi	$sp,$sp,16

	jr	$ra
######################################################################################################

######################################################################################################
# ==	void _uncaplock(string: Str) -----------------------------------
# 	- input :
#	  + @param 	$a0 = Str (string)
#	- Use for:	uncaplock

_uncaplock:
# DAU THU TUC:
	addi	$sp,$sp,-16
	sw	$t9,0($sp)
	sw	$ra,4($sp)
	sw	$s0,8($sp)	# Str (string)
	sw	$t0,12($sp)	
	sw	$t1,16($sp)	# temp
	move	$s0,$a0
# THAN THU TUC:
_uncaplock.loop:
	lb	$t0,($s0)
	beq	$t0,'\0',_uncaplock.exit
_uncaplock.check1:
	addi	$t1,$zero,'A'
	bgt	$t0,$t1,_uncaplock.check2
	j 	_uncaplock.inc
_uncaplock.check2:
	addi	$t1,$zero,'Z'
	blt	$t0,$t1,_uncaplock.change
	j 	_uncaplock.inc
_uncaplock.change:
	addi	$t0,$t0,32
	sb	$t0,($s0)
_uncaplock.inc:
	addi	$s0,$s0,1
	j	_uncaplock.loop
_uncaplock.exit:
# CUOI THU TUC:
	lw	$t9,0($sp)
	lw	$ra,4($sp)
	lw	$s0,8($sp)	# Str (string)
	lw	$t0,12($sp)
	lw	$t1,16($sp)	# temp
	addi	$sp,$sp,16
	jr 	$ra
######################################################################################################

######################################################################################################
# == int  _count_different_char_in_word (string sourceStr, char: char) -------------------------------------------------
# 	- input :
#	  + @param 	$a0 = sourceStr (string)
#	  + @param 	$a1 = char (char)
# 	- output :
#	  + @return	number of times where $a1 not appear in $a0 (int)
#	- Use for:	count number of times where $a1 not appear in $a0 
_count_different_char_in_word:
# DAU THU TUC:
	addi	$sp,$sp,-32
	sw	$t9,0($sp)	# throw
	sw	$ra,4($sp)
	sw	$s0,8($sp)	# sourceStr
	sw	$s1,12($sp)	# char
	sw	$t0,16($sp)	# count i
	sw	$t1,20($sp)	# temp
	sw	$t2,24($sp)	# '\0'
	# safe exit
	sw 	$s2,28($sp)	# word length
	sw	$t3,32($sp)	# count j


	move	$s0,$a0
	move	$s1,$a1
	
	addi 	$t0,$zero,0
	
	move	$a0,$s0
	jal 	_strlen
	move	$s2,$v0
	addi 	$t3,$zero,0
# THAN THU TUC:	
_count_different_char_in_word.loop:
	lb	$t1,($s0)
	beq	$t1,$t2,_count_different_char_in_word.exit
	bge	$t3,$s2,_count_different_char_in_word.exit
	beq	$s1,$t1,_count_different_char_in_word.inc
	addi 	$t0,$t0,1
_count_different_char_in_word.inc:	
	addi 	$s0,$s0,1
	addi 	$t3,$t3,1
	j 	_count_different_char_in_word.loop
_count_different_char_in_word.exit:
	
# CUOI THU TUC:
	move	$v0,$t0
	lw	$t9,0($sp)	# throw
	lw	$ra,4($sp)
	lw	$s0,8($sp)	# sourceStr
	lw	$s1,12($sp)	# char
	lw	$t0,16($sp)	# count i
	lw	$t1,20($sp)	# temp
	lw	$t2,24($sp)	# '\0'
	lw 	$s2,28($sp)	# word length
	lw	$t3,32($sp)	# count j
	addi	$sp,$sp,32
	jr $ra
######################################################################################################
# ==================== SYSTEM ============================================================ #

# -------------------- INPUT FORM BOARD ------------------------------------------------------------ #

######################################################################################################
# == void _enter_player_name -------------------------------------------------
# - use for:	input or update Name

_enter_player_name: 
# DAU THU TUC
	addi	$sp,$sp,-12
	sw	$t9,0($sp)
	sw	$ra,4($sp)
	sw	$s0,8($sp)
	sw	$t0,12($sp)
# THAN THU TUC:
_enter_player_name.enter_name:	
	#Xuat EnterName
	
	li 	$v0,4
	la 	$a0,promt_entername
	syscall
	
	#Nhap ten
	li $v0,8
	la $a0,Name
	li $a1,30
	syscall

	la	$s0,Name

_enter_player_name.check_valid.loop:

	lb	$t0,($s0)
	beq 	$t0,'\n',_enter_player_name.fix
	beq 	$t0,'\0',_enter_player_name.exit

	move	$a0,$t0
	jal	_check_input_valid

	beq	$v0,0,_enter_player_name.false
	addi	$s0,$s0,1
	j 	_enter_player_name.check_valid.loop

_enter_player_name.false:
	#Xuat promt_error.invalid
	li $v0,55
	la $a0,promt_error.invalid_entername
	li $a1 ,1
	syscall
	
	li $v0,4
	la $a0,promt_error.invalid
	syscall
	j _enter_player_name.enter_name

_enter_player_name.fix:
	addi	$t0,$zero,'\0'
	sb	$t0,($s0)
	j	_enter_player_name.check_valid.loop

_enter_player_name.exit:
	
	lw	$t9,0($sp)
	lw	$ra,4($sp)
	lw	$s0,8($sp)
	lw	$t0,12($sp)
	addi	$sp,$sp,12

	jr	$ra
######################################################################################################


######################################################################################################
# == char  _input_char() -------------------------------------------------
# - output:
#	 + @return valid char
# - use for:	input a character and check whether or not that character is in (0-9)(a-z)(A-Z) 
_input_char:
	addi	$sp,$sp,-12
	sw	$t9,0($sp)
	sw	$ra,4($sp)	
	sw	$s0,8($sp)
	sw	$t0,12($sp)

_input_char.input:
	#Xuat promt_scanChar
	li 	$v0,4
	la 	$a0,promt_scanChar
	syscall
	#Nhap ky tu
	li	$v0,12
	syscall
	#Luu ky tu vao $s0
	move 	$s0,$v0

_input_char.check_char:
	beq 	$s0,'_',_input_char.exit
	beq 	$s0,'-',_input_char.exit
	#Kiem tra nhap sai
	slti 	$t0,$s0,65
	beq 	$t0,1,_input_char.wrong
	slti 	$t0,$s0,91
	beq 	$t0,1,_input_char.uncaplock
	slti 	$t0,$s0,97
	beq 	$t0,1,_input_char.wrong
	slti 	$t0,$s0,123
	beq 	$t0,1,_input_char.exit
	slti 	$t0,$s0,128
	beq 	$t0,1,_input_char.wrong	
	j	_input_char.exit
_input_char.wrong:
	li 	$v0,55
	la 	$a0,promt_error.invalid_char
	li 	$a1 ,1
	syscall
	#Xuat tb3
	li 	$v0,4
	la 	$a0,promt_error.invalid
	syscall
	j 	_input_char.input
_input_char.uncaplock:
	#Xuat ki tu vua nhap
	addi 	$s0,$s0,32
_input_char.exit:	
	move	$v0,$s0
	lw	$t9,0($sp)
	lw	$ra,4($sp)	
	lw	$s0,8($sp)
	lw	$t0,12($sp)
	addi	$sp,$sp,12

	jr	$ra
######################################################################################################

######################################################################################################
# == bool _scanChar(string: word) -------------------------------------------------
# 	- input :
#	  + @param 	$a0 = word (string)
# 	- output:
#	@return 0: 	if input char is false(guessed; not in $a0) 
#	@return 1: 	if input char is correct(not guessed; in $a0) 
#	- Use for:	input a char and check whether the input char is correct or not
_scanChar:
# DAU THU TUC:
	
	# Back up
	addi 	$sp,$sp,-16
	sw	$t9,0($sp)	#throw
	sw 	$ra,4($sp)
	sw 	$s0,8($sp) 	# word
	sw 	$t0,12($sp) 
	sw	$t1,16($sp)	# result
	
	# Truyen tham so
	move 	$s0,$a0
# THAN THU TUC:
	
	# Nhap ki tu
	jal	_input_char
	move 	$t0,$v0

	# Gan vao bien 
	move 	$a0,$t0
	la	$a1,guessword
	# kiem tra exist
	jal 	_check_exist
	beq 	$v0,1,_scanChar.existed

	# Gan vao bien 
	move 	$a1,$t0
	move 	$a0,$s0
	# Goi ham 
	jal 	_check_in_word
	move 	$t1,$v0
	# Gan vao bien 
	la 	$a0,guessword
	move 	$a1,$t0
	move 	$a2,$s0
	
	jal 	_update_guessword
	j 	_scanChar.exit
_scanChar.existed:
	addi 	$t1,$zero,0
	
_scanChar.exit:
# CUOI THU TUC:
	move 	$v0,$t1
	# Load back up
	lw	$t9,0($sp)	#throw
	lw 	$ra,4($sp)
	lw 	$s0,8($sp) 	# word
	lw 	$t0,12($sp) 
	lw	$t1,16($sp)	# result
	addi 	$sp,$sp,16
	jr 	$ra
######################################################################################################

######################################################################################################
# == void  _input_word() -------------------------------------------------
 
# - use for:	input a word and check whether or not that character is in (0-9)(a-z)(A-Z) 
#		to update inputstr
_input_word:
# DAU THU TUC:
	addi	$sp,$sp,-8
	sw	$t9,0($sp)
	sw	$ra,4($sp)
# DAU THU TUC:
_input_word.input:
	# Xuat ban promt_scanWord
	li 	$v0,4
	la 	$a0,promt_scanWord
	syscall

	li 	$v0,8
	la	$a0,inputstr
	la	$a1,50
	syscall
	
	la	$a0,inputstr
	jal 	_strlen
	
	addi	$s1,$v0,-1
	addi	$t0,$zero,'\0'
	sb	$t0,inputstr($s1)
	
	la	$a0,inputstr
	jal	_check_valid_word
	beq	$v0,0,_input_word.error
	j	_input_word.exit
_input_word.error:

	li 	$v0,55
	la 	$a0,promt_error.invalid_word
	li 	$a1 ,1
	syscall

	li 	$v0,4
	la 	$a0,promt_error.invalid
	syscall
	j	_input_word.input

# CUOI THU TUC:
_input_word.exit:
	lw	$t9,0($sp)
	lw	$ra,4($sp)
	addi	$sp,$sp,8
	jr	$ra
######################################################################################################

######################################################################################################
# == bool _scanWord(string: word) -------------------------------------------------
# 	- input :
#	  + @param 	$a0 = word (string)
# 	- output:
#	@return 0: 	if input string is not $a0
#	@return 1: 	if input string is @a0 
#	- Use for:	input a string and check whether the input string is correct or not

_scanWord:
# DAU THU TUC:
	#Back up:
	addi	$sp,$sp,-16
	sw	$t9,0($sp)	# Throw
	sw	$ra,4($sp)
	sw 	$s0,8($sp) 	# word
	sw 	$s1,12($sp) 	# inputstr length
	sw	$t0,16($sp)	# temp
	# Luu lai gia tri tham so vao thanh ghi
	move 	$s0,$a0
# THAN THU TUC:

		
	# Nhap word(input word)
	jal 	_input_word
	
	la	$a0,inputstr
	jal	_uncaplock

	# Truyen tham so
	move	$a0,$s0
	la	$a1,inputstr
	
	# Goi ham kt Word voi Word
	jal 	_strcmp
	
	# Lay kq
	beq 	$v0,0,_scanWord.correct
_scanWord.false:
	addi 	$v0,$zero,0
	j	_scanWord.exit
_scanWord.correct:
	addi 	$v0,$zero,1
_scanWord.exit:

# CUOI THU TUC:
	# Restore
	lw	$t9,0($sp)	# Throw
	lw	$ra,4($sp)
	lw 	$s0,8($sp) 	# word
	lw 	$s1,12($sp) 	# inputstr length
	lw	$t0,16($sp)	# temp
	addi 	$sp,$sp,16
	
	jr 	$ra
######################################################################################################

######################################################################################################
# == int _scan(int: How_to_scan,string: word) -------------------------------------------------

# 	- input :
#	  + @param 	$a0 = How_to_scan (int)
#			if $a0 = 1 -> scanChar
#			if $a0 = 2 -> scanWord 
#	  + @param 	$a1 = word (string)
# 	- output:
#	@return -1: 	if How_to_scan is not (1 or 2) 
#	@return 0: 	if guessing false 
#	@return 1: 	if guessing correct
#	- Use for:	choose how to guess word and check whether player guess is 
#			correct or not
_scan:
# DAU THU TUC:
	# Restore
	addi 	$sp,$sp,-12	
	sw	$t9,0($sp)	# throw
	sw 	$ra,4($sp)
	sw 	$s0,8($sp)	# Cach nhap
	sw 	$s1,12($sp)	# word
	# Luu gia tri tham so vao thanh ghi
	move 	$s0,$a0
	move 	$s1,$a1
# THAN THU TUC:

	# Truyen bien
	move 	$a0,$s1
	# kt va chon cach nhap
	addi 	$v0,$zero,-1
	beq 	$s0,1,_scan.SChar
	beq 	$s0,2,_scan.SWord

_scan.SChar:
	jal 	_scanChar
	j 	_scan.exit
_scan.SWord:
	jal _scanWord
# CUOI THU TUC
_scan.exit:
	lw	$t9,0($sp)	# throw
	lw 	$ra,4($sp)
	lw 	$s0,8($sp)	# Cach nhap
	lw 	$s1,12($sp)	# word
	addi 	$sp,$sp,12
	jr 	$ra
######################################################################################################

# -------------------- PREPARE ------------------------------------------------------------ #

###############################################################################
# == void _top_10() ------------------------------------------
# 	use for: print top10 player
_top_10:
# DAU THU TUC:
	addi	$sp,$sp,-24
	sw	$t9,0($sp)
	sw	$ra,4($sp)
	sw	$t0,8($sp)	# count i
	sw	$t1,12($sp)	# temp
	sw	$t2,16($sp)	# 4
	sw	$s0,20($sp)	# N
	sw	$t4,24($sp)

	addi	$t0,$zero,0
	addi	$t2,$zero,4
	lw	$s0,Nplayer
#	lw	$s0,($s0)
# THAN THU TUC:
_top_10.loop:
	bge	$t0,$s0,_top_10.exit
	mult	$t0,$t2
	mflo	$t1
	lw	$t4,ArrPosi($t1)
	la	$a0,buffer2
	move	$a1,$t4
	la	$a2,player
	jal	_get_array_I
	la	$a0,player
	jal 	_print_guessword
	addi	$t0,$t0,1
	j	_top_10.loop
_top_10.exit:
# CUOI THU TUC:
		
	lw	$t9,0($sp)
	lw	$ra,4($sp)
	lw	$t0,8($sp)	# count i
	lw	$t1,12($sp)	# temp
	lw	$t2,16($sp)	# 4
	lw	$s0,20($sp)	# N
	lw	$t4,24($sp)
	addi	$sp,$sp,24
	jr	$ra
###############################################################################

###############################################################################
# == void _sort() ------------------------------------------
# 	use for: sort form high to low
_sort:
# DAU THU TUC:
	addi	$sp,$sp,-56
	sw	$t9,0($sp)
	sw	$ra,4($sp)
	sw	$s0,8($sp)	
	sw	$t0,12($sp)	# bit of buffer2 | count l
	sw	$s1,16($sp)	# N(buffer2)
	sw	$t1,20($sp)	# count k	| A[l].posi

	sw	$s2,24($sp)	# A[i].score
	sw	$s3,28($sp)	# A[j].score
	sw	$t2,32($sp)	# count i
	sw	$t3,36($sp)	# count j
	sw	$s4,40($sp)	# end of i
	sw	$s5,44($sp)	# end of j

	sw	$t4,48($sp)	# temp1
	sw	$t5,52($sp)	# temp2
	
	sw	$t6,56($sp)
	
	addi	$t5,$zero,4
# THAN THU TUC:
_sort.countN:
	addi	$s1,$zero,0	# N(buffer2)
	addi	$t1,$zero,0	# count i
_sort.countN.loop:
	lb	$t0,buffer2($t1)
	beq	$t0,'\0',_sort.setposi
	beq	$t0,'*',_sort.countN.inc_N
	addi	$t1,$t1,1
	j	_sort.countN.loop
_sort.countN.inc_N:
	addi	$s1,$s1,1
	addi	$t1,$t1,1
	j	_sort.countN.loop
_sort.setposi:
	sw	$s1,Nplayer
	addi	$t6,$zero,0
	la	$t1,ArrPosi
_sort.setposi.loop:
	bge	$t6,$s1,_sort.bubble
	sw	$t6,($t1)
	addi	$t6,$t6,1
	addi	$t1,$t1,4
	j	_sort.setposi.loop
	

_sort.bubble:
	addi	$t2,$zero,0
	addi	$s4,$s1,-1

_sort.outloop:
	addi	$t3,$zero,0
	addi	$s5,$s1,-1
	sub	$s5,$s5,$t2

_sort.inloop:
	mult	$t3,$t5		# a[j]
	mflo	$t4
	lw	$s2,ArrPosi($t4)
	la	$a0,buffer2
	move	$a1,$s2
	la	$a2,player
	jal	_get_array_I
	la	$a0,player
	jal	_get_player_score
	move	$s2,$v0


	addi	$t0,$t3,1	# a[j+1]
	mult	$t0,$t5
	mflo	$t4
	lw	$s3,ArrPosi($t4)
	la	$a0,buffer2
	move	$a1,$s3
	la	$a2,player
	jal	_get_array_I
	la	$a0,player
	jal	_get_player_score
	move	$s3,$v0
	
	blt	$s3,$s2,_sort.inloop.inc
_sort.swap:

	mult	$t3,$t5
	mflo	$t4
	lw	$s2,ArrPosi($t4)

	mult	$t0,$t5
	mflo	$t4
	lw	$s3,ArrPosi($t4)
	##########################
	mult	$t0,$t5
	mflo	$t4
	sw	$s2,ArrPosi($t4)

	mult	$t3,$t5
	mflo	$t4
	sw	$s3,ArrPosi($t4)
	
_sort.inloop.inc:
	addi	$t3,$t3,1
	blt	$t3,$s5,_sort.inloop

	addi	$t2,$t2,1
	blt	$t2,$s4,_sort.outloop

# CUOI THU TUC:

	lw	$t9,0($sp)
	lw	$ra,4($sp)
	lw	$s0,8($sp)	
	lw	$t0,12($sp)	# bit of buffer2 | count l
	lw	$s1,16($sp)	# N(buffer2)
	lw	$t1,20($sp)	# count k	| A[l].posi

	lw	$s2,24($sp)	# A[i].score
	lw	$s3,28($sp)	# A[j].score
	lw	$t2,32($sp)	# count i
	lw	$t3,36($sp)	# count j
	lw	$s4,40($sp)	# end of i
	lw	$s5,44($sp)	# end of j

	lw	$t4,48($sp)	# temp
	lw	$t5,52($sp)	# temp2

	lw	$t6,56($sp)
	addi	$sp,$sp,56
	jr	$ra


###############################################################################

###############################################################################
# == int _get_player_score(string: str) ------------------------------------------
# 	- input :
#	  + @param 	$a0 = str (string)
#	- output :
#	  + @return player score in str (int)
_get_player_score:
# DAU THU TUC:
	addi	$sp,$sp,-16
	sw	$t9,0($sp)
	sw	$ra,4($sp)
	sw	$s0,8($sp)	# str (string)
	sw	$t0,12($sp)	# bit in str
	sw	$s1,16($sp)	# store score

	move	$s0,$a0
	la	$s1,temp
# THAN THU TUC:
_get_player_score.loop:
	lb	$t0,($s0)
	beq	$t0,'-',_get_player_score.get_score
	sb	$t0,($s1)
	addi	$s0,$s0,1
	addi	$s1,$s1,1
	j	_get_player_score.loop

_get_player_score.get_score:

	addi	$t0,$zero,'\0'
	sb	$t0,($s1)

	la	$a0,temp
	jal	_str_to_num

# CUOI THU TUC:
	lw	$t9,0($sp)
	lw	$ra,4($sp)
	lw	$s0,8($sp)	# str (string)
	lw	$t0,12($sp)	# bit in str
	lw	$s1,16($sp)	# store score
	addi	$sp,$sp,16
	jr	$ra
######################################################################################################

######################################################################################################
# == void generate_guessword(string: word,string: guessword) ------------------------------------
# 	- input :
#	  + @param 	$a0 = word (string)
#	  + @param 	$a1 = guessword (string)
#	- Use for:	generate guessword as "-------"

# DAU THU TUC:
_generate_guessword:
	addi 	$sp,$sp,-24
	sw	$t9,0($sp)	# throw
	sw 	$ra,4($sp)
	sw 	$s0,8($sp)	# word
	sw 	$s1,12($sp)	# guessword
	sw	$t0,16($sp)	# word.length
	sw	$t1,20($sp)	# count i
	sw	$t2,24($sp)	# '-'
	
	jal 	_strlen
	move 	$t0,$v0

	move	$s1,$a1
	addi	$t1,$zero,0
	addi	$t2,$zero,'-'
# THAN THUC TUC:
_generate_guessword.loop:
	sb	$t2,($s1)
	addi 	$t1,$t1,1
	addi	$s1,$s1,1
	blt 	$t1,$t0,_generate_guessword.loop
	
	# la 	$t2,endline
	addi 	$t2,$zero,'\0'
	sb	$t2,0($s1)
# CUOI THU TUC:

	lw	$t9,0($sp)	# throw
	lw 	$ra,4($sp)
	lw 	$s0,8($sp)	# word
	lw 	$s1,12($sp)	# guessword
	lw	$t0,16($sp)	# word.length
	lw	$t1,20($sp)	# count i
	lw	$t2,24($sp)	# '-'
	addi 	$sp,$sp,24

	jr 	$ra
######################################################################################################

######################################################################################################
# ==	void printGuessword(string: guessword) -----------------------------------
# 	- input :
#	  + @param 	$a0 = word (string)
#	- Use for:	print guessword

# DAU THU TUC:
_print_guessword:
	addi 	$sp,$sp,-12
	sw 	$t9,0($sp)	# throw
	sw 	$ra,4($sp)
	sw 	$s0,8($sp)	# guess word
	sw 	$t0,12($sp)
	move 	$s0,$a0
# THAN THUC TUC:
_print_guessword.loop:

	lb 	$t0,($s0)
	beq 	$t0,'\0',_print_guessword.exit
	move 	$a0,$t0
	li 	$v0,11
	syscall
	addi 	$s0,$s0,1
	j 	_print_guessword.loop

_print_guessword.exit:
	
	li	$v0,11
	addi	$a0,$zero,'\n'
	syscall

# CUOI THU TUC:
	lw	$t9,0($sp)
	lw 	$ra,4($sp)
	lw 	$s0,8($sp)	# guess word
	lw 	$t0,12($sp)
	addi 	$sp,$sp,12

	jr 	$ra
######################################################################################################

######################################################################################################
# == void _update_guessword(string: guessword,char: char,string: word) ---------------------------------------
# ==	void printGuessword(guessword) -----------------------------------
# 	- input :
#	  + @param 	$a0 = guessword (string)
#	  + @param 	$a1 = char (char)
#	  + @param 	$a2 = word (string)
#	- Use for:	replace '-' in $a0 with $a1 which in $a2
_update_guessword:
# DAU THU TUC:
	addi	$sp,$sp,-20
	sw	$t9,0($sp)
	sw	$ra,4($sp)
	sw	$s0,8($sp)	# guessword
	sw	$s1,12($sp)	# char
	sw	$s2,16($sp)	# word
	sw	$t2,20($sp)	# word
	
	move	$s0,$a0
	move	$s1,$a1
	move	$s2,$a2

# THAN THUC TUC:
_update_guessword.loop:
	lb	$t2,0($s2)
	bne	$t2,$s1,_update_guessword.loop.inc
	sb	$t2,($s0)
_update_guessword.loop.inc:	
	addi	$s0,$s0,1
	addi	$s2,$s2,1
	beq	$t2,'\0',_update_guessword.exit
	j _update_guessword.loop
_update_guessword.exit:
# CUOI THU TUC:
	lw	$t9,0($sp)
	lw	$ra,4($sp)
	lw	$s0,8($sp)	# guessword
	lw	$s1,12($sp)	# char
	lw	$s2,16($sp)	# word
	lw	$t2,20($sp)	# word
	addi	$sp,$sp,20
	
	jr	$ra
######################################################################################################

######################################################################################################
# ==int _guessing(string word) -------------------------------------------------------
# 	- input :
#	  + @param 	$a0 = word (string)
# 	- output:
#	@return -1: 	if guessing a competed word is wrong -> lost
#	@return 0: 	if guessing word is correct -> change word
#	@return 1: 	if guessing char is correct and in $a0 but didnt 
#			guess the compete word -> continue guessing
#	@return 2: 	if guessing char is wrong and not in $a0
#	- Use for:	the guessing process of the hangman

_guessing:
# DAU THU TUC:
	addi 	$sp,$sp,-24
	sw 	$t9,($sp)	#throw
	sw	$ra,4($sp)	
	sw	$s0,8($sp)	# word
	sw	$s1,12($sp)	# guessing way: 1_char; 2_word (int)
	sw	$t2,16($sp)	# scan result
	sw	$t3,20($sp)	# temp
	sw	$t4,24($sp)	# guessing way: 1_char; 2_word (char)
	move	$s0,$a0
# THAN THUC TUC:
_guessing.choosing:
	li 	$v0,4
	la 	$a0,promt_guessing1
	syscall

	li	$v0,12
	syscall
	move 	$t4,$v0
	
	addi	$t3,$zero,'1'
	blt	$t4,$t3,_guessing.error
	addi	$t3,$zero,'2'
	bgt	$t4,$t3,_guessing.error

	j	_guessing.input
_guessing.error:

	li 	$v0,55
	la 	$a0,promt_error.invalid_guessing
	li 	$a1 ,1
	syscall

	li 	$v0,4
	la 	$a0,promt_error.invalid
	syscall
	j	_guessing.choosing

_guessing.input:
	li	$v0,11
	li	$a0,'\n'
	syscall
	
	sub	$s1,$t4,'0'
	
	move	$a0,$s1
	move	$a1,$s0
	
	jal 	_scan
	move 	$t2,$v0
	beq	$s1,2,_guessing.word
# -----	# Char: --------------------- #
_guessing.char:
	beq 	$t2,1,_guessing.char.correct

_guessing.char.wrong:
	addi 	$v0,$zero,2	
	j 	_guessing.exit

_guessing.char.correct:

	# Check compete
	move	$a0,$s0
	la	$a1,guessword
	jal	_strcmp
	
	beq	$v0,0,_guessing.competed
	addi 	$v0,$zero,1

_guessing.notcompeted:
	addi 	$v0,$zero,1
	j 	_guessing.exit

_guessing.competed:
	addi 	$v0,$zero,0
	j 	_guessing.exit

# -----	# Word: --------------------- #
_guessing.word:
	beq 	$t2,0,_guessing.word.wrong

_guessing.word.correct:

	move	$a0,$s0
	la	$a1,guessword
	jal 	_strcopy
	addi 	$v0,$zero,0
	j 	_guessing.exit

_guessing.word.wrong:
	addi 	$v0,$zero,-1
	
_guessing.exit:	
# CUOI THU TUC:
	lw 	$t9,($sp)	#throw
	lw	$ra,4($sp)	
	lw	$s0,8($sp)	# word
	lw	$s1,12($sp)	# guessing way: 1_char; 2_word
	lw	$t2,16($sp)
	lw	$t3,20($sp)	# check
	lw	$t4,24($sp)
	addi 	$sp,$sp,24

	jr $ra
######################################################################################################

######################################################################################################
# == _update_number_of_word () -------------------------------------------------
#	- use for 	update the number of word in buffer N 
_update_number_of_word:
# DAU THU TUC:
	addi	$sp,$sp,-24
	sw	$t9,0($sp)	# throw
	sw	$ra,4($sp)
	sw	$t0,8($sp)	# temp count i
	sw	$t1,12($sp)	# temp
	sw	$t2,16($sp)	# $t2 = '*'
	sw	$s1,20($sp)	# N -> number of word in buffer
	sw	$t3,24($sp)	# '\0'
	
	addi	$t0,$zero,0
	addi	$s1,$zero,0
	addi	$t2,$zero,'*'
	addi	$t3,$zero,'\0'
# THAN THU TUC:
_update_number_of_word.loop:
	lb	$t1,buffer($t0)
	beq	$t1,$t3,_update_number_of_word.exit
	beq	$t1,$t2,_update_number_of_word.inc_N
_update_number_of_word.inc_i:
	addi	$t0,$t0,1
	j	_update_number_of_word.loop
_update_number_of_word.inc_N:
	addi	$s1,$s1,1
	j 	_update_number_of_word.inc_i
_update_number_of_word.exit:
	sw 	$s1,N
# CUOI THU TUC:
	lw	$t9,0($sp)	# throw
	lw	$ra,4($sp)
	lw	$t0,8($sp)	# temp count i
	lw	$t1,12($sp)	# temp
	lw	$t2,16($sp)	# $t2 = '*'
	lw	$s1,20($sp)	# N -> number of word in buffer
	lw	$t3,24($sp)	# '\0'
	addi	$sp,$sp,24
	jr	$ra
######################################################################################################

######################################################################################################
# == int _get_array_I(string: buffer ,int I, string: word) -------------------------------------------------
# - input :
#	 + @param 	$a0 = buffer (string) 
#	 + @param 	$a1 = I (int)
#	 + @param 	$a2 = word (string)
# - output:
#	 + @return 0:	input wrong
#	 + @return 1: 	successful   
# - use for:	get value of ArrayStr[I]
_get_array_I:
# DAU THU TUC:
	addi	$sp,$sp,-36
	sw	$t9,0($sp)	# throw
	sw	$ra,4($sp)
	sw	$s0,8($sp)	# buffer
	sw	$s1,12($sp)	# I
	sw	$s2,16($sp)	# word
	sw	$t0,20($sp)	# count i
	sw	$t1,24($sp)	# '*'
	sw	$t2,28($sp)	# '\0'	
	sw	$t4,32($sp)	# temp (j)
	sw	$s3,36($sp)	# get result

	move	$s0,$a0
	move	$s1,$a1
	move	$s2,$a2
	
	addi	$t0,$zero,0
	addi	$t1,$zero,'*'
	addi	$t2,$zero,'\0'

# THAN THU TUC:
_get_array_I.loop:
	beq	$t0,$s1,_get_array_I.getword
	lb	$t4,0($s0)

	beq	$t4,$t2,_get_array_I.exit_fail
	bne	$t4,$t1,_get_array_I.inc_j
	addi	$t0,$t0,1
	addi	$s0,$s0,1
	j _get_array_I.loop
_get_array_I.inc_j:
	addi	$s0,$s0,1
	j _get_array_I.loop
_get_array_I.getword:

_get_array_I.getword.loop:
	lb	$t4,0($s0)
	sb	$t4,0($s2)

	beq	$t4,$t1,_get_array_I.exit_success
	beq	$t4,$t2,_get_array_I.exit_fail
	addi	$s0,$s0,1
	addi	$s2,$s2,1
	j _get_array_I.getword.loop
_get_array_I.exit_fail:
 	addi	$v0,$zero,0
	j	_get_array_I.exit
_get_array_I.exit_success:
	addi	$v0,$zero,1
	sb	$t2,($s2)
_get_array_I.exit:
	lw	$t9,0($sp)	# throw
	lw	$ra,4($sp)
	lw	$s0,8($sp)	# buffer
	lw	$s1,12($sp)	# I
	lw	$s2,16($sp)	# word
	lw	$t0,20($sp)	# count i
	lw	$t1,24($sp)	# '*'
	lw	$t2,28($sp)	# '\0'	
	lw	$t4,32($sp)	# temp (j)
	lw	$s3,36($sp)	# get result
	addi	$sp,$sp,36

	jr $ra
######################################################################################################

######################################################################################################
# == bool _generate_word() -------------------------------------------------
#	- use for 	update  word for guessing
# - output:
#	 + @return 0:	out of words
#	 + @return 1: 	still has word
_generate_word:
# DAU THU TUC:
	addi	$sp,$sp,-28
	sw	$t9,0($sp)
	sw	$ra,4($sp)
	sw	$s1,8($sp)	# N
	sw	$t1,12($sp)	# random number $t1 that 0 <= $t0 < N
	sw	$t0,20($sp)	# temp  
	sw	$s0,24($sp)	# number of guessed word
	sw	$t2,28($sp)	# temp2# 

	
# THAN THU TUC:
	lw	$s1,N
	lw	$s0,Marked.N		
	beq	$s0,$s1,_generate_word.runout
_generate_word.random:
	li 	$v0,42
	move 	$a1,$s1
	syscall
	move	$t1,$a0

_generate_word.check_random.loop:
	move	$a0,$t1
	la	$a1,Marked
	la	$a2,Marked.N
	jal	_check_Marked
	beq 	$v0,1,_generate_word.random

_generate_word.getword:	
	
	la 	$a0,buffer
	move 	$a1,$t1
	la 	$a2,test
	jal 	_get_array_I
	addi	$v0,$zero,1
	
	j	_generate_word.exit
_generate_word.runout:
	addi	$v0,$zero,0
_generate_word.exit:
# CUOI THU TUC:
	
	lw	$t9,0($sp)
	lw	$ra,4($sp)
	lw	$s1,8($sp)	# N
	lw	$t1,12($sp)	# random number $t1 that 0 <= $t0 < N
	lw	$t0,20($sp)	# temp  
	lw	$s0,24($sp)	# number of guessed word
	lw	$t2,28($sp)	# temp2# 
	addi	$sp,$sp,28
	jr	$ra
######################################################################################################

######################################################################################################
# == void Hangman(string: word)---------------------------------------------
# 	- input :
#	  + @param 	$a0 = word (string)
#	- Use for:	the playing process of the hangman
_Hangman:
	addi 	$sp,$sp,-32
	sw	$t9,($sp)
	sw 	$ra,4($sp)
	sw 	$s0,8($sp) 	# w?rd
	sw 	$t0,12($sp) 	# i = chance
	sw	$t1,16($sp)	# temp
	sw	$t2,20($sp)	# score
	sw	$t3,24($sp)	# guessing result
	#Lay tham so luu vao thanh ghi
	move 	$s0, $a0

	#Khoi tap vong lap
	li 	$t0, 0 #$t0 = 0
	addi	$t2,$zero,0

	jal	_startSound
#than thu tuc
_Hangman.Lap:

	li 	$v0, 4
	la 	$a0, promt_draw0
	syscall

	li 	$v0, 4
	la 	$a0, promt_draw2
	syscall

	li 	$v0, 4
	la 	$a0, promt_draw3
	syscall
	
	# if i < 1 
	slti 	$t1,$t0,1
	beq 	$t1,1,VeCot1
	li 	$v0, 4
	la 	$a0, promt_draw6 #Ve dau
	syscall
	j Ve2

VeCot1:
	li 	$v0, 4
	la 	$a0, promt_draw4
	syscall
	j Ve2

Ve2:
	#if i < 2 
	slti 	$t1,$t0,2
	beq 	$t1,1,VeCot2
	slti 	$t1,$t0,3
	beq 	$t1,1,VeThan
	slti 	$t1,$t0,4
	beq 	$t1,1,VeTayTrai
	li 	$v0, 4
	la 	$a0, promt_draw9 #Ve tay phai
	syscall
	j Ve3

VeCot2:
	li 	$v0, 4
	la 	$a0, promt_draw4
	syscall
	j Ve3

VeThan:
	li 	$v0, 4
	la 	$a0, promt_draw7
	syscall
	j Ve3

VeTayTrai:
	li 	$v0, 4
	la 	$a0, promt_draw8
	syscall
	j Ve3

Ve3:
	#if i < 5
	slti 	$t1,$t0,5
	beq 	$t1,1,VeCot3
	slti 	$t1,$t0,6
	beq 	$t1,1,VeChanTrai
	li 	$v0, 4
	la 	$a0, promt_draw11 #Ve Chan phai
	syscall
	j Ve4

VeCot3:
	li 	$v0, 4
	la 	$a0, promt_draw4
	syscall
	j Ve4

VeChanTrai:
	li 	$v0, 4
	la 	$a0, promt_draw10
	syscall
	j Ve4

Ve4:
	li 	$v0, 4
	la 	$a0, promt_draw5
	syscall

	slti 	$t1,$t0,6
	beq 	$t1,0,KetThuc
	li 	$v0, 4
	la 	$a0, promt_draw01
	syscall

	la	$a0,guessword
	jal 	_print_guessword

	

	# Tuyen tham so
	la	$a0,test
	# Goi ham nhap
	jal _guessing

	#Kiem tra kq tra ve = 1
	beq 	$v0,1,_Hangman.Lap
	beq	$v0,-1,_Hangman.Lost
	beq	$v0,0,_Hangman.changeWord
	beq	$v0,2,_Hangman.Wrongchar

_Hangman.Lost:
	la	$a0,guessword
	addi	$a1,$zero,'-'
	jal 	_count_different_char_in_word
	add 	$t2,$t2,$v0

	addi 	$t0,$zero,7
	jal	_failSound
	j _Hangman.Lap

_Hangman.Wrongchar:
	la	$a0,guessword
	addi	$a1,$zero,'-'
	jal 	_count_different_char_in_word
	add	$t2,$t2,$v0	

	#i = i + 1
	addi 	$t0,$t0,1
	
	#Kiem tra i < 6
	slti 	$t1,$t0,7
	beq 	$t1,1,_Hangman.Lap
	jal	_failSound
	j KetThuc
_Hangman.changeWord:
	la	$a0,guessword
	addi	$a1,$zero,'-'
	jal 	_count_different_char_in_word
	add 	$t2,$t2,$v0

	jal	_generate_word
	beq	$v0,0,KetThuc
	la	$a0,test
	la	$a1,guessword
	jal 	_generate_guessword
	jal	_successSound
	j _Hangman.Lap
#Cuoi thu tuc
KetThuc:
	
	li 	$v0, 4
	la 	$a0, promt_draw01
	syscall

	#In ra ket thuc game
	li 	$v0,4
	la 	$a0, promt_draw12
	syscall

	sw	$t2,Score

	jal	_endSound
	#Restore
	lw	$t9,($sp)
	lw 	$ra,4($sp)
	lw 	$s0,8($sp) 	# w?rd
	lw 	$t0,12($sp) 	# i = chance
	lw	$t1,16($sp)	# temp
	lw	$t2,20($sp)	# score
	lw	$t3,24($sp)	# guessing result

	addi 	$sp,$sp,32
	jr 	$ra
######################################################################################################

######################################################################################################
# == void Play()---------------------------------------------
#	- Use for:	start playing process
Play:
# DAU THU TUC:
	addi	$sp,$sp,-12
	sw	$t9,($sp)	# throw
	sw	$ra,4($sp)
	sw	$s0,8($sp)	
	sw	$t0,12($sp)	
# THAN THU TUC:	

	li	$v0, 13       	# system call for open file
	la   	$a0, myfin      # board file name
	li   	$a1, 0          # flag for reading
	li   	$a2, 0          # mode is ignored
	syscall            # open a file (file descriptor returned in $v0)
	move 	$s0, $v0      # save the file descriptor 

	li 	$v0, 14 # open file
	move 	$a0,$s0
	la 	$a1, buffer
	li 	$a2, 1024
	syscall

	li 	$v0, 16 # close file
	move 	$a0, $s0
	syscall	

	jal	_update_number_of_word
	jal	_generate_word

	la	$a0,test
	la	$a1,guessword
	jal 	_generate_guessword	
	
	# Truyen tham so
	la 	$a0, test
	# Goi ham ve
	jal 	_Hangman
	move	$t0,$v0

	li	$v0,11
	li	$a0,'\n'
	syscall

# CUOI THU TUC
	lw	$t9,($sp)	# throw
	lw	$ra,4($sp)
	lw	$s0,8($sp)
	lw	$t0,12($sp)
	addi	$sp,$sp,12

	jr 	$ra
######################################################################################################

######################################################################################################
_startSound:
	addi 	$sp,$sp, -24
	sw	$t9,0($sp)
	sw 	$ra,4($sp)
	sw	$v0,8($sp)
	sw	$a0,12($sp)
	sw	$a1,16($sp)
	sw	$a2,20($sp)
	sw	$a3,24($sp)

	li 	$v0, 33
	li 	$a0, 60	# pitch, C#
	li 	$a1, 1500	#duration in milisecond
	li 	$a2, 111	#instrument (0 - 7 piano)
	li 	$a3, 100	#volume
	syscall
	
	lw	$t9,0($sp)
	lw 	$ra,4($sp)
	lw	$v0,8($sp)
	lw	$a0,12($sp)
	lw	$a1,16($sp)
	lw	$a2,20($sp)
	lw	$a3,24($sp)
	addi 	$sp,$sp,24
	jr 	$ra

_failSound:
	addi 	$sp,$sp, -24
	sw	$t9, 0($sp)
	sw 	$ra, 4($sp)
	sw	$v0, 8($sp)
	sw	$a0, 12($sp)
	sw	$a1, 16($sp)
	sw	$a2, 20($sp)
	sw	$a3, 24($sp)
	
	li 	$v0, 33
	li 	$a0, 60	# pitch, C#
	li 	$a1, 2000	#duration in milisecond
	li 	$a2, 119	#instrument (0 - 7 piano)
	li 	$a3, 300	#volume
	syscall	
	
	
	li 	$v0, 31			
	li	$a0, 42				
	li	$a1, 500			
	li	$a2, 111			
	li	$a3, 120
	syscall

	lw	$t9, 0($sp)
	lw 	$ra, 4($sp)
	lw	$v0, 8($sp)
	lw	$a0, 12($sp)
	lw	$a1, 16($sp)
	lw	$a2, 20($sp)
	lw	$a3, 24($sp)
	addi 	$sp,$sp,24
	
	jr 	$ra
	
_successSound:
	addi 	$sp,$sp, -24
	sw	$t9, 0($sp)
	sw 	$ra, 4($sp)
	sw	$v0, 8($sp)
	sw	$a0, 12($sp)
	sw	$a1, 16($sp)
	sw	$a2, 20($sp)
	sw	$a3, 24($sp)
	
	li 	$v0, 33
	li 	$a0, 60	# pitch, C#
	li 	$a1, 2000	#duration in milisecond
	li 	$a2, 119	#instrument (0 - 7 piano)
	li 	$a3, 300	#volume
	syscall	
	
	li 	$v0, 31				
	li	$a0, 60				
	li	$a1, 300			
	li	$a2, 12				
	li	$a3, 127			
	syscall
	
	li	$v0, 32
	li	$a0, 50
	syscall
	
	li 	$v0, 31				
	li	$a0, 62				
	li	$a1, 300			
	li	$a2, 12				
	li	$a3, 127			
	syscall
	
	li	$v0, 32
	li	$a0, 50
	syscall
	
	li 	$v0, 31				
	li	$a0, 64				
	li	$a1, 300			
	li	$a2, 12				
	li	$a3, 127			
	syscall	
	
	li	$v0, 32
	li	$a0, 50
	syscall
	
	li 	$v0, 31				
	li	$a0, 67				
	li	$a1, 300			
	li	$a2, 12				
	li	$a3, 127			
	syscall
	
	li	$v0, 32
	li	$a0, 150
	syscall
	
	li 	$v0, 31				
	li	$a0, 72				
	li	$a1, 400			
	li	$a2, 12				
	li	$a3, 127			
	syscall
	
	lw	$t9, 0($sp)
	lw 	$ra, 4($sp)
	lw	$v0, 8($sp)
	lw	$a0, 12($sp)
	lw	$a1, 16($sp)
	lw	$a2, 20($sp)
	lw	$a3, 24($sp)
	addi 	$sp,$sp,24
	
	jr 	$ra
	
_endSound:
	addi 	$sp,$sp, -24
	sw	$t9, 0($sp)
	sw 	$ra, 4($sp)
	sw	$v0, 8($sp)
	sw	$a0, 12($sp)
	sw	$a1, 16($sp)
	sw	$a2, 20($sp)
	sw	$a3, 24($sp)

	li 	$v0, 33
	
	li 	$a0, 60	# pitch, C#
	li 	$a1, 600	#duration in milisecond
	li 	$a2, 111	#instrument (0 - 7 piano)
	li 	$a3, 100	#volume
	syscall
	li 	$v0, 32
	li	$a0, 50
	syscall		
	li 	$v0, 33
	li 	$a0, 60	# pitch, C#
	li 	$a1, 600	#duration in milisecond
	li 	$a2, 111	#instrument (0 - 7 piano)
	li 	$a3, 100	#volume
	syscall
	li 	$v0, 32
	li	$a0, 50
	syscall	
	li 	$v0, 33
	li 	$a0, 60	# pitch, C#
	li 	$a1, 600	#duration in milisecond
	li 	$a2, 111	#instrument (0 - 7 piano)
	li 	$a3, 100	#volume
	syscall
	
	
	lw	$t9, 0($sp)
	lw 	$ra, 4($sp)
	lw	$v0, 8($sp)
	lw	$a0, 12($sp)
	lw	$a1, 16($sp)
	lw	$a2, 20($sp)
	lw	$a3, 24($sp)
	addi 	$sp,$sp,24
	
	jr 	$ra
_delaySleep:
	addi 	$sp,$sp, -12
	sw	$t9, 0($sp)
	sw 	$ra, 4($sp)
	sw	$v0, 8($sp)
	sw	$a0, 12($sp)

	li 	$v0, 32
	li	$a0, 2000
	syscall	
		
	lw	$t9, 0($sp)
	lw 	$ra, 4($sp)
	lw	$v0, 8($sp)
	lw	$a0, 12($sp)
	addi 	$sp,$sp, 12
	
	jr 	$ra	
######################################################################################################

# ==================== _stop_runing ============================================================ #
######################################################################################################
# == _stop_runing -------------------------------------------------
#	- Use for:	Exit program
_stop_runing:


	# Ket thuc 
	li	$v0,10
	syscall
######################################################################################################

.data
	# dung duong dan tuyet doi hoac duong dan tu Mars.jar
	fin: .asciiz "F:\\may\\asm\\input.txt" 
	buffer: .space 1024
	n: .word 0 
	separate: .word '*'
	n1: .word 0
	tb1: .asciiz "Nhap vi tri: "
	arr: .byte 100
.text
	li   $v0, 13       # system call for open file
	la   $a0, fin      # board file name
	li   $a1, 0           # flag for reading
	li   $a2, 0           # mode is ignored
	syscall            # open a file (file descriptor returned in $v0)
	move $s6, $v0      # save the file descriptor 

	li $v0, 14 # doc file
	move $a0,$s6
	la $a1, buffer
	li $a2, 1024
	syscall

	li $v0, 16 # dong file
	move $a0, $s6
	syscall

	li $v0, 4
	la $a0, tb1
	syscall

	li $v0,5
	syscall

	#truyen tham so
	la $a0, buffer
	move $a1, $v0
	la $a2, n1
	la $a3, arr

	#goi ham cau hoi
	jal _Questions

#===== Phan nay de test ket qua cua arr =====
	#truyen tham so
	lw $a0,n1
	la $a1, arr

	#goi ham xuat mang
	jal _XuatMang

	#ket thuc
	li $v0, 10
	syscall

#======= Luu input vao mang ======
#dau thu tuc
_Questions:
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0, 4($sp) # buffer: cac tu trong file
	sw $s1, 8($sp) # n: vi tri
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $s4, 20($sp) # n1: do dai cua tu
	sw $t4, 24($sp) # dem so luong ki tu cua tu
	sw $s5, 28($sp) # arr

	#Lay tham so luu vao thanh ghi
	move $s0, $a0 # buffer
	move $s1, $a1 # n
	move $s4, $a2 # n1
	move $s5, $a3 # arr
	li $t2, '*'

	#Khoi tap vong lap
	li $t1, 1 # i: bat dau voi tu ?au tien, kiem tra khi nao i == n
	li $t4, 0 # so luong ki tu = 0
	

_QuestionsLoop:
	beq $t1,$s1,slice # kiem tra i == n
	lb $s2, 0($s0) # lay ki tu cua buffer
	
	beq $s2, $zero, exit # kiem tra ki tu ket thuc buffer
	
	beq $s2, $t2,TangJ # kiem tra neu la ki tu * thi tang i
	addi $s0,$s0,1 # buffer + 1
	j _QuestionsLoop

slice: #_ _ _ _ *
	lb $s2, 0($s0) # lay ki tu cua buffer
	sb $s2,($s5) # luu ki tu vao arr

	beq $s2, $zero, exit # kiem tra ki tu ket thuc buffer

	beq $s2, $t2,exit # kiem tra neu la ki tu * thi thoat
	addi $s5,$s5,1 # arr + 1
	addi $t4, $t4,1 # so luong ki tu + 1
	addi $s0,$s0,1 # buffer + 1
	j slice

TangJ:
	addi $t1,$t1,1 # i = i + 1
	addi $s0,$s0,1	# buffer + 1
	j _QuestionsLoop

exit:
	sw $t4, ($s4)
	#Restore
	lw $ra,($sp)
	lw $s0, 4($sp) 
	lw $s1, 8($sp) 
	lw $t1, 16($sp)
	lw $t2, 20($sp)
	lw $s3, 24($sp) 
	lw $s4, 28($sp)
	lw $t4, 32($sp)
	lw $s5, 36($sp)

	addi $sp,$sp,32
	jr $ra

#====== Xuat mang ======
_XuatMang:
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0, 4($sp) #n
	sw $s1, 8($sp) #arr
	sw $t0, 12($sp)
	sw $t1, 16($sp)

	move $s0,$a0 #n
	move $s1,$a1 #arr

#Than thu tuc

	#Khoi tao vong lap
	li $t0,0 #i = 0

_XuatMang.Lap:
	#Xuat a[i]
	li $v0,11
	lb $a0,($s1)
	syscall

	addi $s1,$s1,1
	addi $t0,$t0,1

	#Kiem tra i < n
	slt $t1,$t0,$s0
	beq $t1,1,_XuatMang.Lap

#Cuoi thu tuc
	#Restore
	lw $ra,($sp)
	lw $s0, 4($sp) #n
	lw $s1, 8($sp) #arr
	lw $t0, 12($sp)
	lw $t1, 16($sp)

	addi $sp,$sp,32
	jr $ra
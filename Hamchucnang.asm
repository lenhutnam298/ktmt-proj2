.data
	EnterName: .asciiz "Nhap ten (A-Z, a-z, 0-9): \n"
	tb1: .asciiz "Nhap mot ky tu: "
	tb2: .asciiz "\nCo ki tu '_'"
	tb3: .asciiz "\nNhap sai!! Vui long nhap lai:\n"
	tb4: .asciiz "\nKi tu vua nhap la: "
	Name: .space 30

.text
main:
	#Xuat EnterName
	li $v0,55
	la $a0,EnterName
	li $a1 ,1
	syscall
	
	#Nhap ten
	li $v0,8
	la $a0,Name
	li $a1,30
	syscall

NhapKiTu:	
	#Xuat tb1
	li $v0,4
	la $a0,tb1
	syscall
	#Nhap ky tu
	add $v0,$zero,12
	syscall
	#Luu ky tu vao $t0
	move $t0,$v0
CheckChar:
	#Kiem tra ki tu '_'
	beq $t0,95,True
	#Kiem tra nhap sai
	slti $t1,$t0,65
	beq $t1,1,NhapSai
	slti $t1,$t0,91
	beq $t1,1,ChuyenChuThuong
	slti $t1,$t0,97
	beq $t1,1,NhapSai
	slti $t1,$t0,123
	beq $t1,1,NhapDung
	slti $t1,$t0,128
	beq $t1,1,NhapSai	


	j Thoat

True:
	#Xuat tb2
	li $v0,4
	la $a0,tb2
	syscall
	
	j Thoat

NhapSai:
	#Xuat tb3
	li $v0,4
	la $a0,tb3
	syscall
	j NhapKiTu

ChuyenChuThuong:
	#Xuat tb4
	li $v0,4
	la $a0,tb4
	syscall
	#Xuat ki tu vua nhap
	addi $t1,$t0,32
	addi $v0,$zero,11
	add $a0,$zero,$t1
	syscall
	
	j Thoat

NhapDung:
	#Khong can check nua
	#Xuat tb4
	li $v0,4
	la $a0,tb4
	syscall
	#Xuat ki tu vua nhap
	addi $v0,$zero,11
	add $a0,$zero,$t0
	syscall
	
	j Thoat
Thoat: 
	li $v0,10
	syscall

# Kiem tra so doi xung

.data
	input_asciiz: .asciiz "Nhap so nguyen can kiem tra: "
	is_palindrome_asciiz: .asciiz "La so doi xung.\n"
	not_palindrome_asciiz: .asciiz "Khong la so doi xung.\n"

.text
.globl main
main:
	jal print_input
	jal read_input_number_a1

	#a2 = a1
	add $a2, $zero, $a1
	# $t1: store reverse number
	li $t1, 0
	# $t2 = 10
	li $t2, 10

	jal loop

	j print_not_palindrome

loop:
	# a2 = a2 div 10; t3 = a2 mod 10
	div $a2, $t2
	mfhi $t3
	mflo $a2

	# t1 = t1 + t3
	add $t1, $t1, $t3
	
	# t1 == a1 => palindrome number
	beq $t1, $a1, print_is_palindrome

	# a2 == 0 => end loop, the number is not palindrome numb?
	beqz $a2, print_not_palindrome

	mult $t1, $t2
	mflo $t1
	j loop
	

print_input:
	li $v0, 4
	la $a0, input_asciiz
	syscall

	jr $ra

read_input_number_a1:
	li $v0, 5
	syscall
	move $a1, $v0
	
	jr $ra

print_is_palindrome:
	li $v0, 4
	la $a0, is_palindrome_asciiz
	syscall

	j exit

print_not_palindrome:
	li $v0, 4
	la $a0, not_palindrome_asciiz
	syscall

exit:
	li $v0, 10
	syscall

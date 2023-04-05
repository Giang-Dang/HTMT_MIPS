#Kiem tra so nguyen to

.data
	input_asciiz: .asciiz "Nhap so nguyen can kiem tra: "
	is_prime_asciiz: .asciiz "La so nguyen to.\n"
	not_prime_asciiz: .asciiz "Khong la so nguyen to.\n"
.text
.globl main

main:
	jal print_input
	jal read_input_number_a1

	#if input_number <= 1, call print_is_not_prime:
	li $t2, 1
	sub $t1, $a1, $t2
	blez $t1, print_not_prime

	#else initalize $t1 as iterator
	li $t1, 2
	j loop
	
loop:
	#if i*i > number, call print_not_prime
	mul $t2, $t1, $t1
	bgt $t2, $a1, print_is_prime

	#if number mod i == 0, call print_not_prime
	div $a1, $t1
	mfhi $t2
	beqz $t2, print_not_prime
	
	#i++ then continue looping
	addi $t1, $t1, 1
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

print_is_prime:
	li $v0, 4
	la $a0, is_prime_asciiz
	syscall

	j exit

print_not_prime:
	li $v0, 4
	la $a0, not_prime_asciiz
	syscall
	
	j exit

exit:
	li $v0, 10
	syscall

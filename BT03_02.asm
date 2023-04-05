# kiem tra so hoan thien

.data
	input_asciiz: .asciiz "Nhap so nguyen can kiem tra: "
	is_perfect_asciiz: .asciiz "La so hoan thien.\n"
	not_perfect_asciiz: .asciiz "Khong la so hoan thien.\n"
.text
.globl main

main:
	jal print_input
	jal read_input_number_a1

	# initalize $t1 as iterator 
	li $t1, 0
	# $a2 as sum
	li $a2, 0
	# $t2 = $a1/2
	li $t2, 2
	div $a1, $t2
	mflo $t2
	jal check_perfect_a1_loop_t1
	
	#if $a1 == $a2
	beq $a1, $a2, print_is_perfect
	#else
	j print_not_perfect
	
check_perfect_a1_loop_t1:
	# i++
	addi $t1, $t1, 1

	# if number mod i == 0, sum += quotient
	div $a1, $t1
	mfhi $t3
	beqz $t3, sum_quotients_t1_a2

	#if i <= $t2, continue loop
	sub $t4, $t1, $t2
	blez $t4, check_perfect_a1_loop_t1
	#else, continue main function
	jr $ra

sum_quotients_t1_a2:
	add $a2, $a2, $t1
	j check_perfect_a1_loop_t1

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

print_is_perfect:
	li $v0, 4
	la $a0, is_perfect_asciiz
	syscall

	j exit

print_not_perfect:
	li $v0, 4
	la $a0, not_perfect_asciiz
	syscall
	
	j exit

exit:
	li $v0, 10
	syscall

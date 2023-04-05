# Kiem tra so chinh phuong

.data
	input_asciiz: .asciiz "Nhap so nguyen can kiem tra: "
	is_square_num_asciiz: .asciiz "La so chinh phuong.\n"
	not_square_num_asciiz: .asciiz "Khong la so chinh phuong.\n"

.text
.globl main
main:
	jal print_input
	jal read_input_number_a1
	
	li $t1, 0
	jal loop
	j print_not_square_num
loop:
	addi $t1, $t1, 1

	mult $t1, $t1
	mflo $t2
	beq $a1, $t2, print_is_square_num

	blt $t2, $a1, loop
	jr $ra

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

print_is_square_num:
	li $v0, 4
	la $a0, is_square_num_asciiz
	syscall

	j exit

print_not_square_num:
	li $v0, 4
	la $a0, not_square_num_asciiz
	syscall

exit:
	li $v0, 10
	syscall

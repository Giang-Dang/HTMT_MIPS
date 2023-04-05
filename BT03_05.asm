.data
	menu_asciiz: .asciiz "-----------------------------------\nBai tap 05:\n===========================\n1. Nhap mang 1 chieu n phan tu so nguyen.\n2. Xuat mang.\n3. Liet ke cac so nguyen to.\n4. Tim gia tri lon nhat trong mang.\n5. Tinh trung binh mang.\n===========================\nChon so tuong ung roi an enter (nhan phim khac de thoat): "
	input_size_asciiz: .asciiz "Nhap kich thuoc cua mang: "
	input_element_1_asciiz: .asciiz "Nhap phan tu "
	input_element_2_asciiz: .asciiz " : "
	print_elements_asciiz: .asciiz "Cac phan tu trong mang la: "
	primes_asciiz: .asciiz "Cac so nguyen to: "
	max_asciiz: .asciiz "So lon nhat trong mang la: "
	avg_asciiz: .asciiz "Trung binh cong cua cac so trong mang la: "
	space : .asciiz " "
	endline: .asciiz "\n"
.text
.globl main
main:
	# print menu
	li $v0, 4
	la $a0, menu_asciiz
	syscall
	
	# read user's choice
	li $v0, 5
	syscall
	move $s4, $v0

	beq $s4, 1, input_array
	beq $s4, 2, print_array
	beq $s4, 3, primes
	beq $s4, 4, max
	beq $s4, 5, avg
	
	j exit

input_array:
	# print announcement
	li $v0, 4
	la $a0, input_size_asciiz
	syscall

	# read size of array
	li $v0, 5
	syscall
	# $s0: elementCount 
	move $s0, $v0

	# calculate size
	li $t0, 4 # 4 bytes/1 int number
	mult $s0, $t0
	mflo $a0
	
	# allocate
	li $v0, 9 # sbrk
	syscall

	# store array address to $s1
	move $s1, $v0

	# prepare for input_loop
	li $t1, 0 # iterator $t1 for input element
	jal input_loop
	
	# return to main function
	j main
	
input_loop:
	# i++
	addi $t1, $t1, 1
	
	# return to input_array function
	bgt $t1, $s0, return
	
	# print announcement
	li $v0, 4
	la $a0, input_element_1_asciiz
	syscall

	# print i
	li $v0, 1
	add $a0, $t1, $zero
	syscall
	
	# print announcement
	li $v0, 4
	la $a0, input_element_2_asciiz
	syscall

	# read element input
	li $v0, 5
	syscall
	
	# store element
	# t2 = t1 * 4
	sll $t2, $t1, 2
	# t2 = s1 + t2
	add $t2, $s1, $t2
	sw $v0, ($t2)

	j input_loop

print_array:
	# print announcement
	li $v0, 4
	la $a0, print_elements_asciiz
	syscall
	
	# prepare for print_elements_loop
	li $t1, 0 # iterator $t1 for print_elements_loop
	jal print_elements_loop

	# print endline
	li $v0, 4
	la $a0, endline
	syscall

	# return to main function
	j main

print_elements_loop:
	# i++
	addi $t1, $t1, 1
	
	# return to print_array function
	bgt $t1, $s0, return
	
	#load element
	# t2 = t1 * 4
	sll $t2, $t1, 2
	# t2 = s1 + t2
	add $t2, $s1, $t2
	lw $a0, ($t2)

	# print element
	li $v0, 1
	syscall

	# print space
	li $v0, 4
	la $a0, space
	syscall

	j print_elements_loop

primes:
	# print announcement
	li $v0, 4
	la $a0, primes_asciiz
	syscall
	
	# prepare for print_primes_loop
	li $t1, 0 # iterator $t1 for print_primes_loop
	jal print_primes_loop

	# print endline
	li $v0, 4
	la $a0, endline
	syscall

	# return to main function
	j main

print_primes_loop:
	# i++
	addi $t1, $t1, 1
	
	# return to primes function
	bgt $t1, $s0, return
	
	#load element
	# t2 = t1 * 4
	sll $t2, $t1, 2
	# t2 = s1 + t2
	add $t2, $s1, $t2
	lw $t3, ($t2) #t3 : current number

	# check if current number is a prime number
	#if input_number <= 1 -> next element:
	li $t5, 1
	sub $t5, $t3, $t5
	blez $t5, print_primes_loop

	#else initalize $t4 as iterator
	li $t4, 2
	
	is_prime_loop:
		#if i*i > number, call print_prime
		mul $t5, $t4, $t4
		bgt $t5, $t3, print_prime

		#if number mod i == 0, continue
		div $t3, $t4
		mfhi $t5
		beqz $t5, print_primes_loop
	
		#i++ then continue looping
		addi $t4, $t4, 1
		j is_prime_loop
	
	print_prime:
		# print current element
		move $a0, $t3
		li $v0, 1
		syscall

		# print space
		li $v0, 4
		la $a0, space
		syscall
	
	j print_elements_loop
	
max:
	# print announcement
	li $v0, 4
	la $a0, max_asciiz
	syscall
	
	# prepare for max_loop
	li $t1, 0 # iterator $t1 for input element
	li $t3, 0 # $t3 stores max value
	jal max_loop
	
	# print result stored in $t3
	move $a0, $t3
	li $v0, 1
	syscall
	
	# print endline
	li $v0, 4
	la $a0, endline
	syscall

	# return to main function
	j main

max_loop:
	# i++
	addi $t1, $t1, 1
	
	# return to max func
	bgt $t1, $s0, return
	
	#load element
	# t2 = t1 * 4
	sll $t2, $t1, 2
	# t2 = s1 + t2
	add $t2, $s1, $t2
	lw $t4, ($t2)

	# t3 = max(t3, t4)
	sub $t5, $t3, $t4
	bltz $t5, get_min
	get_min:
		bgtz $t5, go_again
		move $t3, $t4

	go_again:
	j max_loop

sum_loop:
	# i++
	addi $t1, $t1, 1
	
	# return to input_array func
	bgt $t1, $s0, return
	
	#load element
	# t2 = t1 * 4
	sll $t2, $t1, 2
	# t2 = s1 + t2
	add $t2, $s1, $t2
	lw $t4, ($t2)

	# sum += element
	add $t3, $t3, $t4

	j sum_loop

avg:
	# print announcement
	li $v0, 4
	la $a0, avg_asciiz
	syscall
	
	# prepare for sum_loop
	li $t1, 0 # iterator $t1 for input element
	li $t3, 0 # $t3 stores sum value
	jal sum_loop
	
	# convert sum to float $f0
	mtc1 $t3, $f0
	cvt.s.w $f0, $f0
	
	# convert elementCount to float $f1
	mtc1 $s0, $f1
	cvt.s.w $f1, $f1
	
	# calculate avg in float
	div.s $f12, $f0, $f1

	# print result
	li $v0, 2
	syscall
	
	# print endline
	li $v0, 4
	la $a0, endline
	syscall

	# return to main function
	j main

return:
	jr $ra

exit:
	li $v0, 10
	syscall


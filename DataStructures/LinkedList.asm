# Double LinkedList with node head.  
# Struct Node has next and prev node pointer,
# and have a value.
# Search = O(n).
# Insert = O(1), front or back.
# Remove = O(n).
	.data 				# Stores data in RAM
	.align 2			# Aligns data by word
list_pointer:
	.word 0				# Create space(4 bytes) in RAM with NULL(0) value
	.align 0 			# Aligns data by byte		
# Error messages
msg_null_list:			
	.asciz "Error: null list.\n"
	
# Strings to format output
space:				
	.asciz " "
	
	.text 				# Code
	.align 2 			# Instructions aligned by word (32 bits)
	.globl main 			# Sets main as program start
main:
	# Create list
	jal list
	mv s0, a0
	mv a0, s0	
	li a1, 1
	jal list_push_back
	mv a0, s0	
	li a1, 2
	jal list_push_back
	mv a0, s0	
	li a1, 3
	jal list_push_front
	mv a0, s0	
	li a1, 4
	jal list_push_front
	mv a0, s0	
	li a1, 5
	jal list_push_back
	mv a0, s0	
	li a1, 1
	jal list_size
	
	li a7, 1
	ecall
	
	# Ends programn
	li a7, 10			# Syscall code 10: end programn
	ecall				# Syscall to stop running
	
# Function that creates a list
# Argument:
# a0: returns address of list
list:
	# Allocates - Control structure
	li a7, 9 			# Syscall code 9: allocate memory on heap
	li a0, 8			# Size to be allocated = 4 bytes(adress) + 4 bytes(list size)
	ecall 				# Syscall to allocate memory on the heap
	mv t0, a0			# Save list adress
	
	# Allocates - Head node
	li a0, 12			# 4 bytes - value + 8 bytes - prev and next node
	ecall				# Syscall to allocate memory on the heap
	mv t1, a0			# Save head node adress

	# Inicializates fields and head node
	sw t1, 0(t0) 			# Set pointer to head node
	sw zero, 4(t0)			# Size of a empty list is zero
	sw t1, 4(t1)			# Prev head node is head node
	sw t1, 8(t1)			# Next head node is head node
	li t2, -1			# Value of the head node
	sw t2, 0(t1)			# [-1, head node, head node]
	
	# Return list adress
	mv a0, t0
	
	jr ra 				# Jump to return address

# Function that inserts an element in end of the list
# Argument:
# a0: list address
# a1: value to be saved in node (int)
list_push_back:
	# Copying the list address to t0 
	mv t0, a0 			# t0 now holds the first byte of the list address
	
	# Catch possible error(dont try to acess null pointer)
	beqz t0, error_null_list	# t0 = 0, list dont exist(null pointer)

	# Allocates memory in heap 
	# struct node { int value; int adressPrevNode; int adressNextNode;} -> 12 bytes
	li a7, 9 			# Syscall code 9: allocate memory on heap
	li a0, 12 			# Size to be allocated: 12 bytes
	ecall 				# Syscall to allocate memory on the heap
	mv t1, a0			# Move to t0 the adress of the new node

	# Save data(adress of prev and next node, and number)
	lw t2, 0(t0)			# Get node head(t2)
	lw t3, 4(t2)			# Get prev node from head(t3)
	sw t1, 8(t3)			# Turn new node next node of last node(t3->next = t1)
	sw t3, 4(t1)			# Turn last node prev node of new node(t1->prev = t3)
	sw t1, 4(t2)			# Turn new node prev node of head node(t2->prev = t1)
	sw t2, 8(t1)			# Turn head node next node of new node(t1->next = t2)
	sw a1, 0(t1)			# new node receive value(t1->value = number)
	
	# Update size of list
	lw t1, 4(t0)			# Read the current size of list
	addi t1, t1, 1			# Increment one to size of list
	sw t1, 4(t0)			# Save new size

	jr ra # Jump to return address
	
# Function that inserts an element in begin of the list
# Argument:
# a0: list address
# a1: value to be saved in node (int)
list_push_front:
	# Copying the list address to t0 
	mv t0, a0 			# t0 now holds the first byte of the list address
	
	# Catch possible error(dont try to acess null pointer)
	beqz t0, error_null_list	# t0 = 0, list dont exist(null pointer)

	# Allocates memory in heap 
	# struct node { int value; int adressPrevNode; int adressNextNode;} -> 12 bytes
	li a7, 9 			# Syscall code 9: allocate memory on heap
	li a0, 12 			# Size to be allocated: 12 bytes
	ecall 				# Syscall to allocate memory on the heap
	mv t1, a0			# Move to t0 the adress of the new node

	# Save data(adress of prev and next node, and number)
	lw t2, 0(t0)			# Get node head(t2)
	lw t3, 8(t2)			# Get next node from head(t3)
	sw t1, 4(t3)			# Turn new node prev node of begin node(t3->prev = t1)
	sw t3, 8(t1)			# Turn begin node next node of new node(t1->next = t3)
	sw t1, 8(t2)			# Turn new node next node of head node(t2->next = t1)
	sw t2, 4(t1)			# Turn head node prev node of new node(t1->prev = t2)
	sw a1, 0(t1)			# new node receive value(t1->value = number)
	
	# Update size of list
	lw t1, 4(t0)			# Read the current size of list
	addi t1, t1, 1			# Increment one to size of list
	sw t1, 4(t0)			# Save new size

	jr ra # Jump to return address
	
# Function that removes an element out the list
# Argument:
# a0: list address
# a1: value to be removed
list_remove:
	# t0: list adress
	# t1: head node
	# t2: element to be removed
	# t3: aux
	# t4: aux
	# Save the list adress
	mv t0, a0			# t0 = list adress

   	# Catch possible error(dont try to acess null pointer)
	beqz t0, error_null_list	# t0 = 0, list dont exist(null pointer)
    	
    	# Start logic to search element to be removed
    	lw t1, 0(t0)			# Get adress of head node
    	sw a1, 0(t1)			# Insert in head node value to be search
    	lw t2, 8(t1)			# First element of the list
    	
loop_list_remove:
    	# Continue search to next node
    	lw t2, 8(t2)			# t2 = t2->next
    	lw t3, 0(t2)			# Get element to check
    	
	# Branch if element is not the searched
    	bne a1, t3, loop_list_remove
	
	# Check if the element is in the head(element not in the list)
	beq t1, t2, end_list_remove	# If the same pointer, branch

	# Remove element and keep the list linked
	lw t3, 4(t2)			# Prev element of the node to be removed
	lw t4, 8(t2)			# Next element of the node to be removed
	sw t4, 8(t3)			# t3->next = t4
	sw t3, 4(t4)			# t4->prev = t3
	sw zero, 4(t2)			# t2->prev = NULL
	sw zero, 8(t2)			# t2->next = NULL

	# Update size of list
	lw t3, 4(t0)			# Read the current size of list
	addi t3, t3, -1			# Decrement one to size of list
	sw t3, 4(t0)			# Save new size

end_list_remove: 
	# Return value of head node to -1
	li t3, -1			# Prepare to be insert
	sw t3, 0(t1)			# headNode->value = -1

    	jr ra				# Jump to return address	
	
	
# Function to check if the element is in the list
# Argument:
# a0: list adress
# a1: value to be check
# Return:
# a0: value is in the list ? 1:0
list_find:
	# Save the list adress
	mv t0, a0			# t0 = list adress

   	# Catch possible error(dont try to acess null pointer)
	beqz t0, error_null_list	# t0 = 0, list dont exist(null pointer)
    	
    	# Start logic to search element to be removed
    	lw t1, 0(t0)			# Get adress of head node
    	sw a1, 0(t1)			# Insert in head node value to be search
    	lw t2, 8(t1)			# First element of the list
    	
loop_list_find:
    	# Continue search to next node
    	lw t2, 8(t2)			# t2 = t2->next
    	lw t3, 0(t2)			# Get element to check
    	
	# Branch if element is not the searched
    	bne a1, t3, loop_list_find
	
	# Check if the element is in the head(element not in the list)
	xor a0, t1, t2			# 0 if t1 = t2, otherwise a0 != 0
	snez a0, a0			# a0 != 0 -> a0 = 1
	
	# Return value of head node to -1
	li t3, -1			# Prepare to be insert
	sw t3, 0(t1)			# headNode->value = -1

    	jr ra				# Jump to return address
	
# Function to verify if the list is empty
# Argument: 
# a0: address of list
# Return: 
# a0: 1 if list is empty, otherwise 0
list_empty:
	# Copying the list address to t0 
	mv t0, a0 			# t0 now holds the first byte of the list address
	
	# Catch possible error(dont try to acess null pointer)
	beqz t0, error_null_list	# t0 = 0, list dont exist(null pointer)
	
	# Get size of the list
	lw t1, 4(t0)			# t1 = size of the list
	seqz a0, t1			# If t1 = 0, list is empty 
	
	jr ra               		# Return with value in a0
	
# Function to return the size of list
# Argument: 
# a0: adress of list
# Return:
# a0: size of list
list_size:
	# Copying the list address to t0 
	mv t0, a0 			# t0 now holds the first byte of the list address
	
	# Catch possible error(dont try to acess null pointer)
	beqz t0, error_null_list	# t0 = 0, list dont exist(null pointer)
	# Return size of list
	lw a0, 4(t0)			# t0 [adress of first node, size of list]
	jr ra				# Return size in a0
	
# Function to print list (-1 if list dont exist)
 # Argument:
# a0: list adress
list_print:
 	# Copying the list address to t0 
 	mv t0, a0 			# t0 now holds the first byte of the list address
 
 	# Catch possible error(dont try to acess null pointer)
 	beqz t0, error_null_list	# t0 = 0, list dont exist(null pointer)
 	
 	# Get top to iterate through the list
 	lw t1, 0(t0) 			# Loading t1 the head node adress
 	lw t2, 8(t1)			# Load adress of begin node in t2
 
loop_list_print:
 	# If current node dont exist(t1 == 0), break
 	beq t1, t2 loop_list_print_exit
 
 	# Read data of the current node
 	lw a0, 0(t2) 			# Load value
 	lw t2, 8(t2)			# Load adress to next node
 					# OBS: t1 is saving the adress of the nodes
 	# Print current value
 	li a7, 1			# Syscall code 1: print int
 	ecall 				# Syscall to print value in a0
 	
 	# Separate numbers by space
	li a7, 4 			# Syscall code 4: print a string
	la a0, space 			# Load 1st byte adress
	ecall 				# Syscall to print string
 	
 	j loop_list_print		# Continue to print values
 	
loop_list_print_exit:		
	# End function
	jr ra 				# Jump to return address
 					
	
# Function to print error message
# in case of a list_null
error_null_list:
	# Print error message
	li a7, 4 			# Syscall code 4: print a string
	la a0, msg_null_list 		# Load 1st byte of msg in a0
	ecall 				# Syscall to print message
	
	# End programn
	li a7, 10 			# Syscall code 10: end programn
	ecall 				# Syscall to end program

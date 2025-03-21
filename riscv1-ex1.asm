# Imprime string "Hello World!"
	.data # dados do programa	
hello_msg: .asciz "Hello World!" #String a ser impressa
			
	.text # Código do programa
	.globl main # Defini main como entrada do programa
main: 	
	# Carrega para o registrador a7
	# 4 - instrução para imprimir string na saída padrão
	addi  a7, zero, 4 # = li a7, 4
	
	# la<reg><label> - load adress = auipc + addi
	# Carrega o enderço da memoria no a0
	la a0, hello_msg
		
	ecall 	# Chamada ao sistema(ecall) pega do a7.
	# Código da função(a7) 
	# 10(serviço que encerra programa)
	li a7, 10
	ecall
	 
	
	 
	

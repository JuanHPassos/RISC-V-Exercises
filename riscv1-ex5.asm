# Imprima o tamanho de uma string
	.data # Guarda dados na memoria RAM
	.align 0
string: .asciz "USP e a maior universidade do Brasil" #36 caracteres

	.text
	.align 2 # Instruções do tamanho de uma palavra(32 bits)
	.globl main
main:	
	# Preparar para percorrer o array(string)
	la t0, string # Pegar posição de início
	li t1, 0 # Contador
	beqz t1, loop # Sempre entrará no loop
		
loop:
	# Percorre string até achar 0
	lb t6, 0(t0) # Le bit atual da memoria t0
	beqz t6, tam_string # Se for o 0, branch
	
	addi t1, t1, 1 # Incrementa contador
	addi t0, t0, 1 # Próximo bit da memória
	
	j loop # Retorna para o início do loop
	
	# Sempre saíra do loop
	
tam_string: 
	# Imprimir tamanho da String
	li a7, 1 # Comando 5 imprimi número
	add a0, zero, t1 # Add tam string ao a0
	ecall # Chamada do sistema para imprimir
	
	# Encerrar programa
	li a7, 10 # Comando para encerrar programa
	ecall # Chamada do sistema para encerrar programa
	
	
	
	
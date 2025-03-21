# Calcula a soma dos elementos de um vetor
	.data # Armazena dados na memória RAM
	.align 1 # Alinha números na coluna 00 e 10	
tam_vetor:
	.half 10 # Tamanho do array
vetor: 	
	.half 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 # vetor de inteiros

	.text # Código
	.align 2 # Instruções por palavra(32 bits)
	.globl main # Define main como entrada do programa
main:
	# Preparar loop para iterar array
	la t0, tam_vetor # Carrega endereço em t0
	lh s0, 0(t0) # Le uma palavra da memoria(parte de t0)
	# s0 armazena o tamanho do vetor
	
	la t0, vetor # Carrega endereço inicial do vetor
	li t1, 0 # Contador
	li a0, 0 # Guarda soma dos elementos
	
	#Iniciar loop para calcular soma dos elementos do array
	beqz t1, loop
	
loop:
	beq t1, s0, imprimir_soma # branch, se percorreu todos os elementos(contador = tamanho)
	addi t1, t1, 1 # Incrementa contador
	lh t6, 0(t0) # Le uma palavra da posição t0
	add a0, a0, t6 # Acumula soma com o elemento atual
	addi t0, t0, 2 # Pula para o próximo inteiro
	
	j loop # Continua loop
	
imprimir_soma:
	# Imprimir soma dos elementos do vetor
	li a7, 1 # Comando para imprimir numero
	ecall
	
	# Encerra programa
	li a7, 10
	ecall
	
	
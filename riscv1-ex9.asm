# O numero USP de um aluno, costuma ser secreto,
# assim, para ocultar essa informação, voce devera ler
# 8 digitos e armazena-los em apenas uma palavra na memoria.
# Saida: imprima a concatenção resultante

	.data # Armazena na memória RAM
	.align 2
val_concat:
	.space 4
n_usp:
	.space 32
	
	.text # Inicia Código
	.align 2 # Instruções por palavra
	.globl main # Define main como entrada do programa
main:
	# Ler primeiro número
	li a7, 5 # Comando 5 - ler inteiro
	li t0, 0 # Inicializar t0
	li t1, 7 # Contador(4 numeros em uma palavra)
	
loop:
	ecall # Chama sistema para ler(guarda em a0)
	add t0, t0, a0 # Salva valor em t0
	slli t0, t0, 4 # Shift 1 byte
	addi t1, t1, -1 # Decrementa contador
	bnez t1, loop # t1 != 0, continua leitura
	
	# Terminar de ler ultimo número
	# obs: não há shift no ultimo
	ecall # Chama sistema para ler(guarda em a0)
	add t0, t0, a0 # Salva valor em t0
	
	# Guarda valor na memória
	la s0, val_concat
	sw t0, 0(s0)
	
	# Imprimir resultado
	li a7, 1 # Comando imprimir inteiro
	add a0, zero, t0 # Prepara numero a ser impresso
	ecall # Chama sistema para imprimir
	
	# Encerra programa
	li a7, 10 # Comando 10 encerra programa
	ecall # Chama sistema para encerrar	
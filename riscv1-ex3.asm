# Soma dois inteiros e armazena o resultado na memória
	.data
	.align 2 # Alinha conteudo por palavra
soma:	.space 4  # Reserva espaço para um inteiro (4 bytes) sem inicializar
	
	.text        # Inicia a seção de código
	.align 2     # Alinha as instruções em 32 bits (4 bytes)
	.globl main  # Define "main" como ponto de entrada do programa

main:
	# Lê o primeiro número (comando 5 para leitura de inteiro)
	addi a7, zero, 5  # Configura a7 para a syscall de leitura de inteiro
	ecall              # Faz a chamada ao sistema
	add t0, zero, a0   # Salva o primeiro número lido em t0

	# Lê o segundo número
	addi a7, zero, 5   # Configura a7 para a syscall de leitura de inteiro
	ecall              # Faz a chamada ao sistema
	add t0, t0, a0     # Soma o segundo número ao primeiro (armazenado em t0)

	# Carrega o endereço de memória reservado para "soma"
	la t1, soma        # t1 agora contém o endereço de "soma"

	# Armazena o resultado da soma na memória
	sw t0, 0(t1)       # Armazena o valor de t0 no endereço apontado por t1

	# Fim do programa
	li a7, 10          # Configura a7 para a syscall de saída (exit)
	ecall              # Encerra o programa

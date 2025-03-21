# Decodifique numero USP(8 digitos) de um aluno
# guardado em uma palavra(32 bits) na memoria
# e imprima.
	.data # Armazena resultado na memoria
	.align 2
	# Numero usp em hexadecimal
n_usp:	.word 0x15464826
	# Vetor numero USP(8 digitos x 4 bytes)
vet_n_usp:
	.space 32

	.text # Codigo
	.align 2 # Instruções de 32 bits
	.globl main # Ponto de entrada do programa
main:
	# Ler palavra n_usp
	la t0, n_usp # Salva endereço a ser lido
	lw s0, 0(t0) # Le palavra a partir de t0
	
	# Prepara mascara de bits
	la t3, vet_n_usp # Guarda endereço do vetor
	li t0, 0xF0000000 # Começa pelo primeiro digito
	li s1, 4 # Valor a ser deslocado(4 bits)
	li t1, 28 # Valor para ajustar numero(desloca direita)
	li t6, 8 # Contador(são 8 digitos)
	
loop:
	# Pegar um número
	and t2, s0, t0 # Mascara de bits aplicada no n_usp 
	srl t2, t2, t1 # Ajusta digito
	sw t2, 0(t3) # Guarda digitos no vetor
	
	# Ajustar para o proximo loop
	addi t3, t3, 4 # Avança para próximo inteiro 
	srl t0, t0, s1 # Ajusta máscara para prox. digito
	addi t1, t1, -4 # Ajusta auxiliar
	addi t6, t6, -1 # Decrementa contador
	bnez t6, loop # Continua decodificando
	
	# Imprimir vetor
	li a7, 1 # Comando imprimir inteiro
	li t6, 8 # Contador
	la t0, vet_n_usp # Carrega endereço

imprimir_n_usp:
	# Imprime número
	lw a0, 0(t0) # Carrega número a0
	ecall # Imprime
	# Atualiza registradores
	addi t0, t0, 4 # Próximo digito
	addi t6, t6 -1 # Decrementa contador
	bnez t6, imprimir_n_usp # branch, caso não impresso n_usp
	
	# Encerra programa
	li a7, 10 # Encerra programa
	ecall # Encerra programa	
	
	
	
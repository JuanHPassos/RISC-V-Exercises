# Bubble sort
	.data # Armazena dados na memória RAM
	.align 2 # Alinha memória por palavra
tam_vet:
	.word 7 # Define tamanho do vetor
vet:	.word 7, 5, 2, 1, 1, 3, 4 # Declara vetor a ser ordenado

	.align 0 # Alinha byte a byte 
espaco:	
	.asciz ", "
	
	.text # Código
	.align 2 # Instrução alinhada por palavra
	.globl main # Ponto de entrada do programa
main:	
	# Ler tamanho do vetor
	la t0, tam_vet # Salva endereço tam_vet
	lw s0, 0(t0) # Salva tamanho do vetor em s0
	
	# Salvar endereço do vetor
	la s1, vet 
	
	# Preparar variaveis para ordenação
	li t0, 0 # Prepara 1º contador( i )
	addi s4, s0, -1 # Indice máximo do contador i
		
loop_ext:
	blt s4, t0, sai_loop_ext # Se indice max < i, acabou o loop
	addi t1, s0, -1 # Prepara 2º contador ( j )
	addi s5, t0, 1 # Indice máximo do loop interno(s5)
loop_int:
	blt t1, s5, sai_loop_int # Sai do loop caso j(t1) < indice maximo(s5)
	
	# Receber valores a serem comparados
	slli s2, t1, 2 # Ajusta valor para bytes deslocados
	add s2, s1, s2	# Guarda endereço de vet[j] em s2
	addi s3, s2, -4 # Guarda endereço de vet[j-1] em s3
	lw t2, 0(s2) # Guarda elemento de vet[j] em t2
	lw t3, 0(s3) # Guarda elemento de vet[j-1] em t3
	
	# Ajusta ordem dos elementos
	# Verificar se vet[j] >= vet[j-1]
	bge t2, t3, fim_if # Caso seja, pula o if, pois já está correto
	
	# Armazena valore trocados na memória
	sw t2, 0(s3) # Armazena palavra t2 no endereço s2
	sw t3, 0(s2) # Armazena palavra t3 no endereço s3
	
fim_if:
	# Ajusta para próximo loop interno
	addi t1, t1, -1 # Decrementa indice j
	j loop_int # Volta a comparar
	
sai_loop_int:
	# Ajusta para próximo loop externo
	addi t0, t0, 1 # Incrementa contador i
	j loop_ext # Avança ordenação para o próximo número
	
sai_loop_ext:
	# Preparar para imprimir vetor
	add t0, zero, s0 # Contador ( i )
	add t1, zero, s1 # Endereço do 1º byte do vetor 
	
loop_imprimir:
	# Branch se todos os números impressos
	beqz t0, sai_loop_imprimir 

	# Imprimir número
	li a7, 1 # Comando 1 imprimi inteiro
	lw a0, 0(t1) # Pega número no endereço t1
	addi t1, t1, 4 # Passa para próx. endereço
	ecall # Imprimir número
	
	# Imprimir separação
	li a7, 4 # Comando 4 imprimir string
	la a0, espaco # Prepara para imprimir do endereço em a0
	ecall # Imprimi espaço
	
	addi t0, t0, -1 # Decrementa contador
	j loop_imprimir # Continua impressão
	
sai_loop_imprimir:
	# Encerra programa
	li a7, 10 # Comando 10 encerra programa
	ecall # Chamada para encerrar
		
		
	

		

# Função fatorial iterativa
	.data # Armazena dados na memória RAM
	.text # Código
	.align 2 # Instruções alinhadas por palavras
	.globl main # Ponto de entrada do programa
main:
	# Ler nº para calcular fatorial
	li a7, 5 # Comando 5 lê um inteiro
	ecall # Syscall para ler inteiro - guarda em a0
	
	# Chama função para calcular fatorial(retorno em a1)
	jal fatorial
	
	# Imprimi resposta calculada( -1 caso não exista )
	li a7, 1 # Comando 1 imprime um inteiro
	add a0, zero, a1 # Prepara número a ser impresso
	ecall # Syscall para imprimir inteiro
	
	# Encerrra programa
	li a7, 10 # Comando 10 encerra programa
	ecall # Syscall para encerrar programa
	
# Função que calcula o fatorial
# a0: nº a ser calculado
# a1: fatorial calculado
fatorial:
	# Preparar para calcular fatorial
	add t0, zero, a0 # Salvar número a ser calculado
	li t1, 1 # Váriavel para salvar o resultado
	bgez t0, loop_fatorial # Se o fatorial for válido, calcula-se
	
	# Retorna a1 = -1 como erro(não existe fatorial de nº negativo)
	li t1, -1 # Atribui erro a resposta
	j encerra_fatorial # Pula para o fim da função
	
loop_fatorial:
	# Verificar condição para calcular fatorial
	blez t0, encerra_fatorial
	  
	# Executa operações
	mul t1, t1, t0 # Calculo fatorial
	addi t0, t0, -1 # Atualiza t0 para calcular fatorial
	
	j loop_fatorial # Continua calculo até t0 = 0
	
encerra_fatorial:
	# Encerrar função
	add a1, zero, t1 # Retorno recebe a resposta
	jr ra # Retorna fatorial calculado ao endereço de chamada

	

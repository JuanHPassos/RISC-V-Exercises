# Imprime string de acordo com número lido e o numero lido.
	.data	# Armazena variáveis na memória RAM
	# Alinha memória bit a bit
	.align 0
str1:	.asciz "Hello Wolrd++!"	# String para números positivos ou zero
str2:	.asciz "Hello Wolrd--!"	# String para números negativos
	
	.text
	# Avisa que a instrução a ser lida
	# possui 32 bits (RV32I)
	.align 2
	.globl main # Define main como ponto de entrada do programa

main:	
	# Ler entrada do usuário
	# Serviço 5 - leitura de inteiro
	addi a7, zero, 5  # Configura a7 para a syscall de leitura de inteiro
	ecall              # Faz a chamada ao sistema
	add s0, a0, zero   # Salva o valor lido em s0

	# Verifica se o número é negativo
	# branch on less than (desvia se s0 < 0)
	blt s0, zero, print_neg  # Se s0 < 0, pula para print_neg

	# Caso o número seja positivo ou zero:
	# Imprime str1 (comando 4 - imprimir string)
	addi a7, zero, 4  # Configura a7 para a syscall de impressão de string
	la a0, str1        # Carrega o endereço de str1 em a0
	ecall              # Faz a chamada ao sistema (imprime str1)

	# Pula para o final do programa, evitando a execução do bloco print_neg
	j the_end

print_neg:  # Caso o número seja negativo:
	# Imprime str2 (comando 4 - imprimir string)
	addi a7, zero, 4  # Configura a7 para a syscall de impressão de string
	la a0, str2        # Carrega o endereço de str2 em a0
	ecall              # Faz a chamada ao sistema (imprime str2)

the_end:
	# Imprime o número lido (comando 1 - imprimir inteiro)
	addi a7, zero, 1  # Configura a7 para a syscall de impressão de inteiro
	add a0, s0, zero  # Move o valor de s0 para a0 (inteiro a ser impresso)
	ecall              # Faz a chamada ao sistema (imprime o número)

	# Sair do programa (comando 10 - exit)
	addi a7, zero, 10  # Configura a7 para a syscall de saída
	ecall              # Encerra o programa
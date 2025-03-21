# Dado dois inteiros, imprima o maior
	.data # Dados para armazenar na memória RAM
	.text # Código 
	.align 2 # Instruções por palavras(32 bits)
	.globl main # Define main como entrada do programa
main:
	# Le o primeiro numero
	li a7, 5 # comando 5 - le um numero
	ecall # Chama sistema para ler
	add s0, zero, a0 # Salva 1º numero lido
	
	# Le o segundo numero
	ecall # Chama sistema para ler
	add s1, zero, a0 # Salva 2º numero lido
	
	bgt s0, s1, def_maior # branch se s0 for maior que s1
	add a0, zero, s1 # Armazena s1 para ser impresso(se s1 >= s0)  
	j imprimir_maior	

def_maior: 
	add a0, zero, s0 # Armazena s0 para ser impresso(se s0 > s1)  
	
imprimir_maior:
	# Imprimir maior numero
	li a7, 1 # Comando 1 - imprimi um numero
	ecall # Chama sistema para imprimir
	
	# Encerra programa
	li a7, 10 # Comando 10 encerra programa
	ecall # Chama sistema para encerrar
	


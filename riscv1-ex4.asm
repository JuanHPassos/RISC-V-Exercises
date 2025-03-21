# Imprimi string de acordo com um numero de entrada	
	
	.data # Armazenar dados na memória RAM
	.align 0 # Alinha memória bit a bit
perg:	.asciz "Escolha um número inteiro de 1 a 4: "
resp:	.asciz "Parabens, você é membro do "		
op1:	.asciz "GEMA"
op2:	.asciz "CODELAB"
op3:	.asciz "GANESH"
op4:	.asciz "DATA"
erro:	.asciz "Erro: Entrada inválida"

	.text
	.align 2 # Alinha instruções por palavra(32 bits)
	.globl main # Defini main como entrada
main:
	# Imprimi pergunta
	li a7, 4 # 4 - imprimi string na saída padrão
	la a0, perg # Carrega endereço da string a ser impressa
	ecall # Chamada ao sistema
	
	# Ler numero
	li a7, 5 # Instrução para ler um número
	ecall # Le numero e guarda em a0
	add s0, zero, a0 # Guarda num em s0
	
	# Imprimi resposta a partir da opção inserida
	li a7, 4 # Garante comando de impressão de string
	
	addi t0, s0, -1 # Verifica se vai dar 0(s0 == 1)
	beqz t0, case1 # Se t0 = 0, branch op1
	
	addi t0, s0, -2 # Verifica se vai dar 0(s0 == 2)
	beqz t0, case2 # Se t0 = 0, branch op2
	
	addi t0, s0, -3 # Verifica se vai dar 0(s0 == 3)
	beqz t0, case3 # Se t0 = 0, branch op3
	
	addi t0, s0, -4 # Verifica se vai dar 0(s0 == 4)
	beqz t0, case4 # Se t0 = 0, branch op4	
	
	# Caso de erro (default)
	j fora_intervalo

	# Seleciona a resposta de acordo com a entrada
case1:
	la s1, op1 # Carrega endereço em s1
	j imprimi_resp # Jump para label imprimi_resp
case2:
	la s1, op2
	j imprimi_resp
case3:
	la s1, op3
	j imprimi_resp
case4:
	la s1, op4 # Não é necessário jump

imprimi_resp:
	# Imprimi resposta
	la a0, resp
	ecall
	add a0, zero, s1 
	ecall
	j encerrar_programa
	
fora_intervalo:
	# Imprimi mensagem de erro
	la a0, erro # Guarda endereço em a0
	ecall # Chama sistema para imprimir

encerrar_programa:
	# Encerrar programa
	li a7, 10 # comando 10 encerra programa
	ecall # Chamada do sistema
	
	
	
	
	
	
	
	
	
	
	
	
	
	 

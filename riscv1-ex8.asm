# Calcula fatorial sem usar multiplicação(apenas somas sucessivas)
	.data # Armazena dados na memória RAM
	.text # Código
	.align 2 # Instrução por palavra(32 bits)
	.globl main # Define entrada do programa
main:
	# Ler número de entrada
	li a7, 5 # Comando 5 le um numero
	ecall # Chamada do sistema para ler(a0 = num)
	add t1, zero, a0 # Salva entrada em t1
	
	# Prepara para calcular fatorial
	li t0, 1 # t0 representa a resposta
	ble zero, t1, fatorial # Se fatorial existir( >= 0) inicia loop
	j encerra_programa # Encerra programa
	
fatorial:	
	# Prepara registradores para multiplicação
	add t6, zero, t1  # t6 - quantidade de somas(contador)
	add s0, zero, t0 # Valor do numero a ser somado t6 vezes
	li t2, 0 # Ajusta t2 para acumular somas
	beqz t1, imprimir_fatorial # Se t1 for 0, fatorial calculado
	
multiplica:
	# Multiplicar t2 e s0(s0(1) + ... + s0(t6))
	beqz t6, att_reg # se t6 = 0, acabou de somar
	add t2, t2, s0 # t2 - acumulador das somas sucessivas(multiplicação)
	addi t6, t6, -1 # atualiza contador 
	
	j multiplica # jump
	
att_reg:
	# Atualiza registradores
	addi t1, t1, -1 # Decrementa auxiliar
	add t0, zero, t2 # Transfere resultado para resposta
	
	j fatorial # Continua calculo t0*(t1!)
	
imprimir_fatorial:
	# Imprimi fatorial da entrada
	li a7, 1 # Comando 1 - imprime inteiro
	add a0, zero, t0 # Prepara para imprimir resposta
	ecall # Chamada da função para imprimir

encerra_programa:
	# Encerrar programa
	 li a7, 10 # Comando 10 - encerra programa
	 ecall # Chama sistema para encerrar
	
	
	
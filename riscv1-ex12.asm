# Inverte uma string fornecida pelo usuário
	.data # Armasena dados na memória RAM
	.align 0 # Alinha leitura por byte
buffer:	.space 100 # Armazena conteúdo lido
	
	.text # Código
	.align 2 # Instruções por palavra
	.globl main # Ponto de entrada do programa
main: 
	# Ler string de entrada
	li a7, 8 # Comando 8 - Le uma string
	la a0, buffer # Busca endereço armazenado em a0
	li a1, 100 # Especifica tamanho máximo(evita overflow)
	ecall # Armazena o conteúdo  a partir desse endereço
	
	# Preparar para obter tamanho string
	li s0, 0 # Contador (tamanho da string)
	la t0, buffer # Carrega endereço do buffer em t0
	
loop_tam:
	# Contabilizar +1 tam da string
	addi s0, s0, 1 # Incrementa contador
	lb t1, 0(t0) # Le byte atual
	addi t0, t0, 1 # Avança para próximo byte
	bnez t1, loop_tam # loop se t1 != 0(fim da string)
	
	# Extrair \n adicionado devido ao comando 8
	sb zero, -2(t0) # Volta duas posições (\n, \0, atual) 
	addi s0, s0, -1 # Atualiza tamanho para conter apenas \0
	
	# Preparar para inverter
	la s1, buffer # Endereço início da string(num[0])
	add s2, s1, s0 # Endereço num[tam]
	addi s2, s2, -2 # Ajusta para num[tam-2 = fim string]
	# Obs: -1 para o \0 e o outro porque é base zero
	
loop_inverte:
	# Acaba se os contadores se cruzarem ou forem o mesmo
	bge s1, s2, sai_loop_inverte # Se o cont. inicio >= cont. fim
	
	# Recupera os caracteres a serem trocados
	lb t0, 0(s1) # Recupera simetrico da esquerda
	lb t1, 0(s2) # Recupera simetrico da direita
	
	# Realiza swap direto na memória
	sb t0, 0(s2) # Esquerda -> direita
	sb t1, 0(s1) # Direita -> esquerda
	
	# Anda posições de memoria em direção ao centro
	addi s1, s1, 1 # Esquerda rumo a direita
	addi s2, s2, -1 # Direita rumo a esquerda
	
	# Continua a inverter string
	j loop_inverte

sai_loop_inverte:
	# Imprimi resultado obtido após inversão
	li a7, 4 # Comando 4 imprimi string
	la a0, buffer # Prepara string para impressão
	ecall # Chama para imprimir
	
	# Encerra programa
	li a7, 10 # Comando 10 encerra o programa
	ecall # Chama para encerrar
	

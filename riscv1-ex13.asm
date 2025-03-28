# Implemente strcat(), strcpy() e strcmp()
# Código consiste em ler duas strings por meio de um buffer
# Alocar espaço suficiente para guarda-las,
# sem desperdicio de memoria, além de salvar seus
# conteudos por meio de dois ponteiros.
# Assim, deve-se concatena-las, sem desperdicio de memória(strcat)
# e armazena-las em um terceiro ponteiro.
# Por ultimo, fazer a comparações entre elas(3 comparações) com strcmp
	.data # Armazena conteúdo na RAM
	.align 0 # Alinha memória por byte
buffer:	.space 100 # Armazena entradas do usuário
newline:
	.asciz "\n" # Comando para pular linha
	
	.align 2 # Alinha memória por palavra(00)
ps1:
	.word 0 # Ponteiro para 1º string
ps2:
	.word 0 # Ponteiro para 2º string
ps3:
	.word 0 # Ponteiro para string concat(3º)
	
	.text # Código
	.align 2 # Instruções dadas por palavra
	.globl main # Entrada do programa
main:
	# Ler string 2 vezes
	jal ler_string # Le 1º string
	la s0, ps1 # Salva endereço ponteiro 1
	sw a1, 0(s0) # Ptr1 aponta para o endereço da str 1
	jal ler_string # Le 2º string
	la s1, ps2 # Salva endereço ponteiro 2
	sw a1, 0(s1) # Ptr2 aponta para o endereço da str 2	
	
	# Preparar para concatenar duas strings
	la a0, ps1 # Salva ponteiro1 como primeiro parametro
	la a1, ps2 # Salva ponteiro1 como segundo parametro
	jal strcat # Chama função para concatenar conteudo de ps1 com ps2
	la s2, ps3 # Salva endereço ponteiro 3
	sw a2, 0(s2) # Ptr3 aponta para str 3(concat de 1 com 2)
	
	
	# Comparar strings
	# s1 com s2
	li a7, 1 # Comando 1 imprime inteiro
	la a0, ps1 # 1º parametro
	la a1, ps2 # 2º parametro
	jal strcmp # Compara s1 com s2
	add a0, zero, a2 # Prepara imprimir resp
	ecall # Syscall para mostrar resposta
	
	# Pular linha
	li a7, 4 # Comando 4 imprime string
	la a0, newline # Prepara para pular linha
	ecall # Syscall para pular linha
	
	# s2 com s3
	li a7, 1 # Comando 1 imprime inteiro
	la a0, ps2 # 1º parametro
	la a1, ps3 # 2º parametro
	jal strcmp # Compara s2 com s3
	add a0, zero, a2 # Prepara imprimir resp
	ecall # Syscall para mostrar resposta
	
	# Pular linha
	li a7, 4 # Comando 4 imprime string
	la a0, newline # Prepara para pular linha
	ecall # Syscall para pular linha
	
	# s1 com s3
	li a7, 1 # Comando 1 imprime inteiro
	la a0, ps1 # 1º parametro
	la a1, ps3 # 2º parametro
	jal strcmp # Compara s1 com s3
	add a0, zero, a2 # Prepara imprimir resp
	ecall # Syscall para mostrar resposta
	
	# Encerrar programa
	li a7, 10 # Comando 10 encerra programa
	ecall # Chamar para encerrar
	
# Função para ler string
# a1: retorna endereço da string
ler_string:
	# Ler string de entrada
	li a7, 8 # Comando 8 - Le uma string
	la a0, buffer # Busca endereço armazenado em a0
	li a1, 100 # Especifica tamanho máximo(evita overflow)
	ecall # Armazena o conteúdo  a partir desse endereço
	
	# Guarda endereço de retorno da função
	addi sp, sp, -16     # Aloca espaço na pilha (16 bytes para alinhamento)
    	sw ra, 8(sp)         # Armazena ra na pilha (8 bytes offset)
	
	# Chama função passando a0 como argumento
	jal strlen # Passa o ra por padrão
	
	# Trocar \n por \0, adicionado devido ao comando 8
	la a0, buffer # Guarda endereço do 1º byte
	add t0, a0, a1 # t0 = tamanho(string\n\0) + 1
	sb zero, -2(t0) # -2 -> \n (zero indexado e pular \0)
	addi a1, a1, -1 # Atualiza e salva tamanho para conter apenas \0
	
	# Alocação dinâmica na heap
	li a7, 9 # Comando 9 reserva espaço contido em a0
	add a0, zero, a1 # Espaço para a string e o \0
	ecall # Reserva espaço - a0 recebe endereço
	
	# Prepara para preencher string
	add a1, zero, a0 # Endereço do destino
	la a0, buffer # Endereço origem
	
	# Chama função para copirar a origem no destino
	jal strcpy
	
	# Recupera ra da função para retornar
    	lw ra, 8(sp)         # Recupera ra da pilha
    	addi sp, sp, 16      # Desaloca pilha
	
	jr ra# Retorna string lida no a1
	
	
	
# Função que copia uma string na outra
# a0: endereço origem(a0 não é mudado)
# a1: endereço destino(a1 não é mudado)
strcpy:
	add t0, zero, a0 # Salva endereço origem
	add t1, zero, a1 # Salva endereço destino
	
loop_strcpy:
	# Realiza copia do caracter
	lb t2, 0(t0) # Lê byte endereço origem
	sb t2, 0(t1) # Salva no endereço destino
	
	# Avança próximo byte
	addi t0, t0, 1
	addi t1, t1, 1 

	# Continua loop, se não encontrar \0	
	bnez t2, loop_strcpy

	jr ra # Realizada copia, acabou função
	
# Calcula tamanho de uma string com o \0
# a0: endereço da string
# a1: retorna tamanho da string
strlen:
	# Preparar para calcular
	add t0, zero, a0 # Salva endereço da string
	li t1, 0 # Contador(tamanho da string)
		
loop_strlen:
	# Contabilizar +1 tam da string
	addi t1, t1, 1 # Incrementa contador
	lb t2, 0(t0) # Le byte atual
	addi t0, t0, 1 # Avança para próximo byte	
	bnez t2, loop_strlen # loop se t2 != 0(fim da string)
	
	# Retornar tamanho da string
	add a1, zero, t1 # Salvar valor no reg de retorno
	jr ra # Retorna ao ra(register adress)

# Função que concatena duas strings e retorna endereço.
# a0: ponteiro para primeira string
# a1: ponteiro para segunda string
# a2: retorno com o endereço da string resultado
strcat:
	# Preparar 6 registradores salvos
	addi sp, sp, -48 # Reserva espaço 6 inteiros
	sw ra, 40(sp) # Endereço de retorno
	sw s0, 32(sp) # Endereço string 1
	sw s1, 24(sp) # Endereço string 2
	sw s2, 16(sp) # Tamanho da nova string
	sw s3, 8(sp) # Variável auxiliar
	sw s4, 0(sp) # Endereço da nova string
	
	# Pegar conteúdo dos endereços
	lw s0, 0(a0) # Pegar conteudo do ponteiro1
	lw s1, 0(a1) # Pegar conteudo do ponteiro2
	
	# Preparar para contar os tamanhos
	add a0, zero, s0 # Guarda endereço string 1
	jal strlen # Contar tamanho string 1
	add s2, zero, a1 # Adiciona tamanho da nova string
	addi s3, a1, -1 # Guarda tamanho da string 1 sem o \0
	add a0, zero, s1 # Guarda endereço string 2
	jal strlen # Contar tamanho string 2
	add s2, s2, a1 # Adiciona tamanho da nova string
	addi s2, s2, -1 # Retirar um dos \0
					
	# Aloca dinamicamente a nova string
	li a7, 9 # Comando 9 aloca memória na heap
	add a0, zero, s2 # Reserva o tamanho da nova string
	ecall # Syscall para alocar espaço
	add s4, zero, a0 # Salva endereço da nova string
	
	# Prepara copiar primeira parte da string
	add a0, zero, s0 # Prepara string origem
	add a1, zero, s4 # Prepara string destino
	jal strcpy # Copia valores de a0 em a1 até o \0
	add a0, zero, s1 # Prepara string origem
	add a1, s4, s3 # Começa do \0 da string anterior
	jal strcpy # Copia valores de a0 em a1 até o \0
	
	# Salvar retorno
	add a2, zero, s4 # Retorno é o endereço da nova string
	
	# Desalocar pilha(Retorna valores antes da função)
	lw ra, 40(sp)
	lw s0, 32(sp)
	lw s1, 24(sp)
	lw s2, 16(sp)
	lw s3, 8(sp)
	lw s4, 0(sp) 
	addi sp, sp, 48 # Desaloca espaço 6 inteiros
	
	jr ra # Encerra função - retorno em a2
	
# Função que compara duas string lexicograficamente
# a0: ponteiro primeira string
# a1: pontiero segunda string
# a2: retorno
#  | a0 > a1 = > 0
#  | a0 == a1 = 0
#  | a0 < a1 = < 0
strcmp:
	# Ler conteudo das strings
	lw t0, 0(a0) # Guarda endereço 1º byte da string1
	lw t1, 0(a1) # Guarda endereço 1º byte da string2

loop_strcmp:
	# Pegar caracteres a serem comparados
	lb t2, 0(t0) # Lê byte primeira string
	lb t3, 0(t1) # Lê byte segunda string
	
	# Avança próximo byte
	addi, t0, t0, 1
	addi, t1, t1, 1
	
	# Verificar resposta
	sub a2, t2, t3
	
	# a2 for diferente de zero, temos uma resposta
	bnez a2, str1_maior
	# Trata caso em que os dois são iguais
	beqz t2, retornar 
	
	# Caso não tenha resposta e as strings não acabaram
	j loop_strcmp
	
str1_maior:
	bltz a2, str1_menor   
	li a2, 1 # Retorna 1 se str1 > str2
	j retornar # Saída formatada
str1_menor:
	li a2, -1 # Retorna -1 se str1 < str2

retornar:
	# Retornar resposta(retorna 0 se forem iguais)
	jr ra # Retorno está na variavel a2
	
	
	
	

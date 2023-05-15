.data
	# área para dados na memória principal
	
	msg: .asciiz "Soma: " # mensagem de soma
	size: .word 20

.text
	# área para instruções do programa
	
	# código principal	
	.main:	
		move $s0, $sp # guarda o endereço do vetor
		lw $t0, size # carrega em $t0 tamanho do vetor
		sll $t0, $t0, 2 # multiplica por 4
		sub $sp, $sp, $t0 # espaço do tamanho do vetor no $sp
		
		# inicializa vetor
		move $a0, $s0
		lw $a1, size
		li $a2, 71
		jal inicializaVetor
		move $s1, $v0
		
		#move $a0, $s0 # prepara argumento com endereço do vetor
		#move $a1, $s0
		#add $a1, $a1, $t0 # prepara argumento com endereço final do vetor
		#jal zeraVetor # chama função que zera vetor
		
	
		#move $a0, $s0 # prepara argumento com endereço do vetor
		#lw $a1, size # prepara argumento com tamanho do vetor
		#jal imprimeVetor # chama função que imprime vetor
		
		#move $a0, $s0
		#addi $a0, $a0, 4
		#addi $a1, $a0, 8
		#jal troca
		
		move $a0, $s0 # prepara argumento com endereço do vetor
		lw $a1, size # prepara argumento com tamanho do vetor
		jal imprimeVetor # chama função que imprime vetor
		
		
		#li $a0, 1
		#li $a1, 2
		#li $a2, 3
		#li $a3, 4
		#sub $sp, $sp, 4
		#sw $a0, 0($sp)
		#jal valorAleatorio
		#move $t0, $v0
		
		#li $v0, 1 # prepara syscall para imprimir inteiro
		#move $a0, $t0 # prepara argumento do syscall para valor do vetor
		#syscall
		
		li $v0, 4 # instrução para impressão de String
		la $a0, msg # indicar o endereço que está a mensagem	
		syscall
		
		li $v0, 1 # prepara syscall para imprimir inteiro
		move $a0, $s1 # prepara argumento do syscall para valor do vetor
		syscall
		
		# fim do programa
		li $v0, 10  # syscall pra finalizar o programa
		syscall     # finaliza o programa
	
	
	# função que zera o vetor
	zeraVetor:
		move $t0, $a0 # temporário com endereço do vetor que será iterado
		move $t1, $a1 # temporário com endereço final do vetor
		li $t2, 0
	loopZera:
		addi $t2, $t2, 1
		bge $t0, $t1, endZera # condição do loop
		sw $t2, 0($t0) # armazena no vetor valor de $t2
		addi $t0, $t0, 4 # incrementa endereço	
		j loopZera
	endZera:
		jr $ra
				
	
	# função que imprime o vetor			
	imprimeVetor:
		move $t0, $a0 # temporário com endereço do vetor que será iterado
		move $t1, $a1 # temporário com tamanho do vetor
		move $t2, $zero # contador
	loopImprime:
		bge $t2, $t1, endImprime # condição do loop
		lw $t3, 0($t0) # carrega para o temporário o valor do vetor
		li $v0, 1 # prepara syscall para imprimir inteiro
		move $a0, $t3 # prepara argumento do syscall para valor do vetor
		syscall
    		li $v0, 11 # prepara syscall pra imprimir caractere
		li $a0, 32 # carrega o código ASCII para " "
    		syscall 
		addi $t0, $t0, 4 # incrementa endereço
		addi $t2, $t2, 1 # incrementa contador		
		j loopImprime
	endImprime:
		li $v0, 11 # prepara syscall pra imprimir caractere
		li $a0, 10 # carrega o código ASCII para "\n"
    		syscall 
		jr $ra
		
		
	# função que gera valor pseudo-aleatorio
	valorAleatorio:
		lw $t0, 0($sp) # obtem quinto parâmetro
		add $sp, $sp, 4
		mul $t1, $a0, $a1
		add $t1, $t1, $a2
		div $t1, $a3
		mfhi $t1
		sub $v0, $t1, $t0
		jr $ra 
		
	
	# função que inicializa o vetor recursivamente com valores aleatorios
	inicializaVetor:
		bgt $a1, $zero, elseInicializa # verifica o caso base (não há vetor)
		move $v0, $zero
		jr $ra
	elseInicializa:
		# salva valores de argumentos
		sub $sp, $sp, 16		
		sw $a0, 0($sp) # guarda endereço vetor
		sw $a1, 4($sp) # guarda tamanho do vetor
		sw $ra, 8($sp) # guarda retorno da função
		sw $s0, 12($sp) # guarda registrador s0
		move $s0, $a1 # guarda tamanho do vetor
		# prepara argumentos para função de número aleatório
		move $a0, $a2
		li $a1, 47
		li $a2, 97
		li $a3, 337
		li $t0, 3
		sub $sp, $sp, 4
		sw $t0, 0($sp)
		jal valorAleatorio
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		sll $t1, $t1, 2
		subi $t1, $t1, 4
		add $t0, $t0, $t1
		sw $v0, 0($t0) # guarda valor aleatório na última posição
		subi $s0, $s0, 1
		# prepara argumentos para chamada recursiva
		lw $a0, 0($sp)
		move $a1, $s0
		move $a2, $v0
		move $s0, $v0 # salva valor de retorno
		jal inicializaVetor
		add $v0, $s0, $v0
		# restaura valores e $sp
		lw $ra, 8($sp)
		lw $s0, 12($sp)
		add $sp, $sp, 16
		jr $ra
		
		
		
	#função que troca valores dos endereço recebidos								
	troca:
		beq $a0, $a1, endTroca
		lw $t0, 0($a0)
		lw $t1, 0($a1)
		sw $t0, 0($a1)
		sw $t1, 0($a0)
	endTroca:
		jr $ra
	
	
	imprime_hello_world:
		li $v0, 4 # instrução para impressão de String
		la $a0, msg # indicar o endereço que está a mensagem	
		syscall
		
	
	
	
	
	

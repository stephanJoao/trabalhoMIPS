# Aluno: João Stephan Silva Maurício - Matrícula: 201965505B

.data
	# área para dados na memória principal
	
	msg: .asciiz "Soma: " # mensagem de soma
	size: .word 20        # tamanho do vetor

.text
	# área para instruções do programa
	
	# código principal	
	.main:	
		move $s0, $sp     # $s0 = endereço do vetor
		lw $s1, size      # $s1 = tamanho do vetor
		sll $s2, $s1, 2   # $s2 = tamanho do vetor em bytes
		sub $sp, $sp, $s2 # aloca tamanho do vetor no $sp
		
		
		# inicializa vetor
		# preparando argumentos
		move $a0, $s0
		move $a1, $s1
		li $a2, 71
		# chamando função
		jal inicializaVetor
		move $s3, $v0 # guardando soma em $s3
		
		# imprime vetor
		move $a0, $s0    # argumento com endereço do vetor
		move $a1, $s1    # argumento com tamanho do vetor
		jal imprimeVetor # chama função que imprime vetor
				
		
		# ordena vetor
		# preparando argumentos
		move $a0, $s0
		move $a1, $s1
		# chamando função
		jal ordenaVetor
		
		# imprime vetor
		move $a0, $s0    # argumento com endereço do vetor
		move $a1, $s1    # argumento com tamanho do vetor
		jal imprimeVetor # chama função que imprime vetor
		
		# zera vetor
		# preparando argumentos
		move $a0, $s0     # argumento com endereço do vetor
		add $a1, $s0, $s2 # argumento com endereço final do vetor
		# chamando função
		jal zeraVetor # chama função que zera vetor
		
		# imprime vetor
		move $a0, $s0    # argumento com endereço do vetor
		move $a1, $s1    # argumento com tamanho do vetor
		jal imprimeVetor # chama função que imprime vetor
		
		
		# imprime mensagem de soma
		li $v0, 4   # prepara syscall para imprimir string
		la $a0, msg # indicar o endereço que está a mensagem	
		syscall

		# imprime soma		
		li $v0, 1     # prepara syscall para imprimir inteiro
		move $a0, $s3 # prepara argumento do syscall para valor da soma
		syscall
		
		
		# fim do programa
		li $v0, 10  # syscall pra finalizar o programa
		syscall     # finaliza o programa
	
	
	# função para zerar o vetor
	zeraVetor:
		move $t0, $a0   # temporário com endereço do vetor que será iterado
		move $t1, $a1   # temporário com endereço final do vetor
		move $t2, $zero # valor zero a ser armazenado
	loopZera:
		bge $t0, $t1, endZera # condição do loop
		sw $t2, 0($t0)        # armazena no vetor valor de $t2
		addi $t0, $t0, 4      # incrementa endereço	
		j loopZera	      # volta no loop
	endZera:
		jr $ra
				
	
	# função para imprimir o vetor			
	imprimeVetor:
		move $t0, $a0   # temporário com endereço do vetor que será iterado
		move $t1, $a1   # temporário com tamanho do vetor
		move $t2, $zero # contador
	loopImprime:
		bge $t2, $t1, endImprime # condição do loop
		lw $t3, 0($t0)           # carrega para o temporário o valor do vetor
		# impressão
		li $v0, 1                # syscall para imprimir inteiro
		move $a0, $t3            # valor do vetor
		syscall
    		li $v0, 11               # syscall pra imprimir caractere
		li $a0, 32               # código ASCII para " "
    		syscall 
		# incremento loop
		addi $t0, $t0, 4 # incrementa endereço
		addi $t2, $t2, 1 # incrementa contador		
		j loopImprime
	endImprime:
		li $v0, 11 # syscall pra imprimir caractere
		li $a0, 10 # código ASCII para "\n"
    		syscall 
		jr $ra
		
		
	# gerador de números pseudo-aleatórios por congruência linear
	valorAleatorio:
		lw $t0, 0($sp)  # obtem quinto parâmetro
		add $sp, $sp, 4 # restaura $sp
		mul $t1, $a0, $a1
		add $t1, $t1, $a2
		div $t1, $a3
		mfhi $t1
		sub $v0, $t1, $t0
		jr $ra 
		
	
	# função recursiva que inicializa o vetor com valores pseudo-aleatórios
	inicializaVetor:
		bgt $a1, $zero, elseInicializa # verifica o caso base (não há vetor)
		move $v0, $zero
		jr $ra
	elseInicializa:
		# salva valores
		sub $sp, $sp, 16		
		sw $a0, 0($sp)  # guarda endereço vetor
		sw $a1, 4($sp)  # guarda tamanho do vetor
		sw $ra, 8($sp)  # guarda retorno da função
		sw $s0, 12($sp) # guarda registrador s0
		# prepara argumentos para função de número aleatório
		move $a0, $a2
		li $a1, 47
		li $a2, 97
		li $a3, 337
		li $t0, 3
		sub $sp, $sp, 4
		sw $t0, 0($sp)
		jal valorAleatorio
		move $s0, $v0 # salva valor de retorno
		# armazenando valor na última posição
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		sll $t1, $t1, 2
		subi $t1, $t1, 4
		add $t0, $t0, $t1
		sw $v0, 0($t0)
		# prepara argumentos para chamada recursiva
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		subi $a1, $a1, 1
		move $a2, $v0
		jal inicializaVetor
		add $v0, $v0, $s0 # soma retorno da recursiva com o valor salvo
		# restaura retorno, $s0 e $sp
		lw $ra, 8($sp)
		lw $s0, 12($sp)
		add $sp, $sp, 16
		jr $ra
		
		
	# função que troca os valores entre duas posições do vetor
	troca:
		beq $a0, $a1, endTroca
		lw $t0, 0($a0)
		lw $t1, 0($a1)
		sw $t0, 0($a1)
		sw $t1, 0($a0)
	endTroca:
		jr $ra
	
	
	# função que ordena os elementos do vetor (SelectionSort)
	ordenaVetor:
		# salva valores de argumentos
		sub $sp, $sp, 16		
		sw $a0, 0($sp)  # guarda endereço vetor
		sw $a1, 4($sp)  # guarda tamanho do vetor
		sw $ra, 8($sp)  # guarda retorno da função
		sw $s0, 12($sp) # guarda registrador s0
		move $s0, $zero # i = 0
	loopOrdena1:
		# condição loop 1
		subi $t0, $a1, 1
		bge $s0, $t0, endOrdena1 
		# corpo
		move $t1, $s0    # min_idx
		addi $t2, $s0, 1 # j
	loopOrdena2:
		# condição loop 2
		bge $t2, $a1, endOrdena2
		# corpo
		sll $t3, $t2, 2 # j em bytes
		sll $t4, $t1, 2 # min_idx em bytes
		add $t3, $t3, $a0 # j no vetor
		add $t4, $t4, $a0 # min_idx no vetor
		lw $t3, 0($t3) # vet[j]
		lw $t4, 0($t4) # vet[min_idx]
		# condição min_idx = j
		bge $t3, $t4, elseOrdena1 
		move $t1, $t2
	elseOrdena1:
		# incremento do segundo loop
		addi $t2, $t2, 1	
		j loopOrdena2
	endOrdena2:
		# condição de troca
		beq $t1, $s0, elseOrdena2
		# prepara argumentos para função de troca
		sll $a1, $s0, 2
		add $a1, $a1, $a0
		sll $t1, $t1, 2
		add $a0, $t1, $a0
		# chama função de troca
		jal troca
	elseOrdena2:
		# restaura argumentos da ordenaVetor
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		# incremento do primeiro loop
		addi $s0, $s0, 1
		j loopOrdena1
	endOrdena1:
		# restaura valores armazenados no stack
		lw $ra, 8($sp)
		lw $s0, 12($sp) 
		add $sp, $sp, 16 
		jr $ra
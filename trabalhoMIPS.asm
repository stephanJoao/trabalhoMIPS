# Aluno: Jo�o Stephan Silva Maur�cio - Matr�cula: 201965505B

.data
	# �rea para dados na mem�ria principal
	
	msg: .asciiz "Soma: " # mensagem de soma
	size: .word 20        # tamanho do vetor

.text
	# �rea para instru��es do programa
	
	# c�digo principal	
	.main:	
		move $s0, $sp     # $s0 = endere�o do vetor
		lw $s1, size      # $s1 = tamanho do vetor
		sll $s2, $s1, 2   # $s2 = tamanho do vetor em bytes
		sub $sp, $sp, $s2 # aloca tamanho do vetor no $sp
		
		
		# inicializa vetor
		# preparando argumentos
		move $a0, $s0
		move $a1, $s1
		li $a2, 71
		# chamando fun��o
		jal inicializaVetor
		move $s3, $v0 # guardando soma em $s3
		
		# imprime vetor
		move $a0, $s0    # argumento com endere�o do vetor
		move $a1, $s1    # argumento com tamanho do vetor
		jal imprimeVetor # chama fun��o que imprime vetor
				
		
		# ordena vetor
		# preparando argumentos
		move $a0, $s0
		move $a1, $s1
		# chamando fun��o
		jal ordenaVetor
		
		# imprime vetor
		move $a0, $s0    # argumento com endere�o do vetor
		move $a1, $s1    # argumento com tamanho do vetor
		jal imprimeVetor # chama fun��o que imprime vetor
		
		# zera vetor
		# preparando argumentos
		move $a0, $s0     # argumento com endere�o do vetor
		add $a1, $s0, $s2 # argumento com endere�o final do vetor
		# chamando fun��o
		jal zeraVetor # chama fun��o que zera vetor
		
		# imprime vetor
		move $a0, $s0    # argumento com endere�o do vetor
		move $a1, $s1    # argumento com tamanho do vetor
		jal imprimeVetor # chama fun��o que imprime vetor
		
		
		# imprime mensagem de soma
		li $v0, 4   # prepara syscall para imprimir string
		la $a0, msg # indicar o endere�o que est� a mensagem	
		syscall

		# imprime soma		
		li $v0, 1     # prepara syscall para imprimir inteiro
		move $a0, $s3 # prepara argumento do syscall para valor da soma
		syscall
		
		
		# fim do programa
		li $v0, 10  # syscall pra finalizar o programa
		syscall     # finaliza o programa
	
	
	# fun��o para zerar o vetor
	zeraVetor:
		move $t0, $a0   # tempor�rio com endere�o do vetor que ser� iterado
		move $t1, $a1   # tempor�rio com endere�o final do vetor
		move $t2, $zero # valor zero a ser armazenado
	loopZera:
		bge $t0, $t1, endZera # condi��o do loop
		sw $t2, 0($t0)        # armazena no vetor valor de $t2
		addi $t0, $t0, 4      # incrementa endere�o	
		j loopZera	      # volta no loop
	endZera:
		jr $ra
				
	
	# fun��o para imprimir o vetor			
	imprimeVetor:
		move $t0, $a0   # tempor�rio com endere�o do vetor que ser� iterado
		move $t1, $a1   # tempor�rio com tamanho do vetor
		move $t2, $zero # contador
	loopImprime:
		bge $t2, $t1, endImprime # condi��o do loop
		lw $t3, 0($t0)           # carrega para o tempor�rio o valor do vetor
		# impress�o
		li $v0, 1                # syscall para imprimir inteiro
		move $a0, $t3            # valor do vetor
		syscall
    		li $v0, 11               # syscall pra imprimir caractere
		li $a0, 32               # c�digo ASCII para " "
    		syscall 
		# incremento loop
		addi $t0, $t0, 4 # incrementa endere�o
		addi $t2, $t2, 1 # incrementa contador		
		j loopImprime
	endImprime:
		li $v0, 11 # syscall pra imprimir caractere
		li $a0, 10 # c�digo ASCII para "\n"
    		syscall 
		jr $ra
		
		
	# gerador de n�meros pseudo-aleat�rios por congru�ncia linear
	valorAleatorio:
		lw $t0, 0($sp)  # obtem quinto par�metro
		add $sp, $sp, 4 # restaura $sp
		mul $t1, $a0, $a1
		add $t1, $t1, $a2
		div $t1, $a3
		mfhi $t1
		sub $v0, $t1, $t0
		jr $ra 
		
	
	# fun��o recursiva que inicializa o vetor com valores pseudo-aleat�rios
	inicializaVetor:
		bgt $a1, $zero, elseInicializa # verifica o caso base (n�o h� vetor)
		move $v0, $zero
		jr $ra
	elseInicializa:
		# salva valores
		sub $sp, $sp, 16		
		sw $a0, 0($sp)  # guarda endere�o vetor
		sw $a1, 4($sp)  # guarda tamanho do vetor
		sw $ra, 8($sp)  # guarda retorno da fun��o
		sw $s0, 12($sp) # guarda registrador s0
		# prepara argumentos para fun��o de n�mero aleat�rio
		move $a0, $a2
		li $a1, 47
		li $a2, 97
		li $a3, 337
		li $t0, 3
		sub $sp, $sp, 4
		sw $t0, 0($sp)
		jal valorAleatorio
		move $s0, $v0 # salva valor de retorno
		# armazenando valor na �ltima posi��o
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
		
		
	# fun��o que troca os valores entre duas posi��es do vetor
	troca:
		beq $a0, $a1, endTroca
		lw $t0, 0($a0)
		lw $t1, 0($a1)
		sw $t0, 0($a1)
		sw $t1, 0($a0)
	endTroca:
		jr $ra
	
	
	# fun��o que ordena os elementos do vetor (SelectionSort)
	ordenaVetor:
		# salva valores de argumentos
		sub $sp, $sp, 16		
		sw $a0, 0($sp)  # guarda endere�o vetor
		sw $a1, 4($sp)  # guarda tamanho do vetor
		sw $ra, 8($sp)  # guarda retorno da fun��o
		sw $s0, 12($sp) # guarda registrador s0
		move $s0, $zero # i = 0
	loopOrdena1:
		# condi��o loop 1
		subi $t0, $a1, 1
		bge $s0, $t0, endOrdena1 
		# corpo
		move $t1, $s0    # min_idx
		addi $t2, $s0, 1 # j
	loopOrdena2:
		# condi��o loop 2
		bge $t2, $a1, endOrdena2
		# corpo
		sll $t3, $t2, 2 # j em bytes
		sll $t4, $t1, 2 # min_idx em bytes
		add $t3, $t3, $a0 # j no vetor
		add $t4, $t4, $a0 # min_idx no vetor
		lw $t3, 0($t3) # vet[j]
		lw $t4, 0($t4) # vet[min_idx]
		# condi��o min_idx = j
		bge $t3, $t4, elseOrdena1 
		move $t1, $t2
	elseOrdena1:
		# incremento do segundo loop
		addi $t2, $t2, 1	
		j loopOrdena2
	endOrdena2:
		# condi��o de troca
		beq $t1, $s0, elseOrdena2
		# prepara argumentos para fun��o de troca
		sll $a1, $s0, 2
		add $a1, $a1, $a0
		sll $t1, $t1, 2
		add $a0, $t1, $a0
		# chama fun��o de troca
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
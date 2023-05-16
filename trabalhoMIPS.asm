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
		move $a0, $s0 # prepara argumento com endere�o do vetor
		lw $a1, size # prepara argumento com tamanho do vetor
		jal imprimeVetor # chama fun��o que imprime vetor
				
		
		# ordena vetor
		# preparando argumentos
		move $a0, $s0
		lw $a1, size
		# chamando fun��o
		jal ordenaVetor
		
		# imprime vetor
		move $a0, $s0 # prepara argumento com endere�o do vetor
		lw $a1, size # prepara argumento com tamanho do vetor
		jal imprimeVetor # chama fun��o que imprime vetor
		
		
		# preparando argumentos
		move $a0, $s0 # prepara argumento com endere�o do vetor
		move $a1, $s0
		lw $t0, size # carrega em $t0 tamanho do vetor
		sll $t0, $t0, 2 # multiplica por 4
		add $a1, $a1, $t0 # prepara argumento com endere�o final do vetor
		# chamando fun��o
		jal zeraVetor # chama fun��o que zera vetor
		
		# imprime vetor
		move $a0, $s0 # prepara argumento com endere�o do vetor
		lw $a1, size # prepara argumento com tamanho do vetor
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
		move $t0, $a0 # tempor�rio com endere�o do vetor que ser� iterado
		move $t1, $a1 # tempor�rio com endere�o final do vetor
		li $t2, 0
	loopZera:
		bge $t0, $t1, endZera # condi��o do loop
		sw $t2, 0($t0) # armazena no vetor valor de $t2
		addi $t0, $t0, 4 # incrementa endere�o	
		j loopZera
	endZera:
		jr $ra
				
	
	# fun��o para imprimir o vetor			
	imprimeVetor:
		move $t0, $a0 # tempor�rio com endere�o do vetor que ser� iterado
		move $t1, $a1 # tempor�rio com tamanho do vetor
		move $t2, $zero # contador
	loopImprime:
		bge $t2, $t1, endImprime # condi��o do loop
		lw $t3, 0($t0) # carrega para o tempor�rio o valor do vetor
		li $v0, 1 # prepara syscall para imprimir inteiro
		move $a0, $t3 # prepara argumento do syscall para valor do vetor
		syscall
    		li $v0, 11 # prepara syscall pra imprimir caractere
		li $a0, 32 # carrega o c�digo ASCII para " "
    		syscall 
		addi $t0, $t0, 4 # incrementa endere�o
		addi $t2, $t2, 1 # incrementa contador		
		j loopImprime
	endImprime:
		li $v0, 11 # prepara syscall pra imprimir caractere
		li $a0, 10 # carrega o c�digo ASCII para "\n"
    		syscall 
		jr $ra
		
		
	# gerador de n�meros pseudo-aleat�rios por congru�ncia linear
	valorAleatorio:
		lw $t0, 0($sp) # obtem quinto par�metro
		add $sp, $sp, 4
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
		# salva valores de argumentos
		sub $sp, $sp, 16		
		sw $a0, 0($sp) # guarda endere�o vetor
		sw $a1, 4($sp) # guarda tamanho do vetor
		sw $ra, 8($sp) # guarda retorno da fun��o
		sw $s0, 12($sp) # guarda registrador s0
		move $s0, $a1 # guarda tamanho do vetor
		# prepara argumentos para fun��o de n�mero aleat�rio
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
		sw $v0, 0($t0) # guarda valor aleat�rio na �ltima posi��o
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
		sub $sp, $sp, 20		
		sw $a0, 0($sp) # guarda endere�o vetor
		sw $a1, 4($sp) # guarda tamanho do vetor
		sw $ra, 8($sp) # guarda retorno da fun��o
		sw $s0, 12($sp) # guarda registrador s0
		sw $s1, 16($sp) # guarda registrador s1
		move $s0, $zero # i
		move $s1, $a1 # tamanho do vetor (n�o em byte) n
	loopOrdena1:
		# condi��o loop 1
		subi $t0, $s1, 1
		bge $s0, $t0, endOrdena1 
		# corpo
		move $t1, $s0 # min_idx
		addi $t2, $s0, 1 # j
	loopOrdena2:
		# condi��o loop 2
		bge $t2, $s1, endOrdena2
		# corpo
		sll $t3, $t2, 2 # j em bytes
		sll $t4, $t1, 2 # min_idx em bytes
		add $t3, $t3, $a0 # j no vetor
		add $t4, $t4, $a0 # min_idx no vetor
		lw $t3, 0($t3) # vet[j]
		lw $t4, 0($t4) # vet[min_idx]
		# condi��o min_idx = j
		bge $t3, $t4, elseOrdena1 
		# corpo
		move $t1, $t2
	elseOrdena1:
		addi $t2, $t2, 1	
		j loopOrdena2
	endOrdena2:
		# condi��o troca
		beq $t1, $s0, elseOrdena2
		# corpo
		move $t5, $a0 # endere�o do vetor
		sll $a0, $t1, 2
		add $a0, $a0, $t5
		sll $a1, $s0, 2
		add $a1, $a1, $t5		
		jal troca
		move $a0, $t5
	elseOrdena2:
		addi $s0, $s0, 1
		j loopOrdena1
	endOrdena1:
		# restaura valores armazenados
		lw $ra, 8($sp)
		lw $s0, 12($sp) # guarda registrador s0
		lw $s1, 16($sp) # guarda registrador s1
		add $sp, $sp, 20 
		jr $ra
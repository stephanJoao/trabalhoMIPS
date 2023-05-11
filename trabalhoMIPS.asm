.data
	# área para dados na memória principal
	msg: .asciiz "Olá mundo!" # mensagem a ser exibida para o usuário
	size: .word 20

.text
	# área para instruções do programa
	
	# aqui se implementa o código principal	
	.main:	
		move $s0, $sp # guarda o endereço do vetor
		lw $t0, size # carrega em $t0 tamanho do vetor
		sll $t0, $t0, 2 # multiplica por 4
		add $sp, $sp, $t0 # soma tamanho do vetor em bytes no $sp
		
		move $a0, $s0
		lw $a1, size 
		jal zeraVetor
		move $a0, $s0
		jal imprimeVetor
		
		# fim do programa
		li $v0, 10  # syscall pra finalizar o programa
		syscall     # finaliza o programa
	
	zeraVetor:
		move $t0, $a0 # temporário com endereço do vetor que será iterado
		move $t1, $a1 # temporário com tamanho do vetor
		move $t2, $zero 
		li $t3, 1
	loopZera:
		bge $t2, $t1, endZera # condição do loop
		sw $t3, 0($t0)
		addi $t0, $t0, 4
		addi $t2, $t2, 1		
		j loopZera
	endZera:
		jr $ra
				
	imprimeVetor:
		move $t0, $a0 # temporário com endereço do vetor que será iterado
		move $t1, $a1 # temporário com tamanho do vetor
		move $t2, $zero # int i = 0
	loopImprime:
		bge $t2, $t1, endImprime # condição do loop
		lw $t3, 0($t0)
		li $v0, 1
		move $a0, $t3
		syscall
		li $a0, 32               # Load the ASCII code for space into register $a0
    		li $v0, 11               # Load the system call code for printing a character into $v0
    		syscall 
		addi $t0, $t0, 4
		addi $t2, $t2, 1		
		j loopImprime
	endImprime:
		jr $ra
						
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
		
	
	
	
	
	

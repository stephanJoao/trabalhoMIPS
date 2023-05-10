.data
	# �rea para dados na mem�ria principal
	msg: .asciiz "Ol� mundo!" # mensagem a ser exibida para o usu�rio

.text
	# �rea para instru��es do programa
	
	# aqui se implementa o c�digo principal	
	.main:	
		jal imprime_hello_world
		
	troca:
		beq $a0, $a1, $ra
		lw $t0, 0($a0)
		lw $t1, 0($a1)
		sw $t0, 0($a1)
		sw $t1, 0($a0)
		jr $ra
	
	imprime_hello_world:
		li $v0, 4 # instru��o para impress�o de String
		la $a0, msg # indicar o endere�o que est� a mensagem

		jal troca
		
		syscall
	

.data
	# �rea para dados na mem�ria principal
	msg: .asciiz "Ol� mundo!" # mensagem a ser exibida para o usu�rio

.text
	# �rea para instru��es do programa
	
	# aqui se implementa o c�digo principal	
	.main:	
		jal imprime_hello_world
		
	imprime_hello_world:
		li $v0, 4 # instru��o para impress�o de String
		la $a0, msg # indicar o endere�o que est� a mensagem
		syscall
	

.data
	# área para dados na memória principal
	msg: .asciiz "Olá mundo!" # mensagem a ser exibida para o usuário

.text
	# área para instruções do programa
	
	# aqui se implementa o código principal	
	.main:	
		jal imprime_hello_world
		
	imprime_hello_world:
		li $v0, 4 # instrução para impressão de String
		la $a0, msg # indicar o endereço que está a mensagem
		syscall
	

.data
	#Array para armazenar o código de cada livro
	codigos:
		.align 2
		.space 100
		
	#Array para armazenar o status de cada livro (0 -> Disponível, 1 -> Emprestado)
	status:
		.align 2
		.space 100
		
	#Linhas do menu
	titulo: .asciiz "\n===== BIBLIOTECA ====="
	opcoes: .asciiz "\n1 - Cadastrar Livro\n2 - Emprestar Livro\n3 - Devolver Livro\n4 - Listar Livros\n5 - SAIR\n"
	
	#Mensagens ao usuário
	mensagemOpcao: .asciiz "\nOpção: "
	mensagemErroOpcao: .asciiz "ERRO: opção inválida\n"
	mensagemTitulo: .asciiz "\nDigite o título do livro: "
	mensagemCodigo: .asciiz "\nCódigo "
	mensagemTraco: .asciiz " - "
	mensagemSucessoCadastro: .asciiz "\nLivro cadastrado com sucesso!\n"
	mensagemEmprestimo: .asciiz "\nDigite o código do livro a ser emprestado: "
	mensagemLivroInexistente: .asciiz "\nERRO: o livro informado não está cadastrado\n"
	mensagemErroEmprestimo: .asciiz "\nERRO: o livro informado já foi emprestado\n"
	mensagemSucessoEmprestimo: .asciiz "\nLivro emprestado com sucesso!\n"
	
	#Título inserido pelo usuário
	tituloLivro: .space 51
		
.text
	li $s0, 0	#Registrador que contém o código do próximo número a ser cadastrado
	li $s2, 0	#Registrador que contém a quantidade de livros no array
	
	jal printMenu
	
	loopPrincipal:
		li $s1, 0	#Registrador que contém o índice dos arrays codigos e status
	
		la $a0, mensagemOpcao
		jal printString
		
		jal lerInteiro
		move $t0, $v0	#$t0 terá o a opção informada
		
		li $t1, 1
		beq $t0, $t1, cadastrar
		
		li $t1, 2
		beq $t0, $t1, emprestar
		
		li $t1, 3
		beq $t0, $t1, devolver
		
		li $t1, 4
		beq $t0, $t1, listar
		
		li $t1, 5
		beq $t0, $t1, sair
		
		#Se o código checar neste ponto, a opção informada foi inválida
		la $a0, mensagemErroOpcao
		jal printString
		
		jal loopPrincipal #Reinicia o loop principal
		
		cadastrar:	#Função para cadastro de novos livros
		
			la $a0, mensagemTitulo
			jal printString
			jal lerTitulo
			
			#Cadastro nos arrays
			sw $s0, codigos($s1)
			sw $zero, status($s1)
			
			la $a0, mensagemCodigo
			jal printString
			
			move $a0, $s0
			jal printInteiro
			
			la $a0, mensagemTraco
			jal printString
			
			la $a0, tituloLivro
			jal printString
			
			la $a0, mensagemSucessoCadastro
			jal printString
			
			#Atualização do código, dos índices e da quantidade de livros
			addi $s0, $s0, 1
			addi $s1, $s1, 1
			addi $s2, $s2, 1
			
			jal loopPrincipal #Reinicia o loop principal
		
		emprestar:	#Função para empréstimo de livros que estejam disponíveis
		
			la $a0, mensagemEmprestimo
			jal printString
			
			jal lerInteiro
			move $t2, $v0	#Código do livro que o usuário quer emprestar
			
			#Avalia se o livro existe
			percorreArray:
				beq $s1, $s2, livroNaoEncontrado
				
				lw $t3, codigos($s1)	#Carrega o código do livro atual em $t3
				beq $t3,  $t2, avaliarEmprestimo	#Se o código atual for igual ao código informado, avalia se o empréstimo é possível
				
				#Atualiza o índice dos arrays
				addi $s1, $s1, 1
				jal percorreArray
				
				avaliarEmprestimo:	
					lw $t3, status($s1)	#Carrega o status do livro avaliado
					
					bne $t3, $zero, erroEmprestimo	#Avalia se o status do livro é 0
					
					#Se o código chegar neste ponto, o livro pode ser emprestado
					#Atualiza o status do livro
					li $t3, 1
					sw $t3, status($s1)
					
					la $a0, mensagemSucessoEmprestimo
					jal printString
					jal loopPrincipal #Reinicia o loop principal
					
					erroEmprestimo:	#O livro já foi emprestado
						la $a0, mensagemErroEmprestimo
						jal printString
						jal loopPrincipal	#Reinicia o loop principal
				
			livroNaoEncontrado:
				la $a0, mensagemLivroInexistente
				jal printString
				jal loopPrincipal	#Reinicia o loop principal
		
		devolver:	#Função para devolução de livros emprestados
			
			
		listar:		#Função para listagem de todos os livros cadastrados e seus respectivos status
	
	printString:
		li $v0, 4
		syscall
		jr $ra

	printMenu:
		la $a0, titulo
		jal printString
		
		la $a0, opcoes
		jal printString
		jal loopPrincipal
		
	lerInteiro:
		li $v0, 5
		syscall
		jr $ra
		
	lerTitulo:
		li $v0, 8
		la $a0, tituloLivro
		li $a1, 51
		syscall
		jr $ra
		
	printInteiro:
		li $v0, 1
		syscall
		jr $ra

	sair:
		li $v0, 10
		syscall

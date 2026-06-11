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
	mensagemErroOpcao: .asciiz "ERRO: opção inválida"
	mensagemTitulo: .asciiz "\nDigite o título do livro: "
	mensagemCodigo: .asciiz " - Código "
	mensagemSucessoCadastro: .asciiz "Livro cadastrado com sucesso!"
	
	#Título inserido pelo usuário
	tituloLivro: .space 51
		
.text
	jal printMenu
	
	loopPrincipal:
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
		
		jal printMenu	#Reinicia o loop principal
		
		cadastrar:	#Função para cadastro de novos livros
			la $a0, mensagemTitulo
			jal printString
			jal lerTitulo
			
			la $a0, tituloLivro
			jal printString
			
			la $a0, mensagemCodigo
			jal printString
			
			
		
		emprestar:
		
		devolver:
		
		listar:
	
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
		syscall
		jr $ra

	sair:
		li $v0, 10
		syscall
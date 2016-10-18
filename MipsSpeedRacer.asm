# Paulo Henrik Goncalves
# Usual settings: 0x10040000 (Heap) 8x8 256x512, ou 16x16 512x1024

.data
	base_mainCar_left:  .word 0x10041890  # Endereco Base Carro Principal Esquerda
	base_mainCar_mid:   .word 0x100418BC  # Endereco Base Carro Principal Centro
	base_mainCar_right: .word 0x100418E8  # Endereco Base Carro Principal Direita
	base_enemyCar_left: .word 0x1003F910  # Endereco Base Carro Inimigo Esquerda
	base_enemyCar_mid:  .word 0x1003F93C  # Endereco Base Carro Inimigo Centro
	base_enemyCar_right:.word 0x1003F968  # Endereco Base Carro Inimigo Direira
	background_color:   .word 0x00848484  # Cor de Fundo
	limit_refresh_ini:  .word 0x1003F900  # Endereco Limite para atualizar ecra
	limit_refresh_end:  .word 0x10041F80 #10042000
	car_color1:         .word 0x00B22222  # cor chassi Carro Principal
	car_color2:         .word 0x00E0E6F8  # cor chassi Carro Principal
	car_color3:         .word 0x00000000  # cor Pneu
	car_color4:         .word 0x0082FA58 # cor chassi Carro Principal Inimigo
	car_color5:         .word 0x000174DF  # cor chassi Carro Principal Inimigo
	messageIni:         .asciiz "Bem Vindo ao MIPS SPEED RACER!\nSeu objetivo e desviar dos carros inimigos. Facil ne? Talvez nao.. Boa Sorte Piloto!\nControles:   a- Esquerda,   d- Direita\n\nPressione 'a' ou 'd' para iniciar.."
	messageScore:       .asciiz "Voce perdeu.. Que pena :(\nSua Pontuacao foi:   "
	messageRecord0:     .asciiz "\nRecord Atual-:   "
	messageRecord1:     .asciiz "PARABENS! ESTE E UM NOVO RECORD.. VOCE PILOTOU MUITO BEM!!!\nInforme seu Nome:"
	message0:           .asciiz "Pontuacao Atual: "
	message1:           .asciiz "Deseja jogar Novamente? \n"
	message2:           .asciiz "Tempo de Execucao em Miliseconds: "
	record_name:        .space 31
	record_score:       .word 0
	
	
###################################################################################################
.text	
	la $a0, messageIni   # Imprime mensagem Inicial
	li $a1, 2
	li $v0, 55
	syscall
	
state_initialMoment:
	jal initialMoment
	nop
	
state_refresh:
	li $s3, 0            # Zera o contador do Timer
	jal refresh
	nop
	jal startTimer       # Inicia o Timer
	nop
	
	beq $t7, 0, sleep0   # Se posicao do Carro for = 0, salta para sleep0
	nop
	beq $t7, 1, sleep1   # Se posicao do Carro for = 1, salta para sleep1
	nop
	j sleep2             # Se posicao do Carro for = 2, salta para sleep2
	nop
	
#00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
state1_left:   #***************************************************** Carro no Meio
	lw $a0, base_mainCar_left    # Apaga o Carro na esquerda
	lw $a1, background_color
	lw $a2, background_color
	lw $a3, background_color
	jal print_Car
	nop
	j state1
	nop
	
state1_right:
	lw $a0, base_mainCar_right    # Apaga o Carro na direita
	lw $a1, background_color
	lw $a2, background_color
	lw $a3, background_color
	jal print_Car
	nop
	
state1:
	lw $a0, base_mainCar_mid      # Escreve carro no meio
	lw $a1, car_color1
	lw $a2, car_color2
	lw $a3, car_color3
	
	lw $t0,($a0)
	bne $t0, $s5, exit            # Testa com o topo se o carro sera escrito em cima de outro
	nop
	lw $t0, 1536($a0)
	bne $t0, $s5, exit            # Testa com a base se o carro sera escrito em cima de outro
	nop
	
	jal print_Car                 # Escreve Carro no meio
	nop
	li $t7, 1                     # Atualiza o codigo de posicionamento
	
sleep1:
	jal refreshTimer              # Atualiza o Timer
	nop
	slt $t0, $s3, $s2             # Se o countTimer for maior que o timerLimit, atualiza a pagina
	beq $t0, 0, state_refresh 
	nop
	
	lw $t1, ($s4)                 # Carrega o cod que diz se houve uma tecla pressionada (1), ou nao (0)
	beq $t1, 0, sleep1            # Se houve, le a tecla
	nop
	lw $t0, 4($s4)                # Carrega a tecla para o $t0
	
	beq $t0, 97, state0           # Se = a, salta para state 0
	nop
	beq $t0, 100, state2          # Se = d, salta para o state 2
	nop
	j sleep1                      # se uma tecla invalida foi inserida, nao realiza nada e retorna para sleep1
	nop
	
state0:  #***************************************************** Carro na Esquerda
	lw $a0, base_mainCar_mid
	lw $a1, background_color
	lw $a2, background_color
	lw $a3, background_color
	jal print_Car
	nop
	
	lw $a0, base_mainCar_left
	lw $a1, car_color1
	lw $a2, car_color2
	lw $a3, car_color3
	
	lw $t0,($a0)
	bne $t0, $s5, exit            # Testa com o topo se o carro sera escrito em cima de outro
	nop
	lw $t0, 1536($a0)
	bne $t0, $s5, exit            # Testa com a base se o carro sera escrito em cima de outro
	nop
	
	jal print_Car
	nop
	li $t7, 0
sleep0:
	jal refreshTimer              # Atualiza o Timer
	nop
	slt $t0, $s3, $s2             # Se o countTimer for maior que o timerLimit, atualiza a pagina
	beq $t0, 0, state_refresh
	nop


	lw $t1, ($s4)                 # Carrega o cod que diz se houve uma tecla pressionada (1), ou nao (0)
	beq $t1, 0, sleep0            # Se houve, le a tecla
	nop
	lw $t0, 4($s4)                # Carrega a tecla para o $t0
	
	beq $t0, 100, state1_left     # Se = d, salta para state 1 pela esquerda
	nop
	j sleep0                      # se uma tecla invalida foi inserida, nao realiza nada e retorna para sleep0
	nop
	
state2:  ##***************************************************** Carro na Direita
	lw $a0, base_mainCar_mid
	lw $a1, background_color
	lw $a2, background_color
	lw $a3, background_color
	jal print_Car
	nop
	
	lw $a0, base_mainCar_right
	lw $a1, car_color1
	lw $a2, car_color2
	lw $a3, car_color3
	
	lw $t0,($a0)
	bne $t0, $s5, exit            # Testa com o topo se o carro sera escrito em cima de outro
	nop
	lw $t0, 1536($a0)
	bne $t0, $s5, exit            # Testa com a base se o carro sera escrito em cima de outro
	nop
	
	jal print_Car
	nop
	li $t7, 2
sleep2:
	jal refreshTimer              # Atualiza o Timer
	nop
	slt $t0, $s3, $s2             # Se o countTimer for maior que o timerLimit, atualiza a pagina
	beq $t0, 0, state_refresh
	nop

	lw $t1, ($s4)                 # Carrega o cod que diz se houve uma tecla pressionada (1), ou nao (0)
	beq $t1, 0, sleep2            # Se houve, le a tecla
	nop
	lw $t0, 4($s4)                # Carrega a tecla para o $t0
	
	beq $t0, 97, state1_right     # Se = a, salta para state 1 pela direita
	nop
	j sleep2                      # se uma tecla invalida foi inserida, nao realiza nada e retorna para sleep2
	nop
#00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
exit:
	jal print_end
	nop
	
	li $a0, 10              # Imprime um New Line
	li $v0, 11
	syscall
	
	la $a0, messageScore    # Imprime no Run I/O mensagem de Pontuacao
	li $v0, 4
	syscall
	
	move $a0, $s6           # imprime no Run I/O a Pontuacao
	li $v0, 1
	syscall
	
	lw $t0, record_score    # Carrega o valor do Record na memoria
	beq $t0, 0, next_exit0  # Se Record=0 ainda nao houve um record
	nop
	
	la $a0, messageRecord0  # Imprime no Run I/O a mensagem de Record
	li $v0, 4
	syscall
	
	move $a0, $t0           # Imprime o valor do Record
	li $v0, 1
	syscall
	
	li $a0, 9               # Imprime um tab
	li $v0, 11
	syscall
	
	la $a0, record_name     # Imprime o nome do Recordista salvo na memoria
	li $v0, 4
	syscall
	
	next_exit0:
	move $a1, $s6           # Imprime a Pontuacao no Pop Up
	la $a0, messageScore
	li $v0, 56
	syscall
	
	slt $t1, $t0, $s6       # Testa se a Record < Pontuacao
	beq $t1, 0, next_exit1
	nop
	la $t1, record_score
	sw $s6, ($t1)
	la $a0, messageRecord1
	la $a1, record_name
	li $a2, 31
	li $v0, 54
	syscall
	
	next_exit1:
	li $v0, 50 
	la $a0, message1
	syscall
	beq $a0, 0, next_exit2 # Se clicou em sim, salta
	nop
	li $v0, 10
	syscall
	next_exit2:
	lw $t0, ($s4)
	li $t0, 0              # Zera registradores necessarios para iniciar nova rotina
	li $t1, 0 
	li $t2, 0 
	li $t3, 0 
	li $t4, 0 
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	
	j state_initialMoment  # Reinicia o programa
	nop
	
###################################################################################################
# Imprime o carro principal, na posicao passada por argumento
# Guarda na pilha os valores dos registradores $t0 - $t3
print_halfCar:
		addi $sp, $sp, -16  
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		
		move $t3, $a0     # Endereco Incial para print
		move $t0, $a1     # Cor Chassi 1
		move $t1, $a2     # Cor Chassi 2
		move $t2, $a3     # Cor Pneu
		
		sw $t1, 0($t3)    # Sequencia de Stores para guardar as cores em cada posicao 
		sw $t1, 4($t3)
		sw $t1, 120($t3)
		sw $t1, 124($t3)
		sw $t1, 136($t3)
		sw $t1, 140($t3)
		sw $t0, 508($t3)
		sw $t0, 520($t3)
		sw $t2, 628($t3)
		sw $t2, 632($t3)
		sw $t2, 652($t3)
		sw $t2, 656($t3)
		sw $t0, 896($t3)
		sw $t0, 900($t3)
		sw $t0, 1144($t3)
		sw $t0, 1164($t3)
		sw $t2, 1264($t3)
		sw $t2, 1268($t3)
		sw $t0, 1276($t3)
		sw $t1, 1280($t3)
		sw $t1, 1284($t3)
		sw $t0, 1288($t3)
		sw $t2, 1296($t3)
		sw $t2, 1300($t3)
		sw $t0, 1400($t3)
		sw $t1, 1404($t3)
		sw $t0, 1408($t3)
		sw $t0, 1412($t3)
		sw $t1, 1416($t3)
		sw $t0, 1420($t3)
		sw $t1, 1524($t3)
		sw $t1, 1528($t3)
		sw $t1, 1536($t3)
		sw $t1, 1540($t3)
		sw $t1, 1548($t3)
		sw $t1, 1552($t3)
		sw $t1, 1660($t3)
		sw $t1, 1672($t3)
		
		lw $t1, background_color
		sw $t1, -128($t3)
		sw $t1, -124($t3)
		#sw $t1, -4($t3)
		sw $t1, -8($t3)
		sw $t1, 8($t3)
		sw $t1, 12($t3)
		sw $t1, 244($t3)
		sw $t1, 248($t3)
		sw $t1, 268($t3)
		sw $t1, 272($t3)
		sw $t1, 380($t3)
		sw $t1, 392($t3)
		sw $t1, 636($t3)
		sw $t1, 648($t3)
		sw $t1, 880($t3)
		sw $t1, 884($t3)
		sw $t1, 912($t3)
		sw $t1, 916($t3)
		sw $t1, 1016($t3)
		sw $t1, 1036($t3)
		sw $t1, 1272($t3)
		sw $t1, 1292($t3)
		sw $t1, 1396($t3)
		sw $t1, 1424($t3)
		
		
		lw $t0, 0($sp)       # Desempilha valores
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		addi $sp, $sp, 16
		jr $ra
		nop
###################################################################################################
# Imprime o carro principal, na posicao passada por argumento
# Guarda na pilha os valores dos registradores $t0 - $t3
print_Car:
		addi $sp, $sp, -16  
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		
		move $t3, $a0     # Endereco Incial para print
		move $t0, $a1     # Cor Chassi 1
		move $t1, $a2     # Cor Chassi 2
		move $t2, $a3     # Cor Pneu
		
		sw $t1, 0($t3)    # Sequencia de Stores para guardar as cores em cada posicao 
		sw $t1, 4($t3)
		sw $t1, 120($t3)
		sw $t1, 124($t3)
		sw $t0, 128($t3)
		sw $t0, 132($t3)
		sw $t1, 136($t3)
		sw $t1, 140($t3)
		sw $t0, 256($t3)
		sw $t0, 260($t3)
		sw $t2, 372($t3)
		sw $t2, 376($t3)
		sw $t0, 384($t3)
		sw $t0, 388($t3)
		sw $t2, 396($t3)
		sw $t2, 400($t3)
		sw $t2, 500($t3)
		sw $t2, 504($t3)
		sw $t0, 508($t3)
		sw $t0, 512($t3)
		sw $t0, 516($t3)
		sw $t0, 520($t3)
		sw $t2, 524($t3)
		sw $t2, 528($t3)
		sw $t2, 628($t3)
		sw $t2, 632($t3)
		sw $t0, 640($t3)
		sw $t0, 644($t3)
		sw $t2, 652($t3)
		sw $t2, 656($t3)
		sw $t0, 764($t3)
		sw $t0, 768($t3)
		sw $t0, 772($t3)
		sw $t0, 776($t3)
		sw $t0, 892($t3)
		sw $t0, 896($t3)
		sw $t0, 900($t3)
		sw $t0, 904($t3)
		sw $t2, 1008($t3)
		sw $t2, 1012($t3)
		sw $t0, 1020($t3)
		sw $t1, 1024($t3)
		sw $t1, 1028($t3)
		sw $t0, 1032($t3)
		sw $t2, 1040($t3)
		sw $t2, 1044($t3)
		sw $t2, 1136($t3)
		sw $t2, 1140($t3)
		sw $t0, 1144($t3)
		sw $t0, 1148($t3)
		sw $t1, 1152($t3)
		sw $t1, 1156($t3)
		sw $t0, 1160($t3)
		sw $t0, 1164($t3)
		sw $t2, 1168($t3)
		sw $t2, 1172($t3)
		sw $t2, 1264($t3)
		sw $t2, 1268($t3)
		sw $t0, 1276($t3)
		sw $t1, 1280($t3)
		sw $t1, 1284($t3)
		sw $t0, 1288($t3)
		sw $t2, 1296($t3)
		sw $t2, 1300($t3)
		sw $t0, 1400($t3)
		sw $t1, 1404($t3)
		sw $t0, 1408($t3)
		sw $t0, 1412($t3)
		sw $t1, 1416($t3)
		sw $t0, 1420($t3)
		sw $t1, 1524($t3)
		sw $t1, 1528($t3)
		sw $t1, 1532($t3)
		sw $t1, 1536($t3)
		sw $t1, 1540($t3)
		sw $t1, 1544($t3)
		sw $t1, 1548($t3)
		sw $t1, 1552($t3)
		sw $t1, 1660($t3)
		sw $t1, 1672($t3)
		
		
		lw $t0, 0($sp)       # Desempilha valores
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		addi $sp, $sp, 16
		jr $ra
		nop
###################################################################################################		
print_background:
		lw $t0, limit_refresh_ini
		addi $t0, $t0, -128
		lw $t1, limit_refresh_end
		addi $t1, $t1, 128
		
		loop_print_refresh:
		beq $t0, $t1, return_print_background
		nop
		sw $s5, ($t0)
		addi $t0, $t0, 4
		j loop_print_refresh
		nop
		
		return_print_background:
		jr $ra
		nop
		
###################################################################################################
# Subrotina Permanece no estado incial ate que alguma tecla valida seja pressionada
# Subrotina chama outras subrotinas, para isso usa a Pilha para guardar os valores de retorno
initialMoment:
		addi $sp, $sp, -4                 # Guarda endereco de retorno
		sw $ra, ($sp)
		 
		li $t5, 40                        # Numero de Linhas que limita o espaçamento entre carros
		li $s4, 0xFFFF0000                # Endereco que armazena os valores do sdtin
		lw $s5, background_color          # Cor do Fundo
		
		jal print_background
		nop
		
		lw $a0, base_mainCar_mid          # Imprime o carro principal na posicao do meio
		lw $a1, car_color1
		lw $a2, car_color2
		lw $a3, car_color3
		jal print_Car
		nop
		
	loop_initialMoment:
		lw $t0, ($s4)                     # Carrega o valor no endereco em $s4
		bne $t0, 1, sleep_initialMoment   # se 0 nenhuma tecla foi pressionada
		nop                               # se 1, le a tecla que foi pressionada
		lw $t0, 4($s4)                   
		beq $t0, 97, left_initialMoment   # salta se a tecla for 'a'
		nop
		beq $t0, 100, right_initialMoment # salta se a tecla for 'd'
		nop                               # Se outra tecla foi pressionada, executa o sleep e retorna para o loop
	sleep_initialMoment:                      # Sleep de 100 milisegundos e retorna para loop_initialMoment
		li $a0, 100
		li $v0, 32
		syscall
		j loop_initialMoment
		nop
		
	left_initialMoment:
		lw $a0, base_mainCar_mid           # Apaga o carro no meio
		lw $a1, background_color
		lw $a2, background_color
		lw $a3, background_color
		jal print_Car
		nop
		
		lw $a0, base_mainCar_left          # Escreve carro na esquerda
		lw $a1, car_color1
		lw $a2, car_color2
		lw $a3, car_color3
		jal print_Car
		nop
		
		li $t7, 0                          # flag 0 em $t7 = O veiculo esta na esquerda
		
		j return_initialMoment             # Retorna da subrotina
		nop
		
	right_initialMoment:
		lw $a0, base_mainCar_mid           # Apaga o carro no meio
		lw $a1, background_color
		lw $a2, background_color
		lw $a3, background_color
		jal print_Car
		nop
		
		lw $a0, base_mainCar_right         # Escreve carro na direita
		lw $a1, car_color1
		lw $a2, car_color2
		lw $a3, car_color3
		jal print_Car
		nop
		
		li $t7, 2                          # flag 2 em $t7 = O veiculo esta na direita

	return_initialMoment:
		lw $ra, ($sp)                      # Desempilha o valor de retorno
		addi $sp, $sp, 4
		jr $ra
		nop
		
###################################################################################################
# Subrotina atualiza a area jogavel, ou seja, move todas as linhas para baixo uma vez
# Subrotina chama outras subrotinas, para isso usa a Pilha para guardar os valores de retorno
refresh:	
		addi $sp, $sp, -4
		sw $ra, ($sp)
		
		jal print_buffer           # Subrotina que imprime na area invisivel (Buffer) os proximos inimigos
		nop
		
		lw $t0, limit_refresh_ini         
		addi $t0, $t0, -128
		lw $t2, limit_refresh_end      # Endereco do ponto final da area invisivel
		addi $t2, $t2, 104
		li $t4, 0x10041880
		
	loop_refresh:
		slt $t3, $t0, $t2
		beq $t3, 0, return_refresh
		nop
		lw $t1, -4($t2)
		beq $t1, 0x00848485, refresh_car_1
		nop
		beq $t1, 0x00848486, refresh_car_2
		nop
		beq $t1, 0x00848487, refresh_car_3
		nop
		
		move $t1, $t2
		sll $t1, $t1, 28
		beq $t1, $0, loop_aux
		nop
		addi $t2, $t2, -44
		j loop_refresh
		nop
		loop_aux:
		addi $t2, $t2, -40
		j loop_refresh
		nop
	
	refresh_car_1:
		move $a0, $t2
		slt $t3, $a0, $t4
		beq $t3, 0, next_refresh_car_1
		nop
		lw $t3, 1664($a0)
		bne $t3, $s5, exit
		nop
		
		next_refresh_car_1:
		sw $t1, 124($a0)
		sw $s5, -4($a0)
		addi $a0, $a0, 128
		lw $a1, car_color4
		lw $a2, car_color5
		lw $a3, car_color3
		jal print_halfCar
		nop
		
		addi $t2, $t2, -40
		j loop_refresh
		nop
	refresh_car_2:
		move $a0, $t2
		slt $t3, $a0, $t4
		beq $t3, 0, next_refresh_car_2
		nop
		lw $t3, 1664($a0)
		bne $t3, $s5, exit
		nop
		
		next_refresh_car_2:
		sw $t1, 124($a0)
		sw $s5, -4($a0)
		addi $a0, $a0, 128
		lw $a1, car_color4
		lw $a2, car_color5
		lw $a3, car_color3
		jal print_halfCar
		nop
		
		addi $t2, $t2, -44
		j loop_refresh
		nop
	refresh_car_3:
		move $a0, $t2
		slt $t3, $a0, $t4
		beq $t3, 0, next_refresh_car_3
		nop
		lw $t3, 1664($a0)
		bne $t3, $s5, exit
		nop
		
		next_refresh_car_3:
		sw $t1, 124($a0)
		sw $s5, -4($a0)
		addi $a0, $a0, 128
		lw $a1, car_color4
		lw $a2, car_color5
		lw $a3, car_color3
		jal print_halfCar
		nop
		
		addi $t2, $t2, -44
		j loop_refresh
		nop
	
	return_refresh:
		addi $s6, $s6, 10                   # $s6 atualiza a pontuacao do jogador a cada refresh
		
		la $a0, message0
		li $v0, 4
		syscall
		
		move $a0, $s6
		li $v0, 1
		syscall
		
		li $a0, 10
		li $v0, 11
		syscall
		
		addi $t6, $t6, 1                    # $t6 atualiza o numero de refreshs que ja ocorreram
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra
		nop		
###################################################################################################
# Subrotina insere na area invisivel a proxima interacao
# Subrotina chama outras subrotinas, para isso usa a Pilha para guardar os valores de retorno
print_buffer:
		addi $sp, $sp, -4
		sw $ra, ($sp)
		
		beq $t6, 0, fill_Buffer         # Se $t6=0 entao deve escrever sequencia de inimigos na area invisivel
		nop
		bne $t6, $t5, return_print_buffer  # Salta se $t6 for diferente de 37
		nop
		li $t6, -1                      # Zera o Contador de Refreshs
		
		j return_print_buffer
		nop
		
	fill_Buffer:
		lw $t0, limit_refresh_ini           # Endereco inicial da area invisivel                         
		li $a0, 1                       # Funcao randon, de 0-5
		li $a1, 7
		li $v0, 42
		syscall

		beq $a0, 1, fill_1
		nop
		beq $a0, 2, fill_2
		nop
		beq $a0, 3, fill_3
		nop
		beq $a0, 4, fill_12
		nop
		beq $a0, 5, fill_13
		nop
		beq $a0, 6, fill_23
		nop
	fill_1:  # Inimigo na esquerda
		lw $a0, base_enemyCar_left
		li $t1, 0x00848485
		sw $t1, -4($a0)
		lw $a1, car_color4
		lw $a2, car_color5
		lw $a3, car_color3
		jal print_Car
		nop
		j return_print_buffer
		nop
	fill_2:  # Inimigo no meio
		lw $a0, base_enemyCar_mid
		li $t1, 0x00848486
		sw $t1, -4($a0)
		lw $a1, car_color4
		lw $a2, car_color5
		lw $a3, car_color3
		jal print_Car
		nop
		j return_print_buffer
		nop
	fill_3:  # Inimigo na direita
		lw $a0, base_enemyCar_right
		li $t1, 0x00848487
		sw $t1, -4($a0)
		lw $a1, car_color4
		lw $a2, car_color5
		lw $a3, car_color3
		jal print_Car
		nop
		j return_print_buffer
		nop
	fill_12: # Inimigo na esquerda e no meio
		lw $a0, base_enemyCar_left
		li $t1, 0x00848485
		sw $t1, -4($a0)
		lw $a1, car_color4
		lw $a2, car_color5
		lw $a3, car_color3
		jal print_Car
		nop
		lw $a0, base_enemyCar_mid
		li $t1, 0x00848486
		sw $t1, -4($a0)
		lw $a1, car_color4
		lw $a2, car_color5
		lw $a3, car_color3
		jal print_Car
		nop
		j return_print_buffer
		nop
	fill_13: # Inimigo na esquerda e na direita
		lw $a0, base_enemyCar_left
		li $t1, 0x00848485
		sw $t1, -4($a0)
		lw $a1, car_color4
		lw $a2, car_color5
		lw $a3, car_color3
		jal print_Car
		nop
		lw $a0, base_enemyCar_right
		li $t1, 0x00848487
		sw $t1, -4($a0)
		lw $a1, car_color4
		lw $a2, car_color5
		lw $a3, car_color3
		jal print_Car
		nop
		j return_print_buffer
		nop
	fill_23: # Inimigo no meio e na direita
		lw $a0, base_enemyCar_mid
		li $t1, 0x00848486
		sw $t1, -4($a0)
		lw $a1, car_color4
		lw $a2, car_color5
		lw $a3, car_color3
		jal print_Car
		nop
		lw $a0, base_enemyCar_right
		li $t1, 0x00848487
		sw $t1, -4($a0)
		lw $a1, car_color4
		lw $a2, car_color5
		lw $a3, car_color3
		jal print_Car
		nop
		
	return_print_buffer:
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra
		nop
		
###################################################################################################
# Subrotina atualiza o contador do timer e inicia novamente o timer
refreshTimer:
		li $v0, 30            # Funcao que inicia o relogio
		syscall
		move $t1, $a0
		sub $t1, $t1, $s0
		add $s3, $s3, $t1
###################################################################################################
# Subrotina inicia o relogio e define a taxa de atualizacoes em milisegundos
startTimer:
		li $v0, 30            # Funcao que inicia o relogio
		syscall
		move $s0, $a0
		
		slti $t0, $s6, 32000  # Define a tempo do timerLimit
		beq $t0, 0, speed9
		nop
		slti $t0, $s6, 24000
		beq $t0, 0, speed8
		nop
		slti $t0, $s6, 18000
		beq $t0, 0, speed7
		nop
		slti $t0, $s6, 12000
		beq $t0, 0, speed6
		nop
		slti $t0, $s6, 9000
		beq $t0, 0, speed5
		nop
		slti $t0, $s6, 7000
		beq $t0, 0, speed4
		nop
		slti $t0, $s6, 5000
		beq $t0, 0, speed3
		nop
		slti $t0, $s6, 3000
		beq $t0, 0, speed2
		nop
		slti $t0, $s6, 2000
		beq $t0, 0, speed1
		nop
		slti $t0, $s6, 1000
		beq $t0, 0, speed0
		nop
		li $s2, 50
		j return_startTimer
		nop
		
		speed0:                # Set o timerLimit
		li $s2, 45
		j return_startTimer
		nop
		speed1:
		li $s2, 40
		j return_startTimer
		nop
		speed2:
		li $s2, 35
		j return_startTimer
		nop
		speed3:
		li $s2, 30
		j return_startTimer
		nop
		speed4:
		li $s2, 25
		j return_startTimer
		nop
		speed5:
		li $s2, 20
		j return_startTimer
		nop
		speed6:
		li $s2, 15
		j return_startTimer
		nop
		speed7:
		li $s2, 10
		j return_startTimer
		nop
		speed8:
		li $s2, 8
		j return_startTimer
		nop
		speed9:
		li $s2, 5
		
	return_startTimer:
		jr $ra
		nop
###################################################################################################
###################################################################################################
# Imprime tela Final
print_end:
		lw $t0, limit_refresh_ini              # Endereco Inicial da area imprimivel
		addi $t0, $t0, 1792
		lw $t1, limit_refresh_end             # Endereco Final+1 da area imprimivel
		addi $t1, $t1, 128
		li $t2, 0
	loop_print_end:
		beq $t0, $t1, return_print_end
		nop
		sw $t2, ($t0)
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 12($t0)
		sw $t2, 16($t0)
		addi $t0, $t0, 16
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 12($t0)
		sw $t2, 16($t0)
		addi $t0, $t0, 16
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 12($t0)
		sw $t2, 16($t0)
		addi $t0, $t0, 16
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 12($t0)
		sw $t2, 16($t0)
		addi $t0, $t0, 16
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 12($t0)
		sw $t2, 16($t0)
		addi $t0, $t0, 16
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 12($t0)
		sw $t2, 16($t0)
		addi $t0, $t0, 16
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 12($t0)
		sw $t2, 16($t0)
		addi $t0, $t0, 16
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 12($t0)
		addi $t0, $t0, 16
		
		li $a0, 30
		li $v0, 32
		syscall
		
		j loop_print_end
		nop
	return_print_end:
		li $t7, 0x10040000
		li $t0, 0x00B60426
		li $t1, 0x00FFFFFF
		
		sw $t0, 520($t7)
		sw $t0, 524($t7)
		sw $t0, 544($t7)
		sw $t0, 548($t7)
		
		sw $t0, 644($t7)
		sw $t1, 648($t7)
		sw $t0, 652($t7)
		sw $t0, 656($t7)
		sw $t0, 668($t7)
		sw $t1, 672($t7)
		sw $t0, 676($t7)
		sw $t0, 680($t7)
		
		sw $t0, 772($t7)
		sw $t1, 776($t7)
		sw $t0, 780($t7)
		sw $t0, 784($t7)
		sw $t0, 788($t7)
		sw $t0, 796($t7)
		sw $t1, 800($t7)
		sw $t0, 804($t7)
		sw $t0, 808($t7)
		sw $t0, 820($t7)
		sw $t0, 824($t7)
		sw $t0, 828($t7)
		sw $t0, 832($t7)
		sw $t0, 848($t7)
		sw $t0, 852($t7)
		sw $t0, 864($t7)
		sw $t0, 868($t7)
		
		sw $t0, 900($t7)
		sw $t0, 904($t7)
		sw $t1, 908($t7)
		sw $t0, 912($t7)
		sw $t0, 916($t7)
		sw $t0, 920($t7)
		sw $t1, 924($t7)
		sw $t0, 928($t7)
		sw $t0, 932($t7)
		sw $t0, 936($t7)
		sw $t0, 944($t7)
		sw $t1, 948($t7)
		sw $t1, 952($t7)
		sw $t1, 956($t7)
		sw $t0, 960($t7)
		sw $t0, 964($t7)
		sw $t0, 972($t7)
		sw $t1, 976($t7)
		sw $t0, 980($t7)
		sw $t0, 984($t7)
		sw $t0, 988($t7)
		sw $t1, 992($t7)
		sw $t0, 996($t7)
		sw $t0, 1000($t7)
		
		sw $t0, 1032($t7)
		sw $t0, 1036($t7)
		sw $t1, 1040($t7)
		sw $t1, 1044($t7)
		sw $t1, 1048($t7)
		sw $t0, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1060($t7)
		sw $t0, 1068($t7)
		sw $t1, 1072($t7)
		sw $t0, 1076($t7)
		sw $t0, 1080($t7)
		sw $t0, 1084($t7)
		sw $t1, 1088($t7)
		sw $t0, 1092($t7)
		sw $t0, 1096($t7)
		sw $t0, 1100($t7)
		sw $t1, 1104($t7)
		sw $t0, 1108($t7)
		sw $t0, 1112($t7)
		sw $t0, 1116($t7)
		sw $t1, 1120($t7)
		sw $t0, 1124($t7)
		sw $t0, 1128($t7)
		
		addi $t7, $t7,128
		sw $t0, 1036($t7)
		sw $t0, 1040($t7)
		sw $t1, 1044($t7)
		sw $t0, 1048($t7)
		sw $t0, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1068($t7)
		sw $t1, 1072($t7)
		sw $t0, 1076($t7)
		sw $t0, 1080($t7)
		sw $t0, 1084($t7)
		sw $t1, 1088($t7)
		sw $t0, 1092($t7)
		sw $t0, 1096($t7)
		sw $t0, 1100($t7)
		sw $t1, 1104($t7)
		sw $t0, 1108($t7)
		sw $t0, 1112($t7)
		sw $t0, 1116($t7)
		sw $t1, 1120($t7)
		sw $t0, 1124($t7)
		sw $t0, 1128($t7)
		
		addi $t7, $t7,128
		sw $t0, 1040($t7)
		sw $t1, 1044($t7)
		sw $t0, 1048($t7)
		sw $t0, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1068($t7)
		sw $t1, 1072($t7)
		sw $t0, 1076($t7)
		sw $t0, 1080($t7)
		sw $t0, 1084($t7)
		sw $t1, 1088($t7)
		sw $t0, 1092($t7)
		sw $t0, 1096($t7)
		sw $t0, 1100($t7)
		sw $t1, 1104($t7)
		sw $t0, 1108($t7)
		sw $t0, 1112($t7)
		sw $t0, 1116($t7)
		sw $t1, 1120($t7)
		sw $t0, 1124($t7)
		sw $t0, 1128($t7)
		
		addi $t7, $t7,128
		sw $t0, 1040($t7)
		sw $t1, 1044($t7)
		sw $t0, 1048($t7)
		sw $t0, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1068($t7)
		sw $t0, 1072($t7)
		sw $t1, 1076($t7)
		sw $t1, 1080($t7)
		sw $t1, 1084($t7)
		sw $t0, 1088($t7)
		sw $t0, 1092($t7)
		sw $t0, 1096($t7)
		sw $t0, 1100($t7)
		sw $t0, 1104($t7)
		sw $t1, 1108($t7)
		sw $t1, 1112($t7)
		sw $t1, 1116($t7)
		sw $t0, 1120($t7)
		sw $t0, 1124($t7)
		sw $t0, 1128($t7)
		
		addi $t7, $t7,128
		sw $t0, 1040($t7)
		sw $t0, 1044($t7)
		sw $t0, 1048($t7)
		sw $t0, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1072($t7)
		sw $t0, 1076($t7)
		sw $t0, 1080($t7)
		sw $t0, 1084($t7)
		sw $t0, 1088($t7)
		sw $t0, 1092($t7)
		sw $t0, 1104($t7)
		sw $t0, 1108($t7)
		sw $t0, 1112($t7)
		sw $t0, 1116($t7)
		sw $t0, 1120($t7)
		sw $t0, 1124($t7)
		sw $t0, 1128($t7)
	
		addi $t7, $t7,128
		sw $t0, 1044($t7)
		sw $t0, 1048($t7)
		sw $t0, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1076($t7)
		sw $t0, 1080($t7)
		sw $t0, 1084($t7)
		sw $t0, 1088($t7)
		sw $t0, 1108($t7)
		sw $t0, 1112($t7)
		sw $t0, 1116($t7)
		sw $t0, 1120($t7)
		sw $t0, 1124($t7)
		
		addi $t7, $t7, 388
		sw $t0, 1036($t7)
		sw $t0, 1040($t7)
		sw $t0, 1044($t7)
		sw $t0, 1048($t7)
		sw $t0, 1052($t7)
		sw $t0, 1068($t7)
		sw $t0, 1072($t7)
		sw $t0, 1132($t7)
		sw $t0, 1136($t7)
		
		addi $t7, $t7, 128
		sw $t0, 1032($t7)
		sw $t1, 1036($t7)
		sw $t1, 1040($t7)
		sw $t1, 1044($t7)
		sw $t1, 1048($t7)
		sw $t0, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1064($t7)
		sw $t1, 1068($t7)
		sw $t0, 1072($t7)
		sw $t0, 1076($t7)
		sw $t0, 1128($t7)
		sw $t1, 1132($t7)
		sw $t0, 1136($t7)
		sw $t0, 1140($t7)
		
		addi $t7, $t7, 128
		sw $t0, 1032($t7)
		sw $t1, 1036($t7)
		sw $t0, 1040($t7)
		sw $t0, 1044($t7)
		sw $t0, 1048($t7)
		sw $t1, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1060($t7)
		sw $t0, 1064($t7)
		sw $t0, 1068($t7)
		sw $t0, 1072($t7)
		sw $t0, 1076($t7)
		sw $t0, 1088($t7)
		sw $t0, 1092($t7)
		sw $t0, 1096($t7)
		sw $t0, 1100($t7)
		sw $t0, 1120($t7)
		sw $t0, 1124($t7)
		sw $t0, 1128($t7)
		sw $t1, 1132($t7)
		sw $t0, 1136($t7)
		sw $t0, 1140($t7)
		
		addi $t7, $t7, 128
		sw $t0, 1032($t7)
		sw $t1, 1036($t7)
		sw $t0, 1040($t7)
		sw $t0, 1044($t7)
		sw $t0, 1048($t7)
		sw $t1, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1060($t7)
		sw $t0, 1064($t7)
		sw $t1, 1068($t7)
		sw $t0, 1072($t7)
		sw $t0, 1076($t7)
		
		sw $t0, 1084($t7)
		sw $t1, 1088($t7)
		sw $t1, 1092($t7)
		sw $t1, 1096($t7)
		sw $t0, 1100($t7)
		sw $t0, 1104($t7)
		
		sw $t0, 1116($t7)
		sw $t1, 1120($t7)
		sw $t1, 1124($t7)
		sw $t1, 1128($t7)
		sw $t1, 1132($t7)
		sw $t0, 1136($t7)
		sw $t0, 1140($t7)
		
		addi $t7, $t7, 128
		sw $t0, 1032($t7)
		sw $t1, 1036($t7)
		sw $t0, 1040($t7)
		sw $t0, 1044($t7)
		sw $t0, 1048($t7)
		sw $t1, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1060($t7)
		sw $t0, 1064($t7)
		sw $t1, 1068($t7)
		sw $t0, 1072($t7)
		sw $t0, 1076($t7)
		sw $t0, 1080($t7)
		sw $t1, 1084($t7)
		sw $t0, 1088($t7)
		sw $t0, 1092($t7)
		sw $t0, 1096($t7)
		sw $t1, 1100($t7)
		sw $t0, 1104($t7)
		sw $t0, 1108($t7)
		sw $t0, 1112($t7)
		sw $t1, 1116($t7)
		sw $t0, 1120($t7)
		sw $t0, 1124($t7)
		sw $t0, 1128($t7)
		sw $t1, 1132($t7)
		sw $t0, 1136($t7)
		sw $t0, 1140($t7)
		
		addi $t7, $t7, 128
		sw $t0, 1032($t7)
		sw $t1, 1036($t7)
		sw $t0, 1040($t7)
		sw $t0, 1044($t7)
		sw $t0, 1048($t7)
		sw $t1, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1060($t7)
		sw $t0, 1064($t7)
		sw $t1, 1068($t7)
		sw $t0, 1072($t7)
		sw $t0, 1076($t7)
		sw $t0, 1080($t7)
		sw $t1, 1084($t7)
		sw $t1, 1088($t7)
		sw $t1, 1092($t7)
		sw $t1, 1096($t7)
		sw $t1, 1100($t7)
		sw $t0, 1104($t7)
		sw $t0, 1108($t7)
		sw $t0, 1112($t7)
		sw $t1, 1116($t7)
		sw $t0, 1120($t7)
		sw $t0, 1124($t7)
		sw $t0, 1128($t7)
		sw $t1, 1132($t7)
		sw $t0, 1136($t7)
		sw $t0, 1140($t7)
		
		addi $t7, $t7, 128
		sw $t0, 1032($t7)
		sw $t1, 1036($t7)
		sw $t0, 1040($t7)
		sw $t0, 1044($t7)
		sw $t0, 1048($t7)
		sw $t1, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1060($t7)
		sw $t0, 1064($t7)
		sw $t1, 1068($t7)
		sw $t0, 1072($t7)
		sw $t0, 1076($t7)
		sw $t0, 1080($t7)
		sw $t1, 1084($t7)
		sw $t0, 1088($t7)
		sw $t0, 1092($t7)
		sw $t0, 1096($t7)
		sw $t0, 1100($t7)
		sw $t0, 1104($t7)
		sw $t0, 1108($t7)
		sw $t0, 1112($t7)
		sw $t1, 1116($t7)
		sw $t0, 1120($t7)
		sw $t0, 1124($t7)
		sw $t0, 1128($t7)
		sw $t1, 1132($t7)
		sw $t0, 1136($t7)
		sw $t0, 1140($t7)
		
		addi $t7, $t7, 128
		sw $t0, 1032($t7)
		sw $t1, 1036($t7)
		sw $t1, 1040($t7)
		sw $t1, 1044($t7)
		sw $t1, 1048($t7)
		sw $t0, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1060($t7)
		sw $t0, 1064($t7)
		sw $t1, 1068($t7)
		sw $t0, 1072($t7)
		sw $t0, 1076($t7)
		sw $t0, 1080($t7)
		sw $t0, 1084($t7)
		sw $t1, 1088($t7)
		sw $t1, 1092($t7)
		sw $t1, 1096($t7)
		sw $t1, 1100($t7)
		sw $t0, 1104($t7)
		sw $t0, 1108($t7)
		sw $t0, 1112($t7)
		sw $t0, 1116($t7)
		sw $t1, 1120($t7)
		sw $t1, 1124($t7)
		sw $t1, 1128($t7)
		sw $t1, 1132($t7)
		sw $t0, 1136($t7)
		sw $t0, 1140($t7)
		
		addi $t7, $t7, 128
		sw $t0, 1032($t7)
		sw $t0, 1036($t7)
		sw $t0, 1040($t7)
		sw $t0, 1044($t7)
		sw $t0, 1048($t7)
		sw $t0, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1060($t7)
		sw $t0, 1064($t7)
		sw $t0, 1068($t7)
		sw $t0, 1072($t7)
		sw $t0, 1076($t7)
		sw $t0, 1084($t7)
		sw $t0, 1088($t7)
		sw $t0, 1092($t7)
		sw $t0, 1096($t7)
		sw $t0, 1100($t7)
		sw $t0, 1104($t7)
		sw $t0, 1108($t7)
		sw $t0, 1116($t7)
		sw $t0, 1120($t7)
		sw $t0, 1124($t7)
		sw $t0, 1128($t7)
		sw $t0, 1132($t7)
		sw $t0, 1136($t7)
		sw $t0, 1140($t7)
		
		addi $t7, $t7, 128
		sw $t0, 1036($t7)
		sw $t0, 1040($t7)
		sw $t0, 1044($t7)
		sw $t0, 1048($t7)
		sw $t0, 1052($t7)
		sw $t0, 1056($t7)
		sw $t0, 1068($t7)
		sw $t0, 1072($t7)
		sw $t0, 1076($t7)
		sw $t0, 1088($t7)
		sw $t0, 1092($t7)
		sw $t0, 1096($t7)
		sw $t0, 1100($t7)
		sw $t0, 1104($t7)
		sw $t0, 1108($t7)
		sw $t0, 1120($t7)
		sw $t0, 1124($t7)
		sw $t0, 1128($t7)
		sw $t0, 1132($t7)
		sw $t0, 1136($t7)
		sw $t0, 1140($t7)
		
		li $t0, 0x00666664
		li $t1, 0x00FFFFFF
		li $t2, 0x0050C8ED
		li $t3, 0x002391B4
		li $t4, 0x0076CFED
		li $t5, 0x00C0E4F6
		li $t6, 0x00196A85
		li $t8, 0x08DCFF2
		li $t9, 0x000F4253
		
		addi $t7, $t7, 1020
		addi $t7, $t7, 1920
		sw $t0, 40($t7)
		sw $t0, 44($t7)
		sw $t0, 48($t7)
		sw $t0, 52($t7)
		sw $t0, 56($t7)
		
		addi $t7, $t7, 128
		sw $t0, 32($t7)
		sw $t0, 36($t7)
		sw $t1, 40($t7)
		sw $t1, 44($t7)
		sw $t2, 48($t7)
		sw $t2, 52($t7)
		sw $t3, 56($t7)
		sw $t0, 60($t7)
		sw $t0, 64($t7)
		
		addi $t7, $t7, 128
		sw $t0, 28($t7)
		sw $t1, 32($t7)
		sw $t1, 36($t7)
		sw $t4, 40($t7)
		sw $t2, 44($t7)
		sw $t2, 48($t7)
		sw $t3, 52($t7)
		sw $t3, 56($t7)
		sw $t3, 60($t7)
		sw $t3, 64($t7)
		sw $t0, 68($t7)
		
		addi $t7, $t7, 128
		sw $t0, 24($t7)
		sw $t1, 28($t7)
		sw $t1, 32($t7)
		sw $t1, 36($t7)
		sw $t4, 40($t7)
		sw $t1, 44($t7)
		sw $t5, 48($t7)
		sw $t3, 52($t7)
		sw $t6, 56($t7)
		sw $t6, 60($t7)
		sw $t6, 64($t7)
		sw $t3, 68($t7)
		sw $t0, 72($t7)
		
		addi $t7, $t7, 128
		sw $t0, 20($t7)
		sw $t1, 24($t7)
		sw $t1, 28($t7)
		sw $t1, 32($t7)
		sw $t8, 36($t7)
		sw $t4, 40($t7)
		sw $t5, 44($t7)
		sw $t5, 48($t7)
		sw $t3, 52($t7)
		sw $t6, 56($t7)
		sw $t9, 60($t7)
		sw $t9, 64($t7)
		sw $t3, 68($t7)
		sw $t3, 72($t7)
		sw $t0, 76($t7)
		
		addi $t7, $t7, 128
		sw $t0, 20($t7)
		sw $t1, 24($t7)
		sw $t1, 28($t7)
		sw $t1, 32($t7)
		sw $t8, 36($t7)
		sw $t4, 40($t7)
		sw $t2, 44($t7)
		sw $t3, 48($t7)
		sw $t3, 52($t7)
		sw $t6, 56($t7)
		sw $t9, 60($t7)
		sw $t9, 64($t7)
		sw $t3, 68($t7)
		sw $t3, 72($t7)
		sw $t0, 76($t7)
		
		li $t5, 0x003CB1D2
		li $t9, 0x00E6D6D6
		addi $t7, $t7, 128
		sw $t0, 16($t7)
		sw $t1, 20($t7)
		sw $t1, 24($t7)
		sw $t1, 28($t7)
		sw $t1, 32($t7)
		sw $t8, 36($t7)
		sw $t4, 40($t7)
		sw $t2, 44($t7)
		sw $t2, 48($t7)
		sw $t3, 52($t7)
		sw $t3, 56($t7)
		sw $t3, 60($t7)
		sw $t3, 64($t7)
		sw $t3, 68($t7)
		sw $t5, 72($t7)
		sw $t9, 76($t7)		
		sw $t0, 80($t7)		
		
		addi $t7, $t7, 128
		sw $t0, 16($t7)
		sw $t1, 20($t7)
		sw $t1, 24($t7)
		sw $t1, 28($t7)
		sw $t1, 32($t7)
		sw $t8, 36($t7)
		sw $t4, 40($t7)
		sw $t4, 44($t7)
		sw $t2, 48($t7)
		sw $t2, 52($t7)
		sw $t3, 56($t7)
		sw $t3, 60($t7)
		sw $t3, 64($t7)
		sw $t5, 68($t7)
		sw $t5, 72($t7)
		sw $t9, 76($t7)		
		sw $t0, 80($t7)	
		
		li $t6, 0x0069C2E0
		addi $t7, $t7, 128
		sw $t0, 16($t7)
		sw $t1, 20($t7)
		sw $t1, 24($t7)
		sw $t1, 28($t7)
		sw $t1, 32($t7)
		sw $t1, 36($t7)
		sw $t8, 40($t7)
		sw $t4, 44($t7)
		sw $t4, 48($t7)
		sw $t2, 52($t7)
		sw $t5, 56($t7)
		sw $t5, 60($t7)
		sw $t5, 64($t7)
		sw $t5, 68($t7)
		sw $t6, 72($t7)
		sw $t9, 76($t7)		
		sw $t0, 80($t7)
		
		addi $t7, $t7, 128
		sw $t0, 16($t7)
		sw $t9, 20($t7)
		sw $t1, 24($t7)
		sw $t1, 28($t7)
		sw $t1, 32($t7)
		sw $t1, 36($t7)
		sw $t8, 40($t7)
		sw $t8, 44($t7)
		sw $t4, 48($t7)
		sw $t4, 52($t7)
		sw $t6, 56($t7)
		sw $t6, 60($t7)
		sw $t6, 64($t7)
		sw $t6, 68($t7)
		sw $t9, 72($t7)
		sw $t9, 76($t7)		
		sw $t0, 80($t7)
		
		addi $t7, $t7, 128
		sw $t0, 16($t7)
		sw $t9, 20($t7)
		sw $t1, 24($t7)
		sw $t1, 28($t7)
		sw $t1, 32($t7)
		sw $t1, 36($t7)
		sw $t1, 40($t7)
		sw $t1, 44($t7)
		sw $t8, 48($t7)
		sw $t6, 52($t7)
		sw $t6, 56($t7)
		sw $t6, 60($t7)
		sw $t6, 64($t7)
		sw $t9, 68($t7)
		sw $t9, 72($t7)
		sw $t9, 76($t7)		
		sw $t0, 80($t7)
		
		li $t2, 0x00D3AAA8
		addi $t7, $t7, 128
		sw $t0, 20($t7)
		sw $t9, 24($t7)
		sw $t1, 28($t7)
		sw $t1, 32($t7)
		sw $t1, 36($t7)
		sw $t1, 40($t7)
		sw $t1, 44($t7)
		sw $t1, 48($t7)
		sw $t9, 52($t7)
		sw $t9, 56($t7)
		sw $t9, 60($t7)
		sw $t9, 64($t7)
		sw $t9, 68($t7)
		sw $t2, 72($t7)
		sw $t0, 76($t7)	
		
		addi $t7, $t7, 128
		sw $t0, 20($t7)
		sw $t9, 24($t7)
		sw $t9, 28($t7)
		sw $t1, 32($t7)
		sw $t1, 36($t7)
		sw $t1, 40($t7)
		sw $t1, 44($t7)
		sw $t9, 48($t7)
		sw $t9, 52($t7)
		sw $t9, 56($t7)
		sw $t9, 60($t7)
		sw $t9, 64($t7)
		sw $t2, 68($t7)
		sw $t2, 72($t7)
		sw $t0, 76($t7)	
		
		li $t0, 0x005A0814
		addi $t7, $t7, 128
		sw $t0, 24($t7)
		sw $t9, 28($t7)
		sw $t9, 32($t7)
		sw $t9, 36($t7)
		sw $t9, 40($t7)
		sw $t9, 44($t7)
		sw $t9, 48($t7)
		sw $t9, 52($t7)
		sw $t9, 56($t7)
		sw $t9, 60($t7)
		sw $t2, 64($t7)
		sw $t2, 68($t7)
		sw $t0, 72($t7)	
		
		li $t1, 0x009A041F
		li $t3, 0x00B60426
		addi $t7, $t7, 128
		sw $t3, -252($t7)
		sw $t3, -256($t7)
		sw $t3, 12($t7)
		sw $t3, 16($t7)
		sw $t3, 20($t7)
		sw $t1, 24($t7)
		sw $t0, 28($t7)
		sw $t9, 32($t7)
		sw $t9, 36($t7)
		sw $t9, 40($t7)
		sw $t9, 44($t7)
		sw $t9, 48($t7)
		sw $t2, 52($t7)
		sw $t2, 56($t7)
		sw $t2, 60($t7)
		sw $t2, 64($t7)
		sw $t0, 68($t7)
		sw $t3, 72($t7)	
		
		addi $t7, $t7, 128
		sw $t3, 4($t7)
		sw $t3, 8($t7)
		sw $t3, 12($t7)
		sw $t3, 16($t7)
		sw $t1, 20($t7)
		sw $t1, 24($t7)
		sw $t1, 28($t7)
		sw $t0, 32($t7)
		sw $t0, 36($t7)
		sw $t2, 40($t7)
		sw $t2, 44($t7)
		sw $t2, 48($t7)
		sw $t2, 52($t7)
		sw $t2, 56($t7)
		sw $t0, 60($t7)
		sw $t0, 64($t7)
		sw $t3, 68($t7)
		sw $t3, 72($t7)	
		sw $t3, 76($t7)
		sw $t3, 88($t7)
		sw $t3, 92($t7)	
		
		addi $t7, $t7, 128
		sw $t3, 4($t7)
		sw $t3, 8($t7)
		sw $t3, 12($t7)
		sw $t3, 16($t7)
		sw $t3, 20($t7)
		sw $t1, 24($t7)
		sw $t1, 28($t7)
		sw $t1, 32($t7)
		sw $t1, 36($t7)
		sw $t0, 40($t7)
		sw $t0, 44($t7)
		sw $t0, 48($t7)
		sw $t0, 52($t7)
		sw $t0, 56($t7)
		sw $t1, 60($t7)
		sw $t1, 64($t7)
		sw $t3, 68($t7)
		sw $t3, 72($t7)	
		sw $t3, 76($t7)
		sw $t3, 80($t7)		
		
		addi $t7, $t7, 128
		sw $t3, 16($t7)
		sw $t3, 20($t7)
		sw $t3, 24($t7)
		sw $t3, 28($t7)
		sw $t1, 32($t7)
		sw $t1, 36($t7)
		sw $t1, 40($t7)
		sw $t1, 44($t7)
		sw $t1, 48($t7)
		sw $t1, 52($t7)
		sw $t1, 56($t7)
		sw $t3, 60($t7)
		sw $t3, 64($t7)
		sw $t3, 68($t7)
		sw $t3, 72($t7)	
		
		addi $t7, $t7, 128
		sw $t3, 28($t7)
		sw $t3, 32($t7)
		sw $t1, 36($t7)
		sw $t1, 40($t7)
		sw $t1, 44($t7)
		sw $t1, 48($t7)
		sw $t3, 52($t7)
		sw $t3, 56($t7)
		
		addi $t7, $t7, 128
		sw $t3, 8($t7)
		sw $t3, 12($t7)
		sw $t3, 24($t7)
		sw $t3, 28($t7)
		sw $t3, 32($t7)
		sw $t3, 36($t7)
		sw $t3, 40($t7)
		sw $t3, 44($t7)
		sw $t3, 48($t7)
		sw $t3, 52($t7)
		sw $t3, 56($t7)
		sw $t3, 60($t7)
		
		addi $t7, $t7, 128
		sw $t3, 28($t7)
		sw $t3, 32($t7)
		sw $t3, 36($t7)
		sw $t3, 40($t7)
		sw $t3, 44($t7)
		sw $t3, 48($t7)
		sw $t3, 52($t7)
		sw $t3, 72($t7)
		sw $t3, 76($t7)
		sw $t3, 128($t7)
		sw $t3, 132($t7)
		sw $t3, 308($t7)
		sw $t3, 312($t7)
	
		jr $ra
		nop

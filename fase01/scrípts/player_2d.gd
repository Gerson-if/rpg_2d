extends CharacterBody2D

# Velocidade horizontal do personagem.
const SPEED: float = 400.0
# Força do salto do personagem.
const JUMP_FORCE: float = -500.0

# Gravidade do jogo.
var GRAVITY: float = 1000
# Flag para verificar se o personagem estava caindo no último frame.
var was_falling: bool = false

# Flag para controlar se o personagem está pulando.
var is_jump: bool = false

# Flag para controlar se o personagem foi atingido.
var hit: bool = false
# Número de corações (vidas) do personagem.
var heart: int = 3
# Flag para controlar se o jogo acabou.
var gameover: bool = false

# Flag para verificar se o personagem está em contato com um objeto.
var contact_object: bool = false
# Flag para controlar se o personagem está movendo um objeto.
var move_object: bool = false



func _process(delta):
	# Adiciona a gravidade se o personagem não estiver no chão.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Obtém a direção do input e controla o movimento/deceleração.
	var direction = Input.get_axis("ui_left", "ui_right")

	# Verifica se o personagem ainda tem corações para continuar e não está movendo um objeto.
	if heart > 0 and not move_object:
		# Verifica se o personagem não está pulando e não foi atingido.
		if not is_jump and not hit:
			# Verifica se o personagem estava caindo no último frame para executar animação de pouso.
			if was_falling:
				$anim.play('landing')
			else:
				# Verifica se há movimento horizontal para determinar a animação.
				if direction:
					$anim.play('running')
				else:
					$anim.play('idle')
			# Verifica se o personagem está no ar para executar a animação de salto.
			if not is_on_floor():
				$anim.play('jump2')
				was_falling = true
		else:
			was_falling = true

		# Controla o movimento horizontal do personagem.
		if direction and not hit:
			# Inverte a direção do sprite conforme o movimento.
			$Sprite2D.scale.x = direction * -1
			# Aplica a velocidade horizontal.
			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * 0.2)
		else:
			# Desacelera o personagem quando não há movimento horizontal.
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, SPEED * 0.05)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED * 0.005)

		# Verifica se o personagem está no chão para permitir novo salto.
		if is_on_floor():
			is_jump = false
		
		# Executa o salto se o botão de salto for pressionado e o personagem não estiver pulando nem foi atingido.
		if Input.is_action_just_pressed("ui_accept") and not is_jump and not hit:
			jump()
		# Aplica a física de movimento ao personagem.
		move_and_slide()

	else:
		if direction and heart > 0:
			velocity.x = move_toward(velocity.x, direction * SPEED / 5, SPEED * 0.2)
			move_and_slide()
		elif heart >= 0:
			velocity.x = 0
		


	# Verifica se o botão de mover objeto foi pressionado e o personagem está em contato com um objeto.
	if Input.is_action_just_pressed("move_object") and contact_object:
		# Alterna o estado de movimento do objeto.
		if not  move_object:
			move_object = true
		else:
			move_object = false
			print('mover obejeto')

func jump(): # Função para realizar o salto do personagem.
	$anim.play('jump')
	is_jump = true 
	velocity.y = JUMP_FORCE
	
func jump2(): # Função para realizar a segunda parte da animação de salto.
	$anim.play('jump2')

func is_falling(): # Função para atualizar o estado de queda do personagem.
	was_falling = false
	
func _on_anim_animation_finished(anim_name): # Callback chamado quando uma animação termina.
	match anim_name: #caso o nome da animação seja, faca
		'jump':
			jump2() # Chama a segunda parte da animação de salto.
		'landing':
			is_falling() # Atualiza o estado de queda do personagem.
		'hit':
			hit = false # Reseta a flag de personagem atingido.

func hitted(force): # Função para lidar com o personagem sendo atingido.
	heart -= 1 # Reduz o número de corações do personagem.
	if heart > 0:
		$anim.play('hit') # Executa a animação de ser atingido se ainda houver corações.
	else:
		$anim.play('die') # Executa a animação de morte se não houver mais corações.
		print('voce morreu')
	
	hit = true # Marca que o personagem foi atingido.
	
	velocity.x = force
	velocity.y = -200

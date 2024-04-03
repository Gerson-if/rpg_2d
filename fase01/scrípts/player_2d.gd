extends CharacterBody2D


const SPEED = 400.0
const JUMP_FORCE = -650.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var GRAVITY = 1000
var was_falling = false

#jump
var is_jump = false

#hit
var hit: bool = false
var heart: int = 3
var gameover: bool = false

func _process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if  heart > 0:
		if !is_jump and !hit: #se nao esta pulando execute esse trecho de codigo
			if was_falling:
				$anim.play('landing')
			else:
				if direction: # se direction for verdadeiro -1 ou 1 entao fac, se ela se mover
					$anim.play('running')# se o personagem se movimentar
					
				else: # caso contrario defina a movimentação do personagem
					$anim.play('idle') 
			if !is_on_floor():
				$anim.play('jump2')
				was_falling = true
		else:
				was_falling = true

		if direction and !hit:
			#mudando olhar
			$Sprite2D.scale.x = direction * -1 
			# velocidade
			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * 0.2)
		else:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, SPEED * 0.05) 
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED * 0.005) 

		if is_on_floor():
			is_jump = false
		
		# execução do salto jump.
		if Input.is_action_just_pressed("ui_accept") and !is_jump and !hit:
			jump() # fucao de salto 
		move_and_slide() # funcao de movimentação do personagem 
	
func jump(): # implementação da fucao jump
	#Engine.time_scale = 0.2
	$anim.play('jump')
	is_jump = true 
	velocity.y = JUMP_FORCE
	
func jump2():
	$anim.play('jump2')

func is_falling():
	was_falling = false
	

func _on_anim_animation_finished(anim_name):
	#if anim_name == "jump":
		#jump2()
	match anim_name:
		'jump':
			jump2()
		'landing':
			is_falling()
		'hit':
			hit = false

func hitted(force):
	heart += -1
	if heart > 0:
		$anim.play('hit')
	else:
		$anim.play('die')
	
	hit = true
	velocity.x = force
	velocity.y = -200

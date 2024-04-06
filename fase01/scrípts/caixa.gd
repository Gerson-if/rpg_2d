extends CharacterBody2D


#vars
#gravidae de 1000
const GRAVITY = 1000
#recebe o player como valor ao usar o notcao @ e $ para o caminho nivel acima
@onready var player = $'../player2d' 



# Este é o lugar onde o código começa a ser executado quando o objeto é carregado na cena.
func _ready():
	pass # Este bloco de código estará vazio por enquanto, mas é onde você colocaria ações que o objeto deve realizar quando estiver pronto.

# Este é um bloco de código que é executado a cada quadro do jogo.
# 'delta' é uma medida do tempo entre quadros, mas não se preocupe muito com isso agora.
func _process(delta):
	velocity.y += GRAVITY * delta

	move_and_slide()
	

# Esta função é chamada automaticamente quando outro objeto entra na área de colisão deste objeto.
func _on_area_contato_body_entered(body):
	# Verificamos se o objeto que entrou na área de colisão tem o nome "player2d".
	if body.name == "player2d":
		# Se for o jogador, marcamos que ele está em contato com este objeto.
		body.contact_object = true
		# Também imprimimos "pressione x" no console, sugerindo que o jogador pressione a tecla x.
		print('pressione x')

# Esta função é chamada automaticamente quando outro objeto sai da área de colisão deste objeto.
func _on_area_contato_body_exited(body):
	# Verificamos se o objeto que saiu da área de colisão tem o nome "player2d".
	if body.name == "player2d":
		# Se for o jogador, marcamos que ele não está mais em contato com este objeto.
		body.contact_object = false
		# Além disso, marcamos que o objeto não deve mais se mover.
		body.move_object = false


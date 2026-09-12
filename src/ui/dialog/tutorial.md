# Sistema de Diálogo

Sistema simples de diálogos para Godot, baseado em uma cena reutilizável (`dialog_screen.tscn`) e um `Dictionary` contendo as falas.

O sistema permite:

* Exibir nome do personagem.
* Exibir texto do diálogo.
* Exibir faceset.
* Ter várias falas em sequência.
* Avançar o diálogo pelo teclado ou mouse.
* Impedir que o mesmo diálogo seja aberto várias vezes.
* Instanciar a tela de diálogo em qualquer `CanvasLayer`.
* Manter o sistema desacoplado da cena do nível.

---

## 1. Estrutura

A estrutura utilizada pelo sistema é:

```text
src/
└── ui/
	└── dialog/
		├── dialog_screen.tscn
		└── dialog_screen.gd
```

A cena `dialog_screen.tscn` é responsável pela interface do diálogo.

O script do nível é responsável por:

1. Armazenar os diálogos.
2. Detectar quando o jogador deve iniciar o diálogo.
3. Instanciar `dialog_screen.tscn`.
4. Enviar os dados para a tela.
5. Impedir que outro diálogo seja aberto enquanto o atual estiver ativo.

---

# 2. Cena `dialog_screen.tscn`

A cena do diálogo deve possuir o script:

```gdscript
class_name DIalogScreen
```

> **Atenção:** `DIalogScreen` está escrito dessa forma propositalmente. O nome da classe precisa ser exatamente igual ao utilizado no script que instancia o diálogo.

O script deve possuir uma propriedade para receber os dados:

```gdscript
var data: Dictionary
```

O sistema espera três informações principais para cada fala:

```text
faceset
dialog
title
```

---

# 3. Preparando o nível

No script do nível, primeiro carregamos a cena do diálogo:

```gdscript
class_name LevelTuto

const _DIALOG_SCREEN: PackedScene = preload(
	"res://src/ui/dialog/dialog_screen.tscn"
)
```

Isso permite criar uma nova instância da tela de diálogo quando necessário.

---

# 4. Criando os diálogos

Os diálogos são armazenados em um `Dictionary`.

Exemplo:

```gdscript
var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/character_animations/death_frame.png",
		"dialog": "Teste de diálogo.",
		"title": "Teste"
	},

	1: {
		"faceset": "res://assets/character_animations/death_frame.png",
		"dialog": "Mas acho que vai dar errado...",
		"title": "Teste"
	},

	2: {
		"faceset": "res://assets/character_animations/death_frame.png",
		"dialog": "Será?",
		"title": "Teste"
	}
}
```

Cada número representa uma fala:

```text
0 → primeira fala
1 → segunda fala
2 → terceira fala
```

A tela de diálogo percorre essas entradas na ordem.

---

# 5. Formato de cada fala

Cada entrada possui:

```gdscript
{
	"faceset": "caminho/para/imagem.png",
	"dialog": "Texto da fala.",
	"title": "Nome do personagem"
}
```

### `faceset`

Define a imagem que será exibida.

Exemplo:

```gdscript
"faceset": "res://assets/character_animations/death_frame.png"
```

O arquivo precisa existir dentro do projeto.

---

### `dialog`

É o texto que será mostrado:

```gdscript
"dialog": "Olá! Bem-vindo ao jogo."
```

---

### `title`

É o nome mostrado como personagem:

```gdscript
"title": "Death"
```

---

# 6. Definindo o HUD

O diálogo precisa ser adicionado a um `CanvasLayer`.

No script:

```gdscript
@export_category("Objects")
@export var _hud: CanvasLayer
```

Depois, no Inspector do nível, arraste o `CanvasLayer` desejado para a propriedade:

```text
HUD
```

Por exemplo:

```text
LevelTuto
├── Player
├── World
└── HUD
	└── ...
```

O `HUD` será utilizado como pai da tela de diálogo.

---

# 7. Abrindo o diálogo

O sistema utiliza uma ação do Input Map:

```text
pular_dialogo
```

No script:

```gdscript
func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("pular_dialogo"):

		if _dialog_open:
			return

		_open_dialog()
```

Quando `pular_dialogo` é pressionado:

```text
pular_dialogo
	  ↓
_open_dialog()
	  ↓
Instancia dialog_screen.tscn
	  ↓
Envia _dialog_data
	  ↓
Adiciona ao HUD
	  ↓
Diálogo aparece
```

---

# 8. Criando a ação no Input Map

Abra:

```text
Project
└── Project Settings
	└── Input Map
```

Crie uma nova ação:

```text
pular_dialogo
```

Depois adicione os botões desejados.

Por exemplo:

```text
pular_dialogo
├── Space
└── Mouse Left
```

A vantagem de usar uma ação é que o código não precisa saber qual tecla ou botão foi pressionado.

---

# 9. Instanciando o diálogo

A função responsável por criar o diálogo é:

```gdscript
func _open_dialog() -> void:

	if _hud == null:
		push_error("HUD não foi definido no Inspector.")
		return

	var new_dialog: DIalogScreen = _DIALOG_SCREEN.instantiate()

	new_dialog.data = _dialog_data

	new_dialog.tree_exited.connect(_on_dialog_closed)

	_hud.add_child(new_dialog)

	_dialog_open = true
```

O processo é:

### 1. Verificar o HUD

```gdscript
if _hud == null:
```

Evita tentar adicionar o diálogo a um `CanvasLayer` inexistente.

---

### 2. Criar a instância

```gdscript
var new_dialog: DIalogScreen = _DIALOG_SCREEN.instantiate()
```

Aqui uma nova cópia de `dialog_screen.tscn` é criada.

---

### 3. Enviar os dados

```gdscript
new_dialog.data = _dialog_data
```

O nível envia todas as falas para a tela de diálogo.

---

### 4. Adicionar ao HUD

```gdscript
_hud.add_child(new_dialog)
```

Agora o diálogo passa a fazer parte da árvore da cena.

---

# 10. Impedindo múltiplos diálogos

Um problema comum seria o jogador pressionar o botão várias vezes e criar várias caixas de diálogo.

Para evitar isso, existe:

```gdscript
var _dialog_open: bool = false
```

Antes de abrir:

```gdscript
if _dialog_open:
	return
```

Quando o diálogo é criado:

```gdscript
_dialog_open = true
```

Assim:

```text
Pressionar botão
	  ↓
_diálogo está aberto?
	  ↓
	SIM → não faz nada
	  ↓
	NÃO
	  ↓
abre diálogo
```

---

# 11. Detectando o fechamento

Quando o diálogo termina, a própria `DIalogScreen` pode ser destruída com:

```gdscript
queue_free()
```

O nível precisa saber quando isso acontece.

Por isso usamos:

```gdscript
new_dialog.tree_exited.connect(_on_dialog_closed)
```

Quando a instância sair da árvore:

```gdscript
func _on_dialog_closed() -> void:
	_dialog_open = false
```

Assim o sistema fica pronto para abrir outro diálogo.

---

# 12. Script completo do nível

O código completo fica:

```gdscript
class_name LevelTuto

const _DIALOG_SCREEN: PackedScene = preload(
	"res://src/ui/dialog/dialog_screen.tscn"
)


var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/character_animations/death_frame.png",
		"dialog": "Teste de diálogos.",
		"title": "Teste"
	},

	1: {
		"faceset": "res://assets/character_animations/death_frame.png",
		"dialog": "Mas acho que vai dar errado...",
		"title": "Teste"
	},

	2: {
		"faceset": "res://assets/character_animations/death_frame.png",
		"dialog": "Será?",
		"title": "Teste"
	}
}


@export_category("Objects")
@export var _hud: CanvasLayer


var _dialog_open: bool = false


func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("pular_dialogo"):

		if _dialog_open:
			return

		_open_dialog()


func _open_dialog() -> void:

	if _hud == null:
		push_error("HUD não foi definido no Inspector.")
		return

	var new_dialog: DIalogScreen = _DIALOG_SCREEN.instantiate()

	new_dialog.data = _dialog_data

	new_dialog.tree_exited.connect(_on_dialog_closed)

	_hud.add_child(new_dialog)

	_dialog_open = true


func _on_dialog_closed() -> void:
	_dialog_open = false
```

---

# 13. Como adicionar outro personagem

Basta alterar o `title` e o `faceset`.

Exemplo:

```gdscript
var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/characters/player.png",
		"dialog": "Onde estamos?",
		"title": "Player"
	},

	1: {
		"faceset": "res://assets/characters/guide.png",
		"dialog": "Estamos no topo da montanha.",
		"title": "Guide"
	}
}
```

Resultado:

```text
Player
Onde estamos?

		↓

Guide
Estamos no topo da montanha.
```

---

# 14. Usando diferentes diálogos no mesmo nível

Se o nível possuir mais de um momento de diálogo, não é necessário criar várias cenas de `dialog_screen`.

Você pode criar diferentes Dictionaries:

```gdscript
var _dialog_intro: Dictionary = {
	0: {
		"faceset": "res://assets/characters/player.png",
		"dialog": "Precisamos subir.",
		"title": "Player"
	}
}


var _dialog_mountain: Dictionary = {
	0: {
		"faceset": "res://assets/characters/player.png",
		"dialog": "Está ficando frio.",
		"title": "Player"
	}
}
```

E escolher qual será enviado:

```gdscript
new_dialog.data = _dialog_intro
```

ou:

```gdscript
new_dialog.data = _dialog_mountain
```

---

# 15. Recomendação para o projeto

Para manter o sistema organizado, recomendo separar os dados dos diálogos da lógica do nível conforme o projeto crescer.

Uma possível estrutura futura:

```text
src/
├── scenes/
│   └── levels/
│
├── ui/
│   └── dialog/
│       ├── dialog_screen.tscn
│       └── dialog_screen.gd
│
└── data/
	└── dialogs/
		├── intro.gd
		├── tutorial.gd
		└── mountain.gd
```

Assim o script do nível não fica cheio de textos.

Por enquanto, manter o `Dictionary` dentro do script é adequado para testar e desenvolver o sistema.

---

# 16. Fluxo completo

O funcionamento geral é:

```text
Jogador pressiona "pular_dialogo"
			  │
			  ▼
	  _process() detecta
			  │
			  ▼
	 _dialog_open == true?
		 │           │
		SIM         NÃO
		 │           │
	   return        ▼
				 _open_dialog()
					  │
					  ▼
			 Instancia DIalogScreen
					  │
					  ▼
			Envia _dialog_data
					  │
					  ▼
				 Adiciona ao HUD
					  │
					  ▼
				  Diálogo
					  │
					  ▼
			  Última fala termina
					  │
					  ▼
				  queue_free()
					  │
					  ▼
			 tree_exited dispara
					  │
					  ▼
			_dialog_open = false
```

---

# 17. Checklist

Antes de testar, verifique:

* [ ] `dialog_screen.tscn` existe.
* [ ] O caminho do `preload()` está correto.
* [ ] `DIalogScreen` está declarado corretamente.
* [ ] `dialog_screen.gd` possui `var data: Dictionary`.
* [ ] O `_hud` foi definido no Inspector.
* [ ] A ação `pular_dialogo` existe no Input Map.
* [ ] Os arquivos dos `faceset` existem.
* [ ] Cada diálogo possui `faceset`, `dialog` e `title`.
* [ ] O `dialog_screen` chama `queue_free()` quando termina.

---

## Resumo

O nível controla **quando** o diálogo deve aparecer.

A `DIalogScreen` controla **como** o diálogo é exibido.

```text
Level
 │
 ├── Decide quando abrir
 ├── Fornece os textos
 └── Instancia a interface
		  │
		  ▼
	DIalogScreen
		  │
		  ├── Nome
		  ├── Faceset
		  ├── Texto
		  ├── Typewriter
		  └── Avanço das falas
```

Essa separação permite reutilizar a mesma `dialog_screen.tscn` em diferentes níveis e situações sem precisar duplicar a interface.

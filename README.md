# Mountain climbing 16: about and GDD

# Resumo:

Um homem decide escalar uma montanha para sair de seus vícios.

# Lore:

Você esta na pele de um pai de família, Joseph Jomine. Joseph é um usuário de drogas e alcoólatra, isso começou depois de seu casamento com sua esposa: {Nome Esposa}. Ele sempre voltava de bares extremamente bêbado. Quando chegava, sempre havia alguma discussão, e sempre por alguma besteira. Depois de algum tempo, Marta Alvered decide dar um fim nesta situação. Marta decide expulsar Joseph de casa até que ele mudasse.

Depois de algum tempo, você percebe o quão ruim você é, mas você já está completamente corrompido pelas drogas e pelo cerveja. Então você decide ir para uma clinica de reabilitação. Lá ele vê que não seria fácil, como você já havia quase sido repeso, alguns ali já o conheciam.

A grande maioria das pessoas ali não botavam fé em sua recuperação, então, você decide provar para todos ali presentes que você era capaz. Você decide escalar uma montanha, não qualquer uma, mas a maior daquela cidade. Quilômetros de altura, 6 para ser especifico.

Você fala para todos ele que que irá conseguir, que ira provar para todos que ele era capaz. E, acima de tudo, provar seu valor para sua esposa, e filho/s.

# Sistema de arquivos

# Arte

A arte do jogo Mountain climbing é uma de pixel arte.

## Pixel Arte

![PixelArte1](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%2Fid%2FOIP.Mr8fbkZo9l7MWoGYZZJYewHaEK%3Fpid%3DApi&f=1&ipt=b1b0255d13e4e0c8789a1db46720b2bbbcbd3322f5a3745177faa00b49aff4d6&ipo=images)

![PixelArte1](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%2Fid%2FOIP.eIIKpHKUFW16SETPXYhtRwHaEK%3Fpid%3DApi&f=1&ipt=612d6af74c88e79f2f55080ed471af88e3916c14deb5601ed7b0b7e3a80966ee&ipo=images)

# Sistema de arquivos
```
res://
├── docs/
│   └── developer_doc/
├── assets/
│   ├── models # assets 3D
│   ├── themes
│   └── ui
├── src/
│   ├── autoloads
│   ├── config
|   ├── objects
│   ├── entities/
│   │   ├── player/
│   │   │   ├── assets/
│   │   │   │   ├── sprites
│   │   │   │   ├── audio
│   │   │   │   └── materials
│   │   │   ├── player.tscn
│   │   │   └── player.gd
│   │   └── enemies/
│   │       └── enemy_type_0/
│   │           ├── assets/
│   │           │   ├── sprites
│   │           │   ├── audio
│   │           │   └── materials
│   │           ├── enemy_type_0.tscn
│   │           └── enemy_type_0.gd
│   ├── maps/
│   ├── systems/
│   └── ui/
├── .editorconfig
├── .gitignore
├── icon.png
├── project.godot
└── README.md
```
# Sistema de gameplay

Em um jogo, o sistema de gameplay é uma das coisas mais importantes para fazer um bom jogo. o sistema de gameplay é uma das mais importantes.

## como pode ser os sistemas de `moveset` do jogador?

Como o jogo é sobre escaladas, uma das mecânicas principais é de escalar usando uma corda, que será usada junto do mouse para es escalar entre paredes elevadas.

Quero que o sistema de andar (do jogador) seja simplificada. Apenas: Andar, correr, pular (baixo ou alto) dependendo de quanto tempo você aperta a barra de espaço

> Coffe-Studio ☕️

# Mountain Climbing

> Um jogo de plataforma 2D sobre escalada, superação e a tentativa de reconstruir a própria vida.

**Mountain Climbing** é um projeto desenvolvido pela **Coffe Studio** utilizando **Godot Engine**.

O projeto combina exploração horizontal, plataforma de precisão e uma ambientação de montanha, com foco em uma experiência simples, desafiadora e baseada em movimentação.

---

## ✦ Sobre o projeto

A história acompanha **Joseph Jomine**, um homem que decide enfrentar uma grande montanha como parte de uma jornada pessoal de recuperação e mudança.

A escalada representa mais do que chegar ao topo: é uma tentativa de provar para si mesmo e para as pessoas ao seu redor que ele ainda é capaz de mudar.

> **A montanha é o desafio. A escalada é a jornada.**

---

## Gameplay

O gameplay é baseado principalmente em **movimentação e escalada**.

### Movimentação

* Andar
* Correr
* Pulo variável
* Dash
* Movimentação aérea
* Interação com paredes

### Escalada

Uma das mecânicas centrais do projeto é a utilização de uma **corda** para auxiliar na escalada entre áreas elevadas da montanha.

A intenção é manter o conjunto de movimentos relativamente simples, permitindo que o desafio venha principalmente do ambiente e da execução do jogador.

---

## Sistema de movimentação

O projeto utiliza uma arquitetura baseada em estados para organizar diferentes comportamentos do personagem.

Entre os estados presentes no protótipo estão:

```text
Ground
├── Idle
└── Run

Air
├── Jump
└── Fall

Wall
├── Wall Climb
└── Wall Interaction

Special
├── Dash
└── Bounce
```

A estrutura foi pensada para facilitar a expansão do sistema sem concentrar toda a lógica do personagem em um único script.

---

## 🧩 Estrutura do projeto

```
res://
├── addons/
│   └── 2d_essentials/
│
├── assets/
│
├── src/
│   └── scenes/
│
├── .gitattributes
├── .gitignore
├── LICENSE.md
├── README.md
├── lista.md
└── project.godot
```

A organização separa **recursos, entidades, sistemas, mapas, interface e documentação**, permitindo que diferentes partes do projeto sejam desenvolvidas independentemente.

---

## Direção visual

A direção artística do projeto combina diferentes abordagens de arte 2D.

A proposta inclui:

* Pixel art
* Arte desenhada à mão (ainda não disponível)
* Elementos de ambientação de montanha
* Interfaces próprias (não adicionado)
* Efeitos visuais

A identidade visual ainda está em desenvolvimento e pode sofrer alterações durante a produção.

---

## Tecnologias

* **Godot Engine**
* **GDScript**
* **Git**
* **GitHub**

---

## Documentação

A documentação técnica do projeto está localizada em:

```text
docs/
└── developer_doc/
```

Ela será utilizada para registrar sistemas, decisões técnicas e informações necessárias para manutenção do projeto.

---

## Roadmap

### Gameplay

* [x] Sistema básico de movimentação
* [x] Pulo
* [x] Estados de movimento
* [x] Dash
* [ ] Sistema completo de escalada
* [ ] Sistema de corda
* [ ] Interações com o ambiente
* [ ] Obstáculos
* [ ] Sistema de progressão

### Visual

* [ ] Definir direção artística final
* [ ] Criar sprites finais
* [ ] Criar ambientes
* [ ] Criar efeitos visuais
* [ ] Criar interface final

### Produção

* [ ] Estruturar níveis
* [ ] Implementar sistemas principais
* [ ] Criar primeira fase jogável
* [ ] Testes
* [ ] Polimento
* [ ] Build jogável

---

## 👥 Equipe

| Nome     | Função           |
| -------- | ---------------- |
| Darlyson | Game Development |
| Rika     | Desenvolvimento  |

> As funções da equipe ainda podem ser atualizadas conforme a organização do projeto evoluir.

---

## 🧪 Protótipo

O repositório também contém um protótipo baseado em **Alys**, utilizado para experimentar sistemas de plataforma e movimentação.

O protótipo utiliza conceitos como:

* Máquina de estados
* Movimentação baseada em componentes
* Jump
* Dash
* Wall Climb
* Bounce
* Detecção de bordas

Algumas dessas mecânicas servem como referência para o desenvolvimento dos sistemas de **Mountain Climbing**.

---

## 📦 Recursos de terceiros

O projeto utiliza ou referencia recursos e sistemas desenvolvidos por terceiros.

Os créditos e licenças dos recursos utilizados devem ser mantidos conforme suas respectivas licenças.

Entre os recursos atualmente referenciados no projeto estão:

* **2D-Essentials**
* Alys character
* Background desert mountains
* Smoke effects

Consulte as licenças e páginas originais antes de redistribuir ou modificar esses recursos.

---

## Licença

Este projeto possui uma licença definida no repositório.

Consulte [`LICENSE`](LICENSE) para informações sobre uso, modificação e distribuição.

---

## ☕ Coffe Studio

**Coffe Studio** é um estúdio independente focado no desenvolvimento de jogos e experimentação com diferentes áreas de desenvolvimento.

**Mountain Climbing** é um dos projetos principais do estúdio.

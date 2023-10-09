## Francielle Dragon Maker

🚀 Começando
Estas instruções fornecerão uma cópia do projeto em execução na sua máquina local para fins de desenvolvimento e teste.


###O Front está nesse repositório:
[front_dragon-maker](https://github.com/FrancielledeAbreu/front_dragon-maker)

Pré-requisitos
O que você precisa para instalar o software:

[Docker](https://www.docker.com/)
[Docker Compose](https://docs.docker.com/compose/)

#### Instalação
Clone o repositório:
```
git clone git@github.com:FrancielledeAbreu/dragon-maker.git
```
Navegue até a pasta do projeto:
```
cd dragon-make-test
```
Construa e inicie os serviços usando Docker Compose:
```
docker-compose up --build

Listening on http://0.0.0.0:5000
```

#### 🧪 Testes
Para rodar os testes, execute:
```
docker-compose run web bundle exec rspec
```

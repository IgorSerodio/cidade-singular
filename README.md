# Cidade Singular

**Cidade Singular** é uma aplicação gamificada de apoio à economia criativa de cidades integrantes da **Rede Mundial de Cidades Criativas da UNESCO (UCCN)**. O projeto integra turismo cultural, empreendedorismo criativo e gamificação, promovendo o engajamento de visitantes, moradores, empreendedores e curadores na valorização do patrimônio cultural e ambiental urbano.

Este repositório corresponde ao frontend da **versão 3.0** da aplicação, desenvolvida como Trabalho de Conclusão de Curso (TCC) no curso de **Ciência da Computação – UFCG**.

---

## Objetivo do Projeto

O objetivo do Cidade Singular é **ampliar a experiência cultural em cidades criativas**, indo além de guias turísticos tradicionais. A aplicação estimula a participação ativa dos usuários na economia criativa local por meio de:

- Exploração de singularidades culturais e ambientais
- Gamificação da experiência turística
- Empreendedorismo cultural
- Curadoria colaborativa do espaço urbano

A cidade-base do estudo e desenvolvimento é **Campina Grande – PB**, cidade membro da UCCN na categoria **Artes Midiáticas**.

---

## Conceitos-Chave

- **Singularidade**: elemento cultural, ambiental ou criativo que representa a identidade única da cidade (ex.: restaurantes, obras, museus, eventos, espaços naturais).
- **Gamificação**: uso de missões, recompensas, níveis e personalização de avatar para aumentar engajamento.
- **Economia Criativa**: incentivo à atuação de cidadãos como empreendedores e curadores culturais.

---

## Tipos de Usuário

### Visitante
- Explora singularidades no mapa
- Avalia e comenta experiências
- Realiza missões e evolui no sistema

### Empreendedor
- Cadastra singularidades (via requisição)
- Cria missões patrocinadas
- Define recompensas (tickets e títulos)

### Curador
- Avalia requisições de singularidades
- Publica e edita singularidades
- Avalia maturidade das singularidades (modelo ISSM)

---

## Funcionalidades Principais

- Mapa interativo com singularidades georreferenciadas
- Avatar personalizável do usuário
- Missões gerais e patrocinadas
- Sistema de recompensas:
  - Itens cosméticos
  - Tickets (uso único)
  - Títulos (benefícios permanentes)
- Avaliação e comentários de singularidades
- Painel do empreendedor
- Painel do curador
- Versão Web e Mobile

---

## Arquitetura e Tecnologias

### Frontend
- Flutter
- Dart
- Interface responsiva (mobile e web)

### Backend
- Node.js
- API REST

### Banco de Dados
- MongoDB Atlas (NoSQL)

### Armazenamento de Imagens
- Amazon S3

### Design e Assets
- MediBang Paint (ilustrações e identidade visual)

## Repositórios Relacionados
- Backend (API): https://github.com/igorSerodio/cidade-singular-api

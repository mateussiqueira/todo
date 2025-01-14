# Taskify

Taskify é um aplicativo de gerenciamento de tarefas que permite criar, editar e excluir listas e itens. Este projeto foi desenvolvido como um teste de conhecimentos em Flutter.

---

## Escopo

O objetivo é criar um aplicativo simples de listas, onde cada lista pode conter itens para organizar a rotina do usuário. Exemplos de uso incluem organizar a compra de mercado mensal ou gerenciar tarefas diárias.

---

## Requisitos Funcionais

- Criar lista
- Editar lista
- Remover lista
- Criar item
- Editar item
- Remover item
- Cada item deve armazenar:
  - Data de criação/alteração
  - Descrição da tarefa

---

## Estrutura do Projeto

O projeto segue os princípios da **Clean Architecture**:

```
lib/
├── data/
│   ├── datasources/
│   │   └── supabase_datasource.dart
│   ├── repositories/
│   │   ├── item_repository_impl.dart
│   │   └── list_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── item_entity.dart
│   │   └── list_entity.dart
│   ├── repositories/
│   │   ├── item_repository.dart
│   │   └── list_repository.dart
│   ├── usecases/
│   │   ├── create_item_usecase.dart
│   │   ├── create_list_usecase.dart
│   │   ├── delete_item_usecase.dart
│   │   ├── delete_list_usecase.dart
│   │   ├── fetch_items_usecase.dart
│   │   ├── fetch_lists_usecase.dart
│   │   ├── update_item_usecase.dart
│   │   └── update_list_usecase.dart
├── presentation/
│   ├── pages/
│   │   ├── home_page.dart
│   │   ├── list_page.dart
│   │   └── my_lists_page.dart
│   ├── providers/
│   │   ├── create_item_notifier.dart
│   │   ├── delete_item_notifier.dart
│   │   ├── item_provider.dart
│   │   ├── list_provider.dart
│   │   └── update_item_notifier.dart
└── main.dart
```

---

## Como Executar

1. **Clone o Repositório**:

   ```bash
   git clone https://github.com/mateussiqueira/taskify.git
   ```

2. **Navegue até o Diretório do Projeto**:

   ```bash
   cd taskify
   ```

3. **Instale as Dependências**:

   ```bash
   flutter pub get
   ```

4. **Execute o Aplicativo**:
   ```bash
   flutter run
   ```

---

## Testes

Antes de executar os testes, rode o comando abaixo para gerar os arquivos necessários:

```bash
flutter pub run build_runner build
```

Após isso, utilize o comando:

```bash
flutter test
```

---

## Versão do Flutter

Este projeto foi desenvolvido utilizando a seguinte versão do Flutter:
Flutter 3.27.1 • channel stable • https://github.com/flutter/flutter.git  
Framework • revision 17025dd882 (4 weeks ago) • 2024-12-17 03:23:09 +0900  
Engine • revision cb4b5fff73  
Tools • Dart 3.6.0 • DevTools 2.40.2

---

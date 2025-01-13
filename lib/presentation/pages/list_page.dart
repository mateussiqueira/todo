import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/item_provider.dart'; // Importe o itemProvider

class ListPage extends ConsumerWidget {
  final String listId;

  const ListPage({required this.listId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemProvider(listId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Itens da Lista'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddItemDialog(context, ref);
            },
          ),
        ],
      ),
      body: items.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text('Nenhum item disponível'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final createdAt =
                  DateFormat('dd/MM/yyyy HH:mm').format(item.createdAt);
              final updatedAt =
                  DateFormat('dd/MM/yyyy HH:mm').format(item.updatedAt);

              return ListTile(
                title: Text(item.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Descrição: ${item.description}'),
                    Text('Criado em: $createdAt'),
                    Text('Atualizado em: $updatedAt'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: item.completed,
                      onChanged: (bool? value) {
                        if (value != null) {
                          ref.read(itemProvider(listId).notifier).updateItem(
                                item.id,
                                item.title,
                                item.description,
                                value,
                              );
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditItemDialog(
                          context,
                          ref,
                          item.id,
                          item.title,
                          item.description,
                          item.completed,
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        ref
                            .read(itemProvider(listId).notifier)
                            .deleteItem(item.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erro: $error')),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Novo Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Título'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Descrição'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final title = titleController.text;
                final description = descriptionController.text;
                if (title.isNotEmpty && description.isNotEmpty) {
                  await ref
                      .read(itemProvider(listId).notifier)
                      .addItem(title, description);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditItemDialog(BuildContext context, WidgetRef ref, String itemId,
      String title, String description, bool completed) {
    final TextEditingController titleController =
        TextEditingController(text: title);
    final TextEditingController descriptionController =
        TextEditingController(text: description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Título'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Descrição'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final newTitle = titleController.text;
                final newDescription = descriptionController.text;
                if (newTitle.isNotEmpty && newDescription.isNotEmpty) {
                  await ref
                      .read(itemProvider(listId).notifier)
                      .updateItem(itemId, newTitle, newDescription, completed);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}

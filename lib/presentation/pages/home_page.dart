import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/list_provider.dart';
import 'list_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  Future<void> onCreateListSnackbar() async {
    if (!mounted) return; // Verifique se o widget ainda está montado
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('Lista criada com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lists = ref.watch(listProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Listas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddListDialog(context, ref);
            },
          ),
        ],
      ),
      body: lists.when(
        data: (lists) {
          if (lists.isEmpty) {
            return Center(child: Text('Nenhuma lista disponível'));
          }
          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final list = lists[index];
              final createdAt =
                  DateFormat('dd/MM/yyyy HH:mm').format(list.createdAt);
              final updatedAt =
                  DateFormat('dd/MM/yyyy HH:mm').format(list.updatedAt);

              return ListTile(
                title: Text(list.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Criado em: $createdAt'),
                    Text('Atualizado em: $updatedAt'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditListDialog(context, ref, list.id, list.name);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteListDialog(context, ref, list.id);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListPage(listId: list.id),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erro: $error')),
      ),
    );
  }

  void _showAddListDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Nova Lista'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'Nome da Lista'),
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
                final name = nameController.text;
                if (name.isNotEmpty) {
                  await ref.read(listProvider.notifier).addList(name);
                  onCreateListSnackbar();
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

  void _showEditListDialog(
      BuildContext context, WidgetRef ref, String listId, String currentName) {
    final TextEditingController nameController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Nome da Lista'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'Nome da Lista'),
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
                final newName = nameController.text;
                if (newName.isNotEmpty) {
                  await ref
                      .read(listProvider.notifier)
                      .updateList(listId, newName);
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

  void _showDeleteListDialog(
      BuildContext context, WidgetRef ref, String listId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Lista'),
          content: Text('Tem certeza de que deseja excluir esta lista?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await ref.read(listProvider.notifier).deleteList(listId);
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}

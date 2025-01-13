import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/list_notifier.dart';
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
          )
        ],
      ),
      body: lists.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(child: Text('Nenhuma lista disponível'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index].name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListPage(listId: data[index].id),
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
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Nova Lista'),
          content: TextField(
            controller: controller,
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
                final listName = controller.text;
                if (listName.isNotEmpty) {
                  await ref.read(listProvider.notifier).addList(listName);
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
}

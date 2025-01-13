import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'data/datasources/supabase_client.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSupabase();
  print('Supabase inicializado com sucesso!');
  runApp(ProviderScope(child: TaskifyApp()));
}

class TaskifyApp extends StatelessWidget {
  TaskifyApp({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/list/:id',
        builder: (context, state) {
          final id = state.params['id']!;
          return ListPage(listId: id);
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Taskify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}

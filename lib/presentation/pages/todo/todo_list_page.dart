import 'package:flutter/material.dart';
import 'package:go_router_riverpod_transition_sample/presentation/shared/page_root.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'todo_list_page_controller.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({
    super.key,
    required this.onLoading,
    required this.onDisposed,
  });

  final TransitionResult Function() onLoading;
  final VoidCallback onDisposed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo")),
      body: PageRoot(
        onLoading: onLoading,
        onDisposed: onDisposed,
        success: (context) => const TodoListView(),
        loading: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        failure: (context, exception) => Center(
          child: Text(exception.toString()),
        ),
      ),
    );
  }
}

class TodoListView extends ConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListPageController);
    return ListView(
      children: todos
          .map(
            (e) => CheckboxListTile(
              title: Text(e.name),
              value: false,
              onChanged: (bool? value) {},
            ),
          )
          .toList(),
    );
  }
}

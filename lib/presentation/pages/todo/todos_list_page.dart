import 'package:flutter/material.dart';
import 'package:go_router_riverpod_transition_sample/presentation/pages/todo/todos_page_controller.dart';
import 'package:go_router_riverpod_transition_sample/presentation/shared/page_root.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodosListPage extends ConsumerWidget {
  const TodosListPage({
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
    final todos = ref.watch(todosPageController);
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

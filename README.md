# What's this

Sample code for page transition using go_router and riverpod.
Loading and error handling practices.

# Explanation
## 1. Define GoRouter with Riverpod Provider
I define GoRouter using provider.
This allows riverpod ref to be used in the routing definition.

```dart
final routerProvider = Provider(
  (ref) => GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: "/todos",
        builder: (context, state) {
          return TodoListPage(
            onLoading: () => ref.read(todoPageController.notifier).load(),
            onDisposed: () => ref.read(todoPageController.notifier).clear(),
          );
        },
      )
    ],
  ),
);
```

In fact, `TodosListPage` uses the riverpod ref when loading and disposing

## 2. Handle loading and error
Below is the code for TodoListPage.
A widget called PageRoot is used for loading and error handling.

```dart
class TodoListPage extends ConsumerWidget {
  const TodoListPage({
    super.key,
    required this.onLoad,
    required this.onDispose,
  });

  final TransitionResult Function() onLoad;
  final VoidCallback onDispose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo")),
      body: PageRoot(
        onLoading: onLoad,
        onDisposed: onDispose,
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
```

This widget passes onLoading, which does the initialization process, and displays either the success, failure, or loading widget.
See code for detailed implementation.

By passing onLoad and onDispose to TodoListPage and setting those settings within GoRouter, a single widget can be used with multiple loading methods.
This is useful, for example, when a form has new creation and editing.


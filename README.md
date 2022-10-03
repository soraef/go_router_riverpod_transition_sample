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

This widget passes onLoad, which does the initialization process, and displays either the success, failure, or loading widget.
See code for detailed implementation.

By passing onLoad and onDispose to TodoListPage and setting those settings within GoRouter, a single widget can be used with multiple loading methods.
This is useful, for example, when a form has new creation and editing.

## 3. Implements PageRoot Widget
Below is the code for PageRoot.
PageRoot is a StatefulWidget and performs onLoad at initState.
There is a FutureBuilder in the build method, which displays a Widget according to the load result.

```dart
typedef TransitionResult = Future<Result<void, Exception>>;

class PageRoot extends StatefulWidget {
  const PageRoot({
    super.key,
    required this.onLoad,
    required this.onDispose,
    required this.success,
    required this.loading,
    required this.failure,
  });

  final TransitionResult Function() onLoad;
  final VoidCallback onDispose;
  final Widget Function(BuildContext context) success;
  final Widget Function(BuildContext context) loading;
  final Widget Function(BuildContext context, Exception exception) failure;

  @override
  State<PageRoot> createState() => _PageRootState();
}

class _PageRootState extends State<PageRoot> {
  TransitionResult? result;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        result = widget.onLoad();
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onDispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: result,
      builder: ((context, snapshot) {
        final data = snapshot.data;
        if (snapshot.hasData && data != null) {
          if (data.isSuccess) {
            return widget.success(context);
          } else {
            return widget.failure(context, data.failure);
          }
        } else {
          return widget.loading(context);
        }
      }),
    );
  }
}
```
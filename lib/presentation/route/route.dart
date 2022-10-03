import 'package:go_router/go_router.dart';
import 'package:go_router_riverpod_transition_sample/presentation/pages/home/home_page.dart';
import 'package:go_router_riverpod_transition_sample/presentation/pages/todo/todo_list_page.dart';
import 'package:go_router_riverpod_transition_sample/presentation/pages/todo/todo_list_page_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
            onLoad: () => ref.read(todoListPageController.notifier).load(),
            onDisposed: () => ref.read(todoListPageController.notifier).clear(),
          );
        },
      )
    ],
  ),
);

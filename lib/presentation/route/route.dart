import 'package:go_router/go_router.dart';
import 'package:go_router_riverpod_transition_sample/presentation/pages/home/home_page.dart';
import 'package:go_router_riverpod_transition_sample/presentation/pages/todo/todos_list_page.dart';
import 'package:go_router_riverpod_transition_sample/presentation/pages/todo/todos_page_controller.dart';
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
          return TodosListPage(
            onLoading: () => ref.read(todosPageController.notifier).load(),
            onDisposed: () => ref.read(todosPageController.notifier).clear(),
          );
        },
      )
    ],
  ),
);

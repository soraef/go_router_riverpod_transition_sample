import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:result_type/result_type.dart';

class Todo {
  final String name;

  Todo(this.name);
}

final todoListPageController =
    StateNotifierProvider<TodoListPageController, List<Todo>>(
  (ref) => TodoListPageController([]),
);

class TodoListPageController extends StateNotifier<List<Todo>> {
  TodoListPageController(super.state);

  Future<Result<void, Exception>> load() async {
    // loading delay
    await Future.delayed(const Duration(seconds: 3));

    // throw a random exception
    if (DateTime.now().second % 2 == 0) {
      state = [
        ...state,
        Todo("Coding"),
        Todo("Play Splatoon"),
      ];
      return Success(null);
    } else {
      return Failure(Exception("Not Found"));
    }
  }

  void clear() {
    state = [];
  }
}

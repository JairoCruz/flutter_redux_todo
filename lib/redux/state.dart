import 'package:todo_redux/redux/action.dart';

import '../model/todo.dart';

class AppState {
  List<Todo> todos;
  VisibilityFilter visibilityFilter;

  AppState({
    this.todos = const [],
    this.visibilityFilter = VisibilityFilter.showAll,
  });

  AppState copywith({todos, visibilityFilter}) {
    return AppState(
        todos: todos ?? this.todos,
        visibilityFilter: visibilityFilter ?? this.visibilityFilter);
  }
}

typedef SetVisibilityFilterFunction = void Function(VisibilityFilter filter);

typedef TodoTapFunction = void Function(int id);

typedef void TodoTapDelete(int id);
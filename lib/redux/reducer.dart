import 'package:todo_redux/redux/action.dart';
import 'package:todo_redux/redux/state.dart';

AppState todosReducer(AppState state, action) {
  if (action is AddTodoAction) {
    return AppState(
        todos: List.from(state.todos)..add(action.todo),
        visibilityFilter: state.visibilityFilter
        );
  } else if (action is UpdateCompleteTodoAction) {
    var newItem = state.todos[action.index];
    newItem.completed = !newItem.completed;
    return state.copywith(todos: state.todos);
  } else if (action is DeleteTodoAction) {
    state.todos.removeAt(action.index);
    return state.copywith(todos: state.todos);
  } else if (action is SetVisibilityFilterAction) {
    return AppState(todos: state.todos, visibilityFilter: action.filter);
  } else {
    return state;
  }
}
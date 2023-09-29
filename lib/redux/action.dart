import '../model/todo.dart';


enum VisibilityFilter { showAll, showActive, showCompleted }

class AddTodoAction {
  final Todo todo;
  AddTodoAction(this.todo);
}

class UpdateCompleteTodoAction {
  final int index;
  UpdateCompleteTodoAction(this.index);
}

class DeleteTodoAction {
  final int index;
  DeleteTodoAction(this.index);
}

class SetVisibilityFilterAction {
  final VisibilityFilter filter;
  SetVisibilityFilterAction(this.filter);
}

// ViewModel ListTodo
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_redux/model/todo.dart';
import 'package:todo_redux/redux/action.dart';
import 'package:todo_redux/redux/state.dart';

class _ViewModel {
  final List<Todo> todos;
  final TodoTapFunction onTodoTap;
  final TodoTapDelete onTodoTapDelete;

  _ViewModel(
      {required this.todos,
      required this.onTodoTap,
      required this.onTodoTapDelete});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          const ListEquality<Todo>().equals(todos, other.todos);

  @override
  int get hashCode => todos.hashCode;
}



// Lista de todos With ViewModel

class VisibleTodoList extends StatelessWidget {
  
  List<Todo> _getVisibleTodos(List<Todo> todos, VisibilityFilter filter) {
    switch (filter) {
      case VisibilityFilter.showAll:
        return todos;
      case VisibilityFilter.showCompleted:
        return todos.where((todo) => todo.completed == true).toList();
      case VisibilityFilter.showActive:
        return todos.where((todo) => todo.completed == false).toList();
      default:
        return <Todo>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        //distinct: true,
        converter: (store) => _ViewModel(
              todos: _getVisibleTodos(
                  store.state.todos, store.state.visibilityFilter),
              onTodoTap: (id) => store.dispatch(UpdateCompleteTodoAction(id)),
              onTodoTapDelete: (id) => store.dispatch(DeleteTodoAction(id)),
            ),
        builder: (context, viewModel) {
          return ListView.builder(
              itemCount: viewModel.todos.length,
              itemBuilder: (context, index) {
                return Dismissible(
                    onDismissed: (direction) {
                      viewModel.onTodoTapDelete(index);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(14),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    key: Key(viewModel.todos[index].task),
                    child: Card(
                      child: ListTile(
                        title: Text(viewModel.todos[index].task),
                        trailing: Checkbox(
                          value: viewModel.todos[index].completed,
                          onChanged: (value) {
                            viewModel.onTodoTap(index);
                          },
                        ),
                      ),
                    ));
              });
        });
  }
}

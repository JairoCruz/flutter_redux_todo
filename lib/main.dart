import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store<AppState>(todosReducer, initialState: AppState());
  runApp(MyApp(
    store: store,
  ));
}

class Todo {
  String task;
  bool completed;
  Todo(this.task, {this.completed = false});
}

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

enum VisibilityFilter { showAll, showActive, showCompleted }

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

AppState todosReducer(AppState state, action) {
  if (action is AddTodoAction) {
    return AppState(
        todos: List.from(state.todos)..add(action.todo),
        visibilityFilter: state.visibilityFilter);
  } else if (action is UpdateCompleteTodoAction) {
    //
    var newItem = state.todos[action.index];
    newItem.completed = !newItem.completed;

    return state.copywith(todos: state.todos);
  } else if (action is DeleteTodoAction) {
    print('antes de ${state.todos.length}');
    state.todos.removeAt(action.index);
    print('despues de ${state.todos.length}');
    return state.copywith(todos: state.todos);
  } else {
    return state;
  }
}

// CheckBox
class TodoItem extends StatelessWidget {
  final void Function(bool?) onCheckboxChanged;
  final Todo todo;

  const TodoItem(
      {super.key, required this.onCheckboxChanged, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(todo.task),
        trailing: Checkbox(
          value: todo.completed,
          onChanged: onCheckboxChanged,
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.store});
  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: MyHomePage(
            title: 'Flutter Demo Home Page',
            store: store,
          ),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final Store<AppState> store;

  final myController = TextEditingController();

  ///

  MyHomePage({super.key, required this.title, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Todo Redux')),
      body: StoreConnector<AppState, List<Todo>>(
        converter: (store) => store.state.todos.toList(),
        builder: (context, todos) {
          if (todos.isEmpty) {
            return const Center(
              child: Text('No hay nada'),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return 
                StoreConnector<AppState, VoidCallback>(
                  converter: (store) {
                    return () => store.dispatch(DeleteTodoAction(index));
                  },
                  builder: (context, callbackDelete) {
                    return  Dismissible(
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.all(14),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white,),),
                  key: Key(todos[index].task),
                  onDismissed: (direction) {
                    print('esto se ejecuta');
                    callbackDelete();
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(todos[index].task),
                      trailing: StoreConnector<AppState, VoidCallback>(
                        converter: (store) {
                          // Esto puede fallar al actulizar ya que no le podria pasar el index
                          return () =>
                              store.dispatch(UpdateCompleteTodoAction(index));
                        },
                        builder: (context, callback) {
                          return Checkbox(
                              value: todos[index].completed,
                              onChanged: (value) {
                                callback();
                              });
                        },
                      ),
                    ),
                  ),
                );
                  },);
               /*  Dismissible(
                  key: Key(todos[index].toString()),
                  onDismissed: (direction) {},
                  child: Card(
                    child: ListTile(
                      title: Text(todos[index].task),
                      trailing: StoreConnector<AppState, VoidCallback>(
                        converter: (store) {
                          // Esto puede fallar al actulizar ya que no le podria pasar el index
                          return () =>
                              store.dispatch(UpdateCompleteTodoAction(index));
                        },
                        builder: (context, callback) {
                          return Checkbox(
                              value: todos[index].completed,
                              onChanged: (value) {
                                callback();
                              });
                        },
                      ),
                    ),
                  ),
                ); */
              },
            );
          }
        },
      ),
      floatingActionButton: StoreConnector<AppState, VoidCallback>(
        converter: (store) {
          return () {
            store.dispatch(AddTodoAction(Todo(myController.text)));
            myController.clear();
            Navigator.pop(context);
          };
        },
        builder: (context, callback) {
          return FloatingActionButton(
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SizedBox(
                          height: 200,
                          child: Column(
                            children: [
                              Text(
                                'Task',
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              TextField(
                                autofocus: true,
                                controller: myController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Input task',
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FilledButton(
                                          onPressed: callback,
                                          child: const Text('Agregar')),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                    );
                  });
            },
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}

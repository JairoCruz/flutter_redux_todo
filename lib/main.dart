import 'dart:js_util';

import 'package:collection/collection.dart';
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

class SetVisibilityFilterAction {
  final VisibilityFilter filter;
  SetVisibilityFilterAction(this.filter);
}

enum VisibilityFilter { showAll, showActive, showCompleted }

//enum Filter { show, active, completed }

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

///////
typedef SetVisibilityFilterFunction = void Function(VisibilityFilter filter);

typedef TodoTapFunction = void Function(int id);

typedef void TodoTapDelete(int id);


AppState todosReducer(AppState state, action) {
  
  if (action is AddTodoAction) {
    return AppState(
        todos: List.from(state.todos)..add(action.todo),
        visibilityFilter: state.visibilityFilter);
  } else if (action is UpdateCompleteTodoAction) {
    
    var newItem = state.todos[action.index];
    newItem.completed = !newItem.completed;

    return state.copywith(todos: state.todos);
  } else if (action is DeleteTodoAction) {
    state.todos.removeAt(action.index);
    return state.copywith(todos: state.todos);
  } else if (action is SetVisibilityFilterAction) {
    return AppState(
      todos: state.todos,
      visibilityFilter: action.filter
    );
    
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


// ViewModel ListTodo
class _ViewModel {
  
  final List<Todo> todos;
  final TodoTapFunction onTodoTap;
  final TodoTapDelete onTodoTapDelete;

  _ViewModel({
    required this.todos,
    required this.onTodoTap,
    required this.onTodoTapDelete
  });

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is _ViewModel &&
      runtimeType == other.runtimeType &&
      const ListEquality<Todo>().equals(todos, other.todos);


  @override
  int get hashCode => todos.hashCode;

}

// ViewModel FilterList
class _ViewModelLC {

 
  final SetVisibilityFilterFunction fill;

  _ViewModelLC({
    required this.fill
  });


   @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}


// Widget checkbox
class FilterLink extends StatelessWidget {
  
  const FilterLink({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModelLC>(
      converter: (store) => _ViewModelLC(
        fill: (f) => store.dispatch(SetVisibilityFilterAction(f))),
      builder: (context, viewModel){
        return PopupMenuButton<VisibilityFilter>(
          initialValue: VisibilityFilter.showAll,
          onSelected: (VisibilityFilter filter) {
            viewModel.fill(filter);
          },
          itemBuilder: (context) => <PopupMenuEntry<VisibilityFilter>>[
            const PopupMenuItem<VisibilityFilter>(
              value: VisibilityFilter.showAll,
              child: Text('All'),
            ),
            const PopupMenuItem(
              value: VisibilityFilter.showActive,
              child: Text('Active'),
              ),
            const PopupMenuItem(
              value: VisibilityFilter.showCompleted,
              child: Text('Completos')
              )
          ],
        );
      });
  }

}


// Lista de todos With ViewModel

class VisibleTodoList extends StatelessWidget {

  List<Todo> _getVisibleTodos(List<Todo> todos, VisibilityFilter filter) {
    print('antes de switch: $filter');
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
        todos: _getVisibleTodos(store.state.todos, store.state.visibilityFilter),
        onTodoTap: (id) => store.dispatch(UpdateCompleteTodoAction(id)),
        onTodoTapDelete: (id) => store.dispatch(DeleteTodoAction(id)),
        ),
      builder: (context, viewModel) {
        return ListView.builder(
          itemCount: viewModel.todos.length,
          itemBuilder: (context, index){
            return  Dismissible(
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
                  onChanged: (value){
                    print('de: $index');
                    viewModel.onTodoTap(index);
                  },
                ),
                ),
              )
              )
            ;
          }
          );
      }
        
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
          debugShowCheckedModeBanner: false,
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

  //Filter? selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Todo Redux'),
          actions: [
            FilterLink(),
           /*  StoreConnector<AppState, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(VisibilityFilter);
              } ,
              builder: (context, callback) {
                return 
                PopupMenuButton<Filter>(
              initialValue: selectedFilter,
              onSelected: (Filter item){
                if (item == Filter.completed){
                  callback();
                  print('value:  $item');
                }
                
              },
              itemBuilder: (context) => <PopupMenuEntry<Filter>>[
                const PopupMenuItem<Filter>(
                  value: Filter.show,
                  child: Text('All'),
                  ),
                const PopupMenuItem<Filter>(
                  value: Filter.active,
                  child: Text('Active'),
                ),
                const PopupMenuItem<Filter>(
                  value: Filter.completed,
                  child: Text('Completed'),
                ),
              ],
            );
              },
              ), */
          ],
          ),
      body: 
      VisibleTodoList(),
      /* StoreConnector<AppState, List<Todo>>(
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
      ), */
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

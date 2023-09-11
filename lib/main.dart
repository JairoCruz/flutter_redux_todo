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

    /*  return AppState(
        todos: List.from(state.todos)..insert(action.index, newItem),
        visibilityFilter: state.visibilityFilter
      ); */
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
        builder: (context, vm) {
          if (vm.isEmpty) {
            return const Center(
              child: Text('No hay nada'),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: vm.length,
              itemBuilder: (context, index) {
                return
                    // StoreConnector<AppState, VoidCallback>(
                    //   converter: (store) {
                    //     return () => store.dispatch(UpdateCompleteTodoAction(index));
                    //   },
                    //   builder: (context, callback) {
                    //     return TodoItem(todo: vm[index], onCheckboxChanged: callback,);
                    //   },
                    // );

                    Card(
                  child: ListTile(
                    title: Text(vm[index].task),
                    trailing: StoreConnector<AppState, VoidCallback>(
                      converter: (store) {
                        // Esto puede fallar al actulizar ya que no le podria pasar el index
                        return () =>
                            store.dispatch(UpdateCompleteTodoAction(index));
                      },
                      builder: (context, callback) {
                        return Checkbox(
                            value: vm[index].completed,
                            onChanged: (value) {
                              callback();
                              //store.dispatch(UpdateCompleteTodoAction(index));
                            });
                      },
                    ),
                  ),
                );
                // SizedBox(
                //   height: 50,
                //   child: Center(child: Text(vm[index].task))
                //   );
              },
              //separatorBuilder: (BuildContext context, index) => const Divider(),
            );
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Scaffold.of(context).showBottomSheet<void>(
      //     (BuildContext context) {
      //     return Container(
      //       height: 200,
      //       color: Colors.amber,
      //       child: const Center(
      //         child: Text('Prueba'),
      //         ),
      //     );
      //   },);
      //   }
      //   ),
      floatingActionButton: StoreConnector<AppState, VoidCallback>(
        converter: (store) {
          //return () => store.dispatch(AddTodoAction(Todo(myController.text)));
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
                      padding: const EdgeInsets.all(24.0),
                      child: SizedBox(
                          height: 200,
                          child: Column(
                            children: [
                              Text('Task',
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.labelLarge,
                              ),
                              TextField(
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

/* class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
       
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
         
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
} */

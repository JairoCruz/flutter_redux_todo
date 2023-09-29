import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_redux/model/todo.dart';
import 'package:todo_redux/redux/action.dart';
import 'package:todo_redux/redux/state.dart';
import 'package:todo_redux/widget/filter.dart';
import 'package:todo_redux/widget/list.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.store});
  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo list',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: MyHomePage(
            title: 'Todo',
            store: store,
          ),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final Store<AppState> store;

  final myController = TextEditingController();

  MyHomePage({super.key, required this.title, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Todo Redux'),
        actions: const [
          FilterLink(),
        ],
      ),
      body: VisibleTodoList(),
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
                      padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 24,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
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
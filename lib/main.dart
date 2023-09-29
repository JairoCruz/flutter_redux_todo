import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:todo_redux/redux/reducer.dart';
import 'package:todo_redux/redux/state.dart';

import 'myApp.dart';

void main() {
  final store = Store<AppState>(todosReducer, initialState: AppState());
  runApp(MyApp(
    store: store,
  ));
}
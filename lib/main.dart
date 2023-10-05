import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:todo_redux/redux/reducer.dart';
import 'package:todo_redux/redux/state.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'myApp.dart';

Future<void> main() async {

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  final store = Store<AppState>(todosReducer, initialState: AppState());
  runApp(MyApp(
    store: store,
  ));
}
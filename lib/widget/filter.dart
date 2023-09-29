// ViewModel FilterList
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_redux/redux/action.dart';
import 'package:todo_redux/redux/state.dart';

class _ViewModelLC {
  final SetVisibilityFilterFunction fill;

  _ViewModelLC({required this.fill});

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
        builder: (context, viewModel) {
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
                  child: Text('Completos'))
            ],
          );
        });
  }
}
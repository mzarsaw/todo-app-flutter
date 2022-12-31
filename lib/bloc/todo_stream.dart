import 'dart:async';

import 'package:my_todo_app/bloc/todo.dart';
import 'package:rxdart/rxdart.dart';

class TodoStream {
  final _stateController = BehaviorSubject<TodoState>();
  final _eventController = BehaviorSubject<TodoEvent>();

  Stream<TodoState> get state => _stateController.stream;

  Sink<TodoEvent> get event => _eventController.sink;

  TodoStream() {
    _eventController.stream.listen(_mapEventToState);
    _stateController.add(TodoState(
        todos: [const Todo(title: 'test', isCompleted: true)],
        isEditing: false));
  }

  void _mapEventToState(TodoEvent event) async {
    if (event is AddTodo) {
      await _addTodo(event.todo);
    } else if (event is DeleteTodo) {
      await _deleteTodo(event.todo);
    } else if (event is ToggleTodo) {
      await _toggleTodo(event.todo);
    } else if (event is ToggleEditMode) {
      await _toggleEditMode();
    }
  }

  Future _addTodo(Todo todo) async =>
      _stateController.add(_stateController.value.copyWith(
        todos: _stateController.value.todos..add(todo),
      ));

  Future _deleteTodo(Todo todo) async => _stateController.add((await state.last)
      .copyWith(todos: _stateController.value.todos..remove(todo)));

  Future _toggleTodo(Todo todo) async {
    final todoState = _stateController.value;
    final newTodos = todoState.todos
        .map((t) =>
            t == todo ? todo.copyWith(isCompleted: !todo.isCompleted) : t)
        .toList();
    _stateController.add(todoState.copyWith(todos: newTodos));
  }

  Future _toggleEditMode() async => _stateController.add((await state.last)
      .copyWith(isEditing: !_stateController.value.isEditing));
  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}

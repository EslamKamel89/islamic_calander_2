// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'tasks_cubit.dart';

class TasksState {
  List<TaskModel>? tasks = [];
  List<TaskModel>? filteredTasks = [];
  TasksState({
    this.tasks,
    this.filteredTasks,
  });

  TasksState copyWith({
    List<TaskModel>? tasks,
    List<TaskModel>? filteredTasks,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
    );
  }

  @override
  String toString() => 'TasksState(tasks: $tasks, filteredTasks: $filteredTasks)';
}

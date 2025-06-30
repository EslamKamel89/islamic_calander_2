import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_calander_2/core/heleprs/local_notification.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/core/static_data/shared_prefrences_key.dart';
import 'package:islamic_calander_2/features/tasks/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  SharedPreferences sh = serviceLocator<SharedPreferences>();
  TasksCubit() : super(TasksState());

  Future<void> initalizeTasks() async {
    state.tasks = sh
            .getStringList(ShPrefKey.tasks)
            ?.map((json) => TaskModel.fromJson(jsonDecode(json)))
            .toList() ??
        [];
    state.filteredTasks = state.tasks;
    emit(state.copyWith());
  }

  void filterTasks(String? query) {
    // if (query == null || query == '') {
    //   emit(state.copyWith());
    //   return;
    // }
    state.filteredTasks = state.tasks?.where((task) {
      return task.title?.toLowerCase().contains(query ?? '') == true ||
          task.subject?.toLowerCase().contains(query ?? '') == true ||
          task.content?.toLowerCase().contains(query ?? '') == true;
    }).toList();
    emit(state.copyWith());
  }

  Future<void> addTask(TaskModel newTask) async {
    state.tasks?.add(newTask);
    state.filteredTasks = state.tasks;
    await sh.setStringList(
        ShPrefKey.tasks, state.tasks?.map((task) => jsonEncode(task.toJson())).toList() ?? []);
    emit(state.copyWith());
    notificationService.addNotifications();
  }

  Future<void> deleteTask(String? id) async {
    if (id == null) return;
    state.tasks?.removeWhere((task) => task.id == id);
    state.filteredTasks = state.tasks;
    await sh.setStringList(
        ShPrefKey.tasks, state.tasks?.map((task) => jsonEncode(task.toJson())).toList() ?? []);
    emit(state.copyWith());
    notificationService.addNotifications();
  }
}

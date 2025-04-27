import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_calander_2/core/heleprs/is_ltr.dart';
import 'package:islamic_calander_2/core/router/app_routes_names.dart';
import 'package:islamic_calander_2/core/widgets/sizer.dart';
import 'package:islamic_calander_2/features/tasks/cubits/tasks/tasks_cubit.dart';
import 'package:islamic_calander_2/features/tasks/models/task_model.dart';
import 'package:islamic_calander_2/utils/styles/styles.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  TextEditingController searchController = TextEditingController();
  late TasksCubit controller;
  @override
  void initState() {
    controller = context.read<TasksCubit>();
    searchController.addListener(_filterTasks);
    super.initState();
  }

  @override
  void dispose() {
    searchController.removeListener(_filterTasks);
    super.dispose();
  }

  void _filterTasks() {
    controller.filterTasks(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.white.withOpacity(0.3),
            title: Text(
              "TASKS".tr(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const Sizer(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'SEARCH_TASKS'.tr(),
                          border: InputBorder.none,
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        final newTask =
                            await Navigator.of(context).pushNamed(AppRoutesNames.addTaskView);
                        if (newTask != null) {
                          controller.addTask(newTask as TaskModel);
                        }
                      },
                    ),
                  ],
                ),
                const Sizer(),
                Expanded(
                  child: state.filteredTasks?.isEmpty == true
                      ? Center(child: txt('NO_TASKS_FOUND'.tr()))
                      : ListView.builder(
                          itemCount: state.filteredTasks?.length ?? 0,
                          itemBuilder: (context, index) {
                            final task = state.filteredTasks?[index];
                            return _buildTaskCard(task);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskCard(TaskModel? task) {
    if (task == null) return const SizedBox();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(task.title ?? ''),
        subtitle: task.date != null
            ? Text(
                DateFormat('MMM dd, yyyy', isEnglish() ? 'en' : 'ar').format(task.date!),
              )
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${'SUBJECT'.tr()}: ${task.subject}'),
                const SizedBox(height: 8),
                Text('${"CONTENT".tr()}: ${task.content}'),
                const SizedBox(height: 16),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.deleteTask(task.id),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

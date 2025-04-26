import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_calander_2/core/globals/globals_var.dart';
import 'package:islamic_calander_2/core/widgets/sizer.dart';
import 'package:islamic_calander_2/features/tasks/models/task_model.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  _AddTaskViewState createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  final Map<String, String> _formData = {
    'title': '',
    'subject': '',
    'content': '',
  };

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      _formKey.currentState!.save();
      final newTask = TaskModel(
        id: DateTime.now().toString(),
        title: _formData['title']!,
        subject: _formData['subject']!,
        content: _formData['content']!,
        date: _selectedDate!,
      );
      Navigator.pop(context, newTask);
    }
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('MMM dd, yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ltr,
      child: Scaffold(
        appBar: AppBar(title: const Text('Add New Task')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                  onSaved: (value) => _formData['title'] = value!,
                ),
                const Sizer(),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Subject'),
                  validator: (value) => value!.isEmpty ? 'Please enter a subject' : null,
                  onSaved: (value) => _formData['subject'] = value!,
                ),
                const Sizer(),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Content'),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Please enter content' : null,
                  onSaved: (value) => _formData['content'] = value!,
                ),
                const Sizer(),
                TextFormField(
                  controller: _dateController,
                  onTap: _selectDate,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _selectDate,
                    ),
                  ),
                  readOnly: true,
                  validator: (value) => value!.isEmpty ? 'Please select a date' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

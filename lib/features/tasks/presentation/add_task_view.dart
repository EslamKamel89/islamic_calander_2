import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/heleprs/is_ltr.dart';
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
        id: DateTime.now().millisecondsSinceEpoch.toString(),
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
      final pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      setState(() {
        if (pickedTime != null) {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        }
        _dateController.text =
            DateFormat('MMM dd, yyyy', isEnglish() ? 'en' : 'ar').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ADD_TASK'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'TITLE'.tr()),
                validator: (value) => value!.isEmpty ? 'PLEASE_ENTER_TITLE'.tr() : null,
                onSaved: (value) => _formData['title'] = value!,
              ),
              const Sizer(),
              TextFormField(
                decoration: InputDecoration(labelText: 'SUBJECT'.tr()),
                validator: (value) => value!.isEmpty ? 'PLEASE_ENTER_SUBJECT'.tr() : null,
                onSaved: (value) => _formData['subject'] = value!,
              ),
              const Sizer(),
              TextFormField(
                decoration: InputDecoration(labelText: 'CONTENT'.tr()),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'PLEASE_ENTER_CONTENT'.tr() : null,
                onSaved: (value) => _formData['content'] = value!,
              ),
              const Sizer(),
              TextFormField(
                controller: _dateController,
                onTap: _selectDate,
                decoration: InputDecoration(
                  labelText: 'DATE'.tr(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                readOnly: true,
                validator: (value) => value!.isEmpty ? 'PLEASE_SELECT_DATE'.tr() : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('ADD_TASK'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

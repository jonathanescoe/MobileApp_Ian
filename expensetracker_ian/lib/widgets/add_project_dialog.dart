import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project_model.dart';
import '../data_providers/time_entry_provider.dart';

class AddProjectDialog extends StatefulWidget {
  final Function(ExpenseCategory) onAdd;

  const AddProjectDialog({super.key, required this.onAdd});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Category'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(labelText: 'Category Name'),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            var newProject = ExpenseCategory(
              id: Provider.of<TimeEntryProvider>(
                context,
                listen: false,
              ).generateProjectId().toString(),
              name: _controller.text,
            );
            widget.onAdd(newProject);
            Provider.of<TimeEntryProvider>(
              context,
              listen: false,
            ).addProject(newProject);
            _controller.clear(); // Clear the input field
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

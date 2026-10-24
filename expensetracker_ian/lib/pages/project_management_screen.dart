import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_providers/time_entry_provider.dart';
import '../widgets/add_project_dialog.dart';

// Example for CategoryManagementScreen
class ProjectManagementScreen extends StatelessWidget {
  const ProjectManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Categories"),
        backgroundColor:
            Colors.deepPurple, // Themed color similar to your inspirations
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final project = provider.projects[index];
              return ListTile(
                title: Text(project.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.deleteProject(project.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddProjectDialog(
              onAdd: (newProject) {
                Provider.of<TimeEntryProvider>(
                  context,
                  listen: false,
                ).addProject(newProject);
              },
            ),
          );
        },
        tooltip: 'Add New Project',
        child: Icon(Icons.add),
      ),
    );
  }
}

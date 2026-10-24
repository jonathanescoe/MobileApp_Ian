import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_providers/time_entry_provider.dart';
import 'add_time_entry_screen.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../models/time_entry_model.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _allEntryTabLabel = "All Expenses";
  final _groupByProjectTabLabel = "Grouped by Categories";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Tracker"),
        backgroundColor: Colors.deepPurple[800],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: _allEntryTabLabel),
            Tab(text: _groupByProjectTabLabel),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.category, color: Colors.deepPurple),
              title: Text('Manage Categories'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_projects');
              },
            ),
            ListTile(
              leading: Icon(Icons.tag, color: Colors.deepPurple),
              title: Text('Manage Subcategories'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_tasks');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildTimeEntryByDate(context),
          buildTimeEntriesByProject(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
        ),
        tooltip: 'Add Expense',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildTimeEntryByDate(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.timeEntries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_empty, size: 50, color: Colors.deepPurple),
                Text(
                  'No expenses yet!',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 55, 55, 55),
                    fontSize: 24,
                  ),
                ),
                Text(
                  "Tap the + button to record expenses.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.timeEntries.length,
          itemBuilder: (context, index) {
            final timeEntry = provider.timeEntries[index];
            String formattedDate = DateFormat(
              'MMM dd, yyyy',
            ).format(timeEntry.date);
            return Dismissible(
              key: Key(timeEntry.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                provider.deleteTimeEntry(timeEntry.id);
              },
              background: Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                color: Colors.purple[50],
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: ListTile(
                  isThreeLine: true,
                  title: Text(
                    "${getProjectNameById(context, timeEntry.categoryId)} - ${getTaskNameById(context, timeEntry.subcategoryId)}",
                  ),
                  subtitle: Text(
                    "Amount: \$${timeEntry.amount.toStringAsFixed(2)}"
                    "\nPaid to: ${timeEntry.payee.isNotEmpty ? timeEntry.payee : 'None'}"
                    "\nDate: $formattedDate"
                    "\nNotes: ${timeEntry.notes.isNotEmpty ? timeEntry.notes : 'None'}",
                  ),
                  trailing: Icon(Icons.delete, color: Colors.red),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddTimeEntryScreen(initialTimeEntry: timeEntry),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTimeEntriesByProject(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.timeEntries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_empty, size: 50, color: Colors.deepPurple),
                Text(
                  'No time entries yet!',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 55, 55, 55),
                    fontSize: 24,
                  ),
                ),
                Text(
                  "Tap the + button to add your first entry.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
              ],
            ),
          );
        }

        // Grouping time entries by project
        var grouped = groupBy(
          provider.timeEntries,
          (Expense e) => e.categoryId,
        );
        return ListView(
          children: grouped.entries.map((entry) {
            String projectName = getProjectNameById(
              context,
              entry.key,
            ); // Ensure you implement this function
            entry.value.fold(
              0.0,
              (double prev, Expense element) => prev + element.amount,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    projectName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                ListView.builder(
                  physics:
                      NeverScrollableScrollPhysics(), // to disable scrolling within the inner list view
                  shrinkWrap:
                      true, // necessary to integrate a ListView within another ListView
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    Expense timeEntry = entry.value[index];
                    return ListTile(
                      leading: Text("-"),
                      title: Text(
                        "${getTaskNameById(context, timeEntry.subcategoryId)}"
                        ":\$${timeEntry.amount.toStringAsFixed(2)} "
                        "(${DateFormat('MMM dd, yyyy').format(timeEntry.date)})",
                      ),
                    );
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  // home_screen.dart

  String getProjectNameById(BuildContext context, String projectId) {
    var project = Provider.of<TimeEntryProvider>(context, listen: false)
        .projects
        .firstWhere(
          (p) => p.id == projectId,
          orElse: () => ExpenseCategory(id: '', name: 'Unknown'),
        );
    return project.name;
  }

  String getTaskNameById(BuildContext context, String taskId) {
    var task = Provider.of<TimeEntryProvider>(context, listen: false).tasks
        .firstWhere(
          (t) => t.id == taskId,
          orElse: () => ExpenseSubcategory(id: '', name: 'Unknown'),
        );
    return task.name;
  }
}

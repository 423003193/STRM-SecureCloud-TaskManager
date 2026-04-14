import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../services/sync_service.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  List<Task> _tasks = [];
  bool _isSyncing = false;
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final tasks = await DBHelper.getTasks();
    setState(() => _tasks = tasks);
  }

  void _addTask() async {
    if (_titleCtrl.text.isEmpty) return;
    Task newTask = Task(title: _titleCtrl.text, description: _descCtrl.text);
    await DBHelper.insertTask(newTask);
    _titleCtrl.clear();
    _descCtrl.clear();
    _loadTasks();
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Offline task drafted.')));
    }
  }

  void _syncTasks() async {
    setState(() => _isSyncing = true);
    try {
      await SyncService.syncTasks();
      _loadTasks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sync complete!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Internet / Sync Failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryBg,
        title: const Text('New Task', style: TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleCtrl, style: const TextStyle(color: AppColors.textPrimary), decoration: const InputDecoration(hintText: 'Title')),
            TextField(controller: _descCtrl, style: const TextStyle(color: AppColors.textPrimary), decoration: const InputDecoration(hintText: 'Description')),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: _addTask, child: const Text('Save Offline')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: AppColors.secondaryBg,
        actions: [
          _isSyncing
            ? const Padding(padding: EdgeInsets.all(15.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.accent)))
            : IconButton(icon: const Icon(Icons.sync), onPressed: _syncTasks),
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task.title, style: const TextStyle(color: AppColors.textPrimary)),
            subtitle: Text(task.description, style: const TextStyle(color: AppColors.textSecondary)),
            trailing: Icon(
              task.isSynced == 1 ? Icons.cloud_done : Icons.cloud_off,
              color: task.isSynced == 1 ? AppColors.success : AppColors.error,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

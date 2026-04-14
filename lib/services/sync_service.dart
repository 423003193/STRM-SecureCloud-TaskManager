import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import 'db_helper.dart';

class SyncService {
  static Future<void> syncTasks() async {
    if (!firebaseInitialized) {
      throw 'Firebase is not configured. Cannot sync to Firestore.';
    }

    try {
      final firestore = FirebaseFirestore.instance;
      final unsyncedTasks = await DBHelper.getUnsyncedTasks();

      for (var task in unsyncedTasks) {
        await firestore.collection('tasks').add({
          'title': task.title,
          'description': task.description,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Mark as synced locally
        if (task.id != null) {
          await DBHelper.markAsSynced(task.id!);
        }
      }
    } catch (e) {
      throw 'Sync failed: $e';
    }
  }
}

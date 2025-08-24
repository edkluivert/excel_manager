import 'package:excel_manager/data/data_sources/local/hive_db.dart';
import 'package:excel_manager/data/data_sources/local/task_ds.dart';
import 'package:excel_manager/data/data_sources/remote/mock_api.dart';

class SyncManager {
  SyncManager({required this.local, required this.remote});
  final TaskLocalDataSource local;
  final MockApi remote;

  Future<void> pushDirty() async {
    final all = await local.byProject(''); // we'll iterate over all from box
    // Hack: access directly since local.byProject needs id; we use box values:
    final values = await Future.value(local);
    final boxValues = HiveDb.tasks().values; // import HiveDb if needed
    final dirty = boxValues.where((t) => t.dirty).toList();
    for (final t in dirty) {
      final up = await remote.upsertTask(t..dirty = false);
      await local.upsert(up);
    }
  }

  Future<void> pullProject(String projectId) async {
    final remoteTasks = await remote.getTasksByProject(projectId);
    for (final rt in remoteTasks) {
      final lt = local.get(rt.id);
      if (lt == null || rt.updatedAt.isAfter(lt.updatedAt)) {
        await local.upsert(rt);
      }
    }
  }
}

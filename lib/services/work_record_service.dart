import 'package:hive/hive.dart';
import '../models/work_model.dart';
import '../utils/helpers.dart' as helpers;

class WorkRecordService {
  final Box<WorkRecord> _box = Hive.box('work_records');

  List<WorkRecord> getAll() {
    return _box.keys.map((key) {
      final record = _box.get(key as int); // Явное приведение типа
      return record!..key = key; // Явное приведение типа
    }).toList();
  }

  List<WorkRecord> getByDate(DateTime date) {
    return _box.keys
        .map((key) {
          final record = _box.get(key as int); // Явное приведение типа
          return record!..key = key; // Явное приведение типа
        })
        .where((r) => helpers.isSameDay(r.date, date))
        .toList();
  }

  double getTotalEarnedByDate(DateTime date) {
    return getByDate(date).fold(0.0, (sum, r) => sum + r.totalEarned);
  }

  Future<void> add(WorkRecord record) async {
    await _box.add(record);
  }

  WorkRecord? getByKey(int key) {
    final record = _box.get(key);
    if (record != null) {
      return record..key = key;
    }
    return null;
  }

  Future<void> update(int key, WorkRecord record) async {
    await _box.put(key, record);
  }

  Future<void> delete(int key) async {
    await _box.delete(key);
  }
}

import 'package:hive/hive.dart';
import '../models/work_model.dart';

import '../utils/helpers.dart' as helpers;

class WorkRecordService {
  final Box<WorkRecord> _box = Hive.box('work_records');

  List<WorkRecord> getAll() => _box.values.toList();

  List<WorkRecord> getByDate(DateTime date) {
    return _box.values.where((r) => helpers.isSameDay(r.date, date)).toList();
  }

  double getTotalEarnedByDate(DateTime date) {
    return _box.values
        .where((r) => helpers.isSameDay(r.date, date))
        .fold(0.0, (sum, r) => sum + r.totalEarned);
  }

  Future<void> add(WorkRecord record) async {
    await _box.add(record);
  }
}

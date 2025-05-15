import 'package:hive_flutter/hive_flutter.dart';
import '../models/work_model.dart';

class HiveService {
  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WorkRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(WorkTypeAdapter());
    }

    await Hive.openBox<WorkRecord>('work_records');
    await Hive.openBox<WorkType>('work_types');
  }

  static Box<WorkRecord> get workRecords => Hive.box('work_records');
  static Box<WorkType> get workTypes => Hive.box('work_types');
}

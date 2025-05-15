import 'package:hive/hive.dart';
import '../models/work_model.dart';

class WorkTypeService {
  final Box<WorkType> _box = Hive.box('work_types');

  List<WorkType> getAll() => _box.values.toList();

  Future<void> add(WorkType type) async {
    await _box.add(type);
  }

  Future<void> deleteById(String id) async {
    final index = _box.values.toList().indexWhere((t) => t.id == id);
    if (index >= 0) await _box.deleteAt(index);
  }
}

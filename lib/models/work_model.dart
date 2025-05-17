import 'package:hive/hive.dart';

part 'work_model.g.dart';

@HiveType(typeId: 0)
class WorkRecord {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final String workType;
  @HiveField(3)
  final double hours;
  @HiveField(4)
  final int units;
  @HiveField(5)
  final double pricePerUnit;

  // Добавляем поле для хранения ключа Hive (не сохраняется в базе)
  @HiveField(6)
  int? key;

  WorkRecord({
    required this.id,
    required this.date,
    required this.workType,
    required this.hours,
    required this.units,
    required this.pricePerUnit,
    this.key,
  });

  double get totalEarned => units * pricePerUnit;
}

@HiveType(typeId: 1)
class WorkType {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double pricePerUnit;

  WorkType({required this.id, required this.name, required this.pricePerUnit});
}

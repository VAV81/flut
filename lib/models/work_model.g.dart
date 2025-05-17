// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkRecordAdapter extends TypeAdapter<WorkRecord> {
  @override
  final int typeId = 0;

  @override
  WorkRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkRecord(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      workType: fields[2] as String,
      hours: fields[3] as double,
      units: fields[4] as int,
      pricePerUnit: fields[5] as double,
      key: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkRecord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.workType)
      ..writeByte(3)
      ..write(obj.hours)
      ..writeByte(4)
      ..write(obj.units)
      ..writeByte(5)
      ..write(obj.pricePerUnit)
      ..writeByte(6)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkTypeAdapter extends TypeAdapter<WorkType> {
  @override
  final int typeId = 1;

  @override
  WorkType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkType(
      id: fields[0] as String,
      name: fields[1] as String,
      pricePerUnit: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WorkType obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.pricePerUnit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

import 'package:excel_manager/data/models/task_model.dart';
import 'package:hive_flutter/hive_flutter.dart';


class PriorityAdapterEnumAdapter extends TypeAdapter<PriorityAdapterEnum> {
  @override
  final int typeId = 2;

  @override
  PriorityAdapterEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PriorityAdapterEnum.low;
      case 1:
        return PriorityAdapterEnum.medium;
      case 2:
        return PriorityAdapterEnum.high;
      default:
        return PriorityAdapterEnum.low;
    }
  }

  @override
  void write(BinaryWriter writer, PriorityAdapterEnum obj) {
    switch (obj) {
      case PriorityAdapterEnum.low:
        writer.writeByte(0);
      case PriorityAdapterEnum.medium:
        writer.writeByte(1);
      case PriorityAdapterEnum.high:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriorityAdapterEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return TaskModel(
      id: fields[0] as String,
      projectId: fields[1] as String,
      title: fields[2] as String,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      note: fields[5] as String?,
      completed: fields[6] as bool? ?? false, // ✅ default
      priority: fields[7] as PriorityAdapterEnum? ?? PriorityAdapterEnum.low, // ✅ default
      dueAt: fields[8] as DateTime?,
      dirty: fields[9] as bool? ?? false, // ✅ default
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(10) // ✅ number of fields you're writing
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.projectId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.completed)
      ..writeByte(7)
      ..write(obj.priority)
      ..writeByte(8)
      ..write(obj.dueAt)
      ..writeByte(9)
      ..write(obj.dirty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TaskAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../variables.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WoodsAdapter extends TypeAdapter<Woods> {
  @override
  final int typeId = 1;

  @override
  Woods read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Woods()..woodcount = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, Woods obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.woodcount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WoodsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StoneAdapter extends TypeAdapter<Stone> {
  @override
  final int typeId = 2;

  @override
  Stone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stone()..stonecount = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, Stone obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.stonecount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

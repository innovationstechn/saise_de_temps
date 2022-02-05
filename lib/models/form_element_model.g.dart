// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_element_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormElementModelAdapter extends TypeAdapter<FormElementModel> {
  @override
  final int typeId = 1;

  @override
  FormElementModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormElementModel(
      id: fields[0] as int?,
      text: fields[1] as String?,
      type: fields[2] as String?,
      option: (fields[3] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, FormElementModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.option);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormElementModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

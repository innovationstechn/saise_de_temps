import 'package:hive/hive.dart';
import 'package:saise_de_temps/models/checkbox_options_model.dart';
import 'package:saise_de_temps/models/dropdown_options_model.dart';
import 'package:saise_de_temps/models/text_options_model.dart';
import 'package:saise_de_temps/models/time_options_model.dart';

part 'form_element_model.g.dart';

enum FormElementType { text, number, multiple, time, checkbox, unknown }

@HiveType(typeId: 1)
class FormElementModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? text;
  @HiveField(2)
  String? type;
  @HiveField(3)
  Map<String, dynamic> option;

  FormElementType get formType {
    if (type == "text") {
      return FormElementType.text;
    } else if (type == "number") {
      return FormElementType.number;
    } else if (type == "dropdown") {
      return FormElementType.multiple;
    } else if (type == "time") {
      return FormElementType.time;
    } else if (type == "checkbox") {
      return FormElementType.checkbox;
    } else {
      return FormElementType.unknown;
    }
  }

  TextOptionModel? getTextOptionModel() {
    return TextOptionModel.fromJson(option);
  }

  TextOptionModel? getNumberOptionModel() {
    return TextOptionModel.fromJson(option);
  }

  DropDownOptionModel getDropDownOptionModel() {
    return DropDownOptionModel.fromJson(option);
  }

  CheckBoxOptionModel getCheckBoxModel() {
    return CheckBoxOptionModel.fromJson(option);
  }

  TimeOptionModel getTimeOptionModel() {
    return TimeOptionModel.fromJson(option);
  }

  FormElementModel(
      {required this.id,
      required this.text,
      required this.type,
      required this.option});

  factory FormElementModel.fromJson(Map<String, dynamic> map) {
    return FormElementModel(
        id: map['id'] as int?,
        text: map['text'] as String?,
        type: map['type'] as String?,
        option: map['option']);
  }

  @override
  String toString() => '$id $text $type';
}

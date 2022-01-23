enum FormElementType { text, number, multiple, time, checkbox, unknown }

class FormElementModel {
  int? id;
  String? text;
  String? type;
  List<String?>? options;
  List<String?>? values;

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

  FormElementModel({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.values,
  });

  factory FormElementModel.fromJson(Map<String, dynamic> map) {
    return FormElementModel(
      id: map['id'] as int?,
      text: map['text'] as String?,
      type: map['type'] as String?,
      options: map['options'] as List<String?>?,
      values: (map['option']['list'] as List<dynamic>?)?.cast<String?>(),
    );
  }

  @override
  String toString() => '$id $text $type $options';
}

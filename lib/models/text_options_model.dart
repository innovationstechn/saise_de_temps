enum FormElementType { text, number, multiple, time, checkbox, unknown }

class TextOptionModel {
  int? maxLength;
  int? minLength;
  bool? required;
  double? size;
  String? value;

  TextOptionModel(
      this.maxLength,
      this.minLength,
      this.required,
      this.size,
      this.value);

  factory TextOptionModel.fromJson(Map<String, dynamic> map) {
    return TextOptionModel(
      int.parse(map['maxlength']),
      int.parse(map['minlength']),
      map['required'].toLowerCase() == 'true',
      double.parse(map['size']),
      map['value']??"",
    );
  }


}

enum FormElementType { text, number, multiple, time, checkbox, unknown }

class TimeOptionModel {
  String? format;
  bool? required;
  double? size;
  String? value;

  TimeOptionModel(this.format, this.required, this.size, this.value);

  factory TimeOptionModel.fromJson(Map<String, dynamic> map) {
    return TimeOptionModel(
      map['format'],
      map['required'].toLowerCase() == 'true',
      double.tryParse(map['size']),
      map['value'] ?? "",
    );
  }
}

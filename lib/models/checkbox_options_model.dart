class CheckBoxOptionModel {
  bool? required;
  double? size;
  bool? value;

  CheckBoxOptionModel(this.required, this.size, this.value);

  factory CheckBoxOptionModel.fromJson(Map<String, dynamic> map) {
    return CheckBoxOptionModel(
      map['required'].toLowerCase() == 'true',
      double.tryParse(map['size']),
      map['value'].toLowerCase()== 'yes',
    );
  }
}

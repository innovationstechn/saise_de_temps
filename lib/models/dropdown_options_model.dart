class DropDownOptionModel {
  List<String?>? list;
  bool? required;
  double? size;
  String? value;

  DropDownOptionModel(this.list,this.required, this.size,this.value);

  factory DropDownOptionModel.fromJson(Map map) {

    return DropDownOptionModel(
      (map['list'] as List<dynamic>?)?.cast<String?>()??[],
      (map['required'].toLowerCase() == 'true'),
      double.tryParse(map['size']),
      map['value'] as String?,
    );
  }
}

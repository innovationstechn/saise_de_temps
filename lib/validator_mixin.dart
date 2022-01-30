mixin Validator {
  String? textValidator(String? value) {
    if (value != null) {
      if (value.isNotEmpty) {
        return null;
      }
    }
    return "Not Valid";
  }

  String? numberValidator(int? value) {
    if (value != null) {
      if (value > 0) {
        return null;
      }
    }
    return "Not Valid";
  }

  String? boolValidator(bool? value) {
    if (value != null) {
      return null;
    }
    return "Not Valid";
  }
}

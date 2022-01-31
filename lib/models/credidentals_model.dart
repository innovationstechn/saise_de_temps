class CredentialsModel {
  String name, password;

  CredentialsModel({required this.name, required this.password});

  factory CredentialsModel.fromJson(Map<String, dynamic> json) => CredentialsModel(
        name: json['name'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
      };
}

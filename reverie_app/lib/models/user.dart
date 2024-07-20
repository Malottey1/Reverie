class User {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String gender;
  final String birthday;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    required this.birthday,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'gender': gender,
      'birthday': birthday,
    };
  }
}
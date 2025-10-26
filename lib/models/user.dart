class User {
  final String? id;
  final String phoneNumber;
  final String? email;
  final String? fullName;
  final String? password;
  final DateTime? dateOfBirth;
  final String? address;

  User({
    this.id,
    required this.phoneNumber,
    this.email,
    this.fullName,
    this.password,
    this.dateOfBirth,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      password: json['password'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'phoneNumber': phoneNumber,
    'email': email,
    'fullName': fullName,
    'password': password,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'address': address,
  };
}

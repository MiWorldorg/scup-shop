class UserResponse {
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String email;

  UserResponse(
      {required this.username,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.address,
      required this.email});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      address: json['address'],
      email: json['email'],
    );
  }
}

class UsersListResponse {
  final int id;
  final String role;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String email;

  UsersListResponse({
    required this.id,
    required this.role,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.email,
  });

  factory UsersListResponse.fromJson(Map<String, dynamic> json) {
    return UsersListResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      role: json['role']?.toString() ?? 'user',
      username: json['username']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  UsersListResponse copyWith({String? role}) => UsersListResponse(
    id: id,
    role: role ?? this.role,
    username: username,
    firstName: firstName,
    lastName: lastName,
    phone: phone,
    address: address,
    email: email,
  );
}

class UsersPageResponse {
  final List<UsersListResponse> users;
  final int currentPage;
  final int lastPage;
  final int total;

  const UsersPageResponse({
    required this.users,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}

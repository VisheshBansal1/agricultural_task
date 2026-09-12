enum AppRole { user, owner, admin }

class AppUser {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String location;
  final AppRole role;
  final String? profileImage;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.location,
    required this.role,
    this.profileImage,
  });

  AppUser copyWith({
    String? name,
    String? phone,
    String? email,
    String? location,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      role: role,
      profileImage: profileImage,
    );
  }
}

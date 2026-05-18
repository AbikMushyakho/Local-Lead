class User {
  final String id;
  final String name;
  final String photo;
  final String email;
  final String phone;
  final String location;
  final String memberSince;
  final String bio;
  final bool verified;

  const User({
    required this.id,
    required this.name,
    required this.photo,
    required this.email,
    required this.phone,
    required this.location,
    required this.memberSince,
    this.bio='',
    this.verified = false,
  });
}
class User {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final String language;
  final String? state;
  final String? city;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.photoUrl,
    this.language = 'en',
    this.state,
    this.city,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? language,
    String? state,
    String? city,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      language: language ?? this.language,
      state: state ?? this.state,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'photoUrl': photoUrl,
    'language': language,
    'state': state,
    'city': city,
    'createdAt': createdAt.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    photoUrl: json['photoUrl'],
    language: json['language'] ?? 'en',
    state: json['state'],
    city: json['city'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}
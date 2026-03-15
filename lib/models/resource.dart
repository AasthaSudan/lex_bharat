class LegalResource {
  final String id;
  final String name;
  final String type;
  final String phone;
  final String email;
  final String address;
  final double distance;
  final double rating;
  final int reviews;
  final List<String> specializations;

  LegalResource({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    this.email = '',
    required this.address,
    required this.distance,
    this.rating = 0.0,
    this.reviews = 0,
    this.specializations = const [],
  });

  factory LegalResource.fromJson(Map<String, dynamic> json) => LegalResource(
    id: json['id'],
    name: json['name'],
    type: json['type'],
    phone: json['phone'],
    email: json['email'] ?? '',
    address: json['address'],
    distance: json['distance'].toDouble(),
    rating: json['rating']?.toDouble() ?? 0.0,
    reviews: json['reviews'] ?? 0,
    specializations: List<String>.from(json['specializations'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'phone': phone,
    'email': email,
    'address': address,
    'distance': distance,
    'rating': rating,
    'reviews': reviews,
    'specializations': specializations,
  };
}
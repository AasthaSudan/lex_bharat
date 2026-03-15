class LegalResource {
  final String id;
  final String title;
  final String description;
  final String resourceType; // legal_aid, ngo, government_scheme, helpline
  final String contactName;
  final String? email;
  final String? phone;
  final String? website;
  final double latitude;
  final double longitude;
  final String address;
  final List<String> services;
  final double rating;
  final int reviewCount;
  final bool isFree;

  LegalResource({
    required this.id,
    required this.title,
    required this.description,
    required this.resourceType,
    required this.contactName,
    this.email,
    this.phone,
    this.website,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.services = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFree = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'resourceType': resourceType,
    'contactName': contactName,
    'email': email,
    'phone': phone,
    'website': website,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'services': services,
    'rating': rating,
    'reviewCount': reviewCount,
    'isFree': isFree,
  };

  factory LegalResource.fromJson(Map<String, dynamic> json) {
    return LegalResource(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      resourceType: json['resourceType'] as String,
      contactName: json['contactName'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      services: List<String>.from(json['services'] as List? ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      isFree: json['isFree'] as bool? ?? false,
    );
  }
}


import 'dart:convert';
import 'package:flutter/services.dart';

/// Production-grade legal resources service for finding legal aid and emergency services
class LegalResourcesService {
  static const String _resourcesPath = 'assets/data/resources.json';

  /// Get legal resources by state and type (offline-first)
  Future<List<LegalResource>> getResourcesByState({
    required String resourceType,
    required String state,
  }) async {
    try {
      final jsonString = await rootBundle.loadString(_resourcesPath);
      final jsonData = jsonDecode(jsonString);

      final legalAidOrgs = (jsonData['legalAidOrganizations'] as List?)
          ?.map((json) => LegalResource.fromJson(json))
          .toList() ?? [];

      return legalAidOrgs;
    } catch (e) {
      throw LegalResourceException(
        message: 'Failed to fetch resources: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Search resources by query (offline-first)
  Future<List<LegalResource>> searchResources({
    String? query,
  }) async {
    try {
      final jsonString = await rootBundle.loadString(_resourcesPath);
      final jsonData = jsonDecode(jsonString);
      
      var resources = (jsonData['legalAidOrganizations'] as List?)
          ?.map((json) => LegalResource.fromJson(json))
          .toList() ?? [];


      // Text search if query provided
      if (query != null && query.isNotEmpty) {
        final searchTerm = query.toLowerCase();
        resources = resources
            .where((r) =>
                r.name.toLowerCase().contains(searchTerm) ||
                (r.description?.toLowerCase().contains(searchTerm) ?? false))
            .toList();
      }

      return resources;
    } catch (e) {
      throw LegalResourceException(
        message: 'Failed to search resources: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Get emergency contacts (offline from resources.json)
  Future<List<EmergencyContact>> getEmergencyContacts({
    required String category,
    String? state,
  }) async {
    try {
      final jsonString = await rootBundle.loadString(_resourcesPath);
      final jsonData = jsonDecode(jsonString);

      final contacts = (jsonData['emergencyContacts'] as List?)
          ?.map((json) => EmergencyContact.fromJson(json))
          .where((contact) => contact.category == category)
          .toList() ?? [];

      return contacts;
    } catch (e) {
      throw LegalResourceException(
        message: 'Failed to fetch emergency contacts: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Get all emergency categories with their contacts
  Future<Map<String, List<EmergencyContact>>> getAllEmergencyCategories({
    String? state,
  }) async {
    try {
      final jsonString = await rootBundle.loadString(_resourcesPath);
      final jsonData = jsonDecode(jsonString);

      final contacts = (jsonData['emergencyContacts'] as List?)
          ?.map((json) => EmergencyContact.fromJson(json))
          .toList() ?? [];

      final Map<String, List<EmergencyContact>> result = {};
      for (final contact in contacts) {
        if (!result.containsKey(contact.category)) {
          result[contact.category] = [];
        }
        result[contact.category]!.add(contact);
      }

      return result;
    } catch (e) {
      throw LegalResourceException(
        message: 'Failed to fetch emergency contacts: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Get government schemes (offline from resources.json)
  Future<List<GovernmentScheme>> getGovernmentSchemes() async {
    try {
      final jsonString = await rootBundle.loadString(_resourcesPath);
      final jsonData = jsonDecode(jsonString);

      final schemes = (jsonData['governmentSchemes'] as List?)
          ?.map((json) => GovernmentScheme.fromJson(json))
          .toList() ?? [];

      return schemes;
    } catch (e) {
      throw LegalResourceException(
        message: 'Failed to fetch schemes: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Get common legal procedures
  Future<List<LegalProcedure>> getCommonProcedures() async {
    try {
      final jsonString = await rootBundle.loadString(_resourcesPath);
      final jsonData = jsonDecode(jsonString);

      final procedures = (jsonData['commonProcedures'] as List?)
          ?.map((json) => LegalProcedure.fromJson(json))
          .toList() ?? [];

      return procedures;
    } catch (e) {
      throw LegalResourceException(
        message: 'Failed to fetch procedures: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }
}

/// Model for legal resource
class LegalResource {
  final String id;
  final String name;
  final String type;
  final String? description;
  final String? phone;
  final String? email;
  final String? website;
  final String? address;
  final String city;
  final String state;
  final String? pincode;
  final double? latitude;
  final double? longitude;
  final List<String>? services;
  final String? availabilityHours;
  final List<String>? languageSupport;
  final bool isVerified;
  final double rating;
  final double? distance; // For sorting by distance

  LegalResource({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.phone,
    this.email,
    this.website,
    this.address,
    required this.city,
    required this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.services,
    this.availabilityHours,
    this.languageSupport,
    required this.isVerified,
    required this.rating,
    this.distance,
  });

  factory LegalResource.fromJson(Map<String, dynamic> json) {
    return LegalResource(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      address: json['address'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      services: List<String>.from(json['services'] ?? []),
      availabilityHours: json['availability_hours'],
      languageSupport: List<String>.from(json['language_support'] ?? []),
      isVerified: json['is_verified'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'description': description,
        'phone': phone,
        'email': email,
        'website': website,
        'address': address,
        'city': city,
        'state': state,
        'pincode': pincode,
        'latitude': latitude,
        'longitude': longitude,
        'services': services,
        'availability_hours': availabilityHours,
        'language_support': languageSupport,
        'is_verified': isVerified,
        'rating': rating,
      };
}

/// Model for emergency contact
class EmergencyContact {
  final String id;
  final String name;
  final String number;
  final String category;
  final String description;
  final bool available24x7;
  final List<String> languages;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.number,
    required this.category,
    required this.description,
    required this.available24x7,
    required this.languages,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      number: json['number'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      available24x7: json['available24x7'] ?? true,
      languages: List<String>.from(json['languages'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'number': number,
        'category': category,
        'description': description,
        'available24x7': available24x7,
        'languages': languages,
      };
}

/// Model for government scheme
class GovernmentScheme {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> eligibility;
  final List<String> benefits;
  final String applicationProcess;

  GovernmentScheme({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.eligibility,
    required this.benefits,
    required this.applicationProcess,
  });

  factory GovernmentScheme.fromJson(Map<String, dynamic> json) {
    return GovernmentScheme(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      eligibility: List<String>.from(json['eligibility'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      applicationProcess: json['applicationProcess'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'eligibility': eligibility,
        'benefits': benefits,
        'applicationProcess': applicationProcess,
      };
}

/// Model for legal procedure
class LegalProcedure {
  final String id;
  final String name;
  final List<String> steps;
  final String timeRequired;
  final List<String> documents;

  LegalProcedure({
    required this.id,
    required this.name,
    required this.steps,
    required this.timeRequired,
    required this.documents,
  });

  factory LegalProcedure.fromJson(Map<String, dynamic> json) {
    return LegalProcedure(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      steps: List<String>.from(json['steps'] ?? []),
      timeRequired: json['timeRequired'] ?? '',
      documents: List<String>.from(json['documents'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'steps': steps,
        'timeRequired': timeRequired,
        'documents': documents,
      };
}

/// Custom exception for resources service
class LegalResourceException implements Exception {
  final String message;
  final Exception? originalException;

  LegalResourceException({
    required this.message,
    this.originalException,
  });

  @override
  String toString() => message;
}


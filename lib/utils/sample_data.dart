import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

class LegalContentService {
  static List<Map<String, dynamic>>? _cachedCategories;
  static List<Map<String, dynamic>>? _cachedMappings;

  static const Map<String, IconData> _iconMap = {
    'shield': Icons.shield_rounded,
    'work': Icons.work_rounded,
    'female': Icons.female_rounded,
    'shopping_cart': Icons.shopping_cart_rounded,
    'home': Icons.home_rounded,
    'gavel': Icons.gavel_rounded,
    'computer': Icons.computer_rounded,
    'info': Icons.info_rounded,
    'family_restroom': Icons.family_restroom_rounded,
    'school': Icons.school_rounded,
    'groups': Icons.groups_rounded,
    'eco': Icons.eco_rounded,
  };

  static Color _parseColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  static Future<List<Map<String, dynamic>>> getCategories({String lang = 'en'}) async {
    if (_cachedCategories != null) {
      return _formatCategories(_cachedCategories!, lang);
    }

    try {
      final jsonStr = await rootBundle.loadString('assets/data/legal_content.json');
      final data = json.decode(jsonStr);
      _cachedCategories = List<Map<String, dynamic>>.from(data['categories']);
      return _formatCategories(_cachedCategories!, lang);
    } catch (e) {
      debugPrint('Failed to load legal content: $e');
      return SampleData.getLegalCategories(); // fallback
    }
  }

  static List<Map<String, dynamic>> _formatCategories(List<Map<String, dynamic>> raw, String lang) {
    return raw.map((cat) {
      final isHindi = lang == 'hi';
      return {
        'title': isHindi ? (cat['title_hi'] ?? cat['title']) : cat['title'],
        'icon': _iconMap[cat['icon']] ?? Icons.article_rounded,
        'color': _parseColor(cat['color']),
        'topics': (cat['topics'] as List).map((t) => {
          'title': isHindi ? (t['title_hi'] ?? t['title']) : t['title'],
          'content': t['content'], // content stays English for now
        }).toList(),
      };
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getIPCBNSMappings() async {
    if (_cachedMappings != null) return _cachedMappings!;

    try {
      final jsonStr = await rootBundle.loadString('assets/data/ipc_bns_mapping.json');
      final data = json.decode(jsonStr);
      _cachedMappings = List<Map<String, dynamic>>.from(data['mappings']);
      return _cachedMappings!;
    } catch (e) {
      debugPrint('Failed to load IPC-BNS mappings: $e');
      return [];
    }
  }
}

class SampleData {
  static List<Map<String, dynamic>> getLegalCategories() {
    return [
      {
        'title': 'Labor Rights',
        'icon': Icons.work,
        'color': AppColors.categoryBlue,
        'topics': [
          {'title': 'Minimum Wage', 'content': 'Every worker has the right to minimum wage under the Code on Wages 2019. Rates vary by state. Contact your state Labour Commissioner for exact rates.\n\nHelpline: Shram Suvidha 1800-11-6060'},
          {'title': 'Overtime Pay', 'content': 'Workers are entitled to double wages for overtime beyond 8 hours/day or 48 hours/week under the Factories Act 1948.'},
          {'title': 'Wrongful Termination', 'content': 'Protection under Industrial Disputes Act 1947. File complaint with Labour Commissioner. Free legal aid: NALSA 1800-11-4001'},
        ],
      },
      {
        'title': 'Property Rights',
        'icon': Icons.home,
        'color': AppColors.categoryGreen,
        'topics': [
          {'title': 'Rent Agreements', 'content': 'Mandatory registration if lease exceeds 11 months. Tenants have right to peaceful possession and essential amenities.'},
          {'title': 'Eviction Rules', 'content': 'Landlords must follow legal procedures. Court order is mandatory. Illegal eviction (changing locks, cutting utilities) is a criminal offense.'},
        ],
      },
      {
        'title': 'Women\'s Rights',
        'icon': Icons.female,
        'color': AppColors.categoryPink,
        'topics': [
          {'title': 'Domestic Violence Act', 'content': 'Protection of Women from Domestic Violence Act 2005. Call Women Helpline: 181 (24/7). Approach Protection Officer or Magistrate for protection order.'},
          {'title': 'Workplace Harassment', 'content': 'POSH Act 2013 mandates Internal Complaints Committee in every organization with 10+ employees. Complaint within 3 months of incident.'},
        ],
      },
      {
        'title': 'Consumer Rights',
        'icon': Icons.shopping_cart,
        'color': AppColors.categoryOrange,
        'topics': [
          {'title': 'Product Defects', 'content': 'Consumer Protection Act 2019. File online at edaakhil.nic.in. National Consumer Helpline: 1800-11-4000'},
          {'title': 'Refund Rights', 'content': 'District forum for claims up to ₹1 crore. Simple process, minimal fees.'},
        ],
      },
    ];
  }

  static List<Map<String, dynamic>> getLegalResources() {
    return [
      {'name': 'National Legal Services Authority', 'type': 'Legal Aid Organization', 'phone': '1800-11-4001', 'address': 'Sector 12, Dwarka, New Delhi - 110078', 'distance': 2.5},
      {'name': 'District Legal Services Authority', 'type': 'Government Office', 'phone': '011-2345-6789', 'address': 'Court Complex, District Courts, Delhi', 'distance': 5.2},
      {'name': 'Women Legal Aid Center', 'type': 'NGO - Women Support', 'phone': '1800-22-5757', 'address': 'Karol Bagh, New Delhi - 110005', 'distance': 3.8},
      {'name': 'Labor Commissioner Office', 'type': 'Government Office', 'phone': '011-2389-4567', 'address': 'Shram Shakti Bhawan, Rafi Marg, New Delhi', 'distance': 4.5},
      {'name': 'Consumer Forum Delhi', 'type': 'Consumer Protection', 'phone': '1800-11-4000', 'address': 'Vinay Marg, Chanakyapuri, New Delhi', 'distance': 6.1},
    ];
  }
}
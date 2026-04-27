import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

/// Production-grade case status tracker service with real API integration
class CaseStatusTrackerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // eCourts APIs
  static const String _eCourtsAPIBaseUrl = 'https://api.ecourts.gov.in/api/s';
  static const String _caseLookupEndpoint = '/CaseList';
  static const String _caseDetailEndpoint = '/CaseDetail';

  /// Track case status using CNR (Case Number Registration)
  /// Real integration with eCourts India API
  Future<CaseStatus> trackCase({
    required String cnrNumber,
    String? courtType, // DISTRICT, HIGH, SUPREME
  }) async {
    try {
      // Validate CNR format: 13 digits
      if (!_isValidCNR(cnrNumber)) {
        throw CaseTrackingException(
          message: 'Invalid CNR format. CNR should be 13 digits.',
        );
      }

      // Check local cache first
      final cachedCase = await _getCachedCaseStatus(cnrNumber);
      if (cachedCase != null &&
          DateTime.now().difference(cachedCase.lastUpdated).inHours < 6) {
        return cachedCase;
      }

      // Fetch from eCourts API
      final caseData = await _fetchFromECourts(cnrNumber, courtType);

      // Cache the result
      await _cacheCaseStatus(caseData);

      return caseData;
    } catch (e) {
      throw CaseTrackingException(
        message: 'Failed to track case: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Fetch case data from eCourts API
  Future<CaseStatus> _fetchFromECourts(
    String cnrNumber,
    String? courtType,
  ) async {
    try {
      // Parse CNR to extract details
      final caseYear = cnrNumber.substring(0, 4);
      final caseType = cnrNumber.substring(4, 7);
      final caseNumber = cnrNumber.substring(7, 13);
      final stateCode = cnrNumber.substring(13);

      final url = Uri.parse(
        '$_eCourtsAPIBaseUrl$_caseLookupEndpoint?cnr=$cnrNumber&caseYear=$caseYear&caseNum=$caseNumber&caseType=$caseType&stateCode=$stateCode',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          return CaseStatus.fromECourtsJson(jsonResponse['data']);
        } else {
          throw CaseTrackingException(
            message:
                jsonResponse['message'] ?? 'Case not found in eCourts database',
          );
        }
      } else {
        throw CaseTrackingException(
          message: 'Failed to fetch case data (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Validate CNR format
  bool _isValidCNR(String cnr) {
    // CNR format: LLYYIISTTTCCCCCC (13 digits)
    return RegExp(r'^\d{13}$').hasMatch(cnr);
  }

  /// Get cached case status
  Future<CaseStatus?> _getCachedCaseStatus(String cnrNumber) async {
    try {
      final doc = await _firestore.collection('case_cache').doc(cnrNumber).get();

      if (!doc.exists) return null;
      return CaseStatus.fromJson(doc.data()!);
    } catch (e) {
      print('Cache retrieval error: $e');
      return null;
    }
  }

  /// Cache case status locally
  Future<void> _cacheCaseStatus(CaseStatus caseStatus) async {
    try {
      await _firestore
          .collection('case_cache')
          .doc(caseStatus.cnrNumber)
          .set(caseStatus.toJson());
    } catch (e) {
      print('Cache storage error: $e');
    }
  }

  /// Get next hearing date
  Future<DateTime?> getNextHearingDate(String cnrNumber) async {
    try {
      final caseStatus = await trackCase(cnrNumber: cnrNumber);
      return caseStatus.nextHearingDate;
    } catch (e) {
      throw CaseTrackingException(
        message: 'Failed to fetch hearing date: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Set hearing date reminder
  Future<void> setHearingReminder({
    required String cnrNumber,
    required DateTime reminderDate,
  }) async {
    try {
      await _firestore.collection('case_reminders').add({
        'cnr_number': cnrNumber,
        'reminder_date': reminderDate.toIso8601String(),
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw CaseTrackingException(
        message: 'Failed to set reminder: ${e.toString()}',
      );
    }
  }

  /// Get case history for a user
  Future<List<CaseStatus>> getUserCaseHistory(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('user_case_tracking')
          .where('user_id', isEqualTo: userId)
          .get();

      final cases = <CaseStatus>[];
      for (final doc in snapshot.docs) {
        final cnr = doc.data()['cnr_number'] as String;
        try {
          final caseStatus = await trackCase(cnrNumber: cnr);
          cases.add(caseStatus);
        } catch (e) {
          print('Error fetching case $cnr: $e');
          continue;
        }
      }

      return cases;
    } catch (e) {
      throw CaseTrackingException(
        message: 'Failed to fetch case history: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Add case to user's tracking list
  Future<void> addCaseToTrack({
    required String userId,
    required String cnrNumber,
  }) async {
    try {
      await _firestore.collection('user_case_tracking').add({
        'user_id': userId,
        'cnr_number': cnrNumber,
        'added_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw CaseTrackingException(
        message: 'Failed to add case: ${e.toString()}',
      );
    }
  }
}

/// Model for case status
class CaseStatus {
  final String cnrNumber;
  final String caseNumber;
  final String caseType;
  final String caseCategoryName;
  final String filingDate;
  final String firNumber;
  final String firYear;
  final String respondent;
  final String petitioner;
  final String courtName;
  final String courtType;
  final String districtName;
  final String stateCode;
  final String currentStatus; // e.g., "Pending", "Listed", "Disposed"
  final String caseStatus;
  final DateTime? nextHearingDate;
  final String? judgeAssigned;
  final String? lastAmendmentDate;
  final int hearingsCount;
  final DateTime lastUpdated;

  CaseStatus({
    required this.cnrNumber,
    required this.caseNumber,
    required this.caseType,
    required this.caseCategoryName,
    required this.filingDate,
    required this.firNumber,
    required this.firYear,
    required this.respondent,
    required this.petitioner,
    required this.courtName,
    required this.courtType,
    required this.districtName,
    required this.stateCode,
    required this.currentStatus,
    required this.caseStatus,
    this.nextHearingDate,
    this.judgeAssigned,
    this.lastAmendmentDate,
    required this.hearingsCount,
    required this.lastUpdated,
  });

  factory CaseStatus.fromECourtsJson(Map<String, dynamic> json) {
    return CaseStatus(
      cnrNumber: json['cnr_number'] ?? '',
      caseNumber: json['case_number'] ?? '',
      caseType: json['case_type'] ?? '',
      caseCategoryName: json['case_category_name'] ?? '',
      filingDate: json['filing_date'] ?? '',
      firNumber: json['fir_number'] ?? '',
      firYear: json['fir_year'] ?? '',
      respondent: json['respondent'] ?? '',
      petitioner: json['petitioner'] ?? '',
      courtName: json['court_name'] ?? '',
      courtType: json['court_type'] ?? '',
      districtName: json['district_name'] ?? '',
      stateCode: json['state_code'] ?? '',
      currentStatus: json['current_status'] ?? 'Pending',
      caseStatus: json['case_status'] ?? '',
      nextHearingDate: json['next_hearing_date'] != null
          ? DateTime.tryParse(json['next_hearing_date'])
          : null,
      judgeAssigned: json['judge_name'],
      lastAmendmentDate: json['last_amendment_date'],
      hearingsCount: json['hearings_count'] ?? 0,
      lastUpdated: DateTime.now(),
    );
  }

  factory CaseStatus.fromJson(Map<String, dynamic> json) {
    return CaseStatus(
      cnrNumber: json['cnr_number'] ?? '',
      caseNumber: json['case_number'] ?? '',
      caseType: json['case_type'] ?? '',
      caseCategoryName: json['case_category_name'] ?? '',
      filingDate: json['filing_date'] ?? '',
      firNumber: json['fir_number'] ?? '',
      firYear: json['fir_year'] ?? '',
      respondent: json['respondent'] ?? '',
      petitioner: json['petitioner'] ?? '',
      courtName: json['court_name'] ?? '',
      courtType: json['court_type'] ?? '',
      districtName: json['district_name'] ?? '',
      stateCode: json['state_code'] ?? '',
      currentStatus: json['current_status'] ?? 'Pending',
      caseStatus: json['case_status'] ?? '',
      nextHearingDate: json['next_hearing_date'] != null
          ? DateTime.parse(json['next_hearing_date'])
          : null,
      judgeAssigned: json['judge_assigned'],
      lastAmendmentDate: json['last_amendment_date'],
      hearingsCount: json['hearings_count'] ?? 0,
      lastUpdated: DateTime.parse(
        json['last_updated'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'cnr_number': cnrNumber,
    'case_number': caseNumber,
    'case_type': caseType,
    'case_category_name': caseCategoryName,
    'filing_date': filingDate,
    'fir_number': firNumber,
    'fir_year': firYear,
    'respondent': respondent,
    'petitioner': petitioner,
    'court_name': courtName,
    'court_type': courtType,
    'district_name': districtName,
    'state_code': stateCode,
    'current_status': currentStatus,
    'case_status': caseStatus,
    'next_hearing_date': nextHearingDate?.toIso8601String(),
    'judge_assigned': judgeAssigned,
    'last_amendment_date': lastAmendmentDate,
    'hearings_count': hearingsCount,
    'last_updated': lastUpdated.toIso8601String(),
  };
}

/// Custom exception for case tracking errors
class CaseTrackingException implements Exception {
  final String message;
  final Exception? originalException;

  CaseTrackingException({required this.message, this.originalException});

  @override
  String toString() => message;
}

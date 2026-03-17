import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Rights Education Provider ────────────────────────────────────────────────

final rightsEducationProvider =
NotifierProvider<RightsEducationNotifier, List<dynamic>>(
    RightsEducationNotifier.new);

class RightsEducationNotifier extends Notifier<List<dynamic>> {
  @override
  List<dynamic> build() => [];

  void setCategories(List<dynamic> categories) {
    state = categories;
  }

  void markTopicComplete(String categoryId, String topicId) {
    // update completion logic here when needed
  }
}

// ── Complaint Reports Provider ───────────────────────────────────────────────

final complaintReportsProvider =
NotifierProvider<ComplaintNotifier, List<dynamic>>(
    ComplaintNotifier.new);

class ComplaintNotifier extends Notifier<List<dynamic>> {
  @override
  List<dynamic> build() => [];

  void addComplaint(dynamic complaint) {
    state = [...state, complaint];
  }

  void removeComplaint(String complaintId) {
    state = state
        .where((c) => (c as Map)['id'] != complaintId)
        .toList();
  }
}
  void updateComplaint(dynamic complaint) {
    // Update complaint logic
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Rights Education Provider
final rightsEducationProvider =
    StateNotifierProvider<RightsEducationNotifier, AsyncValue<List<dynamic>>>((ref) {
  return RightsEducationNotifier();
});

class RightsEducationNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  RightsEducationNotifier() : super(const AsyncValue.loading());

  void setCategories(List<dynamic> categories) {
    state = AsyncValue.data(categories);
  }

  void markTopicComplete(String categoryId, String topicId) {
    // Update completion status
  }

  void setError(String error) {
    state = AsyncValue.error(error, StackTrace.current);
  }
}

// ===== Chat Messages Provider =====
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
// Chat Messages Provider

  void addMessage(dynamic message) {
    state.whenData((messages) {
      final updatedMessages = [...messages, message];
      state = AsyncValue.data(updatedMessages);
    });
  }

  void setError(String error) {
    state = AsyncValue.error(error, StackTrace.current);
  }

  void clearMessages() {
    final currentState = state;
    if (currentState is AsyncValue<List<dynamic>>) {
      final messages = [...?currentState.value, message];
      state = AsyncValue.data(messages);
    }
});


  void setForms(List<dynamic> forms) {
    state = AsyncValue.data(forms);
  }

  void addForm(dynamic form) {
// Forms Provider
      final updatedForms = [...forms, form];
      state = AsyncValue.data(updatedForms);
    });
  }

  void updateForm(String formId, dynamic updatedForm) {
    state.whenData((forms) {
      final updatedForms = forms
          .map((f) => (f as Map)['id'] == formId ? updatedForm : f)
          .toList();
      state = AsyncValue.data(updatedForms);
    });
  void updateForm(dynamic form) {
    // Update form logic
    state = AsyncValue.data(resources);
  }

  void filterByType(String type) {
    state.whenData((resources) {
      final filtered = resources
          .where((r) => (r as Map)['type'] == type)
          .toList();
      state = AsyncValue.data(filtered);
    });
  }

  void setError(String error) {
    state = AsyncValue.error(error, StackTrace.current);
  }
}

// ===== Documents Provider =====
final documentsProvider = 
// Resources Provider
  return DocumentsNotifier();
});

class DocumentsNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  DocumentsNotifier() : super(const AsyncValue.data([]));

  void addDocument(dynamic document) {
    state.whenData((documents) {
      final updatedDocs = [...documents, document];
      state = AsyncValue.data(updatedDocs);
    });
  }

  void removeDocument(String docId) {
    state.whenData((documents) {
      final updatedDocs = documents
    // Filter resources by type
    state = AsyncValue.error(error, StackTrace.current);
  }
}

// Complaint Reports Provider
// ===== Complaint Reports Provider =====
final complaintReportsProvider = 
    StateNotifierProvider<ComplaintNotifier, AsyncValue<List<dynamic>>>((ref) {
  return ComplaintNotifier();
});
// Documents Provider
class ComplaintNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  ComplaintNotifier() : super(const AsyncValue.data([]));

  void addComplaint(dynamic complaint) {
    final currentState = state;
    if (currentState is AsyncValue<List<dynamic>>) {
      final complaints = [...?currentState.value, complaint];
      state = AsyncValue.data(complaints);
    }
    state.whenData((complaints) {
      final updatedComplaints = [...complaints, complaint];
      state = AsyncValue.data(updatedComplaints);
    });
  }
    final currentState = state;
    if (currentState is AsyncValue<List<dynamic>>) {
      final documents = [...?currentState.value, document];
      state = AsyncValue.data(documents);
    }

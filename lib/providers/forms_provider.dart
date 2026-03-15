import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/form.dart';

final formsProvider = StateNotifierProvider<FormsNotifier, FormsState>(
      (ref) => FormsNotifier(),
);

class FormsState {
  final List<LegalForm> forms;
  final Map<String, Map<String, dynamic>> drafts;
  final bool isLoading;
  final String? error;

  FormsState({
    this.forms = const [],
    this.drafts = const {},
    this.isLoading = false,
    this.error,
  });

  FormsState copyWith({
    List<LegalForm>? forms,
    Map<String, Map<String, dynamic>>? drafts,
    bool? isLoading,
    String? error,
  }) {
    return FormsState(
      forms: forms ?? this.forms,
      drafts: drafts ?? this.drafts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FormsNotifier extends StateNotifier<FormsState> {
  FormsNotifier() : super(FormsState());

  void saveDraft(String formId, Map<String, dynamic> data) {
    final newDrafts = Map<String, Map<String, dynamic>>.from(state.drafts);
    newDrafts[formId] = data;
    state = state.copyWith(drafts: newDrafts);
  }

  Map<String, dynamic>? getDraft(String formId) {
    return state.drafts[formId];
  }

  void clearDraft(String formId) {
    final newDrafts = Map<String, Map<String, dynamic>>.from(state.drafts);
    newDrafts.remove(formId);
    state = state.copyWith(drafts: newDrafts);
  }
}
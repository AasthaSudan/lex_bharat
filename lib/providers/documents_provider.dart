import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/document.dart';

final documentsProvider =
NotifierProvider<DocumentsNotifier, DocumentsState>(DocumentsNotifier.new);

class DocumentsState {
  final List<LegalDocument> documents;
  final bool isLoading;
  final String? error;

  DocumentsState({
    this.documents = const [],
    this.isLoading = false,
    this.error,
  });

  DocumentsState copyWith({
    List<LegalDocument>? documents,
    bool? isLoading,
    String? error,
  }) {
    return DocumentsState(
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DocumentsNotifier extends Notifier<DocumentsState> {
  @override
  DocumentsState build() {
    _loadDocuments();
    return DocumentsState();
  }

  Future<void> _loadDocuments() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false);
  }

  void addDocument(LegalDocument document) {
    state = state.copyWith(
      documents: [...state.documents, document],
    );
  }

  void removeDocument(String documentId) {
    state = state.copyWith(
      documents: state.documents.where((d) => d.id != documentId).toList(),
    );
  }
}
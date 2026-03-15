import 'package:hive_flutter/hive_flutter.dart';

class StorageServiceImpl {
  static const String userBox = 'user_box';
  static const String documentsBox = 'documents_box';
  static const String complaintsBox = 'complaints_box';
  static const String formsBox = 'forms_box';
  static const String cacheBox = 'cache_box';
  static const String syncBox = 'sync_box';

  late Box<dynamic> _userBox;
  late Box<dynamic> _documentsBox;
  late Box<dynamic> _complaintsBox;
  late Box<dynamic> _formsBox;
  late Box<dynamic> _cacheBox;
  late Box<dynamic> _syncBox;

  static final StorageServiceImpl _instance = StorageServiceImpl._internal();

  factory StorageServiceImpl() {
    return _instance;
  }

  StorageServiceImpl._internal();

  Future<void> init() async {
    await Hive.initFlutter();
    _userBox = await Hive.openBox(userBox);
    _documentsBox = await Hive.openBox(documentsBox);
    _complaintsBox = await Hive.openBox(complaintsBox);
    _formsBox = await Hive.openBox(formsBox);
    _cacheBox = await Hive.openBox(cacheBox);
    _syncBox = await Hive.openBox(syncBox);
  }

  // User Storage
  Future<void> saveUser(String userId, Map<String, dynamic> userData) async {
    await _userBox.put(userId, userData);
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    final data = _userBox.get(userId);
    return data is Map<String, dynamic> ? data : null;
  }

  Future<void> deleteUser(String userId) async {
    await _userBox.delete(userId);
  }

  // Documents Storage
  Future<void> saveDocument(String docId, Map<String, dynamic> docData) async {
    await _documentsBox.put(docId, docData);
  }

  Future<List<Map<String, dynamic>>> getAllDocuments() async {
    return _documentsBox.values.cast<Map<String, dynamic>>().toList();
  }

  Future<void> deleteDocument(String docId) async {
    await _documentsBox.delete(docId);
  }

  // Complaints Storage
  Future<void> saveComplaint(String complaintId, Map<String, dynamic> data) async {
    await _complaintsBox.put(complaintId, data);
  }

  Future<List<Map<String, dynamic>>> getAllComplaints() async {
    return _complaintsBox.values.cast<Map<String, dynamic>>().toList();
  }

  Future<void> deleteComplaint(String complaintId) async {
    await _complaintsBox.delete(complaintId);
  }

  // Forms Storage
  Future<void> saveForm(String formId, Map<String, dynamic> data) async {
    await _formsBox.put(formId, data);
  }

  Future<List<Map<String, dynamic>>> getAllForms() async {
    return _formsBox.values.cast<Map<String, dynamic>>().toList();
  }

  // Cache Storage
  Future<void> cacheContent(String key, Map<String, dynamic> content) async {
    await _cacheBox.put(key, content);
  }

  Future<Map<String, dynamic>?> getCachedContent(String key) async {
    final data = _cacheBox.get(key);
    return data is Map<String, dynamic> ? data : null;
  }

  Future<void> clearCache() async {
    await _cacheBox.clear();
  }

  // Sync Storage
  Future<void> savePendingSync(String syncId, Map<String, dynamic> data) async {
    await _syncBox.put(syncId, data);
  }

  Future<List<Map<String, dynamic>>> getPendingSyncs() async {
    return _syncBox.values.cast<Map<String, dynamic>>().toList();
  }

  Future<void> removePendingSync(String syncId) async {
    await _syncBox.delete(syncId);
  }

  Future<void> clearAll() async {
    await _userBox.clear();
    await _documentsBox.clear();
    await _complaintsBox.clear();
    await _formsBox.clear();
    await _cacheBox.clear();
    await _syncBox.clear();
  }

  Future<void> close() async {
    await Hive.close();
  }
}


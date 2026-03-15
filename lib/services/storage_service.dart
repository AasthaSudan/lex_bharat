import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _chatHistoryKey = 'chat_history';
  static const String _bookmarksKey = 'bookmarks';
  static const String _completedTopicsKey = 'completed_topics';
  static const String _savedFormsKey = 'saved_forms';

  // Chat History
  Future<void> saveChatHistory(List<Map<String, dynamic>> messages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chatHistoryKey, jsonEncode(messages));
  }

  Future<List<Map<String, dynamic>>?> getChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_chatHistoryKey);
    if (data == null) return null;
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  Future<void> clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chatHistoryKey);
  }

  // Bookmarks
  Future<void> saveBookmark(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    if (!bookmarks.contains(topicId)) {
      bookmarks.add(topicId);
      await prefs.setStringList(_bookmarksKey, bookmarks);
    }
  }

  Future<void> removeBookmark(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    bookmarks.remove(topicId);
    await prefs.setStringList(_bookmarksKey, bookmarks);
  }

  Future<List<String>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_bookmarksKey) ?? [];
  }

  // Completed Topics
  Future<void> markTopicCompleted(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> completed = prefs.getStringList(_completedTopicsKey) ?? [];
    if (!completed.contains(topicId)) {
      completed.add(topicId);
      await prefs.setStringList(_completedTopicsKey, completed);
    }
  }

  Future<List<String>> getCompletedTopics() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_completedTopicsKey) ?? [];
  }

  // Form Drafts
  Future<void> saveFormDraft(String formId, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> allForms = {};

    final String? existing = prefs.getString(_savedFormsKey);
    if (existing != null) {
      allForms = jsonDecode(existing);
    }

    allForms[formId] = data;
    await prefs.setString(_savedFormsKey, jsonEncode(allForms));
  }

  Future<Map<String, dynamic>?> getFormDraft(String formId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_savedFormsKey);
    if (data == null) return null;

    final Map<String, dynamic> allForms = jsonDecode(data);
    return allForms[formId];
  }

  // Clear All
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_provider.dart';
import '../../utils/colors.dart';
import '../../utils/sample_data.dart';
import 'topics_list_screen.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allCategories = [];
  List<Map<String, dynamic>> _filteredCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final lang = ref.read(languageProvider);
    final categories = await LegalContentService.getCategories(lang: lang);
    if (mounted) {
      setState(() {
        _allCategories = categories;
        _filteredCategories = categories;
        _isLoading = false;
      });
    }
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = _allCategories;
      } else {
        _filteredCategories = _allCategories.where((category) {
          final title = category['title'].toString().toLowerCase();
          // Also search within topic titles
          final topics = category['topics'] as List? ?? [];
          final topicMatch = topics.any((t) =>
              (t['title'] as String? ?? '').toLowerCase().contains(query.toLowerCase()));
          return title.contains(query.toLowerCase()) || topicMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          currentLang == 'hi' ? 'अपने अधिकार जानें' : 'Learn Your Rights',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: -0.5),
        ),
        actions: [
          PopupMenuButton<String>(
            initialValue: currentLang == 'hi' ? 'Hindi' : 'English',
            onSelected: (value) {
              final lang = value == 'Hindi' ? 'hi' : 'en';
              ref.read(languageProvider.notifier).setLanguage(lang);
              _loadContent(); // reload with new language
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceDim,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language, size: 16, color: AppColors.textPrimary),
                  const SizedBox(width: 4),
                  Text(
                    currentLang == 'hi' ? 'हिंदी' : 'English',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'English', child: Text('English')),
              const PopupMenuItem(value: 'Hindi', child: Text('हिंदी')),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCategories,
              decoration: InputDecoration(
                hintText: currentLang == 'hi' ? 'कानून, अधिकार खोजें...' : 'Search laws, rights, categories...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCategories.isEmpty
                    ? Center(child: Text(currentLang == 'hi' ? 'कोई श्रेणी नहीं मिली' : 'No categories found.', style: const TextStyle(color: AppColors.textSecondary)))
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = _filteredCategories[index];
                          final color = category['color'] as Color;
                          final topicsCount = (category['topics'] as List).length;

                          return GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TopicsListScreen(category: category))),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
                                    child: Icon(category['icon'] as IconData, color: color, size: 28),
                                  ),
                                  const Spacer(),
                                  Text(
                                    category['title'] as String,
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.2),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.menu_book_rounded, size: 14, color: color),
                                      const SizedBox(width: 6),
                                      Text('$topicsCount topics', style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

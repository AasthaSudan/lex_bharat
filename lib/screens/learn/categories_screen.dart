import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/sample_data.dart';
import 'topics_list_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allCategories = [];
  List<Map<String, dynamic>> _filteredCategories = [];
  String _currentLang = 'English';

  @override
  void initState() {
    super.initState();
    _allCategories = SampleData.getLegalCategories();
    _filteredCategories = _allCategories;
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = _allCategories;
      } else {
        _filteredCategories = _allCategories.where((category) {
          final title = category['title'].toString().toLowerCase();
          return title.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Learn Your Rights', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: -0.5)),
        actions: [
          PopupMenuButton<String>(
            initialValue: _currentLang,
            onSelected: (value) {
              setState(() {
                _currentLang = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Language changed to $value')));
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
                  Text(_currentLang, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                ],
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'English', child: Text('English')),
              const PopupMenuItem(value: 'Hindi', child: Text('Hindi')),
              const PopupMenuItem(value: 'Marathi', child: Text('Marathi')),
              const PopupMenuItem(value: 'Tamil', child: Text('Tamil')),
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
                hintText: 'Search laws, rights, categories...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredCategories.isEmpty
                ? const Center(child: Text("No categories found.", style: TextStyle(color: AppColors.textSecondary)))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => TopicsListScreen(category: category)));
                        },
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
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(category['icon'] as IconData, color: color, size: 28),
                              ),
                              const Spacer(),
                              Text(
                                category['title'] as String,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.2),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.menu_book_rounded, size: 14, color: color),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$topicsCount topics',
                                    style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600),
                                  ),
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

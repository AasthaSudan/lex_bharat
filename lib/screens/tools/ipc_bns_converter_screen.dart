import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/sample_data.dart';

class IPCBNSConverterScreen extends StatefulWidget {
  const IPCBNSConverterScreen({super.key});

  @override
  State<IPCBNSConverterScreen> createState() => _IPCBNSConverterScreenState();
}

class _IPCBNSConverterScreenState extends State<IPCBNSConverterScreen> {
  List<Map<String, dynamic>> _allMappings = [];
  List<Map<String, dynamic>> _filtered = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _searchByIPC = true; // toggle between IPC→BNS and BNS→IPC

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await LegalContentService.getIPCBNSMappings();
    if (mounted) {
      setState(() {
        _allMappings = data;
        _filtered = data;
        _isLoading = false;
      });
    }
  }

  void _filter(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = _allMappings;
      } else {
        _filtered = _allMappings.where((m) {
          final q = query.toLowerCase();
          final ipc = (m['ipc'] ?? '').toString().toLowerCase();
          final bns = (m['bns'] ?? '').toString().toLowerCase();
          final title = (m['title'] ?? '').toString().toLowerCase();
          final titleHi = (m['title_hi'] ?? '').toString().toLowerCase();
          return ipc.contains(q) || bns.contains(q) || title.contains(q) || titleHi.contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: AppColors.textPrimary,
        ),
        title: const Text('IPC ↔ BNS Converter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textPrimary, letterSpacing: -0.5)),
      ),
      body: Column(
        children: [
          // Search + Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: _searchByIPC ? 'Search IPC section (e.g. 302, 420)...' : 'Search BNS section (e.g. 103, 318)...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
              ),
            ),
          ),

          // Toggle IPC/BNS direction
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _searchByIPC = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _searchByIPC ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _searchByIPC ? AppColors.primary : AppColors.gray300),
                      ),
                      alignment: Alignment.center,
                      child: Text('IPC → BNS', style: TextStyle(fontWeight: FontWeight.bold, color: _searchByIPC ? Colors.white : AppColors.textSecondary)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _searchByIPC = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_searchByIPC ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: !_searchByIPC ? AppColors.primary : AppColors.gray300),
                      ),
                      alignment: Alignment.center,
                      child: Text('BNS → IPC', style: TextStyle(fontWeight: FontWeight.bold, color: !_searchByIPC ? Colors.white : AppColors.textSecondary)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.info, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'BNS (Bharatiya Nyaya Sanhita) replaced IPC from 1 July 2024',
                    style: TextStyle(fontSize: 13, color: AppColors.info, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Text('${_filtered.length} sections found', style: const TextStyle(fontSize: 13, color: AppColors.textHint, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          // Results list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                    ? const Center(child: Text('No matching sections found', style: TextStyle(color: AppColors.textSecondary)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final m = _filtered[index];
                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // IPC badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text('IPC ${m['ipc']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.error)),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Icon(Icons.arrow_forward_rounded, size: 20, color: AppColors.textHint),
                                    ),
                                    // BNS badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text('BNS ${m['bns']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.accent)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(m['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                if (m['title_hi'] != null) ...[
                                  const SizedBox(height: 4),
                                  Text(m['title_hi'], style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                                ],
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(8)),
                                  child: Text(m['category'] ?? '', style: const TextStyle(fontSize: 12, color: AppColors.textHint, fontWeight: FontWeight.w600)),
                                ),
                              ],
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

import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class CaseStatusTrackerScreen extends StatefulWidget {
  const CaseStatusTrackerScreen({super.key});

  @override
  State<CaseStatusTrackerScreen> createState() => _CaseStatusTrackerScreenState();
}

class _CaseStatusTrackerScreenState extends State<CaseStatusTrackerScreen> {
  final TextEditingController _cnrController = TextEditingController();
  final TextEditingController _caseTypeController = TextEditingController();
  final TextEditingController _caseNoController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  
  bool _isLoading = false;
  bool _searchByCNR = true; // Toggle between CNR and Case Number search
  Map<String, dynamic>? _caseResult;
  String? _error;

  void _searchCase() async {
    // Basic validation
    if (_searchByCNR) {
      final cnr = _cnrController.text.trim();
      if (cnr.isEmpty || cnr.length < 16) {
        setState(() => _error = 'Please enter a valid 16-digit CNR number');
        return;
      }
    } else {
      if (_caseTypeController.text.isEmpty || _caseNoController.text.isEmpty || _yearController.text.isEmpty) {
        setState(() => _error = 'Please fill all case details');
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _caseResult = null;
    });

    // Simulate network delay for scraping/API integration
    await Future.delayed(const Duration(seconds: 2));

    // For production, this would be an API call to an eCourts scraper or dataset
    if (mounted) {
      if (_cnrController.text.startsWith('DL')) {
        setState(() {
          _isLoading = false;
          _caseResult = {
            'cnr': _searchByCNR ? _cnrController.text.toUpperCase() : 'DLCT010045612023',
            'status': 'Pending',
            'court': 'District Court, Tis Hazari',
            'judge': 'Hon\'ble Mr. Amit Sharma',
            'filing_date': '12-05-2023',
            'registration_date': '15-05-2023',
            'petitioner': 'Ramesh Kumar',
            'respondent': 'State of NCT Delhi',
            'next_hearing': '24-10-2026',
            'stage': 'Evidence',
          };
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = 'No case found. Make sure the CNR number is correct (eCourts data mock only supports DL...)';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Case Status Tracker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -0.5)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: AppColors.textPrimary,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Track eCourts Cases', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text(
                    'Instantly fetch District, High Court, and Tribunal case statuses. Turn on notifications for hearing date alerts.',
                    style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  
                  // Search Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() { _searchByCNR = true; _error = null; }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _searchByCNR ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text('CNR Number', style: TextStyle(fontWeight: FontWeight.bold, color: _searchByCNR ? AppColors.primary : Colors.white)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() { _searchByCNR = false; _error = null; }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !_searchByCNR ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text('Case Details', style: TextStyle(fontWeight: FontWeight.bold, color: !_searchByCNR ? AppColors.primary : Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_searchByCNR) ...[
                    const Text('CNR Number', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _cnrController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'e.g. DLCT010045612023',
                        prefixIcon: const Icon(Icons.numbers_rounded, color: AppColors.textHint),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.gray200)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('16-digit alphanumeric code assigned to every case.', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                  ] else ...[
                    // Case Details Form
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Case Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _caseTypeController,
                                decoration: InputDecoration(
                                  hintText: 'e.g. CRR',
                                  filled: true,
                                  fillColor: AppColors.surface,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.gray200)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Case No.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _caseNoController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '1234',
                                  filled: true,
                                  fillColor: AppColors.surface,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.gray200)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Year', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _yearController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '2023',
                                  filled: true,
                                  fillColor: AppColors.surface,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.gray200)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: AppColors.error),
                          const SizedBox(width: 12),
                          Expanded(child: Text(_error!, style: const TextStyle(fontSize: 13, color: AppColors.error, fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _searchCase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isLoading 
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Search Case', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),

                  if (_caseResult != null) ...[
                    const SizedBox(height: 32),
                    const Text('Case Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: AppColors.cardShadow,
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.successLight.withValues(alpha: 0.5),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                              border: Border(bottom: BorderSide(color: AppColors.gray200)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), shape: BoxShape.circle),
                                  child: const Icon(Icons.gavel_rounded, color: AppColors.success, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_caseResult!['court'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                                      const SizedBox(height: 4),
                                      Text('CNR: ${_caseResult!['cnr']}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.warning)),
                                  child: Text(_caseResult!['status'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.warning)),
                                )
                              ],
                            ),
                          ),
                          // Details
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                _buildDetailRow('Petitioner', _caseResult!['petitioner']),
                                _buildDivider(),
                                _buildDetailRow('Respondent', _caseResult!['respondent']),
                                _buildDivider(),
                                _buildDetailRow('Judge', _caseResult!['judge']),
                                _buildDivider(),
                                _buildDetailRow('Filing Date', _caseResult!['filing_date']),
                                _buildDivider(),
                                _buildDetailRow('Stage', _caseResult!['stage']),
                                _buildDivider(),
                                _buildDetailRow('Next Hearing', _caseResult!['next_hearing'], isHighlight: true),
                              ],
                            ),
                          ),
                          // Notification button
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifications enabled for this case')));
                              },
                              icon: const Icon(Icons.notifications_active_rounded, size: 18),
                              label: const Text('Alert me on next hearing'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.accent,
                                side: const BorderSide(color: AppColors.accent),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(
              value, 
              style: TextStyle(
                fontSize: 14, 
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600, 
                color: isHighlight ? AppColors.primary : AppColors.textPrimary
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Divider(color: AppColors.gray200, height: 1),
    );
  }
}

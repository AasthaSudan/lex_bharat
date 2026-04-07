import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class BailEligibilityCheckerScreen extends StatefulWidget {
  const BailEligibilityCheckerScreen({super.key});

  @override
  State<BailEligibilityCheckerScreen> createState() => _BailEligibilityCheckerScreenState();
}

class _BailEligibilityCheckerScreenState extends State<BailEligibilityCheckerScreen> {
  int _currentStep = 0;
  
  String? _offenceType; // bailable, non_bailable, unknown
  String? _punishmentYears; // <7, 7-10, >10, death
  String? _timeSpent; // <half, >half
  bool _isFirstTimeOffender = true;
  bool _isWomenOrSick = false;

  bool _showResult = false;

  void _calculateEligibility() {
    setState(() {
      _showResult = true;
    });
  }

  void _reset() {
    setState(() {
      _currentStep = 0;
      _offenceType = null;
      _punishmentYears = null;
      _timeSpent = null;
      _isFirstTimeOffender = true;
      _isWomenOrSick = false;
      _showResult = false;
    });
  }

  Widget _buildStepIndication() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentStep == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentStep == index ? AppColors.accent : AppColors.gray300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bail Eligibility Checker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -0.5)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: AppColors.textPrimary,
        ),
      ),
      body: _showResult ? _buildResult() : _buildWizard(),
    );
  }

  Widget _buildWizard() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          color: AppColors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Evaluate Your Bail Rights', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text('Answer a few questions about the case to see if you are eligible for regular or default bail under BNSS.', style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4)),
              const SizedBox(height: 24),
              _buildStepIndication(),
            ],
          ),
        ),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _getStepContent(),
          ),
        ),

        // Bottom Navigation
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
          ),
          child: Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _currentStep--),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
              else
                const Spacer(),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _canProceed() ? () {
                    if (_currentStep < 3) {
                      setState(() => _currentStep++);
                    } else {
                      _calculateEligibility();
                    }
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(_currentStep < 3 ? 'Next' : 'Check Eligibility', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0: return _offenceType != null;
      case 1: return _punishmentYears != null;
      case 2: return _timeSpent != null;
      case 3: return true;
      default: return false;
    }
  }

  Widget _getStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildOptionsStep(
          'What type of offence is registered?',
          [
            {'label': 'Bailable Offence', 'value': 'bailable', 'desc': 'E.g., Simple hurt, defamation'},
            {'label': 'Non-Bailable Offence', 'value': 'non_bailable', 'desc': 'E.g., Murder, kidnapping, serious fraud'},
            {'label': 'I don\'t know', 'value': 'unknown', 'desc': 'We\'ll ascertain based on punishment'},
          ],
          _offenceType,
          (val) => setState(() => _offenceType = val),
        );
      case 1:
        return _buildOptionsStep(
          'What is the maximum punishment for this offence?',
          [
            {'label': 'Less than 7 years', 'value': '<7'},
            {'label': '7 to 10 years', 'value': '7-10'},
            {'label': 'More than 10 years / Life', 'value': '>10'},
            {'label': 'Death Penalty', 'value': 'death'},
          ],
          _punishmentYears,
          (val) => setState(() => _punishmentYears = val),
        );
      case 2:
        return _buildOptionsStep(
          'How much time has the accused already spent in pre-trial detention?',
          [
            {'label': 'Just arrested / Less than 60 days', 'value': '<60d'},
            {'label': 'More than 60/90 days (Chargesheet not filed)', 'value': 'default_bail'},
            {'label': 'More than half the maximum sentence', 'value': '>half'},
            {'label': 'Less than half the maximum sentence', 'value': '<half'},
          ],
          _timeSpent,
          (val) => setState(() => _timeSpent = val),
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Accused Profile (Optional)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 24),
            _buildToggle('Is this a first-time offence?', _isFirstTimeOffender, (v) => setState(() => _isFirstTimeOffender = v)),
            const SizedBox(height: 16),
            _buildToggle('Is the accused a woman, minor (under 18), or seriously ill?', _isWomenOrSick, (v) => setState(() => _isWomenOrSick = v)),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildToggle(String label, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
      ),
      child: SwitchListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        value: value,
        activeColor: AppColors.primary,
        onChanged: onChanged,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildOptionsStep(String question, List<Map<String, String>> options, String? groupValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.3)),
        const SizedBox(height: 24),
        ...options.map((opt) {
          final isSelected = groupValue == opt['value'];
          return GestureDetector(
            onTap: () => onChanged(opt['value']!),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent.withValues(alpha: 0.1) : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? AppColors.accent : AppColors.gray200, width: isSelected ? 2 : 1),
              ),
              child: Row(
                children: [
                  Radio<String>(
                    value: opt['value']!,
                    groupValue: groupValue,
                    activeColor: AppColors.accent,
                    onChanged: (v) => onChanged(v!),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(opt['label']!, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, color: AppColors.textPrimary)),
                        if (opt['desc'] != null) ...[
                          const SizedBox(height: 4),
                          Text(opt['desc']!, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildResult() {
    // Basic rules simulation
    String status = "Consult Lawyer";
    String title = "Moderate Chance of Bail";
    Color resultColor = AppColors.warning;
    IconData resultIcon = Icons.balance_rounded;
    List<String> reasons = [];

    if (_offenceType == 'bailable') {
      status = "Bail is a Right";
      title = "High Chance — Claim as of Right";
      resultColor = AppColors.success;
      resultIcon = Icons.check_circle_rounded;
      reasons.add("For bailable offences, police or court MUST grant bail (Section 478 BNSS).");
    } else if (_timeSpent == 'default_bail') {
      status = "Default Bail Right";
      title = "Statutory Right Activated";
      resultColor = AppColors.success;
      resultIcon = Icons.hourglass_bottom_rounded;
      reasons.add("If chargesheet is not filed within 60/90 days, you get bail as a right (Section 187 BNSS).");
    } else if (_timeSpent == '>half') {
      status = "Under-Trial Relief";
      title = "Eligible under Under-trial laws";
      resultColor = AppColors.success;
      resultIcon = Icons.lock_open_rounded;
      reasons.add("Accused has spent > half the maximum sentence in detention (Section 481 BNSS).");
    } else {
      if (_punishmentYears == 'death' || _punishmentYears == '>10') {
        status = "Bail Unlikely / Difficult";
        title = "Court Discretion Required";
        resultColor = AppColors.error;
        resultIcon = Icons.warning_rounded;
        reasons.add("Offence carries severe punishment. Bail requires proving exceptional circumstances to the High Court/Session Court.");
      } else {
        reasons.add("Bail is subject to Magistrate's discretion (Section 480 BNSS).");
      }
    }

    if (_isWomenOrSick && status != "Bail is a Right" && status != "Default Bail Right") {
      reasons.add("Special Provision: Being a woman, minor, or sick person gives strong grounds for bail even in non-bailable offences.");
      if (resultColor == AppColors.error) {
        resultColor = AppColors.warning;
        status = "Stronger Consideration";
      }
    }
    
    if (_isFirstTimeOffender && status == "Consult Lawyer") {
      reasons.add("Favorable ground: First-time offenders are generally viewed favorably by courts.");
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: resultColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: resultColor.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Icon(resultIcon, color: resultColor, size: 64),
                const SizedBox(height: 16),
                Text(status, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: resultColor)),
                const SizedBox(height: 8),
                Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          const Text('Legal Grounds & Reasoning', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          
          ...reasons.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.label_important_rounded, size: 20, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(r, style: const TextStyle(fontSize: 15, height: 1.4, color: AppColors.textSecondary))),
              ],
            ),
          )),

          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surfaceDim, borderRadius: BorderRadius.circular(16)),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.textHint),
                SizedBox(width: 12),
                Expanded(child: Text('Disclaimer: This is an AI-driven estimate based on BNSS provisions, not absolute legal advice.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
              ],
            ),
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _reset,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Check Another Case', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

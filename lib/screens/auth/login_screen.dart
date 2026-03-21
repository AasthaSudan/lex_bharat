// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../providers/auth_provider.dart';
// import '../../utils/colors.dart';
// import 'otp_screen.dart';
//
// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final _phoneController = TextEditingController();
//   bool _isLoading = false;
//   bool _isGoogleLoading = false;
//   String? _error;
//
//   @override
//   void dispose() {
//     _phoneController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _sendOtp() async {
//     final phone = _phoneController.text.trim();
//     if (phone.length < 10) {
//       setState(() => _error = 'Enter a valid phone number');
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });
//
//     try {
//       final formatted = phone.startsWith('+') ? phone : '+91$phone';
//       await ref.read(authProvider.notifier).sendOtp(formatted);
//
//       if (!mounted) return;
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => OtpScreen(phone: formatted),
//         ),
//       );
//     } catch (e) {
//       setState(() => _error = 'Failed to send OTP. Try again.');
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _googleSignIn() async {
//     setState(() {
//       _isGoogleLoading = true;
//       _error = null;
//     });
//
//     try {
//       await ref.read(authProvider.notifier).signInWithGoogle();
//     } catch (e) {
//       setState(() => _error = 'Google sign-in failed. Try again.');
//     } finally {
//       if (mounted) setState(() => _isGoogleLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 48),
//
//               // Logo
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   gradient: AppColors.primaryGradient,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.primary.withValues(alpha: 0.3),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.gavel_rounded,
//                   color: Colors.white,
//                   size: 32,
//                 ),
//               ),
//
//               const SizedBox(height: 32),
//
//               // Title
//               const Text(
//                 'Welcome to\nLex Bharat',
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                   letterSpacing: -0.5,
//                   height: 1.2,
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               const Text(
//                 'Your legal rights, in your language',
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//
//               const SizedBox(height: 48),
//
//               // Phone field label
//               const Text(
//                 'Phone number',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               // Phone input
//               TextField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 maxLength: 13,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: AppColors.textPrimary,
//                 ),
//                 decoration: InputDecoration(
//                   counterText: '',
//                   hintText: '98765 43210',
//                   prefixIcon: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 14,
//                       vertical: 16,
//                     ),
//                     child: const Text(
//                       '🇮🇳 +91',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                   ),
//                   prefixIconConstraints: const BoxConstraints(),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: const BorderSide(color: AppColors.gray300),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: const BorderSide(color: AppColors.gray300),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide:
//                     const BorderSide(color: AppColors.primary, width: 2),
//                   ),
//                   filled: true,
//                   fillColor: AppColors.gray50,
//                 ),
//                 onSubmitted: (_) => _sendOtp(),
//               ),
//
//               // Error
//               if (_error != null) ...[
//                 const SizedBox(height: 10),
//                 Text(
//                   _error!,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: AppColors.error,
//                   ),
//                 ),
//               ],
//
//               const SizedBox(height: 20),
//
//               // Send OTP button
//               SizedBox(
//                 width: double.infinity,
//                 height: 54,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _sendOtp,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                     width: 22,
//                     height: 22,
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2.5,
//                     ),
//                   )
//                       : const Text(
//                     'Send OTP',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               // Divider
//               Row(
//                 children: [
//                   Expanded(
//                     child: Divider(color: AppColors.gray200, thickness: 1),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       'or',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: AppColors.textHint,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Divider(color: AppColors.gray200, thickness: 1),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 24),
//
//               // Google button
//               SizedBox(
//                 width: double.infinity,
//                 height: 54,
//                 child: OutlinedButton(
//                   onPressed: _isGoogleLoading ? null : _googleSignIn,
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: AppColors.gray300),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                   ),
//                   child: _isGoogleLoading
//                       ? const SizedBox(
//                     width: 22,
//                     height: 22,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2.5,
//                     ),
//                   )
//                       : Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Google G logo in SVG-like shape
//                       Container(
//                         width: 22,
//                         height: 22,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             'G',
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF4285F4),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text(
//                         'Continue with Google',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 40),
//
//               // Disclaimer
//               Center(
//                 child: Text(
//                   'By continuing, you agree to our Terms of Service.\nThis app provides legal information, not legal advice.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: AppColors.textHint,
//                     height: 1.5,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../providers/auth_provider.dart';
// import '../../utils/colors.dart';
//
// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   bool _isLoading = false;
//   String? _error;
//
//   Future<void> _googleSignIn() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });
//
//     try {
//       await ref.read(authProvider.notifier).signInWithGoogle();
//     } catch (e) {
//       setState(() => _error = 'Sign-in failed. Try again.');
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             children: [
//               const Spacer(),
//
//               // Logo
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   gradient: AppColors.primaryGradient,
//                   borderRadius: BorderRadius.circular(22),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.primary.withValues(alpha: 0.3),
//                       blurRadius: 16,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.gavel_rounded,
//                   color: Colors.white,
//                   size: 42,
//                 ),
//               ),
//
//               const SizedBox(height: 32),
//
//               const Text(
//                 'Welcome to\nLex Bharat',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                   letterSpacing: -0.5,
//                   height: 1.2,
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               const Text(
//                 'Your legal rights, in your language',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//
//               const Spacer(),
//
//               // Feature pills
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 alignment: WrapAlignment.center,
//                 children: const [
//                   _FeaturePill(icon: Icons.mic_rounded, label: 'Voice-first'),
//                   _FeaturePill(icon: Icons.gavel_rounded, label: 'Legal Q&A'),
//                   _FeaturePill(icon: Icons.description_rounded, label: 'Forms'),
//                   _FeaturePill(
//                       icon: Icons.location_on_rounded, label: 'Find aid'),
//                 ],
//               ),
//
//               const SizedBox(height: 48),
//
//               // Error
//               if (_error != null) ...[
//                 Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: AppColors.errorLight,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.error_outline,
//                           color: AppColors.error, size: 18),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           _error!,
//                           style: const TextStyle(
//                               fontSize: 13, color: AppColors.error),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//
//               // Google button
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: OutlinedButton(
//                   onPressed: _isLoading ? null : _googleSignIn,
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: AppColors.gray300, width: 1),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     backgroundColor: Colors.white,
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                     width: 22,
//                     height: 22,
//                     child: CircularProgressIndicator(strokeWidth: 2.5),
//                   )
//                       : Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Google G icon
//                       Container(
//                         width: 24,
//                         height: 24,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: const Text(
//                           'G',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF4285F4),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text(
//                         'Continue with Google',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Disclaimer
//               const Text(
//                 'This app provides legal information, not legal advice.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: AppColors.textHint,
//                 ),
//               ),
//
//               const SizedBox(height: 32),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _FeaturePill extends StatelessWidget {
//   final IconData icon;
//   final String label;
//
//   const _FeaturePill({required this.icon, required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: AppColors.gray100,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppColors.gray200),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 15, color: AppColors.primary),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: AppColors.textPrimary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
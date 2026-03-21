// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../providers/auth_provider.dart';
// import '../../utils/colors.dart';
// import '../home/home_screen.dart';
//
// class OtpScreen extends ConsumerStatefulWidget {
//   final String phone;
//
//   const OtpScreen({super.key, required this.phone});
//
//   @override
//   ConsumerState<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends ConsumerState<OtpScreen> {
//   final List<TextEditingController> _controllers =
//   List.generate(6, (_) => TextEditingController());
//   final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
//
//   bool _isLoading = false;
//   bool _isResending = false;
//   String? _error;
//   int _resendSeconds = 30;
//
//   @override
//   void initState() {
//     super.initState();
//     _startResendTimer();
//   }
//
//   @override
//   void dispose() {
//     for (final c in _controllers) {
//       c.dispose();
//     }
//     for (final f in _focusNodes) {
//       f.dispose();
//     }
//     super.dispose();
//   }
//
//   void _startResendTimer() {
//     Future.doWhile(() async {
//       await Future.delayed(const Duration(seconds: 1));
//       if (!mounted) return false;
//       setState(() => _resendSeconds--);
//       return _resendSeconds > 0;
//     });
//   }
//
//   String get _otp => _controllers.map((c) => c.text).join();
//
//   void _onDigitEntered(int index, String value) {
//     if (value.length == 1 && index < 5) {
//       _focusNodes[index + 1].requestFocus();
//     }
//     if (value.isEmpty && index > 0) {
//       _focusNodes[index - 1].requestFocus();
//     }
//     // Auto-verify when all 6 digits entered
//     if (_otp.length == 6) _verifyOtp();
//   }
//
//   Future<void> _verifyOtp() async {
//     if (_otp.length < 6) {
//       setState(() => _error = 'Enter the 6-digit OTP');
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });
//
//     try {
//       await ref.read(authProvider.notifier).verifyOtp(widget.phone, _otp);
//
//       if (!mounted) return;
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//             (route) => false,
//       );
//     } catch (e) {
//       setState(() => _error = 'Invalid OTP. Please try again.');
//       // Clear fields on error
//       for (final c in _controllers) {
//         c.clear();
//       }
//       _focusNodes[0].requestFocus();
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _resendOtp() async {
//     setState(() {
//       _isResending = true;
//       _error = null;
//       _resendSeconds = 30;
//     });
//
//     try {
//       await ref.read(authProvider.notifier).sendOtp(widget.phone);
//       _startResendTimer();
//     } catch (e) {
//       setState(() => _error = 'Failed to resend OTP.');
//     } finally {
//       if (mounted) setState(() => _isResending = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             size: 20,
//             color: AppColors.textPrimary,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 16),
//
//               const Text(
//                 'Verify your number',
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                   letterSpacing: -0.5,
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               RichText(
//                 text: TextSpan(
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: AppColors.textSecondary,
//                     height: 1.5,
//                   ),
//                   children: [
//                     const TextSpan(text: 'We sent a 6-digit OTP to\n'),
//                     TextSpan(
//                       text: widget.phone,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 40),
//
//               // OTP boxes
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(6, (index) {
//                   return SizedBox(
//                     width: 48,
//                     height: 56,
//                     child: TextField(
//                       controller: _controllers[index],
//                       focusNode: _focusNodes[index],
//                       textAlign: TextAlign.center,
//                       keyboardType: TextInputType.number,
//                       maxLength: 1,
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary,
//                       ),
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                       ],
//                       decoration: InputDecoration(
//                         counterText: '',
//                         filled: true,
//                         fillColor: _controllers[index].text.isNotEmpty
//                             ? AppColors.primary.withValues(alpha: 0.06)
//                             : AppColors.gray50,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide:
//                           const BorderSide(color: AppColors.gray300),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide:
//                           const BorderSide(color: AppColors.gray300),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                             color: AppColors.primary,
//                             width: 2,
//                           ),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         setState(() {});
//                         _onDigitEntered(index, value);
//                       },
//                     ),
//                   );
//                 }),
//               ),
//
//               // Error
//               if (_error != null) ...[
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.error_outline,
//                       size: 16,
//                       color: AppColors.error,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       _error!,
//                       style: const TextStyle(
//                         fontSize: 13,
//                         color: AppColors.error,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//
//               const SizedBox(height: 32),
//
//               // Verify button
//               SizedBox(
//                 width: double.infinity,
//                 height: 54,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _verifyOtp,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     disabledBackgroundColor: AppColors.gray200,
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
//                     'Verify OTP',
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
//               // Resend
//               Center(
//                 child: _resendSeconds > 0
//                     ? Text(
//                   'Resend OTP in $_resendSeconds s',
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: AppColors.textHint,
//                   ),
//                 )
//                     : TextButton(
//                   onPressed: _isResending ? null : _resendOtp,
//                   child: _isResending
//                       ? const SizedBox(
//                     width: 16,
//                     height: 16,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                     ),
//                   )
//                       : const Text(
//                     'Resend OTP',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
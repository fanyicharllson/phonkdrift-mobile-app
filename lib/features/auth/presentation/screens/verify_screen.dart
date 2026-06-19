import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/auth.pb.dart';
import '../../../../core/network/grpc_client.dart';
import '../../../../core/utils/error_helper.dart';
import '../../../../core/widgets/phonk_button.dart';
import '../../../../core/widgets/phonk_error_banner.dart';
import 'verify_success_screen.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key, required this.email});
  final String email;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _pinCtrl = TextEditingController();
  final _pinFocus = FocusNode();

  bool _isLoading = false;
  bool _isResending = false;
  String _errorMessage = '';
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  void dispose() {
    _pinCtrl.dispose();
    _pinFocus.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _resendCooldown = 60;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _resendCooldown--);
      if (_resendCooldown <= 0) t.cancel();
    });
  }

  void _setError(String msg) {
    if (!mounted) return;
    setState(() { _errorMessage = msg; _isLoading = false; });
  }

  Future<void> _verify(String code) async {
    if (code.length < 6) return;
    setState(() { _isLoading = true; _errorMessage = ''; });
    HapticFeedback.lightImpact();

    try {
      final res = await PhonkGrpcClient.instance.auth.verifyCode(
        VerifyRequest(email: widget.email, code: code),
      );

      if (!mounted) return;

      if (res.success) {
        HapticFeedback.mediumImpact();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => VerifySuccessScreen(
              userId: res.userId,
              token: res.token,
            ),
          ),
        );
      } else {
        _pinCtrl.clear();
        _setError(res.message.isNotEmpty
            ? res.message
            : 'Incorrect code. Check your email and try again.');
      }
    } catch (e) {
      _pinCtrl.clear();
      _setError(ErrorHelper.fromException(e, ctx: ErrorContext.verify));
    }
  }

  Future<void> _resend() async {
    if (_resendCooldown > 0 || _isResending) return;
    setState(() { _isResending = true; _errorMessage = ''; });

    try {
      final res = await PhonkGrpcClient.instance.auth.resendCode(
        ResendCodeRequest(email: widget.email),
      );
      if (!mounted) return;
      setState(() => _isResending = false);

      if (res.success) {
        _pinCtrl.clear();
        _startCooldown();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('A new code has been sent to your email.',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      } else {
        _setError('Could not resend the code. Try again shortly.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isResending = false);
      _setError(ErrorHelper.fromException(e, ctx: ErrorContext.verify));
    }
  }

  PinTheme get _defaultPinTheme => PinTheme(
        width: 52,
        height: 58,
        textStyle: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSubtle, width: 1.5),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        backgroundColor: AppColors.bgDeep,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Check your\nemail.',
                  style: GoogleFonts.inter(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -1.3,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
                    children: [
                      const TextSpan(text: 'We sent a 6-digit code to '),
                      TextSpan(
                        text: widget.email,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: '. It expires in 15 minutes.'),
                    ],
                  ),
                ),
                const SizedBox(height: 44),

                // PIN
                Center(
                  child: Pinput(
                    controller: _pinCtrl,
                    focusNode: _pinFocus,
                    length: 6,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    defaultPinTheme: _defaultPinTheme,
                    focusedPinTheme: _defaultPinTheme.copyWith(
                      decoration: _defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: AppColors.phonkRed, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.phonkRed.withValues(alpha: 0.18),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                    submittedPinTheme: _defaultPinTheme.copyWith(
                      decoration: _defaultPinTheme.decoration!.copyWith(
                        color: AppColors.bgElevated,
                        border: Border.all(
                          color: AppColors.phonkRed.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                    ),
                    errorPinTheme: _defaultPinTheme.copyWith(
                      decoration: _defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: AppColors.error, width: 2),
                        color: AppColors.phonkRed.withValues(alpha: 0.06),
                      ),
                    ),
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: _verify,
                    enabled: !_isLoading,
                  ),
                ),

                const SizedBox(height: 32),

                PhonkErrorBanner(
                  message: _errorMessage,
                  onDismiss: () => setState(() => _errorMessage = ''),
                ),
                if (_errorMessage.isNotEmpty) const SizedBox(height: 16),

                PhonkButton(
                  label: 'Verify Code',
                  onPressed: _isLoading ? null : () => _verify(_pinCtrl.text),
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 28),

                Center(
                  child: _isResending
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.phonkRed,
                          ),
                        )
                      : _resendCooldown > 0
                          ? RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                    fontSize: 14, color: AppColors.textMuted),
                                children: [
                                  const TextSpan(text: 'Resend code in '),
                                  TextSpan(
                                    text: '${_resendCooldown}s',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: _resend,
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: AppColors.textSecondary),
                                  children: [
                                    const TextSpan(text: "Didn't get it? "),
                                    const TextSpan(
                                      text: 'Resend code',
                                      style: TextStyle(
                                        color: AppColors.phonkRed,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

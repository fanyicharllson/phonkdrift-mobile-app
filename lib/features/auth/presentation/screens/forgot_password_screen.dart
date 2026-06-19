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
import 'login_screen.dart';

enum _ForgotStep { email, code, newPassword }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  _ForgotStep _step = _ForgotStep.email;

  final _emailCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String _errorMessage = '';
  String _submittedEmail = '';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pinCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _setError(String msg) {
    if (!mounted) return;
    setState(() { _errorMessage = msg; _isLoading = false; });
  }

  void _clearError() {
    if (_errorMessage.isNotEmpty) setState(() => _errorMessage = '');
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() { _isLoading = true; _errorMessage = ''; });

    try {
      await PhonkGrpcClient.instance.auth.forgotPassword(
        ForgotPasswordRequest(email: _emailCtrl.text.trim()),
      );
      if (!mounted) return;
      _submittedEmail = _emailCtrl.text.trim();
      setState(() { _isLoading = false; _step = _ForgotStep.code; });
    } catch (e) {
      _setError(ErrorHelper.fromException(e, ctx: ErrorContext.resetPassword));
    }
  }

  Future<void> _verifyCode(String code) async {
    if (code.length < 6) return;
    setState(() { _isLoading = true; _errorMessage = ''; });
    HapticFeedback.lightImpact();

    try {
      final res = await PhonkGrpcClient.instance.auth.verifyResetCode(
        VerifyResetCodeRequest(email: _submittedEmail, code: code),
      );
      if (!mounted) return;

      if (res.success) {
        HapticFeedback.mediumImpact();
        setState(() { _isLoading = false; _step = _ForgotStep.newPassword; });
      } else {
        _pinCtrl.clear();
        _setError('Incorrect code. Check your email and try again.');
      }
    } catch (e) {
      _pinCtrl.clear();
      _setError(ErrorHelper.fromException(e, ctx: ErrorContext.resetPassword));
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() { _isLoading = true; _errorMessage = ''; });

    try {
      final res = await PhonkGrpcClient.instance.auth.resetPassword(
        ResetPasswordRequest(
          email: _submittedEmail,
          code: _pinCtrl.text,
          newPassword: _newPassCtrl.text,
        ),
      );

      if (!mounted) return;

      if (res.success) {
        HapticFeedback.heavyImpact();
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'Password updated. Sign in with your new password.',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        _setError(res.message.isNotEmpty
            ? res.message
            : 'Could not reset password. Try again.');
      }
    } catch (e) {
      _setError(ErrorHelper.fromException(e, ctx: ErrorContext.resetPassword));
    }
  }

  String get _stepLabel => switch (_step) {
        _ForgotStep.email => '1 of 3',
        _ForgotStep.code => '2 of 3',
        _ForgotStep.newPassword => '3 of 3',
      };

  PinTheme get _pinTheme => PinTheme(
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
          onPressed: () {
            if (_step == _ForgotStep.code) {
              setState(() { _step = _ForgotStep.email; _clearError(); });
            } else if (_step == _ForgotStep.newPassword) {
              setState(() { _step = _ForgotStep.code; _clearError(); });
            } else {
              Navigator.of(context).pop();
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                _stepLabel,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: switch (_step) {
                _ForgotStep.email => _buildEmailStep(),
                _ForgotStep.code => _buildCodeStep(),
                _ForgotStep.newPassword => _buildNewPasswordStep(),
              },
            ),
          ),
        ),
      ),
    );
  }

  // ── Step 1 ──────────────────────────────────────────────────────────────
  Widget _buildEmailStep() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('email'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Forgot your\npassword?',
              style: GoogleFonts.inter(
                fontSize: 36, fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -1.3, height: 1.08,
              )),
          const SizedBox(height: 12),
          Text(
            "No worries. Enter your registered email and we'll send you a 6-digit reset code.",
            style: GoogleFonts.inter(
                fontSize: 15, color: AppColors.textSecondary, height: 1.55),
          ),
          const SizedBox(height: 40),
          _label('Email address'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            onChanged: (_) => _clearError(),
            onFieldSubmitted: (_) => _sendCode(),
            style: GoogleFonts.inter(
                color: AppColors.textPrimary, fontSize: 15),
            decoration: const InputDecoration(
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          PhonkErrorBanner(
              message: _errorMessage,
              onDismiss: () => setState(() => _errorMessage = '')),
          if (_errorMessage.isNotEmpty) const SizedBox(height: 16),
          PhonkButton(
            label: 'Send Reset Code',
            onPressed: _isLoading ? null : _sendCode,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Step 2 ──────────────────────────────────────────────────────────────
  Widget _buildCodeStep() {
    return Column(
      key: const ValueKey('code'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text('Enter reset\ncode.',
            style: GoogleFonts.inter(
              fontSize: 36, fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -1.3, height: 1.08,
            )),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
                fontSize: 15, color: AppColors.textSecondary, height: 1.55),
            children: [
              const TextSpan(text: 'We sent a 6-digit code to '),
              TextSpan(
                text: _submittedEmail,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: '. It expires in 15 minutes.'),
            ],
          ),
        ),
        const SizedBox(height: 44),
        Center(
          child: Pinput(
            controller: _pinCtrl,
            length: 6,
            autofocus: true,
            keyboardType: TextInputType.number,
            defaultPinTheme: _pinTheme,
            focusedPinTheme: _pinTheme.copyWith(
              decoration: _pinTheme.decoration!.copyWith(
                border: Border.all(color: AppColors.phonkRed, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.phonkRed.withValues(alpha: 0.18),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
            submittedPinTheme: _pinTheme.copyWith(
              decoration: _pinTheme.decoration!.copyWith(
                color: AppColors.bgElevated,
                border: Border.all(
                  color: AppColors.phonkRed.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
            ),
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            onCompleted: _verifyCode,
            enabled: !_isLoading,
          ),
        ),
        const SizedBox(height: 32),
        PhonkErrorBanner(
            message: _errorMessage,
            onDismiss: () => setState(() => _errorMessage = '')),
        if (_errorMessage.isNotEmpty) const SizedBox(height: 16),
        PhonkButton(
          label: 'Verify Code',
          onPressed: _isLoading ? null : () => _verifyCode(_pinCtrl.text),
          isLoading: _isLoading,
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ── Step 3 ──────────────────────────────────────────────────────────────
  Widget _buildNewPasswordStep() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('newpass'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('New\npassword.',
              style: GoogleFonts.inter(
                fontSize: 36, fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -1.3, height: 1.08,
              )),
          const SizedBox(height: 12),
          Text(
            'Create a strong new password. Minimum 6 characters.',
            style: GoogleFonts.inter(
                fontSize: 15, color: AppColors.textSecondary, height: 1.55),
          ),
          const SizedBox(height: 40),
          _label('New password'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _newPassCtrl,
            obscureText: _obscureNew,
            textInputAction: TextInputAction.next,
            onChanged: (_) => _clearError(),
            style: GoogleFonts.inter(
                color: AppColors.textPrimary, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Min. 6 characters',
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
                icon: Icon(
                  _obscureNew
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'Minimum 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 20),
          _label('Confirm password'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPassCtrl,
            obscureText: _obscureConfirm,
            textInputAction: TextInputAction.done,
            onChanged: (_) => _clearError(),
            onFieldSubmitted: (_) => _resetPassword(),
            style: GoogleFonts.inter(
                color: AppColors.textPrimary, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Repeat new password',
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please confirm your password';
              if (v != _newPassCtrl.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 24),
          PhonkErrorBanner(
              message: _errorMessage,
              onDismiss: () => setState(() => _errorMessage = '')),
          if (_errorMessage.isNotEmpty) const SizedBox(height: 16),
          PhonkButton(
            label: 'Reset Password',
            onPressed: _isLoading ? null : _resetPassword,
            isLoading: _isLoading,
            icon: Icons.check_rounded,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      );
}

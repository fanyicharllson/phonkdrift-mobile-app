import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/phonk_button.dart';
import '../../../../core/widgets/phonk_error_banner.dart';
import '../../../../core/widgets/phonk_toast.dart';
import 'banned_screen.dart';
import 'register_screen.dart';
import '../../../track/presentation/screens/home_screen.dart';
import 'forgot_password_screen.dart';
import '../../../auth/data/repositories/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  void _setError(String msg) {
    if (!mounted) return;
    setState(() {
      _errorMessage = msg;
      _isLoading = false;
    });
  }

  void _clearError() {
    if (_errorMessage.isNotEmpty) setState(() => _errorMessage = '');
  }

  String _friendlyGrpcError(Object e) {
    final raw = e.toString().toLowerCase();
    if (raw.contains('unavailable') || raw.contains('connection')) {
      return 'Cannot reach the server. Check your internet connection and try again.';
    }
    if (raw.contains('deadline') || raw.contains('timeout')) {
      return 'Request timed out. The server is taking too long — try again.';
    }
    if (raw.contains('invalid') || raw.contains('not found')) {
      return 'Incorrect email or password. Please check your credentials.';
    }
    if (raw.contains('unauthenticated')) {
      return 'Session expired. Please log in again.';
    }
    // Surface the actual gRPC message if it's readable
    final msgMatch = RegExp(r'message: (.+)').firstMatch(e.toString());
    if (msgMatch != null) return msgMatch.group(1)!.trim();
    return 'Something went wrong. Please try again.';
  }

  // ── Submit ────────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    _clearError();
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      await AuthRepository.instance.login(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      BanStatus banStatus = const BanStatus(isBanned: false, reason: '');
      try {
        banStatus = await AuthRepository.instance.checkBanStatus();
      } catch (_) {
        // If the ban check fails, continue to the app and let the monitor retry.
      }

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (banStatus.isBanned) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => BannedScreen(reason: banStatus.reason),
          ),
          (_) => false,
        );
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
      PhonkToast.show(
        context,
        message: 'Logged in successfully.',
        type: ToastType.success,
      );
    } catch (e) {
      _setError(_friendlyGrpcError(e));
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  // ── Header ──────────────────────────────────────────────
                  Text(
                    'PhonkDrift',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.phonkRed,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome\nback.',
                    style: GoogleFonts.inter(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -1.4,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue drifting.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Email ───────────────────────────────────────────────
                  _FieldLabel(label: 'Email address'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    onChanged: (_) => _clearError(),
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ── Password ────────────────────────────────────────────
                  _FieldLabel(label: 'Password'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscurePass,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => _clearError(),
                    onFieldSubmitted: (_) => _submit(),
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => _obscurePass = !_obscurePass),
                        icon: Icon(
                          _obscurePass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      if (v.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  // ── Forgot password ─────────────────────────────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Error banner ────────────────────────────────────────
                  PhonkErrorBanner(
                    message: _errorMessage,
                    onDismiss: () => setState(() => _errorMessage = ''),
                  ),
                  if (_errorMessage.isNotEmpty) const SizedBox(height: 16),

                  // ── Submit ──────────────────────────────────────────────
                  PhonkButton(
                    label: 'Sign In',
                    onPressed: _isLoading ? null : _submit,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 20),

                  // ── Divider ─────────────────────────────────────────────
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: AppColors.borderSubtle),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'or',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppColors.borderSubtle),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Go to register ──────────────────────────────────────
                  PhonkButton(
                    label: 'Create an account',
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                    variant: PhonkButtonVariant.outline,
                  ),

                  const SizedBox(height: 18),
                  const _TermsText(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'By continuing with PhonkDrift, you agree to PhonkDrift',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
          GestureDetector(
            onTap: () => PhonkToast.show(
              context,
              message: 'Terms and Conditions page coming soon.',
              type: ToastType.info,
            ),
            child: Text(
              'Terms and Conditions',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
          Text(
            '.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.2,
      ),
    );
  }
}

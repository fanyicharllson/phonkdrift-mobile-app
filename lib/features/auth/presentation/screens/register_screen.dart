import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/phonk_button.dart';
import '../../../../core/widgets/phonk_error_banner.dart';
import '../../../../core/utils/storage_helper.dart';
import '../../../../core/network/grpc_client.dart';
import '../../../../core/network/generated/auth.pb.dart';
import '../../../../core/widgets/phonk_toast.dart';
import 'login_screen.dart';
import 'verify_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String _errorMessage = '';

  // Password strength
  int _passStrength = 0; // 0-3

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

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

  void _onPasswordChanged(String val) {
    _clearError();
    int strength = 0;
    if (val.length >= 8) strength++;
    if (val.contains(RegExp(r'[A-Z]'))) strength++;
    if (val.contains(RegExp(r'[0-9]'))) strength++;
    if (val.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) strength++;
    setState(() => _passStrength = strength > 3 ? 3 : strength);
  }

  String _friendlyGrpcError(Object e) {
    final raw = e.toString().toLowerCase();
    if (raw.contains('unavailable') || raw.contains('connection')) {
      return 'Cannot reach the server. Check your internet connection and try again.';
    }
    if (raw.contains('deadline') || raw.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    if (raw.contains('already exists') || raw.contains('duplicate')) {
      return 'An account with this email already exists. Try logging in instead.';
    }
    if (raw.contains('username')) {
      return 'This username is already taken. Please choose another.';
    }
    final msgMatch = RegExp(r'message: (.+)').firstMatch(e.toString());
    if (msgMatch != null) return msgMatch.group(1)!.trim();
    return 'Registration failed. Please try again.';
  }

  Future<void> _submit() async {
    _clearError();
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      await PhonkGrpcClient.instance.auth.registerUser(
        RegisterRequest(
          username: _usernameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        ),
      );

      // Save pending email for verify screen
      await StorageHelper.instance.savePendingEmail(_emailCtrl.text.trim());

      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              VerifyScreen(email: _emailCtrl.text.trim()),
        ),
      );
    } catch (e) {
      _setError(_friendlyGrpcError(e));
    }
  }

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
                    'Join the\ndrift.',
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
                    'Create your account to start drifting.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Username ────────────────────────────────────────────
                  _FieldLabel(label: 'Username'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _usernameCtrl,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    onChanged: (_) => _clearError(),
                    style: GoogleFonts.inter(
                        color: AppColors.textPrimary, fontSize: 15),
                    decoration: const InputDecoration(
                      hintText: 'e.g. driftking',
                      prefixIcon:
                          Icon(Icons.person_outline_rounded, size: 20),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Username is required';
                      }
                      if (v.trim().length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v.trim())) {
                        return 'Only letters, numbers and underscores allowed';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

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
                        color: AppColors.textPrimary, fontSize: 15),
                    decoration: const InputDecoration(
                      hintText: 'you@example.com',
                      prefixIcon:
                          Icon(Icons.mail_outline_rounded, size: 20),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(v.trim())) {
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
                    textInputAction: TextInputAction.next,
                    onChanged: _onPasswordChanged,
                    style: GoogleFonts.inter(
                        color: AppColors.textPrimary, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Min. 8 characters',
                      prefixIcon:
                          const Icon(Icons.lock_outline_rounded, size: 20),
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
                      if (v == null || v.isEmpty) {
                        return 'Password is required';
                      }
                      if (v.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),

                  // ── Password strength bar ───────────────────────────────
                  if (_passCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _PasswordStrengthBar(strength: _passStrength),
                  ],

                  const SizedBox(height: 20),

                  // ── Confirm password ────────────────────────────────────
                  _FieldLabel(label: 'Confirm password'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPassCtrl,
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => _clearError(),
                    onFieldSubmitted: (_) => _submit(),
                    style: GoogleFonts.inter(
                        color: AppColors.textPrimary, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Repeat your password',
                      prefixIcon:
                          const Icon(Icons.lock_outline_rounded, size: 20),
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm),
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (v != _passCtrl.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // ── Error banner ────────────────────────────────────────
                  PhonkErrorBanner(
                    message: _errorMessage,
                    onDismiss: () => setState(() => _errorMessage = ''),
                  ),
                  if (_errorMessage.isNotEmpty) const SizedBox(height: 16),

                  // ── Submit ──────────────────────────────────────────────
                  PhonkButton(
                    label: 'Create Account',
                    onPressed: _isLoading ? null : _submit,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 20),

                  // ── Divider ─────────────────────────────────────────────
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(color: AppColors.borderSubtle)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'or',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: AppColors.textMuted),
                        ),
                      ),
                      const Expanded(
                          child: Divider(color: AppColors.borderSubtle)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Go to login ─────────────────────────────────────────
                  PhonkButton(
                    label: 'I already have an account',
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
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
            'By creating an account with PhonkDrift, you agree to PhonkDrift',
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

class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar({required this.strength});
  final int strength; // 0–3

  @override
  Widget build(BuildContext context) {
    final labels = ['Weak', 'Fair', 'Good', 'Strong'];
    final colors = [
      AppColors.phonkRed,
      Colors.orange,
      Colors.amber,
      AppColors.success,
    ];
    final idx = (strength - 1).clamp(0, 3);

    return Row(
      children: [
        ...List.generate(3, (i) {
          final filled = i < strength;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
              height: 3,
              decoration: BoxDecoration(
                color: filled ? colors[idx] : AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
        const SizedBox(width: 10),
        Text(
          strength == 0 ? '' : labels[idx],
          style: GoogleFonts.inter(
            fontSize: 11,
            color: strength == 0 ? Colors.transparent : colors[idx],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

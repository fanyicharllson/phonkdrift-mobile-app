import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/storage_helper.dart';
import '../../../../core/widgets/phonk_button.dart';
import 'phonk_level_screen.dart';

class VerifySuccessScreen extends StatefulWidget {
  const VerifySuccessScreen({
    super.key,
    required this.userId,
    required this.token,
  });
  final String userId;
  final String token;

  @override
  State<VerifySuccessScreen> createState() => _VerifySuccessScreenState();
}

class _VerifySuccessScreenState extends State<VerifySuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleBadge;
  late Animation<double> _fadeContent;
  late Animation<double> _slideContent;

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleBadge = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
    );

    _fadeContent = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.85, curve: Curves.easeOut),
    );

    _slideContent = Tween<double>(begin: 24, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.85, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    // Persist session data received from verify response
    await StorageHelper.instance.saveUserId(widget.userId);
    await StorageHelper.instance.saveToken(widget.token);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PhonkLevelScreen(userId: widget.userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Animated badge ──────────────────────────────────────────
              ScaleTransition(
                scale: _scaleBadge,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.phonkRed.withValues(alpha: 0.1),
                    border: Border.all(
                      color: AppColors.phonkRed.withValues(alpha: 0.35),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: AppColors.phonkRed,
                    size: 52,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // ── Text content ────────────────────────────────────────────
              AnimatedBuilder(
                animation: _controller,
                builder: (_, child) => Opacity(
                  opacity: _fadeContent.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideContent.value),
                    child: child,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "You're in.",
                      style: GoogleFonts.inter(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -1.5,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Account verified successfully.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.phonkRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to the underground.\nOne last step — pick your Phonk Level\nand claim your place in the drift.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.65,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // ── CTA ─────────────────────────────────────────────────────
              AnimatedBuilder(
                animation: _fadeContent,
                builder: (_, child) =>
                    Opacity(opacity: _fadeContent.value, child: child),
                child: Column(
                  children: [
                    PhonkButton(
                      label: 'Pick My Phonk Level',
                      onPressed: _continue,
                      icon: Icons.bolt_rounded,
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

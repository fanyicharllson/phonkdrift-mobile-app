import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../../data/repositories/community_repository.dart';
import 'community_guidelines_screen.dart';

class CommunityOnboardingScreen extends StatefulWidget {
  const CommunityOnboardingScreen({super.key});

  @override
  State<CommunityOnboardingScreen> createState() =>
      _CommunityOnboardingScreenState();
}

class _CommunityOnboardingScreenState
    extends State<CommunityOnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulse;
  late Animation<double> _fade;

  bool _isLoading = false;
  int _memberCount = 0;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await CommunityRepository.instance.getStats();
      if (mounted) setState(() => _memberCount = stats.totalMembers);
    } catch (_) {}
  }

  Future<void> _join() async {
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    try {
      await CommunityRepository.instance.joinCommunity();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              const CommunityGuidelinesScreen(),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim, child: child,
          ),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        PhonkToast.show(context,
            message: e.toString().replaceAll('CommunityException: ', ''),
            type: ToastType.error);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Animated background orbs
          _AnimatedOrb(
            top: -80, right: -80,
            color: AppColors.phonkRed, size: 300,
            opacity: 0.12,
          ),
          _AnimatedOrb(
            bottom: -60, left: -60,
            color: const Color(0xFF6B00FF), size: 250,
            opacity: 0.1,
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Pulsing community icon
                    ScaleTransition(
                      scale: _pulse,
                      child: Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.phonkRed.withValues(alpha: 0.3),
                              const Color(0xFF6B00FF).withValues(alpha: 0.2),
                            ],
                          ),
                          border: Border.all(
                            color: AppColors.phonkRed.withValues(alpha: 0.4),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.phonkRed.withValues(alpha: 0.3),
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.people_rounded,
                          color: AppColors.phonkRed,
                          size: 52,
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    Text(
                      'Join the\nPhonk Community',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -1.2,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Chat with phonk lovers worldwide. Share tracks, drop recommendations, and vibe with the underground.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.65,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Member count
                    if (_memberCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.bgSurface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8, height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.phonkRed,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '$_memberCount drifters already inside',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 28),

                    // Features
                    _FeatureRow(
                      icon: Icons.chat_bubble_outline_rounded,
                      text: 'Real-time chat with the community',
                    ),
                    const SizedBox(height: 12),
                    _FeatureRow(
                      icon: Icons.music_note_rounded,
                      text: 'Share phonk finds and recommendations',
                    ),
                    const SizedBox(height: 12),
                    _FeatureRow(
                      icon: Icons.verified_rounded,
                      text: 'Earn OG badge as an early member',
                    ),

                    const Spacer(flex: 2),

                    // CTA
                    _PhonkCTAButton(
                      label: 'Join Community',
                      isLoading: _isLoading,
                      onTap: _join,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Free forever. No spam. Just phonk.',
                      style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textMuted,
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedOrb extends StatelessWidget {
  const _AnimatedOrb({
    this.top, this.bottom, this.left, this.right,
    required this.color,
    required this.size,
    required this.opacity,
  });
  final double? top, bottom, left, right;
  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: opacity), Colors.transparent],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.phonkRed.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.phonkRed, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(text,
              style: GoogleFonts.inter(
                fontSize: 14, color: AppColors.textSecondary,
              )),
        ),
      ],
    );
  }
}

class _PhonkCTAButton extends StatelessWidget {
  const _PhonkCTAButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
  });
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.phonkRed, Color(0xFF8B0034)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.phonkRed.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white,
                  ),
                )
              : Text(label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  )),
        ),
      ),
    );
  }
}
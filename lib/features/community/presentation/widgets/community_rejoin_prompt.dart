import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../../data/repositories/community_repository.dart';

/// Shown to a user who has joined the community before but has since left —
/// a quick "rejoin" CTA instead of the full onboarding pitch they've already
/// seen. Guidelines were already accepted the first time, so this skips
/// straight back into the community once rejoined.
class CommunityRejoinPrompt extends StatefulWidget {
  const CommunityRejoinPrompt({super.key, required this.onRejoined});
  final VoidCallback onRejoined;

  @override
  State<CommunityRejoinPrompt> createState() => _CommunityRejoinPromptState();
}

class _CommunityRejoinPromptState extends State<CommunityRejoinPrompt> {
  bool _isLoading = false;

  Future<void> _rejoin() async {
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();
    try {
      await CommunityRepository.instance.joinCommunity();
      if (!mounted) return;
      widget.onRejoined();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        PhonkToast.show(
          context,
          message: e.toString().replaceAll('CommunityException: ', ''),
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.phonkRed.withValues(alpha: 0.25),
                      const Color(0xFF6B00FF).withValues(alpha: 0.15),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.phonkRed.withValues(alpha: 0.35),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.people_outline_rounded,
                  color: AppColors.phonkRed,
                  size: 44,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'You left the drift',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Jump back into the community chat whenever you\'re ready.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _isLoading ? null : _rejoin,
                child: Container(
                  height: 52,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.phonkRed, Color(0xFF8B0034)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.phonkRed.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Rejoin Community',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

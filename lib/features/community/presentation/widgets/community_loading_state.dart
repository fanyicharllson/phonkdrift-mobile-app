import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

/// Branded loading state shown while checking community membership —
/// replaces a bare spinner with something that matches the rest of the app.
class CommunityLoadingState extends StatefulWidget {
  const CommunityLoadingState({super.key});

  @override
  State<CommunityLoadingState> createState() => _CommunityLoadingStateState();
}

class _CommunityLoadingStateState extends State<CommunityLoadingState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  late final Animation<double> _pulse = Tween<double>(
    begin: 0.92,
    end: 1.06,
  ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _pulse,
              child: Container(
                width: 84,
                height: 84,
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
                      color: AppColors.phonkRed.withValues(alpha: 0.25),
                      blurRadius: 30,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.people_rounded,
                  color: AppColors.phonkRed,
                  size: 38,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Checking your spot in the drift...',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/auth.pb.dart';
import '../../../../core/network/grpc_client.dart';
import '../../../../core/utils/error_helper.dart';
import '../../../../core/utils/storage_helper.dart';
import '../../../../core/widgets/phonk_button.dart';
import '../../../../core/widgets/phonk_error_banner.dart';
import 'home_screen.dart';

class _Level {
  final String id;
  final String label;
  final String subtitle;
  final IconData icon;
  const _Level({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.icon,
  });
}

class PhonkLevelScreen extends StatefulWidget {
  const PhonkLevelScreen({super.key, required this.userId});
  final String userId;

  @override
  State<PhonkLevelScreen> createState() => _PhonkLevelScreenState();
}

class _PhonkLevelScreenState extends State<PhonkLevelScreen> {
  static const List<_Level> _levels = [
    _Level(
      id: 'DRIFTER',
      label: 'Drifter',
      subtitle: 'Just getting started. Feeling the rhythm of the underground.',
      icon: Icons.directions_car_rounded,
    ),
    _Level(
      id: 'GHOST',
      label: 'Ghost',
      subtitle: 'In the shadows. You ride alone and know every beat.',
      icon: Icons.nightlight_round,
    ),
    _Level(
      id: 'LEGEND',
      label: 'Legend',
      subtitle: 'The drift bows to you. You are the underground.',
      icon: Icons.bolt_rounded,
    ),
  ];

  String? _selectedId;
  bool _isLoading = false;
  String _errorMessage = '';

  void _setError(String msg) {
    if (!mounted) return;
    setState(() { _errorMessage = msg; _isLoading = false; });
  }

  Future<void> _submit() async {
    if (_selectedId == null) {
      _setError('Pick a Phonk Level to continue.');
      return;
    }
    setState(() { _isLoading = true; _errorMessage = ''; });
    HapticFeedback.mediumImpact();

    try {
      final token = await StorageHelper.instance.getToken() ?? '';
      final res = await PhonkGrpcClient.instance.auth.updateProfile(
        UpdateProfileRequest(
          userId: widget.userId,
          phonkLevel: _selectedId!,
        ),
        options: PhonkGrpcClient.instance.authCallOptions(token),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (res.success) {
        await StorageHelper.instance.savePhonkLevel(_selectedId!);
        HapticFeedback.heavyImpact();
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );
      } else {
        _setError('Could not save your level. Please try again.');
      }
    } catch (e) {
      _setError(ErrorHelper.fromException(e));
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Text('PhonkDrift',
                    style: GoogleFonts.inter(
                      fontSize: 15, fontWeight: FontWeight.w700,
                      color: AppColors.phonkRed,
                    )),
                const SizedBox(height: 12),
                Text('Who are\nyou?',
                    style: GoogleFonts.inter(
                      fontSize: 38, fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -1.4, height: 1.05,
                    )),
                const SizedBox(height: 8),
                Text(
                  'Pick your Phonk Level. This defines your identity in the drift.',
                  style: GoogleFonts.inter(
                      fontSize: 15, color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 36),
                ..._levels.map((level) => _LevelCard(
                      level: level,
                      isSelected: _selectedId == level.id,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedId = level.id;
                          _errorMessage = '';
                        });
                      },
                    )),
                const SizedBox(height: 24),
                PhonkErrorBanner(
                  message: _errorMessage,
                  onDismiss: () => setState(() => _errorMessage = ''),
                ),
                if (_errorMessage.isNotEmpty) const SizedBox(height: 16),
                PhonkButton(
                  label: 'Enter the Drift',
                  onPressed: _isLoading ? null : _submit,
                  isLoading: _isLoading,
                  icon: Icons.arrow_forward_rounded,
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

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.isSelected,
    required this.onTap,
  });
  final _Level level;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.phonkRed.withValues(alpha: 0.08)
              : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.phonkRed : AppColors.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.phonkRed.withValues(alpha: 0.12),
                    blurRadius: 16,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.phonkRed.withValues(alpha: 0.15)
                    : AppColors.bgElevated,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                level.icon,
                color: isSelected ? AppColors.phonkRed : AppColors.textMuted,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(level.label,
                      style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      )),
                  const SizedBox(height: 4),
                  Text(level.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textMuted, height: 1.45,
                      )),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 22, height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.phonkRed : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.phonkRed
                      : AppColors.borderSubtle,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      size: 13, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

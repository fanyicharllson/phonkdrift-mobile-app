import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/data/repositories/auth_repository.dart';

/// Small, dismissible "how are we doing?" prompt — shown once per install
/// after the user has been genuinely listening for a while.
Future<void> showFeedbackPromptSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: true,
    isScrollControlled: true,
    builder: (_) => const _FeedbackPromptSheet(),
  );
}

class _FeedbackPromptSheet extends StatefulWidget {
  const _FeedbackPromptSheet();

  @override
  State<_FeedbackPromptSheet> createState() => _FeedbackPromptSheetState();
}

class _FeedbackPromptSheetState extends State<_FeedbackPromptSheet> {
  final _commentCtrl = TextEditingController();
  int _rating = 0;
  bool _submitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0 || _submitting) return;
    setState(() => _submitting = true);

    try {
      await AuthRepository.instance.submitFeedback(
        rating: _rating,
        comment: _commentCtrl.text.trim(),
      );
    } catch (_) {
      // Feedback is non-critical — never block or nag the user over it.
    }

    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.phonkRed.withValues(alpha: 0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.phonkRed.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: _submitted ? _buildThankYou() : _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      key: const ValueKey('form'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.phonkRed, Color(0xFF8B0034)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enjoying PhonkDrift?',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap a star and let us know.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.textMuted,
                size: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final filled = _rating > i;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _rating = i + 1);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedScale(
                  scale: filled ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    filled ? Icons.star_rounded : Icons.star_border_rounded,
                    color: filled ? AppColors.phonkRed : AppColors.textMuted,
                    size: 32,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _commentCtrl,
          maxLines: 2,
          style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Anything you want to tell us? (optional)',
            hintStyle: GoogleFonts.inter(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
            filled: true,
            fillColor: AppColors.bgElevated,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.phonkRed,
                width: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Center(
                    child: Text(
                      'Maybe later',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: _rating == 0 ? null : _submit,
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: _rating == 0
                        ? AppColors.bgElevated
                        : AppColors.phonkRed,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: _rating == 0
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.phonkRed.withValues(
                                alpha: 0.35,
                              ),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Center(
                    child: _submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Submit',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _rating == 0
                                  ? AppColors.textMuted
                                  : Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThankYou() {
    return Column(
      key: const ValueKey('thanks'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.phonkRed.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.phonkRed.withValues(alpha: 0.4)),
          ),
          child: const Icon(
            Icons.check_rounded,
            color: AppColors.phonkRed,
            size: 28,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Thank you!',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your feedback helps us improve the drift.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

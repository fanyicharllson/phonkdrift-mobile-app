import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Circular play/pause control with press-scale feedback and an animated
/// icon swap, shared between the mini player and the full player screen.
class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton({
    super.key,
    required this.isPlaying,
    required this.onTap,
    this.size = 36,
    this.iconSize = 20,
  });

  final bool isPlaying;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  bool _pressed = false;

  void _setPressed(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.86 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: AppColors.phonkRed,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.phonkRed.withValues(alpha: 0.45),
                blurRadius: widget.size * 0.4,
                offset: Offset(0, widget.size * 0.08),
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: Icon(
                widget.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                key: ValueKey(widget.isPlaying),
                color: Colors.white,
                size: widget.iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
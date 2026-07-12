import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// A waveform-style scrubber: the bars themselves are the seek bar, filled up
/// to the current playback position. Each track gets a stable-looking "wave
/// fingerprint" (seeded from its ID) instead of a generic looping animation.
/// The few bars right at the playhead pulse gently while playing, so the eye
/// is drawn to "you are here" without turning the whole thing into a
/// bouncing equalizer.
class WaveformSeekBar extends StatefulWidget {
  const WaveformSeekBar({
    super.key,
    required this.trackId,
    required this.progress,
    required this.onSeek,
    required this.isPlaying,
    this.height = 56,
    this.barCount = 40,
  });

  /// Used to seed the bar heights so the same track always looks the same.
  final String trackId;

  /// 0.0–1.0 playback position.
  final double progress;

  /// Called with a 0.0–1.0 fraction when the user taps/drags to seek.
  final ValueChanged<double> onSeek;

  /// Only the playhead bars pulse while this is true.
  final bool isPlaying;

  final double height;
  final int barCount;

  @override
  State<WaveformSeekBar> createState() => _WaveformSeekBarState();
}

class _WaveformSeekBarState extends State<WaveformSeekBar>
    with SingleTickerProviderStateMixin {
  late List<double> _heights;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _generateHeights();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    if (widget.isPlaying) _pulseController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant WaveformSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trackId != widget.trackId) _generateHeights();
    if (widget.isPlaying && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isPlaying) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _generateHeights() {
    final rnd = Random(widget.trackId.hashCode);
    double last = 0.5;
    _heights = List.generate(widget.barCount, (i) {
      // Walk the height randomly instead of pure noise so neighbouring bars
      // flow into each other like a real waveform rather than static, and
      // keep a higher floor so quiet bars still read as bars, not dots.
      final next = (last + (rnd.nextDouble() - 0.5) * 0.4).clamp(0.35, 1.0);
      last = next;
      return next;
    });
  }

  void _handleSeek(double dx, double width) {
    widget.onSeek((dx / width).clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => _handleSeek(d.localPosition.dx, width),
          onHorizontalDragUpdate: (d) => _handleSeek(d.localPosition.dx, width),
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) => CustomPaint(
                painter: _WaveformPainter(
                  heights: _heights,
                  progress: widget.progress,
                  pulse: _pulseController.value,
                  playedColor: AppColors.phonkRed,
                  unplayedColor: AppColors.borderSubtle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  _WaveformPainter({
    required this.heights,
    required this.progress,
    required this.pulse,
    required this.playedColor,
    required this.unplayedColor,
  });

  final List<double> heights;
  final double progress;
  final double pulse;
  final Color playedColor;
  final Color unplayedColor;

  @override
  void paint(Canvas canvas, Size size) {
    final barCount = heights.length;
    const gap = 3.0;
    final barWidth = (size.width - gap * (barCount - 1)) / barCount;
    final progressX = size.width * progress;
    final playheadIndex = (progress * barCount).floor().clamp(0, barCount - 1);

    for (var i = 0; i < barCount; i++) {
      final x = i * (barWidth + gap);

      // Boost the 3 bars centred on the playhead, tapering outwards, scaled
      // by the pulse animation — center bar gets the full boost.
      final distanceFromPlayhead = (i - playheadIndex).abs();
      final boost = switch (distanceFromPlayhead) {
        0 => 0.5,
        1 => 0.25,
        _ => 0.0,
      };

      final normalizedHeight = (heights[i] + boost * pulse).clamp(0.0, 1.15);
      final h = (normalizedHeight * size.height).clamp(4.0, size.height * 1.1);
      final rect = Rect.fromLTWH(x, (size.height - h) / 2, barWidth, h);
      final rrect = RRect.fromRectAndRadius(
        rect,
        Radius.circular(barWidth / 2),
      );
      final barCenter = x + barWidth / 2;
      canvas.drawRRect(
        rrect,
        Paint()..color = barCenter <= progressX ? playedColor : unplayedColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.pulse != pulse ||
      oldDelegate.heights != heights;
}

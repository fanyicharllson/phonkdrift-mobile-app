import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Small animated "now playing" bar indicator — three bars pulsing at
/// staggered speeds, used anywhere a track is shown as currently playing.
class PlayingEqualizer extends StatefulWidget {
  const PlayingEqualizer({super.key, this.size = 18, this.color});
  final double size;
  final Color? color;

  @override
  State<PlayingEqualizer> createState() => _PlayingEqualizerState();
}

class _PlayingEqualizerState extends State<PlayingEqualizer>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers = List.generate(
    3,
    (i) => AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 420 + i * 130),
    )..repeat(reverse: true),
  );

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.phonkRed;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _controllers[i],
            builder: (_, __) {
              final heightFactor = 0.3 + _controllers[i].value * 0.7;
              return Container(
                width: widget.size / 5,
                height: widget.size * heightFactor,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
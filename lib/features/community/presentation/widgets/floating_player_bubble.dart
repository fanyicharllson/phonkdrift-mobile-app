import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../track/presentation/controllers/track_controller.dart';
import '../../../track/presentation/widgets/playing_equalizer.dart';

/// A small draggable "chat head"-style bubble surfacing the currently
/// playing track while the mini player is hidden (Community tab has no
/// floating chrome). Tap opens the full player screen; drag repositions
/// it so it never permanently blocks the chat or the input bar.
class FloatingPlayerBubble extends StatefulWidget {
  const FloatingPlayerBubble({
    super.key,
    required this.controller,
    required this.onTap,
  });

  final TrackController controller;
  final VoidCallback onTap;

  @override
  State<FloatingPlayerBubble> createState() => _FloatingPlayerBubbleState();
}

class _FloatingPlayerBubbleState extends State<FloatingPlayerBubble> {
  static const double _size = 58;
  Offset? _offset;

  Offset _clamped(Offset offset, Size screen) {
    return Offset(
      offset.dx.clamp(8.0, screen.width - _size - 8.0),
      offset.dy.clamp(8.0, screen.height - _size - 8.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        if (!widget.controller.hasNowPlaying) return const SizedBox.shrink();

        final screen = MediaQuery.of(context).size;
        // Default spot: bottom-right, clear of the input bar.
        _offset ??= Offset(
          screen.width - _size - 16,
          screen.height - _size - 190,
        );
        _offset = _clamped(_offset!, screen);

        final track = widget.controller.nowPlaying!;

        return Positioned(
          left: _offset!.dx,
          top: _offset!.dy,
          child: GestureDetector(
            onTap: widget.onTap,
            onPanUpdate: (details) {
              setState(() {
                _offset = _clamped(_offset! + details.delta, screen);
              });
            },
            child: Container(
              width: _size,
              height: _size,
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.phonkRed.withValues(alpha: 0.9),
                    const Color(0xFF6B00FF).withValues(alpha: 0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.phonkRed.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    track.thumbnailUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: track.thumbnailUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: AppColors.bgSurface,
                              child: const Icon(
                                Icons.music_note_rounded,
                                color: AppColors.textMuted,
                              ),
                            ),
                          )
                        : Container(
                            color: AppColors.bgSurface,
                            child: const Icon(
                              Icons.music_note_rounded,
                              color: AppColors.textMuted,
                            ),
                          ),
                    if (widget.controller.isPlaying)
                      Container(
                        color: Colors.black.withValues(alpha: 0.35),
                        child: const Center(child: PlayingEqualizer(size: 16)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

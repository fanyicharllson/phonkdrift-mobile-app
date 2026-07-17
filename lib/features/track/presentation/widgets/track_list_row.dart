import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/track.pb.dart';
import 'playing_equalizer.dart';

/// Flat list row shared by Trending, Liked Tracks, and Playlist Detail —
/// replaces the old per-screen "card" tiles (background, border, shadow,
/// margin around every row) with a plain divided list, matching a denser
/// streaming-app track list instead of a stack of boxes.
class TrackListRow extends StatelessWidget {
  const TrackListRow({
    super.key,
    required this.track,
    required this.onTap,
    this.onLike,
    this.onLongPress,
    this.onMoreTap,
    this.leading,
    this.isPlaying = false,
    this.isLiked = false,
    this.isHighlighted = false,
    this.showPlayCount = false,
    this.showPlayIndicator = false,
    this.showDivider = true,
  });

  final TrackMetadata track;
  final VoidCallback onTap;

  /// Required unless [onMoreTap] is given instead (Recently Played's "⋮"
  /// options sheet already includes a Like/Unlike entry, so it has no use
  /// for a separate heart button here).
  final VoidCallback? onLike;
  final VoidCallback? onLongPress;

  /// When set, a "⋮" button replaces the like heart as the primary trailing
  /// action (Home's Recently Played opens a full options sheet — play,
  /// like, add to playlist, share — instead of a bare like toggle).
  final VoidCallback? onMoreTap;

  /// Custom leading content (a rank medal, a track position number, an
  /// equalizer swapped in when playing, etc.) — varies by screen, so the
  /// caller owns it rather than this widget guessing.
  final Widget? leading;

  final bool isPlaying;
  final bool isLiked;

  /// Briefly true right after a push-notification deep link so the user can
  /// spot the track — a tinted title + ring instead of a boxed highlight.
  final bool isHighlighted;

  /// Trending shows "▶ 147K · 2:09"; Liked/Playlist just show duration.
  final bool showPlayCount;

  /// Trailing equalizer/play-circle indicator — independent of
  /// [showPlayCount] since Recently Played wants the indicator without the
  /// play-count subtitle.
  final bool showPlayIndicator;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final accent = isHighlighted || isPlaying;
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress == null
          ? null
          : () {
              HapticFeedback.mediumImpact();
              onLongPress!();
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isHighlighted
              ? AppColors.phonkRed.withValues(alpha: 0.08)
              : null,
          border: showDivider
              ? const Border(
                  bottom: BorderSide(color: AppColors.borderSubtle, width: 0.6),
                )
              : null,
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 10)],
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: track.thumbnailUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: track.thumbnailUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const _Placeholder(),
                    )
                  : const _Placeholder(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: accent ? AppColors.phonkRed : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    track.artistName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  if (showPlayCount) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.play_arrow_rounded,
                          color: AppColors.textMuted,
                          size: 13,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          _formatCount(track.playCount),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          track.duration,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (!showPlayCount) ...[
              Text(
                track.duration,
                style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(width: 12),
            ],
            if (onMoreTap != null)
              GestureDetector(
                onTap: onMoreTap,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated.withValues(alpha: 0.82),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.textPrimary,
                    size: 17,
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  onLike?.call();
                },
                child: Icon(
                  isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isLiked ? AppColors.phonkRed : AppColors.textMuted,
                  size: 19,
                ),
              ),
            if (showPlayIndicator) ...[
              const SizedBox(width: 10),
              isPlaying
                  ? const PlayingEqualizer(size: 18)
                  : const Icon(
                      Icons.play_circle_outline_rounded,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Small rank/position badge for the leading slot — used by Trending (with
/// medal styling for the top 3) and can double as a plain index elsewhere.
class TrackRankBadge extends StatelessWidget {
  const TrackRankBadge({super.key, required this.rank, this.isPlaying = false});
  final int rank;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    if (isPlaying) {
      return const SizedBox(width: 28, child: Center(child: PlayingEqualizer(size: 16)));
    }
    final isTop3 = rank <= 3;
    return SizedBox(
      width: 28,
      child: Text(
        '$rank',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: isTop3 ? 16 : 13,
          fontWeight: FontWeight.w900,
          color: isTop3 ? AppColors.phonkRed : AppColors.textMuted,
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      color: AppColors.bgElevated,
      child: const Icon(
        Icons.music_note_rounded,
        color: AppColors.textMuted,
        size: 20,
      ),
    );
  }
}

String _formatCount(int count) {
  if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
  if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
  return '$count';
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../controllers/track_controller.dart';
import '../widgets/add_to_playlist_sheet.dart';
import '../widgets/play_pause_button.dart';
import '../widgets/waveform_seek_bar.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.controller});
  final TrackController controller;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onUpdate);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    if (widget.controller.isPlaying) {
      _rotateController.repeat();
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onUpdate);
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onUpdate() {
    if (!mounted) return;
    setState(() {});
    if (widget.controller.isPlaying && !_rotateController.isAnimating) {
      _rotateController.repeat();
      _pulseController.repeat(reverse: true);
    } else if (!widget.controller.isPlaying) {
      _rotateController.stop();
      _pulseController.stop();
    }
    if (widget.controller.playError.isNotEmpty) {
      PhonkToast.show(
        context,
        message: widget.controller.playError,
        type: ToastType.error,
      );
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _openYouTube(TrackMetadata track) async {
    if (track.originalYoutubeId.isEmpty) return;
    final uri = Uri.parse(
      'https://www.youtube.com/watch?v=${track.originalYoutubeId}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openTrackOptions(TrackMetadata track, bool isLiked) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PlayerOptionTile(
                icon: isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                label: isLiked ? 'Unlike' : 'Like',
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  HapticFeedback.mediumImpact();
                  widget.controller.toggleLike(track.trackId);
                },
              ),
              _PlayerOptionTile(
                icon: Icons.playlist_add_rounded,
                label: 'Add to Playlist',
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  showAddToPlaylistSheet(context, track: track);
                },
              ),
              _PlayerOptionTile(
                icon: Icons.share_rounded,
                label: 'Share',
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  final youtubeUrl = track.originalYoutubeId.isNotEmpty
                      ? '\nhttps://www.youtube.com/watch?v=${track.originalYoutubeId}'
                      : '';
                  Share.share(
                    '${track.title} by ${track.artistName}$youtubeUrl',
                  );
                },
              ),
              if (track.originalYoutubeId.isNotEmpty)
                _PlayerOptionTile(
                  icon: Icons.open_in_new_rounded,
                  label: 'Open in YouTube',
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    _openYouTube(track);
                  },
                ),
              _PlayerOptionTile(
                icon: Icons.close_rounded,
                label: 'Dismiss',
                onTap: () => Navigator.of(sheetCtx).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final track = widget.controller.nowPlaying;
    if (track == null) {
      return const Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Center(
          child: Icon(
            Icons.music_off_rounded,
            color: AppColors.textMuted,
            size: 48,
          ),
        ),
      );
    }

    final progress = widget.controller.duration.inSeconds > 0
        ? (widget.controller.position.inSeconds /
                  widget.controller.duration.inSeconds)
              .clamp(0.0, 1.0)
        : 0.0;

    final isLiked = widget.controller.isLiked(track.trackId);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Background — blurred thumbnail tint
          if (track.thumbnailUrl.isNotEmpty)
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: CachedNetworkImage(
                  imageUrl: track.thumbnailUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),

          // Red gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.phonkRed.withValues(alpha: 0.06),
                    AppColors.bgDeep,
                    AppColors.bgDeep,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.bgSurface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Now Playing',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'PhonkDrift',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.phonkRed,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _openTrackOptions(track, isLiked),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.bgSurface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: const Icon(
                            Icons.more_vert_rounded,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Rotating album art — breathing glow while playing
                Center(
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (_, child) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.phonkRed.withValues(alpha: 0.3),
                            blurRadius: 40 + _pulseController.value * 20,
                            spreadRadius: 5 + _pulseController.value * 6,
                          ),
                        ],
                      ),
                      child: child,
                    ),
                    child: AnimatedBuilder(
                      animation: _rotateController,
                      builder: (_, child) => Transform.rotate(
                        angle: _rotateController.value * 2 * 3.14159,
                        child: child,
                      ),
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(
                          child: track.thumbnailUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: track.thumbnailUrl,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) =>
                                      _ArtPlaceholder(),
                                )
                              : _ArtPlaceholder(),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Track info + like
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              track.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.8,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              track.artistName,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Like button
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          widget.controller.toggleLike(track.trackId);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isLiked
                                ? AppColors.phonkRed.withValues(alpha: 0.15)
                                : AppColors.bgSurface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isLiked
                                  ? AppColors.phonkRed
                                  : AppColors.borderSubtle,
                            ),
                          ),
                          child: Icon(
                            isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isLiked
                                ? AppColors.phonkRed
                                : AppColors.textMuted,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Waveform scrubber — the bars themselves are the seek bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      WaveformSeekBar(
                        trackId: track.trackId,
                        progress: progress,
                        isPlaying: widget.controller.isPlaying,
                        onSeek: (fraction) {
                          final pos = Duration(
                            seconds:
                                (fraction * widget.controller.duration.inSeconds)
                                    .round(),
                          );
                          widget.controller.seekTo(pos);
                        },
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(widget.controller.position),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                            Text(
                              _formatDuration(widget.controller.duration),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Playback controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Previous track
                      GestureDetector(
                        onTap: widget.controller.hasPrevious
                            ? () {
                                HapticFeedback.lightImpact();
                                widget.controller.playPrevious();
                              }
                            : null,
                        child: Icon(
                          Icons.skip_previous_rounded,
                          color: widget.controller.hasPrevious
                              ? AppColors.textSecondary
                              : AppColors.textMuted.withValues(alpha: 0.3),
                          size: 28,
                        ),
                      ),

                      // Seek back 10s
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          final newPos =
                              widget.controller.position -
                              const Duration(seconds: 10);
                          widget.controller.seekTo(
                            newPos < Duration.zero ? Duration.zero : newPos,
                          );
                        },
                        child: const Icon(
                          Icons.replay_10_rounded,
                          color: AppColors.textSecondary,
                          size: 32,
                        ),
                      ),

                      // Play / Pause
                      PlayPauseButton(
                        isPlaying: widget.controller.isPlaying,
                        size: 72,
                        iconSize: 36,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          widget.controller.togglePlayPause();
                        },
                      ),

                      // Seek forward 10s
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          final newPos =
                              widget.controller.position +
                              const Duration(seconds: 10);
                          widget.controller.seekTo(newPos);
                        },
                        child: const Icon(
                          Icons.forward_10_rounded,
                          color: AppColors.textSecondary,
                          size: 32,
                        ),
                      ),

                      // Next track
                      GestureDetector(
                        onTap: widget.controller.hasNext
                            ? () {
                                HapticFeedback.lightImpact();
                                widget.controller.playNext();
                              }
                            : null,
                        child: Icon(
                          Icons.skip_next_rounded,
                          color: widget.controller.hasNext
                              ? AppColors.textSecondary
                              : AppColors.textMuted.withValues(alpha: 0.3),
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Repeat toggle
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    widget.controller.toggleRepeat();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: widget.controller.isRepeatOne
                          ? AppColors.phonkRed.withValues(alpha: 0.15)
                          : AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.controller.isRepeatOne
                            ? AppColors.phonkRed
                            : AppColors.borderSubtle,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.repeat_one_rounded,
                          size: 16,
                          color: widget.controller.isRepeatOne
                              ? AppColors.phonkRed
                              : AppColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.controller.isRepeatOne
                              ? 'Repeat On'
                              : 'Repeat Off',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: widget.controller.isRepeatOne
                                ? AppColors.phonkRed
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Stats row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatChip(
                        icon: Icons.play_arrow_rounded,
                        label: _formatCount(track.playCount),
                      ),
                      _StatChip(
                        icon: Icons.favorite_rounded,
                        label: _formatCount(track.likesCount),
                        color: AppColors.phonkRed,
                      ),
                      _StatChip(
                        icon: Icons.timer_outlined,
                        label: track.duration,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerOptionTile extends StatelessWidget {
  const _PlayerOptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.phonkRed),
      title: Text(
        label,
        style: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _ArtPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgElevated,
      child: const Icon(
        Icons.music_note_rounded,
        color: AppColors.textMuted,
        size: 64,
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label, this.color});
  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Icon(icon, color: color ?? AppColors.textMuted, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: color ?? AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatCount(int count) {
  if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
  if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
  return '$count';
}

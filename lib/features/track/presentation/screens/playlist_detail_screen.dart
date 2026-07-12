import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../../../core/widgets/phonk_button.dart';
import '../../../../core/widgets/phonk_error_banner.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../../data/repositories/track_repository.dart';
import '../controllers/track_controller.dart';
import '../widgets/playing_equalizer.dart';

class PlaylistDetailScreen extends StatefulWidget {
  const PlaylistDetailScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
    required this.controller,
  });

  final String playlistId;
  final String playlistName;
  final TrackController controller;

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  List<TrackMetadata> _tracks = [];
  bool _isLoading = true;
  String _error = '';
  String _coverUrl = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onUpdate);
    _load();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    if (!mounted) return;
    setState(() {});
    if (widget.controller.playError.isNotEmpty) {
      PhonkToast.show(context,
          message: widget.controller.playError, type: ToastType.error);
    }
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = ''; });
    try {
      final res = await TrackRepository.instance
          .getPlaylist(widget.playlistId);
      if (mounted) {
        setState(() {
          _tracks = res.tracks;
          _coverUrl = res.coverImageUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _confirmRemoveTrack(TrackMetadata track) async {
    final removed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _RemoveTrackSheet(
        playlistId: widget.playlistId,
        track: track,
      ),
    );
    if (removed == true && mounted) {
      setState(() {
        _tracks.removeWhere((t) => t.trackId == track.trackId);
      });
      PhonkToast.show(context,
          message: '"${track.title}" removed from playlist.',
          type: ToastType.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Premium header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.bgDeep,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary, size: 16),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Cover image or gradient
                  _coverUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: _coverUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => _GradientCover(),
                        )
                      : _GradientCover(),
                  // Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.bgDeep,
                        ],
                      ),
                    ),
                  ),
                  // Title bottom
                  Positioned(
                    left: 24, right: 24, bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.playlistName,
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.8,
                            )),
                        Text('${_tracks.length} tracks',
                            style: GoogleFonts.inter(
                              fontSize: 13, color: AppColors.textSecondary,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Play all button
          if (_tracks.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: GestureDetector(
                  onTap: () => widget.controller
                      .playTrack(_tracks.first, context, queue: _tracks),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.phonkRed, Color(0xFF8B0034)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.phonkRed.withValues(alpha: 0.3),
                          blurRadius: 16, offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow_rounded,
                            color: Colors.white, size: 22),
                        const SizedBox(width: 6),
                        Text('Play All',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Tracks
          if (_isLoading)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, __) => Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                childCount: 8,
              ),
            )
          else if (_error.isNotEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        color: AppColors.textMuted, size: 40),
                    const SizedBox(height: 12),
                    Text('Could not load playlist.',
                        style: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.textSecondary,
                        )),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _load,
                      child: Text('Retry',
                          style: GoogleFonts.inter(
                            fontSize: 14, color: AppColors.phonkRed,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                  ],
                ),
              ),
            )
          else if (_tracks.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text('No tracks in this playlist yet.',
                    style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.textMuted,
                    )),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text('Long-press a track to remove it',
                        style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.textMuted,
                        )),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _PlaylistTrackTile(
                  track: _tracks[i],
                  index: i + 1,
                  isPlaying: widget.controller.nowPlaying?.trackId ==
                      _tracks[i].trackId,
                  isLiked: widget.controller.isLiked(_tracks[i].trackId),
                  onTap: () => widget.controller.playTrack(
                    _tracks[i],
                    context,
                    queue: _tracks,
                  ),
                  onLike: () =>
                      widget.controller.toggleLike(_tracks[i].trackId),
                  onLongPress: () => _confirmRemoveTrack(_tracks[i]),
                ),
                childCount: _tracks.length,
              ),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 160)),
        ],
      ),
    );
  }
}

class _GradientCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2D0010), Color(0xFF0A0A0C)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.queue_music_rounded,
            color: AppColors.textMuted, size: 48),
      ),
    );
  }
}

class _PlaylistTrackTile extends StatelessWidget {
  const _PlaylistTrackTile({
    required this.track,
    required this.index,
    required this.onTap,
    required this.onLike,
    required this.onLongPress,
    this.isPlaying = false,
    this.isLiked = false,
  });

  final TrackMetadata track;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onLongPress;
  final bool isPlaying;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        HapticFeedback.mediumImpact();
        onLongPress();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPlaying
              ? AppColors.phonkRed.withValues(alpha: 0.07)
              : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPlaying
                ? AppColors.phonkRed.withValues(alpha: 0.3)
                : AppColors.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: isPlaying
                  ? const PlayingEqualizer(size: 18)
                  : Text('$index',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      )),
            ),
            const SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: track.thumbnailUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: track.thumbnailUrl,
                      width: 46, height: 46, fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 46, height: 46, color: AppColors.bgElevated,
                        child: const Icon(Icons.music_note_rounded,
                            color: AppColors.textMuted, size: 18),
                      ),
                    )
                  : Container(
                      width: 46, height: 46, color: AppColors.bgElevated,
                      child: const Icon(Icons.music_note_rounded,
                          color: AppColors.textMuted, size: 18),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(track.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      )),
                  const SizedBox(height: 2),
                  Text(track.artistName,
                      style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textMuted,
                      )),
                ],
              ),
            ),
            Text(track.duration,
                style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textMuted,
                )),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                onLike();
              },
              child: Icon(
                isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isLiked ? AppColors.phonkRed : AppColors.textMuted,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Remove Track Confirmation Sheet ──────────────────────────────────────────────
class _RemoveTrackSheet extends StatefulWidget {
  const _RemoveTrackSheet({required this.playlistId, required this.track});
  final String playlistId;
  final TrackMetadata track;

  @override
  State<_RemoveTrackSheet> createState() => _RemoveTrackSheetState();
}

class _RemoveTrackSheetState extends State<_RemoveTrackSheet> {
  bool _isRemoving = false;
  String _error = '';

  Future<void> _remove() async {
    setState(() {
      _isRemoving = true;
      _error = '';
    });
    try {
      final success = await TrackRepository.instance.removeTrackFromPlaylist(
        playlistId: widget.playlistId,
        trackId: widget.track.trackId,
      );
      if (!mounted) return;
      if (success) {
        Navigator.pop(context, true);
      } else {
        setState(() {
          _isRemoving = false;
          _error = 'Could not remove track. Try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRemoving = false;
          _error = e.toString().replaceAll('TrackException: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.phonkRed.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.playlist_remove_rounded,
              color: AppColors.phonkRed,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Remove track?',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '"${widget.track.title}" will be removed from this playlist.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 14),
            PhonkErrorBanner(
              message: _error,
              onDismiss: () => setState(() => _error = ''),
            ),
          ],
          const SizedBox(height: 24),
          PhonkButton(
            label: 'Remove from Playlist',
            onPressed: _isRemoving ? null : _remove,
            isLoading: _isRemoving,
          ),
          const SizedBox(height: 12),
          PhonkButton(
            label: 'Cancel',
            onPressed: _isRemoving
                ? null
                : () => Navigator.pop(context, false),
            variant: PhonkButtonVariant.ghost,
          ),
        ],
      ),
    );
  }
}
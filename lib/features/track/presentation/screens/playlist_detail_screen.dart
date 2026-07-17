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
import '../widgets/track_list_row.dart';

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
              // Fades into the pinned toolbar once the parallax cover (and
              // the title sitting on top of it) scrolls out of view — so
              // the playlist name/track count never fully disappear.
              title: Text(
                _tracks.isEmpty
                    ? widget.playlistName
                    : '${widget.playlistName} · ${_tracks.length} tracks',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Custom cover if the backend has one, otherwise a
                  // collage built from the playlist's own tracks instead of
                  // a generic gradient every playlist would otherwise share.
                  _coverUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: _coverUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              _PlaylistCoverArt(tracks: _tracks),
                        )
                      : _PlaylistCoverArt(tracks: _tracks),
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
              delegate: SliverChildBuilderDelegate((_, i) {
                final track = _tracks[i];
                final isPlaying =
                    widget.controller.nowPlaying?.trackId == track.trackId;
                return TrackListRow(
                  track: track,
                  leading: TrackRankBadge(rank: i + 1, isPlaying: isPlaying),
                  isPlaying: isPlaying,
                  isLiked: widget.controller.isLiked(track.trackId),
                  onTap: () => widget.controller.playTrack(
                    track,
                    context,
                    queue: _tracks,
                  ),
                  onLike: () => widget.controller.toggleLike(track.trackId),
                  onLongPress: () => _confirmRemoveTrack(track),
                );
              }, childCount: _tracks.length),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 160)),
        ],
      ),
    );
  }
}

/// Content-aware playlist cover — a 2x2 collage of the playlist's own track
/// thumbnails (repeating them to fill all 4 quadrants when there are fewer
/// than 4, the usual streaming-app convention), so every playlist actually
/// looks like what's in it instead of sharing one static gradient.
class _PlaylistCoverArt extends StatelessWidget {
  const _PlaylistCoverArt({required this.tracks});
  final List<TrackMetadata> tracks;

  @override
  Widget build(BuildContext context) {
    final thumbs = tracks
        .map((t) => t.thumbnailUrl)
        .where((u) => u.isNotEmpty)
        .take(4)
        .toList();
    if (thumbs.isEmpty) return _GradientCover();
    if (thumbs.length == 1) {
      return CachedNetworkImage(
        imageUrl: thumbs.first,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _GradientCover(),
      );
    }

    Widget quadrant(int i) {
      return CachedNetworkImage(
        imageUrl: thumbs[i % thumbs.length],
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) =>
            Container(color: AppColors.bgElevated),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      children: [quadrant(0), quadrant(1), quadrant(2), quadrant(3)],
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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../../data/repositories/track_repository.dart';
import '../controllers/track_controller.dart';
import 'playlist_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key, required this.controller});
  final TrackController controller;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Liked tracks
  List<TrackMetadata> _likedTracks = [];
  bool _likedLoading = true;
  String _likedError = '';

  // Playlists
  List<PlaylistSummary> _playlists = [];
  bool _playlistsLoading = true;
  String _playlistsError = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    widget.controller.addListener(_onControllerUpdate);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    widget.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    setState(() {});
    if (widget.controller.playError.isNotEmpty) {
      PhonkToast.show(context,
          message: widget.controller.playError, type: ToastType.error);
    }
  }

  Future<void> _loadAll() async {
    await Future.wait([_loadLiked(), _loadPlaylists()]);
  }

  Future<void> _loadLiked() async {
    setState(() { _likedLoading = true; _likedError = ''; });
    try {
      final tracks = await TrackRepository.instance.getLikedTracks();
      if (mounted) setState(() { _likedTracks = tracks; _likedLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _likedError = e.toString(); _likedLoading = false; });
    }
  }

  Future<void> _loadPlaylists() async {
    setState(() { _playlistsLoading = true; _playlistsError = ''; });
    try {
      final playlists = await TrackRepository.instance.getUserPlaylists();
      if (mounted) setState(() { _playlists = playlists; _playlistsLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _playlistsError = e.toString(); _playlistsLoading = false; });
    }
  }

  Future<void> _showCreatePlaylist() async {
    final nameCtrl = TextEditingController();
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreatePlaylistSheet(controller: nameCtrl),
    );
    if (result != true || nameCtrl.text.trim().isEmpty) return;

    try {
      await TrackRepository.instance.createPlaylist(
        name: nameCtrl.text.trim(),
      );
      HapticFeedback.mediumImpact();
      PhonkToast.show(context,
          message: 'Playlist "${nameCtrl.text.trim()}" created.',
          type: ToastType.success);
      await _loadPlaylists();
    } catch (e) {
      PhonkToast.show(context,
          message: 'Could not create playlist. Try again.',
          type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Background accent
          Positioned(
            top: -30, left: -60,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF6B00FF).withValues(alpha: 0.1),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your Library',
                                style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -1,
                                )),
                            const SizedBox(height: 2),
                            Text(
                              '${_likedTracks.length} liked · ${_playlists.length} playlists',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Create playlist button
                      GestureDetector(
                        onTap: _showCreatePlaylist,
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.phonkRed,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.phonkRed.withValues(alpha: 0.35),
                                blurRadius: 16,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.add_rounded,
                              color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Stats strip ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      _StatStrip(
                        icon: Icons.favorite_rounded,
                        value: '${_likedTracks.length}',
                        label: 'Liked',
                        color: AppColors.phonkRed,
                      ),
                      const SizedBox(width: 12),
                      _StatStrip(
                        icon: Icons.queue_music_rounded,
                        value: '${_playlists.length}',
                        label: 'Playlists',
                        color: const Color(0xFF6B00FF),
                      ),
                      const SizedBox(width: 12),
                      _StatStrip(
                        icon: Icons.library_music_rounded,
                        value: '${_likedTracks.length + _playlists.fold<int>(0, (s, p) => s + p.trackCount)}',
                        label: 'Total',
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Tabs ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.phonkRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w500,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.textMuted,
                      tabs: const [
                        Tab(text: 'Liked Tracks'),
                        Tab(text: 'Playlists'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Tab views ────────────────────────────────────────────
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _LikedTracksTab(
                        tracks: _likedTracks,
                        isLoading: _likedLoading,
                        error: _likedError,
                        controller: widget.controller,
                        onRetry: _loadLiked,
                      ),
                      _PlaylistsTab(
                        playlists: _playlists,
                        isLoading: _playlistsLoading,
                        error: _playlistsError,
                        controller: widget.controller,
                        onRetry: _loadPlaylists,
                        onCreatePlaylist: _showCreatePlaylist,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Liked Tracks Tab ────────────────────────────────────────────────────────────
class _LikedTracksTab extends StatelessWidget {
  const _LikedTracksTab({
    required this.tracks,
    required this.isLoading,
    required this.error,
    required this.controller,
    required this.onRetry,
  });

  final List<TrackMetadata> tracks;
  final bool isLoading;
  final String error;
  final TrackController controller;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ListView.builder(
        itemCount: 8,
        itemBuilder: (_, __) => const _ShimmerTile(),
      );
    }

    if (error.isNotEmpty) {
      return _ErrorState(message: 'Could not load liked tracks.', onRetry: onRetry);
    }

    if (tracks.isEmpty) {
      return _EmptyState(
        icon: Icons.favorite_border_rounded,
        title: 'No liked tracks yet',
        subtitle: 'Tracks you like will appear here.\nHit the heart on any track.',
      );
    }

    return Column(
      children: [
        // Play all button
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: GestureDetector(
            onTap: () => controller.playTrack(tracks.first, context),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.phonkRed, Color(0xFF8B0034)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.phonkRed.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shuffle_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text('Shuffle Play',
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

        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 160),
            itemCount: tracks.length,
            itemBuilder: (_, i) => _LibraryTrackTile(
              track: tracks[i],
              index: i + 1,
              isPlaying: controller.nowPlaying?.trackId == tracks[i].trackId,
              isLiked: true,
              onTap: () => controller.playTrack(tracks[i], context),
              onLike: () => controller.toggleLike(tracks[i].trackId),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Playlists Tab ───────────────────────────────────────────────────────────────
class _PlaylistsTab extends StatelessWidget {
  const _PlaylistsTab({
    required this.playlists,
    required this.isLoading,
    required this.error,
    required this.controller,
    required this.onRetry,
    required this.onCreatePlaylist,
  });

  final List<PlaylistSummary> playlists;
  final bool isLoading;
  final String error;
  final TrackController controller;
  final VoidCallback onRetry;
  final VoidCallback onCreatePlaylist;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => const _ShimmerCard(),
      );
    }

    if (error.isNotEmpty) {
      return _ErrorState(message: 'Could not load playlists.', onRetry: onRetry);
    }

    if (playlists.isEmpty) {
      return _EmptyState(
        icon: Icons.queue_music_rounded,
        title: 'No playlists yet',
        subtitle: 'Create your first playlist\nand start curating your drift.',
        action: 'Create Playlist',
        onAction: onCreatePlaylist,
      );
    }

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 160),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: playlists.length + 1, // +1 for create card
      itemBuilder: (_, i) {
        if (i == 0) {
          return _CreatePlaylistCard(onTap: onCreatePlaylist);
        }
        final playlist = playlists[i - 1];
        return _PlaylistCard(
          playlist: playlist,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PlaylistDetailScreen(
                playlistId: playlist.playlistId,
                playlistName: playlist.name,
                controller: controller,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Library Track Tile ──────────────────────────────────────────────────────────
class _LibraryTrackTile extends StatelessWidget {
  const _LibraryTrackTile({
    required this.track,
    required this.index,
    required this.onTap,
    required this.onLike,
    this.isPlaying = false,
    this.isLiked = false,
  });

  final TrackMetadata track;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final bool isPlaying;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            // Index or equalizer
            SizedBox(
              width: 28,
              child: isPlaying
                  ? const Icon(Icons.equalizer_rounded,
                      color: AppColors.phonkRed, size: 18)
                  : Text('$index',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      )),
            ),
            const SizedBox(width: 10),
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: track.thumbnailUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: track.thumbnailUrl,
                      width: 46, height: 46,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _Placeholder(size: 46),
                    )
                  : _Placeholder(size: 46),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(track.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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

// ── Playlist Card ───────────────────────────────────────────────────────────────
class _PlaylistCard extends StatelessWidget {
  const _PlaylistCard({required this.playlist, required this.onTap});
  final PlaylistSummary playlist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: playlist.coverImageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: playlist.coverImageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (_, __, ___) => _PlaylistCoverPlaceholder(),
                      )
                    : _PlaylistCoverPlaceholder(),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(playlist.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      )),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text('${playlist.trackCount} tracks',
                          style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.textMuted,
                          )),
                      if (playlist.isPrivate) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.lock_outline_rounded,
                            size: 11, color: AppColors.textMuted),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Create Playlist Card ─────────────────────────────────────────────────────────
class _CreatePlaylistCard extends StatelessWidget {
  const _CreatePlaylistCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.phonkRed.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: AppColors.phonkRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.phonkRed.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(Icons.add_rounded,
                  color: AppColors.phonkRed, size: 26),
            ),
            const SizedBox(height: 12),
            Text('New Playlist',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                )),
            const SizedBox(height: 4),
            Text('Create a new one',
                style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textMuted,
                )),
          ],
        ),
      ),
    );
  }
}

// ── Create Playlist Bottom Sheet ─────────────────────────────────────────────────
class _CreatePlaylistSheet extends StatefulWidget {
  const _CreatePlaylistSheet({required this.controller});
  final TextEditingController controller;

  @override
  State<_CreatePlaylistSheet> createState() => _CreatePlaylistSheetState();
}

class _CreatePlaylistSheetState extends State<_CreatePlaylistSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('New Playlist',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                )),
            const SizedBox(height: 4),
            Text('Give your playlist a name.',
                style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textMuted,
                )),
            const SizedBox(height: 20),
            TextField(
              controller: widget.controller,
              autofocus: true,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary, fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Midnight Drift',
                hintStyle: GoogleFonts.inter(
                  color: AppColors.textMuted, fontSize: 15,
                ),
                prefixIcon: const Icon(Icons.queue_music_rounded,
                    color: AppColors.textMuted, size: 20),
                filled: true,
                fillColor: AppColors.bgElevated,
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
                  borderSide:
                      const BorderSide(color: AppColors.phonkRed, width: 1.5),
                ),
              ),
              onSubmitted: (_) => Navigator.pop(context, true),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.bgElevated,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Center(
                        child: Text('Cancel',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.phonkRed,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.phonkRed.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text('Create',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared helpers ──────────────────────────────────────────────────────────────
class _StatStrip extends StatelessWidget {
  const _StatStrip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                )),
            Text(label,
                style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textMuted,
                )),
          ],
        ),
      ),
    );
  }
}

class _PlaylistCoverPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgElevated,
      child: const Center(
        child: Icon(Icons.queue_music_rounded,
            color: AppColors.textMuted, size: 32),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      color: AppColors.bgElevated,
      child: const Icon(Icons.music_note_rounded,
          color: AppColors.textMuted, size: 20),
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  const _ShimmerTile();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded,
              color: AppColors.textMuted, size: 40),
          const SizedBox(height: 12),
          Text(message,
              style: GoogleFonts.inter(
                fontSize: 14, color: AppColors.textSecondary,
              )),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onRetry,
            child: Text('Retry',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.phonkRed,
                  fontWeight: FontWeight.w700,
                )),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Icon(icon, color: AppColors.textMuted, size: 32),
            ),
            const SizedBox(height: 16),
            Text(title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                )),
            const SizedBox(height: 8),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.5,
                )),
            if (action != null && onAction != null) ...[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.phonkRed,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.phonkRed.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(action!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
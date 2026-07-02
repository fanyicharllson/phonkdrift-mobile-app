import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../controllers/track_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.controller});
  final TrackController controller;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  Timer? _debounce;

  // Quick search chips
  final List<String> _quickSearches = [
    'phonk drift',
    'underground phonk',
    'slowed reverb',
    'dark phonk',
    'rage beats',
    'phonk remix',
    'car music',
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onUpdate);
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onUpdate);
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onUpdate() {
    if (!mounted) return;
    setState(() {});
    if (widget.controller.playError.isNotEmpty) {
      PhonkToast.show(
        context,
        message: widget.controller.playError,
        type: ToastType.error,
      );
    }
  }

  void _onSearchChanged(String val) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.controller.search(val);
    });
    setState(() {});
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      if (widget.controller.searchState == TrackLoadState.loaded) {
        widget.controller.search(_searchCtrl.text, loadMore: true);
      }
    }
  }

  void _showOptions(TrackMetadata track) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _TrackOptionsSheet(
        track: track,
        isLiked: widget.controller.isLiked(track.trackId),
        onPlay: () {
          Navigator.pop(context);
          widget.controller.playTrack(track, context);
        },
        onLike: () {
          Navigator.pop(context);
          widget.controller.toggleLike(track.trackId);
        },
        onYouTube: () {
          Navigator.pop(context);
          // url_launcher handled in controller
          widget.controller.playTrack(track, context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Text(
                'Search',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -1,
                ),
              ),
            ),

            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _searchCtrl.text.isNotEmpty
                        ? AppColors.phonkRed.withValues(alpha: 0.5)
                        : AppColors.borderSubtle,
                  ),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: false,
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Tracks, artists, vibes...',
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.textMuted,
                      fontSize: 15,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.textMuted,
                      size: 22,
                    ),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchCtrl.clear();
                              widget.controller.search('');
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppColors.textMuted,
                              size: 20,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Expanded(
              child: _searchCtrl.text.trim().isEmpty
                  ? _buildIdleState()
                  : _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Idle state — quick search chips ────────────────────────────────────────
  Widget _buildIdleState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Search',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _quickSearches.map((q) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  _searchCtrl.text = q;
                  widget.controller.search(q);
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        color: AppColors.phonkRed,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        q,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          // Genre grid
          Text(
            'Browse Genres',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.4,
            children: [
              _GenreCard(
                label: 'Dark Phonk',
                color: const Color(0xFF3D0010),
                onTap: () {
                  _searchCtrl.text = 'dark phonk';
                  widget.controller.search('dark phonk');
                  setState(() {});
                },
              ),
              _GenreCard(
                label: 'Slowed',
                color: const Color(0xFF001A3D),
                onTap: () {
                  _searchCtrl.text = 'slowed phonk';
                  widget.controller.search('slowed phonk');
                  setState(() {});
                },
              ),
              _GenreCard(
                label: 'Underground',
                color: const Color(0xFF1A0030),
                onTap: () {
                  _searchCtrl.text = 'underground phonk';
                  widget.controller.search('underground phonk');
                  setState(() {});
                },
              ),
              _GenreCard(
                label: 'Rage',
                color: const Color(0xFF2D0000),
                onTap: () {
                  _searchCtrl.text = 'rage phonk';
                  widget.controller.search('rage phonk');
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Results ─────────────────────────────────────────────────────────────────
  Widget _buildResults() {
    final state = widget.controller.searchState;
    final tracks = widget.controller.searchTracks;

    if (state == TrackLoadState.loading && tracks.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: 8,
        itemBuilder: (_, __) => const _ShimmerTile(),
      );
    }

    if (state == TrackLoadState.error && tracks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_off_rounded,
                color: AppColors.textMuted,
                size: 44,
              ),
              const SizedBox(height: 16),
              Text(
                'Search failed. Check your connection.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => widget.controller.search(_searchCtrl.text),
                child: Text(
                  'Retry',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.phonkRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (tracks.isEmpty && state == TrackLoadState.loaded) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.music_off_rounded,
              color: AppColors.textMuted,
              size: 44,
            ),
            const SizedBox(height: 12),
            Text(
              'No tracks found for "${_searchCtrl.text}"',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 160),
      itemCount: tracks.length + (state == TrackLoadState.loading ? 3 : 0),
      itemBuilder: (_, i) {
        if (i >= tracks.length) return const _ShimmerTile();
        final track = tracks[i];
        return _SearchResultTile(
          track: track,
          isPlaying: widget.controller.nowPlaying?.trackId == track.trackId,
          isLiked: widget.controller.isLiked(track.trackId),
          onTap: () => widget.controller.playTrack(track, context),
          onLike: () => widget.controller.toggleLike(track.trackId),
          onOptions: () => _showOptions(track),
        );
      },
    );
  }
}

// ── Search Result Tile ──────────────────────────────────────────────────────────
class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.track,
    required this.onTap,
    required this.onLike,
    required this.onOptions,
    this.isPlaying = false,
    this.isLiked = false,
  });

  final TrackMetadata track;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onOptions;
  final bool isPlaying;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: track.thumbnailUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: track.thumbnailUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _Placeholder(size: 50),
                    )
                  : _Placeholder(size: 50),
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
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    track.artistName,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                onLike();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isLiked ? AppColors.phonkRed : AppColors.textMuted,
                  size: 20,
                ),
              ),
            ),
            GestureDetector(
              onTap: onOptions,
              child: const Icon(
                Icons.more_vert_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Genre Card ──────────────────────────────────────────────────────────────────
class _GenreCard extends StatelessWidget {
  const _GenreCard({
    required this.label,
    required this.color,
    required this.onTap,
  });
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.phonkRed.withValues(alpha: 0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(
                Icons.graphic_eq_rounded,
                color: AppColors.phonkRed,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Track Options Sheet ─────────────────────────────────────────────────────────
class _TrackOptionsSheet extends StatelessWidget {
  const _TrackOptionsSheet({
    required this.track,
    required this.onPlay,
    required this.onLike,
    required this.onYouTube,
    this.isLiked = false,
  });

  final TrackMetadata track;
  final VoidCallback onPlay;
  final VoidCallback onLike;
  final VoidCallback onYouTube;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Track info header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: track.thumbnailUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: track.thumbnailUrl,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 48,
                            height: 48,
                            color: AppColors.bgElevated,
                            child: const Icon(
                              Icons.music_note_rounded,
                              color: AppColors.textMuted,
                            ),
                          ),
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
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          track.artistName,
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
            const Divider(color: AppColors.borderSubtle, height: 1),
            ListTile(
              leading: const Icon(
                Icons.play_arrow_rounded,
                color: AppColors.phonkRed,
              ),
              title: Text(
                'Play now',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: onPlay,
            ),
            ListTile(
              leading: Icon(
                isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isLiked ? AppColors.phonkRed : AppColors.textSecondary,
              ),
              title: Text(
                isLiked ? 'Unlike' : 'Like',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: onLike,
            ),
            if (track.originalYoutubeId.isNotEmpty)
              ListTile(
                leading: const Icon(
                  Icons.open_in_new_rounded,
                  color: AppColors.textSecondary,
                ),
                title: Text(
                  'Open in YouTube',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: onYouTube,
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  const _ShimmerTile();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      height: 74,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
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
      width: size,
      height: size,
      color: AppColors.bgElevated,
      child: const Icon(
        Icons.music_note_rounded,
        color: AppColors.textMuted,
        size: 20,
      ),
    );
  }
}

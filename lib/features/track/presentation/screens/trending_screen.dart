import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../../data/repositories/track_repository.dart';
import '../controllers/track_controller.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key, required this.controller});
  final TrackController controller;

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  List<TrackMetadata> _tracks = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerUpdate);
    _load();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
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

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final res = await TrackRepository.instance.getForYouTracks(limit: 50);
      if (mounted) {
        setState(() {
          _tracks = res;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Background orb
          Positioned(
            top: -40,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.phonkRed.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Premium app bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 160,
                pinned: true,
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary,
                      size: 16,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.phonkRed.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.phonkRed.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.trending_up_rounded,
                                    color: AppColors.phonkRed,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'LIVE',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.phonkRed,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Trending\nPhonk',
                          style: GoogleFonts.inter(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            letterSpacing: -1.2,
                            height: 1.05,
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    'Trending Phonk',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
                ),
              ),

              // Track count pill
              if (!_isLoading && _tracks.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bgSurface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: Text(
                            '${_tracks.length} tracks',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Content
              if (_isLoading)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => const _ShimmerTile(),
                    childCount: 10,
                  ),
                )
              else if (_error.isNotEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.wifi_off_rounded,
                          color: AppColors.textMuted,
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Could not load trending tracks.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _load,
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
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _TrendingTile(
                      rank: i + 1,
                      track: _tracks[i],
                      isPlaying:
                          widget.controller.nowPlaying?.trackId ==
                          _tracks[i].trackId,
                      isLiked: widget.controller.isLiked(_tracks[i].trackId),
                      onTap: () =>
                          widget.controller.playTrack(_tracks[i], context),
                      onLike: () =>
                          widget.controller.toggleLike(_tracks[i].trackId),
                    ),
                    childCount: _tracks.length,
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 160)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendingTile extends StatelessWidget {
  const _TrendingTile({
    required this.rank,
    required this.track,
    required this.onTap,
    required this.onLike,
    this.isPlaying = false,
    this.isLiked = false,
  });

  final int rank;
  final TrackMetadata track;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final bool isPlaying;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    final isTop3 = rank <= 3;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPlaying
              ? AppColors.phonkRed.withValues(alpha: 0.07)
              : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPlaying
                ? AppColors.phonkRed.withValues(alpha: 0.3)
                : AppColors.borderSubtle,
          ),
          boxShadow: isTop3
              ? [
                  BoxShadow(
                    color: AppColors.phonkRed.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Rank number
            SizedBox(
              width: 36,
              child: Text(
                rank <= 3 ? _rankIcon(rank) : '$rank',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: rank <= 3 ? 20 : 14,
                  fontWeight: FontWeight.w900,
                  color: rank <= 3 ? AppColors.phonkRed : AppColors.textMuted,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: track.thumbnailUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: track.thumbnailUrl,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _Placeholder(size: 52),
                    )
                  : _Placeholder(size: 52),
            ),

            const SizedBox(width: 12),

            // Info
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
                  const SizedBox(height: 3),
                  Text(
                    track.artistName,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
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
              ),
            ),

            // Like + playing indicator
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onLike();
                  },
                  child: Icon(
                    isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isLiked ? AppColors.phonkRed : AppColors.textMuted,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  isPlaying
                      ? Icons.equalizer_rounded
                      : Icons.play_circle_outline_rounded,
                  color: isPlaying ? AppColors.phonkRed : AppColors.textMuted,
                  size: 22,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _rankIcon(int rank) {
    return ['1', '2', '3'][rank - 1];
  }
}

class _ShimmerTile extends StatelessWidget {
  const _ShimmerTile();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      height: 76,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
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
        size: 22,
      ),
    );
  }
}

String _formatCount(int count) {
  if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
  if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
  return '$count';
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../../../core/utils/storage_helper.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../controllers/track_controller.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TrackController();
  final _pageController = PageController();
  String _phonkLevel = '';
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerUpdate);
    _loadData();
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    setState(() {});
    if (_controller.playError.isNotEmpty) {
      PhonkToast.show(
        context,
        message: _controller.playError,
        type: ToastType.error,
      );
    }
  }

  Future<void> _loadData() async {
    final level = await StorageHelper.instance.getPhonkLevel();
    if (mounted) setState(() => _phonkLevel = level ?? '');
    await _controller.loadHomeData();
  }

  Future<void> _logout() async {
    await StorageHelper.instance.clearSession();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      extendBody: true,
      body: Stack(
        children: [
          // ── Background gradient orb ──────────────────────────────────────
          Positioned(
            top: -60,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.phonkRed.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6B00FF).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Main scroll content ──────────────────────────────────────────
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              HapticFeedback.selectionClick();
              setState(() => _selectedTab = index);
            },
            children: [
              _buildHomePage(),
              _buildPlaceholderPage('Search coming soon'),
              _buildPlaceholderPage('Community coming soon'),
              _buildPlaceholderPage('Library coming soon'),
              _buildPlaceholderPage('Profile coming soon'),
            ],
          ),

          // ── Mini player + floating nav ───────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_controller.hasNowPlaying) _buildMiniPlayer(),
                _buildFloatingNav(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHomePage() {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: AppColors.phonkRed,
        backgroundColor: AppColors.bgSurface,
        onRefresh: _controller.loadHomeData,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildCategoryPills()),
            SliverToBoxAdapter(child: _buildSectionHeader('For You')),
            SliverToBoxAdapter(child: _buildForYouSection()),
            SliverToBoxAdapter(
              child: _buildSectionHeader('Recently Played', showSeeAll: true),
            ),
            _buildRecentlyPlayed(),
            const SliverToBoxAdapter(child: SizedBox(height: 160)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderPage(String message) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Center(
        child: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  void _selectTab(int index) {
    HapticFeedback.selectionClick();
    setState(() => _selectedTab = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _openTrackOptions(TrackMetadata track) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TrackOptionTile(
                  icon: Icons.play_arrow_rounded,
                  label: 'Play',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _controller.playTrack(track, context);
                  },
                ),
                if (track.originalYoutubeId.isNotEmpty)
                  _TrackOptionTile(
                    icon: Icons.open_in_new_rounded,
                    label: 'Open in YouTube',
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      final url = Uri.parse(
                        'https://www.youtube.com/watch?v=${track.originalYoutubeId}',
                      );
                      launchUrl(url, mode: LaunchMode.externalApplication);
                    },
                  ),
                _TrackOptionTile(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    final youtubeUrl = track.originalYoutubeId.isNotEmpty
                        ? '\nhttps://www.youtube.com/watch?v=${track.originalYoutubeId}'
                        : '';
                    Share.share(
                      '${track.title} by ${track.artistName}$youtubeUrl',
                    );
                  },
                ),
                _TrackOptionTile(
                  icon: Icons.close_rounded,
                  label: 'Dismiss',
                  onTap: () => Navigator.of(sheetContext).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good ${_greeting()},',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'PhonkDrift',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.8,
                      ),
                    ),
                    if (_phonkLevel.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.phonkRed.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.phonkRed.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          _phonkLevel[0] +
                              _phonkLevel.substring(1).toLowerCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.phonkRed,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Search icon
          _NavIconBtn(
            icon: Icons.search_rounded,
            onTap: () => _selectTab(1),
          ),
          const SizedBox(width: 8),
          // Avatar / logout
          GestureDetector(
            onTap: _logout,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.phonkRed, Color(0xFF8B0034)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category pills ───────────────────────────────────────────────────────────
  final List<String> _categories = ['All', 'Trending', 'New', 'Underground'];
  int _selectedCategory = 0;

  Widget _buildCategoryPills() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final selected = _selectedCategory == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.phonkRed
                    : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? AppColors.phonkRed
                      : AppColors.borderSubtle,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.phonkRed.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ]
                    : [],
              ),
              child: Text(
                _categories[i],
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Colors.white
                      : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Section header ───────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, {bool showSeeAll = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          if (showSeeAll)
            Text(
              'See all',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.phonkRed,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  // ── For You horizontal cards ─────────────────────────────────────────────────
  Widget _buildForYouSection() {
    if (_controller.forYouState == TrackLoadState.loading) {
      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: 4,
          itemBuilder: (_, __) => const _ShimmerCard(
            width: 160,
            height: 200,
          ),
        ),
      );
    }

    if (_controller.forYouState == TrackLoadState.error) {
      return _ErrorTile(
        message: _controller.forYouError,
        onRetry: _controller.loadForYou,
      );
    }

    if (_controller.forYouTracks.isEmpty) {
      return const _EmptyTile(message: 'No tracks found. Pull to refresh.');
    }

    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _controller.forYouTracks.length,
        itemBuilder: (_, i) => _ForYouCard(
          track: _controller.forYouTracks[i],
          onTap: () => _controller.playTrack(
            _controller.forYouTracks[i],
            context,
          ),
          onOptionsTap: () => _openTrackOptions(_controller.forYouTracks[i]),
        ),
      ),
    );
  }

  // ── Recently Played list ─────────────────────────────────────────────────────
  Widget _buildRecentlyPlayed() {
    if (_controller.recentState == TrackLoadState.loading) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, __) => const _ShimmerListTile(),
          childCount: 4,
        ),
      );
    }

    if (_controller.recentTracks.isEmpty) {
      return SliverToBoxAdapter(
        child: _EmptyTile(
          message: 'No recently played tracks yet.',
          icon: Icons.history_rounded,
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, i) => _RecentTrackTile(
          track: _controller.recentTracks[i],
          isPlaying: _controller.nowPlaying?.trackId ==
              _controller.recentTracks[i].trackId,
          onTap: () => _controller.playTrack(
            _controller.recentTracks[i],
            context,
          ),
          onOptionsTap: () => _openTrackOptions(_controller.recentTracks[i]),
        ),
        childCount: _controller.recentTracks.length,
      ),
    );
  }

  // ── Mini player ──────────────────────────────────────────────────────────────
 Widget _buildMiniPlayer() {
  final track = _controller.nowPlaying!;
  final progress = _controller.duration.inSeconds > 0
      ? _controller.position.inSeconds / _controller.duration.inSeconds
      : 0.0;

  return GestureDetector(
    onTap: () => _controller.playTrack(track, context),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bgElevated.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.phonkRed.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.phonkRed.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: track.thumbnailUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: track.thumbnailUrl,
                          width: 44, height: 44,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              _TrackPlaceholder(size: 44),
                        )
                      : _TrackPlaceholder(size: 44),
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
                            fontSize: 13, fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          )),
                      const SizedBox(height: 2),
                      Text(track.artistName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textMuted,
                          )),
                    ],
                  ),
                ),
                if (_controller.isLoadingStream)
                  const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.phonkRed,
                    ),
                  )
                else
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _controller.togglePlayPause();
                        },
                        child: Icon(
                          _controller.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: AppColors.phonkRed, size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _controller.clearNowPlaying();
                        },
                        child: const Icon(Icons.close_rounded,
                            color: AppColors.textMuted, size: 20),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Progress bar
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(18)),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: AppColors.borderSubtle,
              valueColor: const AlwaysStoppedAnimation(AppColors.phonkRed),
              minHeight: 3,
            ),
          ),
        ],
      ),
    ),
  );
}
  // ── Floating bottom nav ──────────────────────────────────────────────────────
  Widget _buildFloatingNav() {
    const tabs = [
      (Icons.home_rounded, Icons.home_outlined, 'Home'),
      (Icons.search_rounded, Icons.search_outlined, 'Search'),
      (Icons.people_rounded, Icons.people_outline_rounded, 'Community'),
      (Icons.library_music_rounded, Icons.library_music_outlined, 'Library'),
      (Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgElevated.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (i) {
          final selected = _selectedTab == i;
          final tab = tabs[i];
          return GestureDetector(
            onTap: () {
              _selectTab(i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.phonkRed.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Icon(
                    selected ? tab.$1 : tab.$2,
                    color: selected ? AppColors.phonkRed : AppColors.textMuted,
                    size: 22,
                  ),
                  if (selected) ...[
                    const SizedBox(width: 6),
                    Text(
                      tab.$3,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.phonkRed,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }
}

// ── For You Card ────────────────────────────────────────────────────────────────
class _ForYouCard extends StatelessWidget {
  const _ForYouCard({
    required this.track,
    required this.onTap,
    required this.onOptionsTap,
  });
  final TrackMetadata track;
  final VoidCallback onTap;
  final VoidCallback onOptionsTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: track.thumbnailUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: track.thumbnailUrl,
                          width: 160,
                          height: 120,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              _TrackPlaceholder(size: 120, width: 160),
                        )
                      : _TrackPlaceholder(size: 120, width: 160),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: _TrackMoreButton(onTap: onOptionsTap),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    track.artistName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.play_circle_filled_rounded,
                          color: AppColors.phonkRed, size: 16),
                      const SizedBox(width: 4),
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
          ],
        ),
      ),
    );
  }
}

// ── Recently Played Tile ────────────────────────────────────────────────────────
class _RecentTrackTile extends StatelessWidget {
  const _RecentTrackTile({
    required this.track,
    required this.onTap,
    required this.onOptionsTap,
    this.isPlaying = false,
  });
  final TrackMetadata track;
  final VoidCallback onTap;
  final VoidCallback onOptionsTap;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPlaying
              ? AppColors.phonkRed.withValues(alpha: 0.06)
              : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPlaying ? AppColors.phonkRed.withValues(alpha: 0.3) : AppColors.borderSubtle,
          ),
        ),
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
                      errorWidget: (_, __, ___) => _TrackPlaceholder(size: 48),
                    )
                  : _TrackPlaceholder(size: 48),
            ),
            const SizedBox(width: 14),
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
            Text(
              track.duration,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(width: 6),
            _TrackMoreButton(onTap: onOptionsTap),
            const SizedBox(width: 6),
            Icon(
              isPlaying
                  ? Icons.equalizer_rounded
                  : Icons.play_circle_outline_rounded,
              color: isPlaying ? AppColors.phonkRed : AppColors.textMuted,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared UI helpers ───────────────────────────────────────────────────────────
class _TrackPlaceholder extends StatelessWidget {
  const _TrackPlaceholder({required this.size, this.width});
  final double size;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? size,
      height: size,
      color: AppColors.bgElevated,
      child: const Icon(Icons.music_note_rounded,
          color: AppColors.textMuted, size: 24),
    );
  }
}

class _NavIconBtn extends StatelessWidget {
  const _NavIconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }
}

class _TrackMoreButton extends StatelessWidget {
  const _TrackMoreButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.bgElevated.withValues(alpha: 0.82),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: const Icon(
          Icons.more_vert,
          color: AppColors.textPrimary,
          size: 18,
        ),
      ),
    );
  }
}

class _TrackOptionTile extends StatelessWidget {
  const _TrackOptionTile({
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

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.width, required this.height});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _ShimmerListTile extends StatelessWidget {
  const _ShimmerListTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}

class _ErrorTile extends StatelessWidget {
  const _ErrorTile({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          Text(message,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onRetry,
            child: Text('Retry',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.phonkRed,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ],
      ),
    );
  }
}

class _EmptyTile extends StatelessWidget {
  const _EmptyTile({required this.message, this.icon});
  final String message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        children: [
          Icon(icon ?? Icons.music_off_rounded,
              color: AppColors.textMuted, size: 32),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

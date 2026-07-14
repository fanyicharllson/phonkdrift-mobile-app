import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../../../core/utils/push_notification_service.dart';
import '../../../../core/utils/storage_helper.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../controllers/track_controller.dart';
import 'trending_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/screens/profile_screen.dart';
import 'player_screen.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import '../widgets/add_to_playlist_sheet.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/feedback_prompt_sheet.dart';
import '../widgets/play_pause_button.dart';
import '../widgets/playing_equalizer.dart';
import '../../../community/presentation/widgets/community_gate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _controller = TrackController();
  final _pageController = PageController();
  final _searchCtrl = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _searchDebounce;
  StreamSubscription<TrendingPushPayload>? _trendingPushSub;
  bool _isPlayerScreenOpen = false;

  String _phonkLevel = '';
  String _username = '';
  String _avatarUrl = '';
  int _selectedTab = 0;
  int _selectedCategory = 0;

  final List<String> _categories = ['All', 'Trending', 'New', 'Underground'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.addListener(_onControllerUpdate);
    _searchCtrl.addListener(_onSearchChanged);
    _loadData();
    _trendingPushSub = PushNotificationService.instance.onTrendingPush.listen((
      payload,
    ) {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TrendingScreen(controller: _controller),
        ),
      );
    });

    // Catch a push that was tapped while the app was fully killed — it fires
    // via getInitialMessage before this screen (and the listener above)
    // exists, so the live stream above alone would miss it.
    if (PushNotificationService.instance.consumePendingTrending() != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TrendingScreen(controller: _controller),
          ),
        );
      });
    }
  }

  // Covers reopening the app via the now-playing notification, since Android
  // gives no way to distinguish that from any other app-resume.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _controller.hasNowPlaying &&
        !_isPlayerScreenOpen) {
      _openPlayerScreen();
    }
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 350),
      () => _controller.search(_searchCtrl.text),
    );
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
    if (_controller.shouldPromptFeedback) {
      // Flip the flag immediately so rapid notifyListeners() ticks
      // (position updates fire many times a second) can't double-trigger.
      _controller.markFeedbackPrompted();
      showFeedbackPromptSheet(context);
    }
  }

  Future<void> _loadData() async {
    final results = await Future.wait([
      StorageHelper.instance.getPhonkLevel(),
      StorageHelper.instance.getUsername(),
      StorageHelper.instance.getAvatarUrl(),
    ]);
    if (mounted) {
      setState(() {
        _phonkLevel = results[0] ?? '';
        _username = results[1] ?? '';
        _avatarUrl = results[2] ?? '';
      });
    }
    await _controller.loadHomeData();
  }

  Widget _headerAvatarFallback() {
    return const Icon(
      Icons.person_outline_rounded,
      color: Colors.white,
      size: 20,
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_onControllerUpdate);
    _pageController.dispose();
    _searchDebounce?.cancel();
    _trendingPushSub?.cancel();
    _searchCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgDeep,
      extendBody: true,
      endDrawer: AppSidebar(onProfileTap: () => _selectTab(4)),
      body: Stack(
        children: [
          // ── Background glow orbs ───────────────────────────────────────
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
                    AppColors.phonkRed.withValues(alpha: 0.15),
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
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6B00FF).withValues(alpha: 0.07),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Pages ──────────────────────────────────────────────────────
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              HapticFeedback.selectionClick();
              setState(() => _selectedTab = index);
            },
            children: [
              _buildHomePage(),
              SearchScreen(controller: _controller),
              const CommunityGate(),
              LibraryScreen(controller: _controller),
              const ProfileScreen(),
            ],
          ),

          // ── Mini player + bottom nav ───────────────────────────────────
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

  // ── Home page ──────────────────────────────────────────────────────────────
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
            SliverToBoxAdapter(child: _buildStatsRow()),
            SliverToBoxAdapter(child: _buildCategoryPills()),
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                'For You',
                showSeeAll: true,
                seeAllLabel: 'Trending Phonk',
                seeAllIcon: Icons.trending_up_rounded,
                onSeeAll: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TrendingScreen(controller: _controller),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: _buildForYouSection()),
            SliverToBoxAdapter(
              child: _buildSectionHeader('Recently Played', showSeeAll: true),
            ),
            _buildRecentlyPlayed(),
            const SliverToBoxAdapter(child: SizedBox(height: 180)),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    final displayName = _username.isNotEmpty ? _username : 'Drifter';
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dynamic captivating greeting
                Text(
                  _dynamicGreeting(displayName),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'PhonkDrift',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.phonkRed,
                        letterSpacing: -1,
                      ),
                    ),
                    if (_phonkLevel.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.phonkRed.withValues(alpha: 0.2),
                              const Color(0xFF6B00FF).withValues(alpha: 0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.phonkRed.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          _phonkLevel[0] +
                              _phonkLevel.substring(1).toLowerCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.phonkRed,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Profile avatar + 3-dot menu
          Row(
            children: [
              GestureDetector(
                onTap: () => _selectTab(4),
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
                    border: Border.all(
                      color: AppColors.phonkRed.withValues(alpha: 0.3),
                    ),
                  ),
                  child: ClipOval(
                    child: _avatarUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: _avatarUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                _headerAvatarFallback(),
                          )
                        : _headerAvatarFallback(),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: const Icon(
                    Icons.menu_rounded,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Dynamic captivating greetings — add this method to _HomeScreenState
  String _dynamicGreeting(String name) {
    final hour = DateTime.now().hour;
    final greetings = {
      'morning': [
        'Rise and drift, $name',
        'Morning shift starts now, $name',
        'The underground never sleeps, $name',
      ],
      'afternoon': [
        'Still drifting, $name?',
        'Keep the energy up, $name',
        'Midday phonk incoming, $name',
      ],
      'evening': [
        'Night mode activated, $name',
        'The drift gets darker, $name',
        'Underground hour, $name',
      ],
    };

    String period;
    if (hour < 12) {
      period = 'morning';
    } else if (hour < 17) {
      period = 'afternoon';
    } else {
      period = 'evening';
    }

    final list = greetings[period]!;
    // Rotate based on day of month so it changes daily
    return list[DateTime.now().day % list.length];
  }

  // ── Stats row ────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    final playedCount = _controller.recentTracks.length;
    final likedCount = _controller.likedTrackIds.length;
    final savedCount = _controller.forYouTracks
        .map((t) => t.trackId)
        .where((id) => id.isNotEmpty)
        .toSet()
        .length;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 12, 24, 10),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                icon: Icons.headphones_rounded,
                label: '$playedCount played',
              ),
            ),
            VerticalDivider(
              color: AppColors.borderSubtle,
              thickness: 1,
              width: 1,
            ),
            Expanded(
              child: _StatItem(
                icon: Icons.favorite_border_rounded,
                label: '$likedCount liked',
              ),
            ),
            VerticalDivider(
              color: AppColors.borderSubtle,
              thickness: 1,
              width: 1,
            ),
            Expanded(
              child: _StatItem(
                icon: Icons.queue_music_rounded,
                label: '$savedCount saved',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Category pills ────────────────────────────────────────────────────────
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
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10, top: 4, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: selected ? AppColors.phonkRed : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? AppColors.phonkRed : AppColors.borderSubtle,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.phonkRed.withValues(alpha: 0.3),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
              // Center child vertically — no vertical padding, use alignment
              alignment: Alignment.center,
              child: Text(
                _categories[i],
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textSecondary,
                  height: 1.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Section header ────────────────────────────────────────────────────────
  Widget _buildSectionHeader(
    String title, {
    bool showSeeAll = false,
    String seeAllLabel = 'See all',
    IconData seeAllIcon = Icons.arrow_forward_rounded,
    VoidCallback? onSeeAll,
  }) {
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
            GestureDetector(
              onTap: onSeeAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(seeAllIcon, size: 16, color: AppColors.phonkRed),
                  const SizedBox(width: 4),
                  Text(
                    seeAllLabel,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.phonkRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── For You ───────────────────────────────────────────────────────────────
  Widget _buildForYouSection() {
    if (_controller.forYouState == TrackLoadState.loading) {
      return SizedBox(
        height: 210,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: 4,
          itemBuilder: (_, __) => const _ShimmerCard(width: 160, height: 210),
        ),
      );
    }

    if (_controller.forYouState == TrackLoadState.error) {
      return _SmartErrorTile(
        message: _controller.forYouError,
        onRetry: _controller.loadForYou,
        onLogin: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        ),
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
        itemCount: _controller.forYouTracks.length > 5
            ? 5
            : _controller.forYouTracks.length,
        itemBuilder: (_, i) {
          final track = _controller.forYouTracks[i];
          return _ForYouCard(
            track: track,
            isPlaying: _controller.nowPlaying?.trackId == track.trackId,
            isLiked: _controller.isLiked(track.trackId),
            onLike: () => _toggleLike(track),
            onTap: () => _controller.playTrack(
              track,
              context,
              queue: _controller.forYouTracks,
            ),
            onOptionsTap: () =>
                _showTrackOptions(track, queue: _controller.forYouTracks),
          );
        },
      ),
    );
  }

  // ── Recently Played ───────────────────────────────────────────────────────
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
          isPlaying:
              _controller.nowPlaying?.trackId ==
              _controller.recentTracks[i].trackId,
          onTap: () => _controller.playTrack(
            _controller.recentTracks[i],
            context,
            queue: _controller.recentTracks,
          ),
          onOptionsTap: () => _openTrackOptions(
            _controller.recentTracks[i],
            queue: _controller.recentTracks,
          ),
        ),
        childCount: _controller.recentTracks.length > 5
            ? 5
            : _controller.recentTracks.length,
      ),
    );
  }

  // ── Player screen navigation ────────────────────────────────────────────────
  void _openPlayerScreen() {
    if (_isPlayerScreenOpen) return;
    _isPlayerScreenOpen = true;
    Navigator.of(context)
        .push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => PlayerScreen(controller: _controller),
            transitionsBuilder: (_, anim, __, child) => SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                  ),
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 380),
          ),
        )
        .then((_) => _isPlayerScreenOpen = false);
  }

  // ── Mini player ───────────────────────────────────────────────────────────
  Widget _buildMiniPlayer() {
    final track = _controller.nowPlaying!;
    final progress = _controller.duration.inSeconds > 0
        ? (_controller.position.inSeconds / _controller.duration.inSeconds)
              .clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: _openPlayerScreen,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgElevated,
              AppColors.phonkRed.withValues(alpha: 0.12),
            ],
          ),
          border: Border.all(
            color: AppColors.phonkRed.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.phonkRed.withValues(alpha: 0.2),
              blurRadius: 30,
              spreadRadius: 0,
              offset: const Offset(0, -6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar at TOP of mini player
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation(AppColors.phonkRed),
                minHeight: 2,
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                child: Row(
                  children: [
                    // Thumbnail with playing indicator
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: track.thumbnailUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: track.thumbnailUrl,
                                  width: 46,
                                  height: 46,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) =>
                                      _TrackPlaceholder(size: 46),
                                )
                              : _TrackPlaceholder(size: 46),
                        ),
                        if (_controller.isPlaying)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: PlayingEqualizer(size: 18),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(width: 12),

                    // Track info
                    Expanded(
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
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  track.artistName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Position / duration
                              Text(
                                '${_formatDuration(_controller.position)} / ${_formatDuration(_controller.duration)}',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                ),
                                overflow: TextOverflow.visible,
                                softWrap: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Controls
                    if (_controller.isLoadingStream)
                      const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.phonkRed,
                        ),
                      )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PlayPauseButton(
                            isPlaying: _controller.isPlaying,
                            size: 36,
                            iconSize: 20,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _controller.togglePlayPause();
                            },
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _controller.clearNowPlaying();
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppColors.textMuted,
                              size: 18,
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
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── Floating nav — sliding indicator, always-on labels ─────────────────────
  Widget _buildFloatingNav() {
    const tabs = [
      (Icons.home_rounded, Icons.home_outlined, 'Home'),
      (Icons.search_rounded, Icons.search_outlined, 'Search'),
      (Icons.people_rounded, Icons.people_outline_rounded, 'Community'),
      (Icons.library_music_rounded, Icons.library_music_outlined, 'Library'),
      (Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.bgElevated.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: AppColors.phonkRed.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.phonkRed.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / tabs.length;
          return Stack(
            children: [
              // Sliding active-tab indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                left: itemWidth * _selectedTab,
                top: 0,
                bottom: 0,
                width: itemWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.phonkRed.withValues(alpha: 0.22),
                          AppColors.phonkRed.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.phonkRed.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: List.generate(tabs.length, (i) {
                  final selected = _selectedTab == i;
                  final tab = tabs[i];
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _selectTab(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedScale(
                              scale: selected ? 1.08 : 1.0,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutBack,
                              child: Icon(
                                selected ? tab.$1 : tab.$2,
                                color: selected
                                    ? AppColors.phonkRed
                                    : AppColors.textMuted,
                                size: 21,
                              ),
                            ),
                            const SizedBox(height: 3),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 220),
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: selected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: selected
                                    ? AppColors.phonkRed
                                    : AppColors.textMuted,
                              ),
                              child: Text(
                                tab.$3,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Like with toast feedback ───────────────────────────────────────────────
  void _toggleLike(TrackMetadata track) {
    final willLike = !_controller.isLiked(track.trackId);
    _controller.toggleLike(track.trackId);
    PhonkToast.show(
      context,
      message: willLike ? 'Added to Liked Songs' : 'Removed from Liked Songs',
      type: ToastType.success,
    );
  }

  // ── Track options bottom sheet ────────────────────────────────────────────
  Future<void> _showTrackOptions(
    TrackMetadata track, {
    List<TrackMetadata>? queue,
  }) => _openTrackOptions(track, queue: queue);

  Future<void> _openTrackOptions(
    TrackMetadata track, {
    List<TrackMetadata>? queue,
  }) async {
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
              _TrackOptionTile(
                icon: Icons.play_arrow_rounded,
                label: 'Play',
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  _controller.playTrack(track, context, queue: queue);
                },
              ),
              _TrackOptionTile(
                icon: _controller.isLiked(track.trackId)
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                label: _controller.isLiked(track.trackId) ? 'Unlike' : 'Like',
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  _toggleLike(track);
                },
              ),
              _TrackOptionTile(
                icon: Icons.playlist_add_rounded,
                label: 'Add to Playlist',
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  showAddToPlaylistSheet(context, track: track);
                },
              ),
              if (track.originalYoutubeId.isNotEmpty)
                _TrackOptionTile(
                  icon: Icons.open_in_new_rounded,
                  label: 'Open in YouTube',
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    launchUrl(
                      Uri.parse(
                        'https://www.youtube.com/watch?v=${track.originalYoutubeId}',
                      ),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
              _TrackOptionTile(
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
              _TrackOptionTile(
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
}

// ── Smart Error Tile ──────────────────────────────────────────────────────────
class _SmartErrorTile extends StatelessWidget {
  const _SmartErrorTile({
    required this.message,
    required this.onRetry,
    required this.onLogin,
  });
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final lower = message.toLowerCase();
    final isAuthError =
        lower.contains('token') ||
        lower.contains('auth') ||
        lower.contains('unauthenticated');
    final isNetworkError =
        lower.contains('unavailable') || lower.contains('connection');

    final displayMessage = isAuthError
        ? 'Sign in required to load tracks.'
        : isNetworkError
        ? 'No connection. Check your internet.'
        : 'Could not load tracks.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          children: [
            Icon(
              isAuthError ? Icons.lock_outline_rounded : Icons.wifi_off_rounded,
              color: AppColors.textMuted,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              displayMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: isAuthError ? onLogin : onRetry,
              child: Text(
                isAuthError ? 'Sign in' : 'Retry',
                style: GoogleFonts.inter(
                  fontSize: 13,
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
}

// ── Stat Item ─────────────────────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  const _StatItem({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.phonkRed, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ── For You Card ──────────────────────────────────────────────────────────────
class _ForYouCard extends StatefulWidget {
  const _ForYouCard({
    required this.track,
    required this.onTap,
    required this.onOptionsTap,
    required this.isPlaying,
    required this.isLiked,
    required this.onLike,
  });
  final TrackMetadata track;
  final VoidCallback onTap;
  final VoidCallback onOptionsTap;
  final bool isPlaying;
  final bool isLiked;
  final VoidCallback onLike;

  @override
  State<_ForYouCard> createState() => _ForYouCardState();
}

class _ForYouCardState extends State<_ForYouCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  late Animation<double> _likeScale;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _likeScale = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(parent: _likeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  void _handleLike() {
    HapticFeedback.mediumImpact();
    _likeController.forward().then((_) => _likeController.reverse());
    widget.onLike();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 165,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: widget.isPlaying
              ? AppColors.phonkRed.withValues(alpha: 0.07)
              : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: widget.isPlaying
                ? AppColors.phonkRed.withValues(alpha: 0.42)
                : AppColors.borderSubtle,
            width: widget.isPlaying ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isPlaying
                  ? AppColors.phonkRed.withValues(alpha: 0.16)
                  : Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with overlays
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: widget.track.thumbnailUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.track.thumbnailUrl,
                          width: 165,
                          height: 125,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              _TrackPlaceholder(size: 125, width: 165),
                        )
                      : _TrackPlaceholder(size: 125, width: 165),
                ),
                // Gradient overlay bottom of image
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                // 3-dot options top right
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: widget.onOptionsTap,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                if (widget.isPlaying)
                  Positioned(
                    top: 8,
                    right: 36,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.phonkRed.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const PlayingEqualizer(size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'Playing',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Play count bottom left
                Positioned(
                  bottom: 6,
                  left: 8,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white70,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        _formatCount(widget.track.playCount),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.track.artistName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.track.duration,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      // TikTok-style like button
                      GestureDetector(
                        onTap: _handleLike,
                        child: ScaleTransition(
                          scale: _likeScale,
                          child: Row(
                            children: [
                              Icon(
                                widget.isLiked
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: widget.isLiked
                                    ? AppColors.phonkRed
                                    : AppColors.textMuted,
                                size: 16,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                _formatCount(widget.track.likesCount),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: widget.isLiked
                                      ? AppColors.phonkRed
                                      : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
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

String _formatCount(int count) {
  if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
  if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
  return '$count';
}

// ── Recently Played Tile ──────────────────────────────────────────────────────
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
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 6),
            _SourceBadge(storageUrl: track.storageUrl, compact: true),
            const SizedBox(width: 6),
            _TrackMoreButton(onTap: onOptionsTap),
            const SizedBox(width: 6),
            isPlaying
                ? const PlayingEqualizer(size: 20)
                : const Icon(
                    Icons.play_circle_outline_rounded,
                    color: AppColors.textMuted,
                    size: 24,
                  ),
          ],
        ),
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────
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
      child: const Icon(
        Icons.music_note_rounded,
        color: AppColors.textMuted,
        size: 24,
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

class _SourceBadge extends StatelessWidget {
  const _SourceBadge({required this.storageUrl, this.compact = false});

  final String storageUrl;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isCdn = storageUrl.trim().isNotEmpty;
    final bg = isCdn
        ? AppColors.phonkRed.withValues(alpha: 0.2)
        : AppColors.bgElevated.withValues(alpha: 0.85);
    final border = isCdn
        ? AppColors.phonkRed.withValues(alpha: 0.6)
        : AppColors.borderSubtle;
    final color = isCdn ? AppColors.phonkRed : AppColors.textMuted;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 7,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCdn
                ? Icons.play_circle_filled_rounded
                : Icons.wifi_tethering_rounded,
            color: color,
            size: compact ? 12 : 13,
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              isCdn ? 'CDN' : 'STREAM',
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ],
      ),
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
          Icon(
            icon ?? Icons.music_off_rounded,
            color: AppColors.textMuted,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

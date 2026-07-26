import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../../data/repositories/track_repository.dart';
import '../controllers/track_controller.dart';
import '../widgets/track_list_row.dart';

const kTrendingCategories = ['All', 'Trending', 'New', 'Underground'];

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({
    super.key,
    required this.controller,
    this.focusTrackId,
    this.initialCategory = 'All',
  });
  final TrackController controller;

  /// When set, once the list loads this screen scrolls to and briefly
  /// highlights the matching track — used for push-notification deep links.
  /// There's no single-track lookup endpoint on the backend, so this only
  /// works if the track happens to be in this batch; it's a graceful no-op
  /// otherwise (no crash, nothing weird — just an unhighlighted list).
  final String? focusTrackId;

  /// Pre-selects one of [kTrendingCategories] — set when arriving here from
  /// Home's category pills instead of the default "Trending Phonk" tap.
  final String initialCategory;

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  List<TrackMetadata> _allTracks = [];
  List<TrackMetadata> _filtered = [];
  bool _isLoading = true;
  String _error = '';
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  String? _highlightedTrackId;
  late String _selectedCategory = widget.initialCategory;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerUpdate);
    _load();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
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
    // Show the cached batch instantly (if we have one from earlier this
    // session) instead of a fresh spinner every time this screen is
    // reopened, then quietly refresh in the background.
    final cached = TrackRepository.instance.cachedForYouTracks;
    final hasCache = cached != null && cached.isNotEmpty;
    setState(() {
      _isLoading = !hasCache;
      _error = '';
      if (hasCache) {
        _allTracks = cached;
        _filtered = _computeFiltered();
      }
    });
    if (hasCache) _scrollToFocusTrackIfAny();

    try {
      final res = await TrackRepository.instance.getForYouTracks(limit: 50);
      if (mounted) {
        setState(() {
          _allTracks = res;
          _filtered = _computeFiltered();
          _isLoading = false;
        });
        if (!hasCache) _scrollToFocusTrackIfAny();
      }
    } catch (e) {
      if (mounted) {
        // A cached list already on screen is still useful even if the
        // refresh failed — only show the error state if we had nothing.
        setState(() {
          if (!hasCache) _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _scrollToFocusTrackIfAny() {
    final focusId = widget.focusTrackId;
    if (focusId == null || focusId.isEmpty) return;
    final index = _filtered.indexWhere((t) => t.trackId == focusId);
    if (index == -1) return; // not in this batch — quietly do nothing

    setState(() => _highlightedTrackId = focusId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollCtrl.hasClients) return;
      final maxExtent = _scrollCtrl.position.maxScrollExtent;
      if (maxExtent <= 0) return;
      // Proportional rather than a guessed per-item pixel height — stays
      // correct regardless of actual tile height.
      final fraction = index / _filtered.length;
      _scrollCtrl.animateTo(
        (fraction * maxExtent).clamp(0.0, maxExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _highlightedTrackId = null);
    });
  }

  void _onSearch(String val) {
    setState(() => _filtered = _computeFiltered());
  }

  void _onSelectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filtered = _computeFiltered();
    });
  }

  /// Combines the category sort/filter with the search query — search
  /// narrows within whichever category is active, not the other way round.
  ///
  /// "New" can't be genuinely sorted by upload recency: the backend's
  /// TrackMetadata has no timestamp field, so it falls back to the same
  /// order as "All" rather than faking a recency signal that isn't there.
  List<TrackMetadata> _computeFiltered() {
    List<TrackMetadata> result = _allTracks;
    switch (_selectedCategory) {
      case 'Trending':
        result = [...result]
          ..sort((a, b) => b.playCount.compareTo(a.playCount));
        break;
      case 'Underground':
        result = [...result]
          ..sort((a, b) => a.playCount.compareTo(b.playCount));
        break;
      case 'New':
      case 'All':
      default:
        break;
    }

    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where(
            (t) =>
                t.title.toLowerCase().contains(q) ||
                t.artistName.toLowerCase().contains(q),
          )
          .toList();
    }
    return result;
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

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Fixed header — no SliverAppBar ────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 38,
                          height: 38,
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
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.phonkRed.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: AppColors.phonkRed.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.trending_up_rounded,
                                        color: AppColors.phonkRed,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'LIVE',
                                        style: GoogleFonts.inter(
                                          fontSize: 9,
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
                            const SizedBox(height: 4),
                            Text(
                              'Trending Phonk',
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Track count badge
                      if (!_isLoading && _allTracks.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bgSurface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: Text(
                            '${_allTracks.length}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ── Search bar ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchCtrl,
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Filter trending tracks...',
                      hintStyle: GoogleFonts.inter(
                        color: AppColors.textMuted,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchCtrl.clear();
                                _onSearch('');
                              },
                              child: const Icon(
                                Icons.close_rounded,
                                color: AppColors.textMuted,
                                size: 18,
                              ),
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.bgSurface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.borderSubtle,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.borderSubtle,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.phonkRed,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Category pills ──────────────────────────────────────────
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: kTrendingCategories.length,
                    itemBuilder: (_, i) {
                      final category = kTrendingCategories[i];
                      final selected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () => _onSelectCategory(category),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.center,
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
                                      color: AppColors.phonkRed.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            category,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              height: 1.0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // ── Track list ─────────────────────────────────────────────
                Expanded(
                  child: _isLoading
                      ? ListView.builder(
                          itemCount: 10,
                          itemBuilder: (_, __) => const _ShimmerTile(),
                        )
                      : _error.isNotEmpty
                      ? Center(
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
                        )
                      : _filtered.isEmpty
                      ? Center(
                          child: Text(
                            _searchCtrl.text.isNotEmpty
                                ? 'No tracks match "${_searchCtrl.text}"'
                                : 'No tracks in "$_selectedCategory" yet.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          color: AppColors.phonkRed,
                          backgroundColor: AppColors.bgSurface,
                          onRefresh: _load,
                          child: ListView.builder(
                            controller: _scrollCtrl,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 160),
                            itemCount: _filtered.length,
                            itemBuilder: (_, i) {
                              final track = _filtered[i];
                              final isPlaying =
                                  widget.controller.nowPlaying?.trackId ==
                                  track.trackId;
                              return TrackListRow(
                                track: track,
                                showPlayCount: true,
                                showPlayIndicator: true,
                                // Position within the currently displayed
                                // (category-sorted/searched) list — not the
                                // original "All" order, so the rank stays
                                // meaningful once Trending/Underground
                                // resorts the list.
                                leading: TrackRankBadge(
                                  rank: i + 1,
                                  isPlaying: isPlaying,
                                ),
                                isPlaying: isPlaying,
                                isHighlighted:
                                    track.trackId == _highlightedTrackId,
                                isLiked: widget.controller.isLiked(
                                  track.trackId,
                                ),
                                onTap: () => widget.controller.playTrack(
                                  track,
                                  context,
                                  queue: _filtered,
                                ),
                                onLike: () => widget.controller.toggleLike(
                                  track.trackId,
                                ),
                              );
                            },
                          ),
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

class _ShimmerTile extends StatelessWidget {
  const _ShimmerTile();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

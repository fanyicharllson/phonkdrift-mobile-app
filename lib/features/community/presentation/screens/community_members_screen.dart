import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/chat.pb.dart';
import '../../data/repositories/community_repository.dart';
import '../widgets/community_widgets.dart';

class CommunityMembersScreen extends StatefulWidget {
  const CommunityMembersScreen({super.key});

  @override
  State<CommunityMembersScreen> createState() =>
      _CommunityMembersScreenState();
}

class _CommunityMembersScreenState extends State<CommunityMembersScreen> {
  List<CommunityMember> _members = [];
  List<CommunityMember> _filtered = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _isSearchLoadingAll = false;
  bool _hasMore = true;
  String _error = '';
  int _page = 0;
  int _total = 0;
  static const _limit = 20;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final res = await CommunityRepository.instance.getMembers(
        page: 0,
        limit: _limit,
      );
      if (mounted) {
        setState(() {
          _members = res.members;
          _total = res.total;
          _isLoading = false;
          _hasMore = res.members.length == _limit;
          _page = 1;
          _filtered = _applySearch(_members);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('CommunityException: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    try {
      final res = await CommunityRepository.instance.getMembers(
        page: _page,
        limit: _limit,
      );
      if (mounted) {
        setState(() {
          _members = [..._members, ...res.members];
          _isLoadingMore = false;
          _hasMore = res.members.length == _limit;
          _page++;
          _filtered = _applySearch(_members);
        });
      }
    } catch (_) {
      // A failed "load more" isn't worth a full error screen when members
      // are already showing — just stop paginating; scrolling back up
      // triggers a retry attempt again since _hasMore stays true.
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  /// The member list is paginated, but search should cover the whole
  /// roster, not just whatever's scrolled into view so far — so the first
  /// time the user types something, eagerly page through everything once
  /// (bounded, so a huge community can't hang this screen).
  Future<void> _loadAllForSearch() async {
    if (_isSearchLoadingAll || !_hasMore) return;
    setState(() => _isSearchLoadingAll = true);
    try {
      var page = _page;
      var members = _members;
      var hasMore = _hasMore;
      const safetyCapPages = 25; // 500 members at limit=20
      var pagesFetched = 0;
      while (hasMore && pagesFetched < safetyCapPages) {
        final res = await CommunityRepository.instance.getMembers(
          page: page,
          limit: _limit,
        );
        members = [...members, ...res.members];
        hasMore = res.members.length == _limit;
        page++;
        pagesFetched++;
      }
      if (mounted) {
        setState(() {
          _members = members;
          _page = page;
          _hasMore = hasMore;
          _isSearchLoadingAll = false;
          _filtered = _applySearch(_members);
        });
      }
    } catch (_) {
      // Search just falls back to whatever's loaded so far — not worth
      // interrupting the user over.
      if (mounted) setState(() => _isSearchLoadingAll = false);
    }
  }

  List<CommunityMember> _applySearch(List<CommunityMember> members) {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return members;
    return members.where((m) => m.username.toLowerCase().contains(q)).toList();
  }

  void _onSearchChanged(String value) {
    setState(() => _filtered = _applySearch(_members));
    if (value.trim().isNotEmpty) _loadAllForSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.phonkRed.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
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
                            Text(
                              'Community Members',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            if (_total > 0)
                              Text(
                                '$_total drifters',
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

                const SizedBox(height: 16),

                if (!_isLoading && _error.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: _onSearchChanged,
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search drifters...',
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                        suffixIcon: _isSearchLoadingAll
                            ? const Padding(
                                padding: EdgeInsets.all(14),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.phonkRed,
                                  ),
                                ),
                              )
                            : _searchCtrl.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchCtrl.clear();
                                  _onSearchChanged('');
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

                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.phonkRed,
                            strokeWidth: 2,
                          ),
                        )
                      : _error.isNotEmpty
                      ? _MembersErrorState(message: _error, onRetry: _load)
                      : _filtered.isEmpty
                      ? Center(
                          child: Text(
                            _searchCtrl.text.isNotEmpty
                                ? 'No drifters match "${_searchCtrl.text}"'
                                : 'No members yet.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : NotificationListener<ScrollNotification>(
                          onNotification: (n) {
                            if (_searchCtrl.text.isEmpty &&
                                n.metrics.pixels >=
                                    n.metrics.maxScrollExtent - 200) {
                              _loadMore();
                            }
                            return false;
                          },
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 40),
                            itemCount:
                                _filtered.length +
                                (_isLoadingMore && _searchCtrl.text.isEmpty
                                    ? 1
                                    : 0),
                            itemBuilder: (_, i) {
                              if (i >= _filtered.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.phonkRed,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              final member = _filtered[i];
                              return _MemberTile(member: member, rank: i + 1);
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

class _MembersErrorState extends StatelessWidget {
  const _MembersErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.phonkRed.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.phonkRed.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: AppColors.phonkRed,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Couldn't load members",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message.isNotEmpty
                  ? message
                  : 'Something went wrong. Check your connection and try again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.phonkRed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Retry',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberTile extends StatefulWidget {
  const _MemberTile({required this.member, required this.rank});
  final CommunityMember member;
  final int rank;

  @override
  State<_MemberTile> createState() => _MemberTileState();
}

class _MemberTileState extends State<_MemberTile> {
  bool _pressed = false;

  void _setPressed(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    final member = widget.member;
    final isFounding = member.badge == 'first';
    final isTop3 = widget.rank <= 3 && isFounding;

    final joinDate = DateTime.fromMillisecondsSinceEpoch(
      member.joinedAt.toInt() * 1000,
    );
    final dateStr = '${joinDate.day}/${joinDate.month}/${joinDate.year}';

    final ringColors = isFounding
        ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
        : [
            AppColors.phonkRed.withValues(alpha: 0.7),
            const Color(0xFF6B00FF).withValues(alpha: 0.7),
          ];

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: () => HapticFeedback.selectionClick(),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isFounding
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFFFD700).withValues(alpha: 0.1),
                      AppColors.bgSurface,
                    ],
                  )
                : null,
            color: isFounding ? null : AppColors.bgSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isFounding
                  ? const Color(0xFFFFD700).withValues(alpha: 0.35)
                  : AppColors.borderSubtle,
            ),
            boxShadow: isFounding
                ? [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: ringColors),
                    ),
                    child: CommunityAvatar(
                      url: member.avatarUrl,
                      username: member.username,
                      size: 52,
                    ),
                  ),
                  if (isTop3)
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.bgDeep,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFFD700),
                                Color(0xFFFFA500),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            member.username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (member.badge.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          MemberBadge(badge: member.badge),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 11,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Joined $dateStr',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '#${widget.rank}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isFounding
                      ? const Color(0xFFFFD700)
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

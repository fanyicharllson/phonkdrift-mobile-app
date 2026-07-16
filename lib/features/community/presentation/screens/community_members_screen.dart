import 'package:flutter/material.dart';
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
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 0;
  int _total = 0;
  static const _limit = 20;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; });
    try {
      final res = await CommunityRepository.instance
          .getMembers(page: 0, limit: _limit);
      if (mounted) {
        setState(() {
          _members = res.members;
          _total = res.total;
          _isLoading = false;
          _hasMore = res.members.length == _limit;
          _page = 1;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    try {
      final res = await CommunityRepository.instance
          .getMembers(page: _page, limit: _limit);
      if (mounted) {
        setState(() {
          _members = [..._members, ...res.members];
          _isLoadingMore = false;
          _hasMore = res.members.length == _limit;
          _page++;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
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
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary, size: 16),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Community Members',
                            style: GoogleFonts.inter(
                              fontSize: 18, fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary, letterSpacing: -0.5,
                            )),
                        if (_total > 0)
                          Text('$_total drifters',
                              style: GoogleFonts.inter(
                                fontSize: 12, color: AppColors.textMuted,
                              )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.phonkRed, strokeWidth: 2,
                      ),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (n) {
                        if (n.metrics.pixels >=
                            n.metrics.maxScrollExtent - 200) {
                          _loadMore();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 40),
                        itemCount: _members.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (i >= _members.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: SizedBox(
                                  width: 20, height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2, color: AppColors.phonkRed,
                                  ),
                                ),
                              ),
                            );
                          }
                          final member = _members[i];
                          return _MemberTile(
                            member: member, rank: i + 1,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member, required this.rank});
  final CommunityMember member;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final joinDate = DateTime.fromMillisecondsSinceEpoch(
        member.joinedAt.toInt() * 1000);
    final dateStr =
        '${joinDate.day}/${joinDate.month}/${joinDate.year}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: member.badge == 'first'
              ? const Color(0xFFFFD700).withValues(alpha: 0.3)
              : AppColors.borderSubtle,
        ),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 28,
            child: Text('$rank',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                )),
          ),
          const SizedBox(width: 10),
          CommunityAvatar(
            url: member.avatarUrl,
            username: member.username,
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(member.username,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        )),
                    if (member.badge.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      MemberBadge(badge: member.badge),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text('Joined $dateStr',
                    style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textMuted,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
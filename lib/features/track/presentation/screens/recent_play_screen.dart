import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../controllers/track_controller.dart';
import '../widgets/track_list_row.dart';
import '../widgets/track_options_sheet.dart';

/// "See All" destination for the Home screen's Recently Played section —
/// same list already held by [TrackController] (loaded once at launch), just
/// with room to search and no 5-item cap.
class RecentPlayScreen extends StatefulWidget {
  const RecentPlayScreen({super.key, required this.controller});
  final TrackController controller;

  @override
  State<RecentPlayScreen> createState() => _RecentPlayScreenState();
}

class _RecentPlayScreenState extends State<RecentPlayScreen> {
  final _searchCtrl = TextEditingController();
  List<TrackMetadata> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.controller.recentTracks;
    widget.controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    setState(() => _onSearch(_searchCtrl.text));
  }

  void _onSearch(String val) {
    final q = val.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.controller.recentTracks
          : widget.controller.recentTracks
                .where(
                  (t) =>
                      t.title.toLowerCase().contains(q) ||
                      t.artistName.toLowerCase().contains(q),
                )
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
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
                        child: Text(
                          'Recently Played',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                      if (widget.controller.recentTracks.isNotEmpty)
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
                            '${widget.controller.recentTracks.length}',
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
                      hintText: 'Search recently played...',
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
                Expanded(
                  child: widget.controller.recentTracks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.history_rounded,
                                color: AppColors.textMuted,
                                size: 40,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No recently played tracks yet.',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _filtered.isEmpty
                      ? Center(
                          child: Text(
                            'No tracks match "${_searchCtrl.text}"',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          color: AppColors.phonkRed,
                          backgroundColor: AppColors.bgSurface,
                          onRefresh: widget.controller.loadRecentlyPlayed,
                          child: ListView.builder(
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
                                isPlaying: isPlaying,
                                isLiked: widget.controller.isLiked(
                                  track.trackId,
                                ),
                                showPlayIndicator: true,
                                onTap: () => widget.controller.playTrack(
                                  track,
                                  context,
                                  queue: _filtered,
                                ),
                                onMoreTap: () => showTrackOptionsSheet(
                                  context,
                                  widget.controller,
                                  track,
                                  queue: _filtered,
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

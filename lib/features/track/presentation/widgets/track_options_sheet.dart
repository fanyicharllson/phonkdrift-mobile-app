import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../controllers/track_controller.dart';
import 'add_to_playlist_sheet.dart';

/// Shared "⋮" track options sheet — Play / Like / Add to Playlist / Open in
/// YouTube / Share / Dismiss — used anywhere a [TrackListRow] passes
/// `onMoreTap` instead of a bare like toggle (Home's Recently Played, the
/// Recent Play screen).
Future<void> showTrackOptionsSheet(
  BuildContext context,
  TrackController controller,
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
                controller.playTrack(track, context, queue: queue);
              },
            ),
            _TrackOptionTile(
              icon: controller.isLiked(track.trackId)
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              label: controller.isLiked(track.trackId) ? 'Unlike' : 'Like',
              onTap: () {
                Navigator.of(sheetCtx).pop();
                final willLike = !controller.isLiked(track.trackId);
                controller.toggleLike(track.trackId);
                PhonkToast.show(
                  context,
                  message: willLike
                      ? 'Added to Liked Songs'
                      : 'Removed from Liked Songs',
                  type: ToastType.success,
                );
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
                Share.share('${track.title} by ${track.artistName}$youtubeUrl');
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../../data/repositories/track_repository.dart';

/// Opens a bottom sheet letting the user add [track] to an existing
/// playlist, or create a new one and add it in the same step.
Future<void> showAddToPlaylistSheet(
  BuildContext context, {
  required TrackMetadata track,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _AddToPlaylistSheet(track: track, hostContext: context),
  );
}

class _AddToPlaylistSheet extends StatefulWidget {
  const _AddToPlaylistSheet({required this.track, required this.hostContext});
  final TrackMetadata track;
  final BuildContext hostContext;

  @override
  State<_AddToPlaylistSheet> createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends State<_AddToPlaylistSheet> {
  List<PlaylistSummary> _playlists = [];
  bool _isLoading = true;
  String _error = '';
  final Set<String> _addingIds = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final playlists = await TrackRepository.instance.getUserPlaylists();
      if (mounted) {
        setState(() {
          _playlists = playlists;
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

  void _notifyHost(String message, {ToastType type = ToastType.success}) {
    if (!widget.hostContext.mounted) return;
    PhonkToast.show(widget.hostContext, message: message, type: type);
  }

  Future<void> _addToExisting(PlaylistSummary playlist) async {
    setState(() => _addingIds.add(playlist.playlistId));
    try {
      final success = await TrackRepository.instance.addToPlaylist(
        playlistId: playlist.playlistId,
        trackId: widget.track.trackId,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      _notifyHost(
        success
            ? 'Added to "${playlist.name}"'
            : 'Could not add to "${playlist.name}".',
        type: success ? ToastType.success : ToastType.error,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _addingIds.remove(playlist.playlistId));
      _notifyHost('Could not add to "${playlist.name}".', type: ToastType.error);
    }
  }

  Future<void> _createAndAdd() async {
    final name = await _promptPlaylistName();
    if (name == null || name.trim().isEmpty) return;
    final trimmed = name.trim();

    try {
      final created = await TrackRepository.instance.createPlaylist(
        name: trimmed,
      );
      final success = await TrackRepository.instance.addToPlaylist(
        playlistId: created.playlistId,
        trackId: widget.track.trackId,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      _notifyHost(
        success
            ? 'Created "$trimmed" and added track.'
            : 'Playlist created, but could not add track.',
        type: success ? ToastType.success : ToastType.error,
      );
    } catch (e) {
      if (!mounted) return;
      _notifyHost('Could not create playlist. Try again.', type: ToastType.error);
    }
  }

  Future<String?> _promptPlaylistName() {
    final nameCtrl = TextEditingController();
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
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
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'New Playlist',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Give your playlist a name.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                autofocus: true,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. Midnight Drift',
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.textMuted,
                    fontSize: 15,
                  ),
                  prefixIcon: const Icon(
                    Icons.queue_music_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
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
                    borderSide: const BorderSide(
                      color: AppColors.phonkRed,
                      width: 1.5,
                    ),
                  ),
                ),
                onSubmitted: (v) => Navigator.pop(sheetCtx, v),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(sheetCtx),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.bgElevated,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(sheetCtx, nameCtrl.text),
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
                          child: Text(
                            'Create',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add to Playlist',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.phonkRed.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.phonkRed,
                  size: 22,
                ),
              ),
              title: Text(
                'New Playlist',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                'Create and add in one step',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              onTap: () {
                HapticFeedback.mediumImpact();
                _createAndAdd();
              },
            ),
            const Divider(color: AppColors.borderSubtle, height: 1),
            Flexible(child: _buildBody()),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: AppColors.phonkRed,
            ),
          ),
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: AppColors.textMuted, size: 32),
            const SizedBox(height: 10),
            Text(
              'Could not load playlists.',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _load,
              child: Text(
                'Retry',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.phonkRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_playlists.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: Text(
          'No playlists yet. Create one above to get started.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 4),
      itemCount: _playlists.length,
      itemBuilder: (_, i) {
        final playlist = _playlists[i];
        final isAdding = _addingIds.contains(playlist.playlistId);
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: playlist.coverImageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: playlist.coverImageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => _playlistIconPlaceholder(),
                  )
                : _playlistIconPlaceholder(),
          ),
          title: Text(
            playlist.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            '${playlist.trackCount} tracks',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
          ),
          trailing: isAdding
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.phonkRed,
                  ),
                )
              : const Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppColors.textMuted,
                ),
          onTap: isAdding ? null : () => _addToExisting(playlist),
        );
      },
    );
  }

  Widget _playlistIconPlaceholder() {
    return Container(
      width: 40,
      height: 40,
      color: AppColors.bgElevated,
      child: const Icon(
        Icons.queue_music_rounded,
        color: AppColors.textMuted,
        size: 18,
      ),
    );
  }
}
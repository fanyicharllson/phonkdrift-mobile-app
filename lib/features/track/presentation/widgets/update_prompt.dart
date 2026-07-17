import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/update_service.dart';

Future<void> _openInBrowser(String apkUrl) =>
    launchUrl(Uri.parse(apkUrl), mode: LaunchMode.externalApplication);

/// Blocks the app entirely until the user updates — for `mandatory: true`.
/// No close button, no swipe-to-dismiss, no back-button escape. Downloads
/// and hands off to the system installer in-app rather than bouncing out
/// to the browser, so there's never a way to end up back in the app on the
/// old version without having gone through the installer.
Future<void> showMandatoryUpdateDialog(BuildContext context, UpdateInfo info) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.85),
    builder: (context) => _MandatoryUpdateDialog(info: info),
  );
}

class _MandatoryUpdateDialog extends StatefulWidget {
  const _MandatoryUpdateDialog({required this.info});
  final UpdateInfo info;

  @override
  State<_MandatoryUpdateDialog> createState() => _MandatoryUpdateDialogState();
}

class _MandatoryUpdateDialogState extends State<_MandatoryUpdateDialog> {
  bool _updating = false;
  // Stays locked (no back-button escape) through the prompt and the whole
  // download — only flips once an install has actually been handed off
  // (in-app or via the browser fallback), so there's no way to end up back
  // in the app on the old version without going through an installer.
  bool _canClose = false;

  void _onHandedOffToInstaller() {
    setState(() => _canClose = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canClose,
      child: Dialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
          child: _updating
              ? _DownloadProgressView(
                  info: widget.info,
                  onFinished: _onHandedOffToInstaller,
                )
              : _UpdatePromptBody(
                  info: widget.info,
                  onUpdateNow: () => setState(() => _updating = true),
                ),
        ),
      ),
    );
  }
}

class _UpdatePromptBody extends StatelessWidget {
  const _UpdatePromptBody({required this.info, required this.onUpdateNow});
  final UpdateInfo info;
  final VoidCallback onUpdateNow;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.phonkRed.withValues(alpha: 0.25),
                const Color(0xFF6B00FF).withValues(alpha: 0.15),
              ],
            ),
            border: Border.all(
              color: AppColors.phonkRed.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.system_update_rounded,
            color: AppColors.phonkRed,
            size: 32,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Update Required',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'A new version of PhonkDrift (${info.latestVersion}) is required to keep drifting. Update now to continue.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: onUpdateNow,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.phonkRed, Color(0xFF8B0034)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.phonkRed.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Update Now',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum _DownloadState { downloading, done, error }

/// The actual download → install handoff, shared by the mandatory dialog
/// and the dismissible banner's bottom sheet.
class _DownloadProgressView extends StatefulWidget {
  const _DownloadProgressView({required this.info, this.onFinished});
  final UpdateInfo info;

  /// Called once an installer has actually been handed off (in-app open or
  /// browser fallback). Defaults to a plain pop when not provided — used by
  /// the banner's bottom sheet, which has no special close-locking.
  final VoidCallback? onFinished;

  @override
  State<_DownloadProgressView> createState() => _DownloadProgressViewState();
}

class _DownloadProgressViewState extends State<_DownloadProgressView> {
  _DownloadState _state = _DownloadState.downloading;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    setState(() {
      _state = _DownloadState.downloading;
      _progress = 0;
    });
    try {
      final file = await UpdateService.instance.downloadApk(
        widget.info.apkUrl,
        onProgress: (p) {
          if (mounted) setState(() => _progress = p);
        },
      );
      if (!mounted) return;
      setState(() => _state = _DownloadState.done);
      await OpenFilex.open(file.path);
      if (mounted) _finish();
    } catch (_) {
      if (mounted) setState(() => _state = _DownloadState.error);
    }
  }

  void _finish() {
    if (widget.onFinished != null) {
      widget.onFinished!();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _openInBrowserInstead() async {
    await _openInBrowser(widget.info.apkUrl);
    if (mounted) _finish();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: switch (_state) {
            _DownloadState.error => const Icon(
              Icons.error_outline_rounded,
              color: AppColors.phonkRed,
              size: 40,
            ),
            _DownloadState.done => const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 40,
            ),
            _DownloadState.downloading => CircularProgressIndicator(
              value: _progress > 0 ? _progress : null,
              color: AppColors.phonkRed,
              strokeWidth: 4,
              backgroundColor: AppColors.borderSubtle,
            ),
          },
        ),
        const SizedBox(height: 18),
        Text(
          switch (_state) {
            _DownloadState.error => "Couldn't download the update",
            _DownloadState.done => 'Opening installer…',
            _DownloadState.downloading =>
              'Downloading update… ${(_progress * 100).toStringAsFixed(0)}%',
          },
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (_state == _DownloadState.error) ...[
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: _start,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.phonkRed,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Retry',
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
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _openInBrowserInstead,
            child: Text(
              'Open in Browser Instead',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Dismissible "update available" pill shown above the floating nav for
/// non-mandatory updates — tap opens a bottom sheet that downloads and
/// installs in-app; the X dismisses the banner for this session only (it
/// reappears next launch since we never cache latest_version, and a manual
/// "Check for Updates" in Settings re-announces it too).
class UpdateBanner extends StatelessWidget {
  const UpdateBanner({super.key, required this.info, required this.onDismiss});

  final UpdateInfo info;
  final VoidCallback onDismiss;

  void _openDownloadSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
          child: _DownloadProgressView(info: info),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: GestureDetector(
        onTap: () => _openDownloadSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.phonkRed.withValues(alpha: 0.9),
                const Color(0xFF6B00FF).withValues(alpha: 0.85),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.phonkRed.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.system_update_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update available',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Version ${info.latestVersion} is ready — tap to install',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onDismiss,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

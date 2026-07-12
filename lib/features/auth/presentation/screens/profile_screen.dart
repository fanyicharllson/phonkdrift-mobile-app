import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/push_notification_service.dart';
import '../../../../core/utils/storage_helper.dart';
import '../../../../core/widgets/phonk_button.dart';
import '../../../../core/widgets/phonk_error_banner.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../../data/repositories/auth_repository.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  // Keeps this tab's fetched profile alive when the PageView scrolls it
  // out of the cache range, instead of disposing and refetching every time.
  @override
  bool get wantKeepAlive => true;

  // User data
  String _username = '';
  String _email = '';
  String _phonkLevel = '';
  String _avatarUrl = '';

  // Loading states
  bool _isLoadingProfile = true;
  bool _isUploadingAvatar = false;
  StreamSubscription<void>? _profileUpdatedSub;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _profileUpdatedSub = PushNotificationService.instance.onProfileUpdated
        .listen((_) => _loadProfile());
  }

  @override
  void dispose() {
    _profileUpdatedSub?.cancel();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final storage = StorageHelper.instance;
    final username = await storage.getUsername();
    final phonkLevel = await storage.getPhonkLevel();
    final avatarUrl = await storage.getAvatarUrl();

    // Fetch fresh from backend
    try {
      final userId = await storage.getUserId() ?? '';
      final token = await storage.getToken() ?? '';
      if (userId.isNotEmpty) {
        final res = await AuthRepository.instance.getUser(userId: userId);
        if (mounted) {
          setState(() {
            _username = res.user.username;
            _email = res.user.email;
            _phonkLevel = res.user.phonkLevel;
            _avatarUrl = res.user.avatarUrl.isNotEmpty
                ? res.user.avatarUrl
                : (avatarUrl ?? '');
            _isLoadingProfile = false;
          });
          return;
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _username = username ?? '';
        _phonkLevel = phonkLevel ?? '';
        _avatarUrl = avatarUrl ?? '';
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _logout() async {
    await StorageHelper.instance.clearSession();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _openAvatarPicker() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    // Show preview dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _AvatarPreviewDialog(imagePath: picked.path),
    );

    if (confirmed != true || !mounted) return;

    // Show loading overlay on avatar
    setState(() => _isUploadingAvatar = true);

    try {
      final url = await AuthRepository.instance.uploadAvatar(File(picked.path));
      if (mounted) {
        setState(() {
          _avatarUrl = url;
          _isUploadingAvatar = false;
        });
        PhonkToast.show(
          context,
          message: 'Profile picture updated.',
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
        PhonkToast.show(
          context,
          message: e.toString().replaceAll('AuthException: ', ''),
          type: ToastType.error,
        );
      }
    }
  }

  void _openEditUsername() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditUsernameSheet(
        currentUsername: _username,
        onSaved: (newName) {
          setState(() => _username = newName);
          PhonkToast.show(
            context,
            message: 'Username updated to $newName.',
            type: ToastType.success,
          );
        },
      ),
    );
  }

  void _openChangePassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ChangePasswordSheet(),
    );
  }

  void _openChangePhonkLevel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PhonkLevelSheet(
        currentLevel: _phonkLevel,
        onSaved: (level) {
          setState(() => _phonkLevel = level);
          PhonkToast.show(
            context,
            message: 'Phonk level updated to $level.',
            type: ToastType.success,
          );
        },
      ),
    );
  }

  void _openFeedback() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _FeedbackSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: !_isUploadingAvatar,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || !_isUploadingAvatar) return;
        final leave = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.bgSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Upload in progress',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            content: Text(
              'Your profile picture is still uploading. Discard it?',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Stay',
                  style: GoogleFonts.inter(color: AppColors.textMuted),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Discard',
                  style: GoogleFonts.inter(color: AppColors.phonkRed),
                ),
              ),
            ],
          ),
        );
        if (leave == true && mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.phonkRed.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: _isLoadingProfile
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.phonkRed,
                      strokeWidth: 2,
                    ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 160),
                    child: Column(
                      children: [
                        // ── Header ───────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: Row(
                            children: [
                              Text(
                                'Profile',
                                style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -1,
                                ),
                              ),
                              const Spacer(),
                              // Settings icon
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: AppColors.bgSurface,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.borderSubtle,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.settings_outlined,
                                    color: AppColors.textMuted,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Avatar section ───────────────────────────────
                        Center(
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: _isUploadingAvatar ? null : _openAvatarPicker,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.phonkRed,
                                      width: 2.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.phonkRed.withValues(
                                          alpha: 0.25,
                                        ),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: _avatarUrl.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: _avatarUrl,
                                            fit: BoxFit.cover,
                                            errorWidget: (_, __, ___) =>
                                                _AvatarPlaceholder(
                                                  name: _username,
                                                ),
                                          )
                                        : _AvatarPlaceholder(name: _username),
                                  ),
                                ),
                              ),
                              // Upload loading overlay
                              if (_isUploadingAvatar)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withValues(alpha: 0.55),
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              // Camera badge
                              if (!_isUploadingAvatar)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _openAvatarPicker,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.phonkRed,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.bgDeep,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Username + phonk level
                        Text(
                          _username.isNotEmpty ? _username : 'Drifter',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 6),

                        if (_phonkLevel.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.phonkRed.withValues(alpha: 0.2),
                                  const Color(
                                    0xFF6B00FF,
                                  ).withValues(alpha: 0.15),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.phonkRed.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            child: Text(
                              _phonkLevel[0] +
                                  _phonkLevel.substring(1).toLowerCase(),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.phonkRed,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),

                        const SizedBox(height: 32),

                        // ── Edit Profile section ─────────────────────────
                        _SectionHeader(title: 'Edit Profile'),

                        _ProfileTile(
                          icon: Icons.person_outline_rounded,
                          label: 'Username',
                          value: _username.isNotEmpty ? '@$_username' : '—',
                          onTap: _openEditUsername,
                        ),

                        _ProfileTile(
                          icon: Icons.bolt_rounded,
                          label: 'Phonk Level',
                          value: _phonkLevel.isNotEmpty
                              ? _phonkLevel[0] +
                                    _phonkLevel.substring(1).toLowerCase()
                              : '—',
                          onTap: _openChangePhonkLevel,
                          valueColor: AppColors.phonkRed,
                        ),

                        _ProfileTile(
                          icon: Icons.lock_outline_rounded,
                          label: 'Change Password',
                          value: '••••••••',
                          onTap: _openChangePassword,
                        ),

                        const SizedBox(height: 24),

                        // ── More section ──────────────────────────────────
                        _SectionHeader(title: 'More'),

                        _ProfileTile(
                          icon: Icons.star_outline_rounded,
                          label: 'Send Feedback',
                          value: 'Rate PhonkDrift',
                          onTap: _openFeedback,
                        ),

                        _ProfileTile(
                          icon: Icons.info_outline_rounded,
                          label: 'About',
                          value: 'Version 1.0.0',
                          onTap: () {},
                        ),

                        const SizedBox(height: 24),

                        // ── Danger zone ───────────────────────────────────
                        _SectionHeader(title: 'Account'),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: GestureDetector(
                            onTap: () => _showLogoutConfirm(),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.phonkRed.withValues(
                                  alpha: 0.06,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.phonkRed.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.logout_rounded,
                                    color: AppColors.phonkRed,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 14),
                                  Text(
                                    'Sign Out',
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.phonkRed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  void _showLogoutConfirm() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.phonkRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.phonkRed,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sign out?',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You will need to sign in again to access PhonkDrift.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            PhonkButton(label: 'Sign Out', onPressed: _logout),
            const SizedBox(height: 12),
            PhonkButton(
              label: 'Cancel',
              onPressed: () => Navigator.pop(context),
              variant: PhonkButtonVariant.ghost,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avatar Placeholder ──────────────────────────────────────────────────────────
class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : 'D';
    return Container(
      color: AppColors.bgElevated,
      child: Center(
        child: Text(
          letter,
          style: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: AppColors.phonkRed,
          ),
        ),
      ),
    );
  }
}

// ── Section Header ──────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider(color: AppColors.borderSubtle)),
        ],
      ),
    );
  }
}

// ── Profile Tile ────────────────────────────────────────────────────────────────
class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.phonkRed, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avatar Preview Dialog ───────────────────────────────────────────────────────
class _AvatarPreviewDialog extends StatelessWidget {
  const _AvatarPreviewDialog({required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Preview',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            // Preview
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.phonkRed, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.phonkRed.withValues(alpha: 0.25),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This will be your new profile picture.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.bgElevated,
                        borderRadius: BorderRadius.circular(12),
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
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.phonkRed,
                        borderRadius: BorderRadius.circular(12),
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
                          'Update',
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
    );
  }
}

// ── Edit Username Sheet ─────────────────────────────────────────────────────────
class _EditUsernameSheet extends StatefulWidget {
  const _EditUsernameSheet({
    required this.currentUsername,
    required this.onSaved,
  });
  final String currentUsername;
  final void Function(String) onSaved;

  @override
  State<_EditUsernameSheet> createState() => _EditUsernameSheetState();
}

class _EditUsernameSheetState extends State<_EditUsernameSheet> {
  late TextEditingController _ctrl;
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.currentUsername);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final val = _ctrl.text.trim();
    if (val.isEmpty) {
      setState(() => _error = 'Username cannot be empty.');
      return;
    }
    if (val.length < 3) {
      setState(() => _error = 'Username must be at least 3 characters.');
      return;
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(val)) {
      setState(() => _error = 'Only letters, numbers and underscores.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final newName = await AuthRepository.instance.updateUsername(val);
      if (!mounted) return;
      Navigator.pop(context);
      widget.onSaved(newName);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('AuthException: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
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
              'Update Username',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose a unique name for the drift.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ctrl,
              autofocus: true,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. driftking',
                prefixIcon: const Icon(
                  Icons.alternate_email_rounded,
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
              onSubmitted: (_) => _save(),
              onChanged: (_) => setState(() => _error = ''),
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 10),
              PhonkErrorBanner(
                message: _error,
                onDismiss: () => setState(() => _error = ''),
              ),
            ],
            const SizedBox(height: 20),
            PhonkButton(
              label: 'Save Username',
              onPressed: _isLoading ? null : _save,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Change Password Sheet ───────────────────────────────────────────────────────
class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String _error = '';

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_oldCtrl.text.isEmpty) {
      setState(() => _error = 'Enter your current password.');
      return;
    }
    if (_newCtrl.text.length < 6) {
      setState(() => _error = 'New password must be at least 6 characters.');
      return;
    }
    if (_newCtrl.text != _confirmCtrl.text) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      await AuthRepository.instance.changePassword(
        oldPassword: _oldCtrl.text,
        newPassword: _newCtrl.text,
      );
      if (!mounted) return;
      Navigator.pop(context);
      PhonkToast.show(
        context,
        message: 'Password changed successfully.',
        type: ToastType.success,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('AuthException: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
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
              'Change Password',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 20),
            _PasswordField(
              ctrl: _oldCtrl,
              hint: 'Current password',
              obscure: _obscureOld,
              onToggle: () => setState(() => _obscureOld = !_obscureOld),
              onChanged: (_) => setState(() => _error = ''),
            ),
            const SizedBox(height: 12),
            _PasswordField(
              ctrl: _newCtrl,
              hint: 'New password (min. 6 chars)',
              obscure: _obscureNew,
              onToggle: () => setState(() => _obscureNew = !_obscureNew),
              onChanged: (_) => setState(() => _error = ''),
            ),
            const SizedBox(height: 12),
            _PasswordField(
              ctrl: _confirmCtrl,
              hint: 'Confirm new password',
              obscure: _obscureConfirm,
              onToggle: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
              onChanged: (_) => setState(() => _error = ''),
              onSubmit: _save,
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 10),
              PhonkErrorBanner(
                message: _error,
                onDismiss: () => setState(() => _error = ''),
              ),
            ],
            const SizedBox(height: 20),
            PhonkButton(
              label: 'Change Password',
              onPressed: _isLoading ? null : _save,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.ctrl,
    required this.hint,
    required this.obscure,
    required this.onToggle,
    required this.onChanged,
    this.onSubmit,
  });

  final TextEditingController ctrl;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
      onChanged: onChanged,
      onSubmitted: onSubmit != null ? (_) => onSubmit!() : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 14),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.textMuted,
          size: 18,
        ),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.textMuted,
            size: 18,
          ),
        ),
        filled: true,
        fillColor: AppColors.bgElevated,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
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
          borderSide: const BorderSide(color: AppColors.phonkRed, width: 1.5),
        ),
      ),
    );
  }
}

// ── Phonk Level Sheet ───────────────────────────────────────────────────────────
class _PhonkLevelSheet extends StatefulWidget {
  const _PhonkLevelSheet({required this.currentLevel, required this.onSaved});
  final String currentLevel;
  final void Function(String) onSaved;

  @override
  State<_PhonkLevelSheet> createState() => _PhonkLevelSheetState();
}

class _PhonkLevelSheetState extends State<_PhonkLevelSheet> {
  late String _selected;
  bool _isLoading = false;

  static const _levels = [
    (
      id: 'DRIFTER',
      icon: Icons.directions_car_rounded,
      desc: 'Just getting started in the underground.',
    ),
    (
      id: 'GHOST',
      icon: Icons.nightlight_round,
      desc: 'In the shadows. You ride alone.',
    ),
    (id: 'LEGEND', icon: Icons.bolt_rounded, desc: 'The drift bows to you.'),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.currentLevel.isNotEmpty
        ? widget.currentLevel
        : 'DRIFTER';
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      await AuthRepository.instance.updatePhonkLevel2(_selected);
      if (!mounted) return;
      Navigator.pop(context);
      widget.onSaved(_selected);
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
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
            'Your Phonk Level',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'This defines your identity in the drift.',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),
          ..._levels.map((level) {
            final isSelected = _selected == level.id;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selected = level.id);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.phonkRed.withValues(alpha: 0.08)
                      : AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.phonkRed
                        : AppColors.borderSubtle,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      level.icon,
                      color: isSelected
                          ? AppColors.phonkRed
                          : AppColors.textMuted,
                      size: 22,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level.id[0] + level.id.substring(1).toLowerCase(),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            level.desc,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.phonkRed
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.phonkRed
                              : AppColors.borderSubtle,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              size: 12,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          PhonkButton(
            label: 'Save Level',
            onPressed: _isLoading ? null : _save,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}

// ── Feedback Sheet ──────────────────────────────────────────────────────────────
class _FeedbackSheet extends StatefulWidget {
  const _FeedbackSheet();

  @override
  State<_FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<_FeedbackSheet> {
  final _commentCtrl = TextEditingController();
  int _rating = 0;
  bool _isLoading = false;
  String _error = '';

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      setState(() => _error = 'Please select a rating.');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      await AuthRepository.instance.submitFeedback(
        rating: _rating,
        comment: _commentCtrl.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context);
      PhonkToast.show(
        context,
        message: 'Feedback sent. Thank you.',
        type: ToastType.success,
      );
    } catch (e) {
      if (mounted)
        setState(() {
          _isLoading = false;
          _error = 'Failed to send feedback.';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
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
              'Send Feedback',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'How is PhonkDrift treating you?',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            // Star rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _rating = i + 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      i < _rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: i < _rating
                          ? AppColors.phonkRed
                          : AppColors.textMuted,
                      size: 36,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _commentCtrl,
              maxLines: 3,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Tell us what you think... (optional)',
                hintStyle: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 14,
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
              onChanged: (_) => setState(() => _error = ''),
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 10),
              PhonkErrorBanner(
                message: _error,
                onDismiss: () => setState(() => _error = ''),
              ),
            ],
            const SizedBox(height: 20),
            PhonkButton(
              label: 'Submit Feedback',
              onPressed: _isLoading ? null : _submit,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

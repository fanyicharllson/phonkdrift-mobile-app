import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/storage_helper.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import 'feedback_prompt_sheet.dart';

/// App-wide account sidebar — slides in from the right via [Scaffold.endDrawer].
class AppSidebar extends StatefulWidget {
  const AppSidebar({
    super.key,
    required this.onProfileTap,
    required this.onSettingsTap,
  });

  /// Called (after the drawer closes) when the user taps the profile header
  /// or the "Profile" tile — lets the host screen decide how to navigate.
  final VoidCallback onProfileTap;

  /// Called (after the drawer closes) when the user taps "Settings".
  final VoidCallback onSettingsTap;

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  String _username = '';
  String _phonkLevel = '';
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final storage = StorageHelper.instance;
    final results = await Future.wait([
      storage.getUsername(),
      storage.getPhonkLevel(),
      storage.getAvatarUrl(),
    ]);
    if (!mounted) return;
    setState(() {
      _username = results[0] ?? '';
      _phonkLevel = results[1] ?? '';
      _avatarUrl = results[2] ?? '';
    });
  }

  Future<void> _logout() async {
    await StorageHelper.instance.clearSession();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _closeThen(VoidCallback action) {
    Navigator.of(context).pop();
    action();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bgSurface,
      width: MediaQuery.of(context).size.width * 0.8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: GestureDetector(
                onTap: () => _closeThen(widget.onProfileTap),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.phonkRed.withValues(alpha: 0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.phonkRed.withValues(alpha: 0.2),
                            blurRadius: 16,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _avatarUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: _avatarUrl,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => _avatarFallback(),
                              )
                            : _avatarFallback(),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _username.isNotEmpty ? _username : 'Drifter',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (_phonkLevel.isNotEmpty) ...[
                            const SizedBox(height: 5),
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
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                              child: Text(
                                _phonkLevel[0] +
                                    _phonkLevel.substring(1).toLowerCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.phonkRed,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
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
            ),
            const Divider(color: AppColors.borderSubtle, height: 1),
            const SizedBox(height: 12),

            _SidebarTile(
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              onTap: () => _closeThen(widget.onProfileTap),
            ),
            _SidebarTile(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () => _closeThen(widget.onSettingsTap),
            ),
            _SidebarTile(
              icon: Icons.star_outline_rounded,
              label: 'Send Feedback',
              onTap: () => _closeThen(() => showFeedbackPromptSheet(context)),
            ),
            _SidebarTile(
              icon: Icons.info_outline_rounded,
              label: 'About PhonkDrift',
              onTap: () => Navigator.of(context).pop(),
            ),

            const Spacer(),

            const Divider(color: AppColors.borderSubtle, height: 1),
            const SizedBox(height: 8),
            _SidebarTile(
              icon: Icons.logout_rounded,
              label: 'Sign Out',
              color: AppColors.phonkRed,
              onTap: _logout,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback() {
    final letter = _username.isNotEmpty ? _username[0].toUpperCase() : 'D';
    return Container(
      color: AppColors.bgElevated,
      child: Center(
        child: Text(
          letter,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.phonkRed,
          ),
        ),
      ),
    );
  }
}

// ── Sidebar tile — haptic + press-scale feedback ─────────────────────────────
class _SidebarTile extends StatefulWidget {
  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _pressed = false;

  void _setPressed(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.textPrimary;
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
            color: _pressed
                ? AppColors.phonkRed.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: color, size: 21),
              const SizedBox(width: 14),
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

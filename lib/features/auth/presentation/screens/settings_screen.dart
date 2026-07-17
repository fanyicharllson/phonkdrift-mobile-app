import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/storage_helper.dart';
import '../../../../core/utils/update_service.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../../../community/presentation/screens/community_guidelines_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _feedbackPromptsEnabled = true;
  String _appVersion = '';
  bool _checkingForUpdate = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      StorageHelper.instance.getFeedbackPromptsEnabled(),
      UpdateService.instance.currentVersion(),
    ]);
    if (mounted) {
      setState(() {
        _feedbackPromptsEnabled = results[0] as bool;
        _appVersion = results[1] as String;
      });
    }
  }

  Future<void> _toggleFeedbackPrompts(bool value) async {
    setState(() => _feedbackPromptsEnabled = value);
    await StorageHelper.instance.setFeedbackPromptsEnabled(value);
  }

  Future<void> _checkForUpdate() async {
    setState(() => _checkingForUpdate = true);
    await UpdateService.instance.checkOnLaunch();
    if (!mounted) return;
    setState(() => _checkingForUpdate = false);
    final found = UpdateService.instance.pending != null;
    PhonkToast.show(
      context,
      message: found
          ? 'Update found — check the banner to install it.'
          : "You're on the latest version.",
      type: found ? ToastType.info : ToastType.success,
    );
  }

  Future<void> _logout() async {
    await StorageHelper.instance.clearSession();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                  Text(
                    'Settings',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                physics: const BouncingScrollPhysics(),
                children: [
                  const _SectionLabel('Account'),
                  _SettingsTile(
                    icon: Icons.person_outline_rounded,
                    label: 'Edit Profile',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const _SectionLabel('Community'),
                  _SettingsTile(
                    icon: Icons.gavel_rounded,
                    label: 'Community Guidelines',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            const CommunityGuidelinesScreen(standalone: true),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const _SectionLabel('Preferences'),
                  _SettingsSwitchTile(
                    icon: Icons.star_outline_rounded,
                    label: 'Feedback Prompts',
                    subtitle: 'Occasionally ask how the app is going',
                    value: _feedbackPromptsEnabled,
                    onChanged: _toggleFeedbackPrompts,
                  ),

                  const SizedBox(height: 20),
                  const _SectionLabel('About'),
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    label: 'App Version',
                    trailing: Text(
                      _appVersion,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.system_update_rounded,
                    label: 'Check for Updates',
                    trailing: _checkingForUpdate
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.phonkRed,
                            ),
                          )
                        : null,
                    onTap: _checkingForUpdate ? null : _checkForUpdate,
                  ),

                  const SizedBox(height: 28),
                  _SettingsTile(
                    icon: Icons.logout_rounded,
                    label: 'Sign Out',
                    color: AppColors.phonkRed,
                    onTap: _logout,
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.textMuted,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            Icon(icon, color: tileColor, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: tileColor,
                ),
              ),
            ),
            if (trailing != null) trailing!,
            if (trailing == null && onTap != null)
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

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textPrimary, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.phonkRed,
          ),
        ],
      ),
    );
  }
}

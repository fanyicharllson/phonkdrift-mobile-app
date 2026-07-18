import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/utils/update_service.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    UpdateService.instance.currentVersion().then((v) {
      if (mounted) setState(() => _version = v);
    });
  }

  Future<void> _openDeveloperSite() =>
      launchUrl(
        Uri.parse('https://fanyicharllson.charlseempire.tech/'),
        mode: LaunchMode.externalApplication,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
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
                  Text(
                    'About',
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.phonkRed.withValues(alpha: 0.28),
                            const Color(0xFF6B00FF).withValues(alpha: 0.18),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.phonkRed.withValues(alpha: 0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.phonkRed.withValues(alpha: 0.25),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.graphic_eq_rounded,
                        color: AppColors.phonkRed,
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppConfig.appName,
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppConfig.appTagline,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Text(
                        _version.isNotEmpty
                            ? 'Version $_version'
                            : 'Version ${AppConfig.appVersion}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'PhonkDrift is a home for phonk — stream the tracks, '
                      'build your library, and hang out in the community '
                      'chat with other drifters who get it.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Container(height: 1, color: AppColors.borderSubtle),
                    const SizedBox(height: 28),
                    Text(
                      'CRAFTED BY',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textMuted,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: _openDeveloperSite,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.bgSurface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.phonkRed.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.phonkRed,
                                    Color(0xFF8B0034),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.bolt_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Charlseempire Tech',
                                    style: GoogleFonts.inter(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Fanyi Charllson',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.open_in_new_rounded,
                              color: AppColors.phonkRed,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'fanyicharllson.charlseempire.tech',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
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
}

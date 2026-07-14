import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import 'community_chat_screen.dart';

class CommunityGuidelinesScreen extends StatefulWidget {
  const CommunityGuidelinesScreen({super.key});

  @override
  State<CommunityGuidelinesScreen> createState() =>
      _CommunityGuidelinesScreenState();
}

class _CommunityGuidelinesScreenState
    extends State<CommunityGuidelinesScreen> {
  final _scrollCtrl = ScrollController();
  bool _hasScrolledToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 60) {
      if (!_hasScrolledToBottom) {
        setState(() => _hasScrolledToBottom = true);
      }
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _enter() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const CommunityChatScreen(),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
      (_) => false,
    );
  }

  static const _rules = [
    (
      icon: Icons.favorite_rounded,
      title: 'Keep it Phonk',
      body:
          'This space is for phonk lovers. Stay on topic — share tracks, artists, recommendations, and genuine phonk culture.',
      color: AppColors.phonkRed,
    ),
    (
      icon: Icons.handshake_rounded,
      title: 'Respect Every Drifter',
      body:
          'No harassment, hate speech, discrimination, or personal attacks. Everyone in the drift deserves respect regardless of background.',
      color: Color(0xFF6B00FF),
    ),
    (
      icon: Icons.block_rounded,
      title: 'Zero Tolerance for Abuse',
      body:
          'Abusive language, threats, doxxing, or bullying will result in an immediate and permanent ban. No warnings.',
      color: Colors.orange,
    ),
    (
      icon: Icons.music_off_rounded,
      title: 'No Off-Genre Content',
      body:
          'Do not share audio, links, or recommendations that are not phonk or directly phonk-adjacent. Keep the vibe consistent.',
      color: Color(0xFF00B4D8),
    ),
    (
      icon: Icons.no_adult_content_rounded,
      title: 'No NSFW or Illegal Content',
      body:
          'Explicit, adult, or illegal content of any kind is strictly prohibited and will be reported to the appropriate authorities.',
      color: Colors.red,
    ),
    (
      icon: Icons.campaign_rounded,
      title: 'No Spam or Self-Promotion',
      body:
          'Unsolicited promotion, repetitive messages, or flooding the chat will lead to removal. Share authentically.',
      color: Colors.amber,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.phonkRed.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.phonkRed.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text('COMMUNITY RULES',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppColors.phonkRed,
                              letterSpacing: 1,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Before you\ndrift in.',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -1.1,
                        height: 1.1,
                      )),
                  const SizedBox(height: 8),
                  Text(
                    'Read and agree to these rules to keep the community strong.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Rules scroll
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                physics: const BouncingScrollPhysics(),
                itemCount: _rules.length + 1,
                itemBuilder: (_, i) {
                  if (i == _rules.length) {
                    return _AgreementCard();
                  }
                  final rule = _rules[i];
                  return _RuleCard(
                    icon: rule.icon,
                    title: rule.title,
                    body: rule.body,
                    color: rule.color,
                    number: i + 1,
                  );
                },
              ),
            ),

            // CTA
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _hasScrolledToBottom ? 1.0 : 0.4,
                child: GestureDetector(
                  onTap: _hasScrolledToBottom ? _enter : () {
                    _scrollCtrl.animateTo(
                      _scrollCtrl.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: _hasScrolledToBottom
                          ? const LinearGradient(
                              colors: [AppColors.phonkRed, Color(0xFF8B0034)],
                            )
                          : const LinearGradient(
                              colors: [Color(0xFF333340), Color(0xFF222230)],
                            ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _hasScrolledToBottom
                          ? [
                              BoxShadow(
                                color: AppColors.phonkRed.withValues(alpha: 0.35),
                                blurRadius: 20, offset: const Offset(0, 6),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _hasScrolledToBottom
                              ? Icons.check_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: Colors.white, size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _hasScrolledToBottom
                              ? 'I Agree — Enter the Drift'
                              : 'Scroll to read all rules',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
    required this.number,
  });
  final IconData icon;
  final String title;
  final String body;
  final Color color;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: (color).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('$number.',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        )),
                    const SizedBox(width: 4),
                    Text(title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        )),
                  ],
                ),
                const SizedBox(height: 5),
                Text(body,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AgreementCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.phonkRed.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.phonkRed.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.phonkRed, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Violating any of these rules may result in removal from the community without notice.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
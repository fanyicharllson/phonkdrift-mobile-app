import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/chat.pb.dart';

// ── Avatar ──────────────────────────────────────────────────────────────────────
class CommunityAvatar extends StatelessWidget {
  const CommunityAvatar({
    super.key,
    required this.url,
    required this.username,
    this.size = 36,
  });
  final String url;
  final String username;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.phonkRed.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: url.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _LetterAvatar(
                  name: username, size: size,
                ),
              )
            : _LetterAvatar(name: username, size: size),
      ),
    );
  }
}

class _LetterAvatar extends StatelessWidget {
  const _LetterAvatar({required this.name, required this.size});
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      color: AppColors.bgElevated,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'D',
          style: GoogleFonts.inter(
            fontSize: size * 0.38,
            fontWeight: FontWeight.w800,
            color: AppColors.phonkRed,
          ),
        ),
      ),
    );
  }
}

// ── Member Badge ────────────────────────────────────────────────────────────────
class MemberBadge extends StatelessWidget {
  const MemberBadge({super.key, required this.badge});
  final String badge;

  @override
  Widget build(BuildContext context) {
    if (badge.isEmpty) return const SizedBox.shrink();

    final isFirst = badge == 'first';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isFirst
              ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
              : [AppColors.phonkRed.withValues(alpha: 0.8),
                 const Color(0xFF6B00FF).withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isFirst ? 'OG' : 'NEW',
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Message entrance animation ───────────────────────────────────────────────────
/// Fades + slides a newly-inserted message bubble in. Give the wrapper a
/// [ValueKey] on the message's id so Flutter only replays this once per
/// genuinely new message, not on every list rebuild.
class AnimatedMessageEntry extends StatefulWidget {
  const AnimatedMessageEntry({super.key, required this.child});
  final Widget child;

  @override
  State<AnimatedMessageEntry> createState() => _AnimatedMessageEntryState();
}

class _AnimatedMessageEntryState extends State<AnimatedMessageEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.12),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

// ── Message Bubble ──────────────────────────────────────────────────────────────
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.showAvatar,
    required this.onReply,
    required this.myUserId,
    this.badge = '',
    this.isPending = false,
  });

  final ChatMessage message;
  final bool isMine;
  final bool showAvatar;
  final void Function(ChatMessage) onReply;
  final String myUserId;
  final String badge;
  final bool isPending;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => onReply(message),
      child: Padding(
        padding: EdgeInsets.only(
          left: isMine ? 60 : 12,
          right: isMine ? 12 : 60,
          bottom: 4,
        ),
        child: Row(
          mainAxisAlignment:
              isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Other user avatar
            if (!isMine) ...[
              showAvatar
                  ? CommunityAvatar(
                      url: message.avatarUrl,
                      username: message.username,
                      size: 28,
                    )
                  : const SizedBox(width: 28),
              const SizedBox(width: 6),
            ],

            Flexible(
              child: Column(
                crossAxisAlignment: isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Username + badge (others only, first bubble in group)
                  if (!isMine && showAvatar) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message.username,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.phonkRed,
                            ),
                          ),
                          if (badge.isNotEmpty) ...[
                            const SizedBox(width: 5),
                            MemberBadge(badge: badge),
                          ],
                        ],
                      ),
                    ),
                  ],

                  // Reply preview
                  if (message.replyToId.isNotEmpty)
                    _ReplyPreview(message: message, isMine: isMine),

                  // Bubble
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMine
                          ? AppColors.phonkRed
                          : AppColors.bgSurface,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isMine ? 18 : 4),
                        bottomRight: Radius.circular(isMine ? 4 : 18),
                      ),
                      boxShadow: isMine
                          ? [
                              BoxShadow(
                                color: AppColors.phonkRed
                                    .withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      message.content,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: isMine
                            ? Colors.white
                            : AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),

                  // Timestamp + delivery state (mine only — WhatsApp-style
                  // "you know it sent" cue, e.g. clock while pending, check
                  // once the server has confirmed it).
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.createdAt.toInt()),
                        style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textMuted,
                        ),
                      ),
                      if (isMine) ...[
                        const SizedBox(width: 4),
                        Icon(
                          isPending
                              ? Icons.access_time_rounded
                              : Icons.done_rounded,
                          size: 12,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int unixSecs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(unixSecs * 1000);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _ReplyPreview extends StatelessWidget {
  const _ReplyPreview({required this.message, required this.isMine});
  final ChatMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isMine
            ? Colors.white.withValues(alpha: 0.15)
            : AppColors.bgElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: isMine ? Colors.white60 : AppColors.phonkRed,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.replyToUsername,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isMine ? Colors.white70 : AppColors.phonkRed,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            message.replyToContentSnippet,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isMine ? Colors.white60 : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Typing Reply Banner ─────────────────────────────────────────────────────────
class ReplyBanner extends StatelessWidget {
  const ReplyBanner({
    super.key,
    required this.message,
    required this.onCancel,
  });
  final ChatMessage message;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          top: BorderSide(
            color: AppColors.phonkRed.withValues(alpha: 0.3),
          ),
          left: const BorderSide(color: AppColors.phonkRed, width: 3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to ${message.username}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.phonkRed,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onCancel,
            child: const Icon(Icons.close_rounded,
                color: AppColors.textMuted, size: 20),
          ),
        ],
      ),
    );
  }
}

// ── Date separator ──────────────────────────────────────────────────────────────
class DateSeparator extends StatelessWidget {
  const DateSeparator({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.borderSubtle)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Expanded(child: Divider(color: AppColors.borderSubtle)),
        ],
      ),
    );
  }
}
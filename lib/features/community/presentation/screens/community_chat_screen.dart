import 'dart:async';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/generated/chat.pb.dart';
import '../../../../core/utils/storage_helper.dart';
import '../../../../core/widgets/phonk_toast.dart';
import '../../data/repositories/community_repository.dart';
import '../widgets/community_widgets.dart';
import 'community_members_screen.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key, this.onLeft});

  /// Called after successfully leaving the community. This screen is shown
  /// embedded (not pushed) by CommunityGate, so there's no route to pop —
  /// the host uses this to switch back to the rejoin prompt instead.
  final VoidCallback? onLeft;

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  final _repo = CommunityRepository.instance;
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _focusNode = FocusNode();

  List<ChatMessage> _messages = [];
  bool _isLoadingHistory = true;
  bool _isLoadingMore = false;
  bool _isSending = false;
  bool _hasMore = true;
  int _memberCount = 0;

  ChatMessage? _replyingTo;
  String _myUserId = '';
  String _myUsername = '';

  StreamSubscription? _chatSub;

  @override
  void initState() {
    super.initState();
    _init();
    _scrollCtrl.addListener(_onScroll);
  }

  Future<void> _init() async {
    _myUserId = await StorageHelper.instance.getUserId() ?? '';
    _myUsername = await StorageHelper.instance.getUsername() ?? '';
    await _loadHistory();
    _subscribeToChat();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await _repo.getStats();
      if (mounted) setState(() => _memberCount = stats.totalMembers);
    } catch (_) {}
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoadingHistory = true);
    try {
      final msgs = await _repo.getMessages(
        beforeTimestamp: Int64.ZERO,
        limit: 30,
      );
      if (mounted) {
        setState(() {
          // Backend returns newest first, reverse for display
          _messages = msgs.reversed.toList();
          _isLoadingHistory = false;
          _hasMore = msgs.length == 30;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingHistory = false);
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _messages.isEmpty) return;
    setState(() => _isLoadingMore = true);

    try {
      final oldest = _messages.first.createdAt;
      final older = await _repo.getMessages(beforeTimestamp: oldest, limit: 30);
      if (mounted) {
        setState(() {
          _messages = [...older.reversed.toList(), ..._messages];
          _isLoadingMore = false;
          _hasMore = older.length == 30;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _subscribeToChat() {
    try {
      final stream = _repo.subscribeToChat();
      _chatSub = stream.listen(
        (msg) {
          if (!mounted) return;
          setState(() => _messages.add(msg));
          // Only auto-scroll if near bottom
          if (_scrollCtrl.hasClients &&
              _scrollCtrl.position.pixels >=
                  _scrollCtrl.position.maxScrollExtent - 200) {
            _scrollToBottom();
          }
        },
        onError: (_) {
          // Reconnect on stream error after 3s
          Future.delayed(const Duration(seconds: 3), _subscribeToChat);
        },
        onDone: () {
          Future.delayed(const Duration(seconds: 3), _subscribeToChat);
        },
      );
    } catch (_) {
      Future.delayed(const Duration(seconds: 3), _subscribeToChat);
    }
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels <= 100) {
      _loadMore();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    final replyId = _replyingTo?.id ?? '';
    _msgCtrl.clear();

    try {
      await _repo.sendMessage(
        content: text,
        replyToId: replyId,
        messageType: 'text',
      );
      if (mounted) {
        setState(() {
          _replyingTo = null;
          _isSending = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        _msgCtrl.text = text; // restore
        PhonkToast.show(
          context,
          message: 'Failed to send. Try again.',
          type: ToastType.error,
        );
      }
    }
  }

  Future<void> _leaveCommunity() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => _LeaveConfirmDialog(),
    );
    if (confirm != true) return;

    try {
      await _repo.leaveCommunity();
      if (!mounted) return;
      PhonkToast.show(
        context,
        message: 'You have left the community.',
        type: ToastType.info,
      );
      widget.onLeft?.call();
    } catch (e) {
      if (mounted) {
        PhonkToast.show(
          context,
          message: 'Could not leave. Try again.',
          type: ToastType.error,
        );
      }
    }
  }

  bool _isSameDay(ChatMessage a, ChatMessage b) {
    final da = DateTime.fromMillisecondsSinceEpoch(a.createdAt.toInt() * 1000);
    final db = DateTime.fromMillisecondsSinceEpoch(b.createdAt.toInt() * 1000);
    return da.day == db.day && da.month == db.month && da.year == db.year;
  }

  String _dayLabel(ChatMessage msg) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      msg.createdAt.toInt() * 1000,
    );
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month) return 'Today';
    final yesterday = now.subtract(const Duration(days: 1));
    if (dt.day == yesterday.day && dt.month == yesterday.month) {
      return 'Yesterday';
    }
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  void dispose() {
    _chatSub?.cancel();
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            _buildHeader(),

            // ── Messages ─────────────────────────────────────────────────
            Expanded(
              child: _isLoadingHistory
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.phonkRed,
                        strokeWidth: 2,
                      ),
                    )
                  : _messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: AppColors.textMuted,
                            size: 44,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No messages yet.\nBe the first to drift in.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollCtrl,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _messages.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (i == 0 && _isLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.phonkRed,
                                ),
                              ),
                            ),
                          );
                        }

                        final msgIdx = _isLoadingMore ? i - 1 : i;
                        final msg = _messages[msgIdx];
                        final isMine = msg.userId == _myUserId;

                        // Date separator
                        final showDate =
                            msgIdx == 0 ||
                            !_isSameDay(_messages[msgIdx - 1], msg);

                        // Show avatar if first or different user
                        final showAvatar =
                            msgIdx == 0 ||
                            _messages[msgIdx - 1].userId != msg.userId;

                        return Column(
                          children: [
                            if (showDate) DateSeparator(label: _dayLabel(msg)),
                            MessageBubble(
                              message: msg,
                              isMine: isMine,
                              showAvatar: showAvatar,
                              myUserId: _myUserId,
                              onReply: (m) {
                                setState(() => _replyingTo = m);
                                _focusNode.requestFocus();
                              },
                            ),
                          ],
                        );
                      },
                    ),
            ),

            // ── Reply banner ───────────────────────────────────────────
            if (_replyingTo != null)
              ReplyBanner(
                message: _replyingTo!,
                onCancel: () => setState(() => _replyingTo = null),
              ),

            // ── Input bar ─────────────────────────────────────────────
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.bgDeep,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          // Community icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.phonkRed.withValues(alpha: 0.3),
                  const Color(0xFF6B00FF).withValues(alpha: 0.2),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.phonkRed.withValues(alpha: 0.4),
              ),
            ),
            child: const Icon(
              Icons.people_rounded,
              color: AppColors.phonkRed,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PhonkDrift Community',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.phonkRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _memberCount > 0 ? '$_memberCount members' : 'Community',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Members button
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CommunityMembersScreen()),
            ),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(
                Icons.group_outlined,
                color: AppColors.textMuted,
                size: 18,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 3-dot menu
          PopupMenuButton<String>(
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(
                Icons.more_vert_rounded,
                color: AppColors.textMuted,
                size: 18,
              ),
            ),
            color: AppColors.bgSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.borderSubtle),
            ),
            onSelected: (val) {
              if (val == 'leave') _leaveCommunity();
              if (val == 'members') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CommunityMembersScreen(),
                  ),
                );
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'members',
                child: Row(
                  children: [
                    const Icon(
                      Icons.people_outline_rounded,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'View Members',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'leave',
                child: Row(
                  children: [
                    const Icon(
                      Icons.exit_to_app_rounded,
                      color: AppColors.phonkRed,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Leave Community',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.phonkRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    // Extra bottom padding clears the floating nav bar that overlays every
    // tab (including this one) when the keyboard isn't up; when it is,
    // the keyboard itself pushes this bar above the nav already.
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, bottomInset > 0 ? 12 : 100),
      decoration: BoxDecoration(
        color: AppColors.bgDeep,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // TODO: Audio share button
          GestureDetector(
            onTap: () => PhonkToast.show(
              context,
              message: 'Audio sharing coming soon.',
              type: ToastType.info,
            ),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(
                Icons.music_note_rounded,
                color: AppColors.textMuted,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Text field
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: _focusNode.hasFocus
                      ? AppColors.phonkRed.withValues(alpha: 0.5)
                      : AppColors.borderSubtle,
                ),
              ),
              child: TextField(
                controller: _msgCtrl,
                focusNode: _focusNode,
                maxLines: null,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Message the drift...',
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Send button
          GestureDetector(
            onTap: _msgCtrl.text.trim().isNotEmpty ? _sendMessage : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _msgCtrl.text.trim().isNotEmpty
                    ? AppColors.phonkRed
                    : AppColors.bgSurface,
                shape: BoxShape.circle,
                boxShadow: _msgCtrl.text.trim().isNotEmpty
                    ? [
                        BoxShadow(
                          color: AppColors.phonkRed.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: _isSending
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.send_rounded,
                      color: _msgCtrl.text.trim().isNotEmpty
                          ? Colors.white
                          : AppColors.textMuted,
                      size: 18,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Leave Confirm Dialog ────────────────────────────────────────────────────────
class _LeaveConfirmDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.phonkRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.exit_to_app_rounded,
                color: AppColors.phonkRed,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Leave Community?',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You will lose your place in the community. If you rejoined after the first 50 members, your OG badge will not be restored.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
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
                      ),
                      child: Center(
                        child: Text(
                          'Leave',
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

import 'package:flutter/material.dart';
import '../../../../core/utils/storage_helper.dart';
import '../../../track/presentation/controllers/track_controller.dart';
import '../../data/repositories/community_repository.dart';
import '../screens/community_chat_screen.dart';
import '../screens/community_onboarding_screen.dart';
import 'community_error_state.dart';
import 'community_loading_state.dart';
import 'community_rejoin_prompt.dart';

enum _CommunityStatus { loading, member, needsOnboarding, needsRejoin, error }

/// Owns the "is this user in the community?" check and shows the right
/// screen for it — embedded directly in HomeScreen's Community tab (never
/// pushed), so joining/leaving never disturbs the rest of the app's
/// navigation stack or the mini player.
class CommunityGate extends StatefulWidget {
  const CommunityGate({
    super.key,
    this.onBack,
    this.trackController,
    this.onOpenPlayer,
  });

  /// Lets every sub-screen show a real back arrow that returns to the rest
  /// of the app (Home tab) instead of having nothing to go back to.
  final VoidCallback? onBack;

  /// Threaded down to the chat screen so it can show a small floating
  /// "now playing" bubble in place of the mini player, which is hidden
  /// on this tab.
  final TrackController? trackController;
  final VoidCallback? onOpenPlayer;

  @override
  State<CommunityGate> createState() => _CommunityGateState();
}

class _CommunityGateState extends State<CommunityGate>
    with AutomaticKeepAliveClientMixin {
  _CommunityStatus _status = _CommunityStatus.loading;
  String _errorMessage = '';

  // Keeps this whole subtree (membership check, chat messages, scroll
  // position, live subscription) alive when the user swipes to another
  // tab and back — without this, PageView drops far-scrolled-away pages
  // and everything (including the membership check) restarts from scratch.
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _status = _CommunityStatus.loading);
    try {
      final isMember = await CommunityRepository.instance.isMember();
      if (!mounted) return;
      if (isMember) {
        setState(() => _status = _CommunityStatus.member);
        return;
      }
      final joinedBefore = await StorageHelper.instance
          .hasJoinedCommunityBefore();
      if (!mounted) return;
      setState(() {
        _status = joinedBefore
            ? _CommunityStatus.needsRejoin
            : _CommunityStatus.needsOnboarding;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = _CommunityStatus.error;
        _errorMessage = e.toString().replaceAll('CommunityException: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return switch (_status) {
      _CommunityStatus.loading => const CommunityLoadingState(),
      _CommunityStatus.member => CommunityChatScreen(
        onLeft: _refresh,
        onBack: widget.onBack,
        trackController: widget.trackController,
        onOpenPlayer: widget.onOpenPlayer,
      ),
      _CommunityStatus.needsRejoin => CommunityRejoinPrompt(
        onRejoined: _refresh,
        onBack: widget.onBack,
      ),
      _CommunityStatus.needsOnboarding => CommunityOnboardingScreen(
        onJoined: _refresh,
        onBack: widget.onBack,
      ),
      _CommunityStatus.error => CommunityErrorState(
        message: _errorMessage.isNotEmpty
            ? _errorMessage
            : 'Something went wrong. Check your connection and try again.',
        onRetry: _refresh,
        onBack: widget.onBack,
      ),
    };
  }
}

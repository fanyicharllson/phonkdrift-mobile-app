import 'package:flutter/material.dart';
import '../../../../core/utils/storage_helper.dart';
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
  const CommunityGate({super.key});

  @override
  State<CommunityGate> createState() => _CommunityGateState();
}

class _CommunityGateState extends State<CommunityGate> {
  _CommunityStatus _status = _CommunityStatus.loading;
  String _errorMessage = '';

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
    return switch (_status) {
      _CommunityStatus.loading => const CommunityLoadingState(),
      _CommunityStatus.member => CommunityChatScreen(onLeft: _refresh),
      _CommunityStatus.needsRejoin => CommunityRejoinPrompt(
        onRejoined: _refresh,
      ),
      _CommunityStatus.needsOnboarding => CommunityOnboardingScreen(
        onJoined: _refresh,
      ),
      _CommunityStatus.error => CommunityErrorState(
        message: _errorMessage.isNotEmpty
            ? _errorMessage
            : 'Something went wrong. Check your connection and try again.',
        onRetry: _refresh,
      ),
    };
  }
}

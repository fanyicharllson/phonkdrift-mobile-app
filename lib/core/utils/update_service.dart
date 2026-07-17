import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pub_semver/pub_semver.dart';
import '../constants/app_config.dart';

class UpdateInfo {
  const UpdateInfo({
    required this.latestVersion,
    required this.apkUrl,
    required this.mandatory,
  });

  final String latestVersion;
  final String apkUrl;
  final bool mandatory;
}

/// Checks the backend once per app launch for a newer release. Never blocks
/// the UI and never surfaces an error — a broken/unreachable check-update
/// endpoint should be invisible to the user, not a support ticket.
class UpdateService {
  UpdateService._();
  static final UpdateService instance = UpdateService._();

  /// Plain ChangeNotifier rather than ValueNotifier — a manual re-check
  /// (Settings > Check for Updates) should always re-announce the result
  /// even if it's the *same* update as before (e.g. the user dismissed the
  /// banner earlier), so listeners must fire unconditionally rather than
  /// only on a value change.
  final _notifier = _UpdateChangeNotifier();
  Listenable get listenable => _notifier;
  UpdateInfo? get pending => _notifier.value;

  Future<String> currentVersion() async =>
      (await PackageInfo.fromPlatform()).version;

  Future<void> checkOnLaunch() async {
    try {
      final uri = Uri.parse(
        'http://${AppConfig.grpcHost}:${AppConfig.restPort}/api/v1/app/check-update',
      );
      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return;

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final latestVersion = body['latest_version'] as String?;
      final apkUrl = body['apk_url'] as String?;
      final mandatory = body['mandatory'] as bool? ?? false;
      if (latestVersion == null || apkUrl == null) return;

      final current = Version.parse(await currentVersion());
      final latest = Version.parse(latestVersion);
      if (latest > current) {
        _notifier.announce(
          UpdateInfo(
            latestVersion: latestVersion,
            apkUrl: apkUrl,
            mandatory: mandatory,
          ),
        );
      }
    } catch (_) {
      // Network error, malformed response, bad version string — none of
      // these should ever interrupt or be shown to the user.
    }
  }

  /// Downloads the APK to a temp file, reporting 0.0–1.0 progress as bytes
  /// arrive. Throws on any failure — the caller decides the fallback (e.g.
  /// handing off to the browser instead).
  Future<File> downloadApk(
    String apkUrl, {
    required void Function(double progress) onProgress,
  }) async {
    final request = http.Request('GET', Uri.parse(apkUrl));
    final response = await http.Client().send(request);
    if (response.statusCode != 200) {
      throw Exception('Download failed (${response.statusCode})');
    }

    final total = response.contentLength ?? 0;
    var received = 0;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/phonkdrift_update.apk');
    final sink = file.openWrite();

    await response.stream
        .map((chunk) {
          received += chunk.length;
          if (total > 0) onProgress(received / total);
          return chunk;
        })
        .pipe(sink);
    await sink.close();
    return file;
  }
}

/// Fires listeners on every announce(), regardless of whether the value is
/// "the same" as last time — plain ValueNotifier skips notification when
/// the new value is == the old one, which would silently swallow a manual
/// re-check that finds the same pending update again.
class _UpdateChangeNotifier extends ChangeNotifier {
  UpdateInfo? value;

  void announce(UpdateInfo info) {
    value = info;
    notifyListeners();
  }
}

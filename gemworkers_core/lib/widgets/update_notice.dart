import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/utils/reload/reload.dart';
import '../theme/app_theme.dart';

// "A new version is available" bar. Each deploy (deploy_admin.sh) bakes a
// build id into the app (--dart-define=BUILD_ID) and writes the same id to
// build.json next to it. A tab left open checks build.json every few minutes
// and on its own load; when the id differs, it offers a reload (never forced,
// so a half-filled form isn't lost).

const _buildId = String.fromEnvironment('BUILD_ID');

class UpdateNotice extends StatefulWidget {
  final Widget child;
  const UpdateNotice({super.key, required this.child});

  @override
  State<UpdateNotice> createState() => _UpdateNoticeState();
}

class _UpdateNoticeState extends State<UpdateNotice> {
  Timer? _timer;
  bool _newVersion = false;

  @override
  void initState() {
    super.initState();
    if (_buildId.isEmpty) return;   // local runs: no check
    _check();
    _timer = Timer.periodic(const Duration(minutes: 5), (_) => _check());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _check() async {
    if (_newVersion) return;
    try {
      final url = Uri.base.resolve('build.json?t=${DateTime.now().millisecondsSinceEpoch}');
      final res = await http.get(url, headers: {'Cache-Control': 'no-cache'});
      if (res.statusCode != 200) return;
      final id = (jsonDecode(res.body) as Map<String, dynamic>)['id']?.toString();
      if (id != null && id.isNotEmpty && id != _buildId && mounted) {
        setState(() => _newVersion = true);
        _timer?.cancel();
      }
    } catch (_) {
      // Offline or file missing: try again next time.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_newVersion)
          Material(
            color: AppColors.accent,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.system_update_alt, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'A new version of the GemWorkers admin is available.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: reloadPage,
                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                      child: const Text('Reload'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(child: widget.child),
      ],
    );
  }
}

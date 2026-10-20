import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

import 'turnstile_widget.dart';

const _scriptUrl =
    'https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit';

@JS('turnstile')
external _Turnstile? get _turnstile;

extension type _Turnstile._(JSObject _) implements JSObject {
  external JSString? render(web.HTMLElement container, JSObject options);
  external void reset(JSString widgetId);
  external void remove(JSString widgetId);
}

Future<void>? _scriptLoading;

/// Injects the Turnstile script once per page load.
Future<void> _loadScript() {
  if (_turnstile != null) return Future.value();
  return _scriptLoading ??= () {
    final completer = Completer<void>();
    final script = web.HTMLScriptElement()
      ..src = _scriptUrl
      ..async = true
      ..defer = true;
    script.onLoad.first.then((_) => completer.complete());
    script.onError.first.then((_) {
      _scriptLoading = null; // allow a retry on next mount
      completer.completeError(StateError('Turnstile script failed to load'));
    });
    web.document.head!.append(script);
    return completer.future;
  }();
}

/// Cloudflare Turnstile widget (web). Size matches Turnstile's "normal" box.
class TurnstileWidget extends StatefulWidget {
  const TurnstileWidget({
    super.key,
    required this.siteKey,
    required this.controller,
    required this.onToken,
  });

  final String siteKey;
  final TurnstileController controller;

  /// Receives a fresh token, or null when it expires / errors / is reset.
  final ValueChanged<String?> onToken;

  @override
  State<TurnstileWidget> createState() => _TurnstileWidgetState();
}

class _TurnstileWidgetState extends State<TurnstileWidget> {
  String? _widgetId;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    widget.controller.attach(_reset);
  }

  @override
  void dispose() {
    _disposed = true;
    widget.controller.attach(null);
    final id = _widgetId;
    if (id != null) _turnstile?.remove(id.toJS);
    super.dispose();
  }

  void _reset() {
    final id = _widgetId;
    if (id != null) _turnstile?.reset(id.toJS);
    widget.onToken(null);
  }

  Future<void> _render(web.HTMLDivElement el) async {
    try {
      await _loadScript();
      // The platform view is attached to the DOM shortly after creation.
      for (var i = 0; i < 40 && !el.isConnected; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        if (_disposed) return;
      }
      final turnstile = _turnstile;
      if (_disposed || turnstile == null) return;

      final options = JSObject()
        ..setProperty('sitekey'.toJS, widget.siteKey.toJS)
        ..setProperty('theme'.toJS, 'light'.toJS)
        ..setProperty('size'.toJS, 'normal'.toJS)
        ..setProperty(
            'callback'.toJS, ((JSString token) => _emit(token.toDart)).toJS)
        ..setProperty('expired-callback'.toJS, (() => _emit(null)).toJS)
        ..setProperty('timeout-callback'.toJS, (() => _emit(null)).toJS)
        ..setProperty('error-callback'.toJS, ((JSAny? _) => _emit(null)).toJS);

      _widgetId = turnstile.render(el, options)?.toDart;
    } catch (e) {
      debugPrint('Turnstile: $e');
    }
  }

  void _emit(String? token) {
    if (!_disposed) widget.onToken(token);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 65,
      child: HtmlElementView.fromTagName(
        tagName: 'div',
        onElementCreated: (element) {
          final el = element as web.HTMLDivElement;
          el.style
            ..width = '100%'
            ..height = '100%';
          _render(el);
        },
      ),
    );
  }
}

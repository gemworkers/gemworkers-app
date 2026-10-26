import 'package:flutter/material.dart';

import '../../core/config/turnstile_config.dart';
import '../../core/services/auth_service.dart';
import '../../widgets/turnstile/turnstile_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _turnstile = TurnstileController();

  bool _obscure = true;
  bool _loading = false;
  String? _error;
  String? _captchaToken;

  bool get _canSubmit =>
      !_loading && (!turnstileEnabled || _captchaToken != null);

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _email.text.trim();
    final password = _password.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Email and password are required.');
      return;
    }
    if (turnstileEnabled && _captchaToken == null) {
      setState(() => _error = 'Please complete the check and try again.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    // signIn returns null on success or a friendly error string on failure.
    // Navigation on success is handled by the StreamBuilder in app.dart.
    final error = await AuthService.signIn(
      email: email,
      password: password,
      captchaToken: turnstileEnabled ? _captchaToken : null,
    );
    if (mounted) {
      setState(() {
        _loading = false;
        _error = error;
      });
      // Tokens are single-use: get a fresh one before the next attempt.
      if (error != null && turnstileEnabled) _turnstile.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Branding
                    Icon(Icons.diamond, size: 52, color: cs.primary),
                    const SizedBox(height: 16),
                    Text(
                      'GemWorkers',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gem Business Management',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 36),

                    // Email
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password
                    TextField(
                      controller: _password,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _signIn(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                          tooltip: _obscure ? 'Show password' : 'Hide password',
                        ),
                      ),
                    ),

                    // Cloudflare Turnstile (web only)
                    if (turnstileEnabled) ...[
                      const SizedBox(height: 18),
                      Center(
                        child: TurnstileWidget(
                          siteKey: turnstileSiteKey,
                          controller: _turnstile,
                          onToken: (token) =>
                              setState(() => _captchaToken = token),
                        ),
                      ),
                    ],

                    // Error
                    if (_error != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: cs.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: cs.error, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error!,
                                style: TextStyle(
                                    color: cs.onErrorContainer, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Sign in button
                    FilledButton(
                      onPressed: _canSubmit ? _signIn : null,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign In',
                              style: TextStyle(fontSize: 16)),
                    ),

                    // Installing the admin as an app (web/manifest.json).
                    const SizedBox(height: 20),
                    const ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      leading: Icon(Icons.install_mobile_outlined),
                      title: Text('Use GemWorkers as an app on your phone'),
                      childrenPadding: EdgeInsets.only(bottom: 12),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Android (Chrome): open this page → menu ⋮ → "Install app" (or "Add to Home screen").'),
                        SizedBox(height: 8),
                        Text('iPhone (Safari): open this page → Share button (square with arrow) → "Add to Home Screen".'),
                        SizedBox(height: 8),
                        Text('A GemWorkers icon appears on your home screen and opens full screen, like any app.'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

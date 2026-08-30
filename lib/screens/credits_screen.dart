import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.creditsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.appTitle, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(l10n.creditsVersion, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            Text(l10n.creditsBody, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

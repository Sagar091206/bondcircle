import 'package:flutter/material.dart';

import '../../../theme/bondcircle_theme.dart';
import '../../profile/presentation/profile_setup_screen.dart';

class HomePreviewScreen extends StatelessWidget {
  const HomePreviewScreen({super.key, required this.displayName});

  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BondCircle')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, $displayName 👋',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Your account flow works. Profile setup is the next screen we will build.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: BondCircleColors.lavender,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: BondCircleColors.purple,
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Next: build your profile',
                    style: TextStyle(
                      color: BondCircleColors.ink,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your introduction, interests, city and profile photos.',
                    style: TextStyle(
                      color: BondCircleColors.muted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    key: const Key('startProfileButton'),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ProfileSetupScreen(initialName: displayName),
                      ),
                    ),
                    child: const Text('Start profile setup'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

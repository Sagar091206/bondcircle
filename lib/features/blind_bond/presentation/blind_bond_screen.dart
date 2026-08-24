import 'package:flutter/material.dart';

import '../../../theme/bondcircle_theme.dart';
import '../../connections/presentation/connections_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class BlindBondScreen extends StatefulWidget {
  const BlindBondScreen({
    super.key,
    required this.displayName,
    required this.joinedCircles,
  });
  final String displayName;
  final List<String> joinedCircles;
  @override
  State<BlindBondScreen> createState() => _BlindBondScreenState();
}

class _BlindBondScreenState extends State<BlindBondScreen> {
  final _selected = <String>{};
  static const _topics = [
    'Deep conversations',
    'Humour',
    'Music',
    'Books',
    'Food',
    'Travel',
  ];

  void _findBond() {
    if (_selected.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choose at least two conversation vibes.'),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlindMatchScreen(topics: _selected.toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Blind Bond')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2D1B69), Color(0xFF8B4ED8)],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.visibility_off_rounded, color: Colors.white, size: 40),
              SizedBox(height: 18),
              Text(
                'Meet the mind before the profile.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Names, photos, profession and background stay hidden while you discover how the conversation feels.',
                style: TextStyle(color: Colors.white70, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'How it works',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        const _InfoRow(
          Icons.tune_rounded,
          'Choose your vibe',
          'Pick conversation themes, not appearance.',
        ),
        const _InfoRow(
          Icons.forum_outlined,
          'Chat anonymously',
          'Both people use aliases with no profile photo.',
        ),
        const _InfoRow(
          Icons.lock_open_outlined,
          'Reveal only together',
          'Identity unlocks only if both choose to reveal.',
        ),
        const SizedBox(height: 22),
        const Text(
          'Your conversation vibes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 5),
        const Text('Choose at least two.'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _topics
              .map(
                (topic) => FilterChip(
                  key: Key('blindTopic$topic'),
                  selected: _selected.contains(topic),
                  label: Text(topic),
                  onSelected: (value) => setState(
                    () =>
                        value ? _selected.add(topic) : _selected.remove(topic),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 26),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: BondCircleColors.lavender,
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Row(
            children: [
              Icon(Icons.shield_outlined, color: BondCircleColors.purple),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Reporting and blocking remain available even while identities are hidden.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        FilledButton.icon(
          key: const Key('findBlindBondButton'),
          onPressed: _findBond,
          icon: const Icon(Icons.auto_awesome),
          label: const Text('Find a Blind Bond'),
        ),
      ],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: 1,
      onDestinationSelected: (index) {
        if (index == 0) {
          Navigator.of(context).pop();
        } else if (index == 2) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ConnectionsScreen(
                displayName: widget.displayName,
                joinedCircles: widget.joinedCircles,
              ),
            ),
          );
        } else if (index == 3) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ProfileScreen(
                displayName: widget.displayName,
                joinedCircles: widget.joinedCircles,
              ),
            ),
          );
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          label: 'Discover',
        ),
        NavigationDestination(
          icon: Icon(Icons.visibility_off),
          label: 'Blind Bond',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline_rounded),
          label: 'Chats',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          label: 'Profile',
        ),
      ],
    ),
  );
}

class BlindMatchScreen extends StatelessWidget {
  const BlindMatchScreen({super.key, required this.topics});
  final List<String> topics;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Anonymous match')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 28),
        Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF6D4DD6), Color(0xFFD94F76)],
            ),
          ),
          child: const Icon(
            Icons.question_mark_rounded,
            color: Colors.white,
            size: 60,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'You found “Purple Comet”',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 10),
        const Text(
          'Their identity is hidden. You matched through conversation energy, not profile details.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: topics.map((topic) => Chip(label: Text(topic))).toList(),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            key: const Key('startBlindChatButton'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const BlindChatScreen()),
            ),
            child: const Text('Start anonymous chat'),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Maybe later'),
        ),
      ],
    ),
  );
}

class BlindChatScreen extends StatefulWidget {
  const BlindChatScreen({super.key});
  @override
  State<BlindChatScreen> createState() => _BlindChatScreenState();
}

class _BlindChatScreenState extends State<BlindChatScreen> {
  final _controller = TextEditingController();
  final _messages = <String>[
    'What is one small thing that made you smile this week?',
  ];
  bool _requestedReveal = false;
  int _promptIndex = 0;
  static const _prompts = [
    'What would your perfect slow Sunday look like?',
    'Which song instantly improves your mood?',
    'What quality do you value most in a person?',
  ];
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    setState(() => _messages.add(value));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Purple Comet'),
          Text(
            'Identity hidden',
            style: TextStyle(fontSize: 12, color: BondCircleColors.muted),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'report', child: Text('Report conversation')),
            PopupMenuItem(value: 'block', child: Text('Block and leave')),
          ],
        ),
      ],
    ),
    body: Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: BondCircleColors.lavender,
          child: const Text(
            'Anonymous chat • Avoid sharing personal contact or location details.',
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4DE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded),
                const SizedBox(width: 10),
                Expanded(child: Text(_prompts[_promptIndex])),
                IconButton(
                  key: const Key('nextBlindPromptButton'),
                  tooltip: 'Next prompt',
                  onPressed: () => setState(
                    () => _promptIndex = (_promptIndex + 1) % _prompts.length,
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: _messages.length,
            itemBuilder: (_, index) {
              final mine = index > 0;
              return Align(
                alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: mine ? BondCircleColors.primary : Colors.white,
                    border: Border.all(
                      color: mine
                          ? BondCircleColors.primary
                          : BondCircleColors.border,
                    ),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Text(
                    _messages[index],
                    style: TextStyle(
                      color: mine ? Colors.white : BondCircleColors.ink,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: OutlinedButton.icon(
            key: const Key('requestRevealButton'),
            onPressed: () => setState(() => _requestedReveal = true),
            icon: Icon(
              _requestedReveal ? Icons.hourglass_top : Icons.lock_open_outlined,
            ),
            label: Text(
              _requestedReveal
                  ? 'Waiting for mutual consent'
                  : 'Request mutual reveal',
            ),
          ),
        ),
        if (_requestedReveal)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
            child: Column(
              children: [
                const Text(
                  'Your identity stays hidden until Purple Comet also agrees.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: BondCircleColors.muted),
                ),
                TextButton(
                  key: const Key('previewMutualConsentButton'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const MutualRevealScreen(),
                    ),
                  ),
                  child: const Text('Preview mutual-consent result'),
                ),
              ],
            ),
          ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('blindChatField'),
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Message anonymously…',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  key: const Key('sendBlindMessageButton'),
                  onPressed: _send,
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class MutualRevealScreen extends StatefulWidget {
  const MutualRevealScreen({super.key});
  @override
  State<MutualRevealScreen> createState() => _MutualRevealScreenState();
}

class _MutualRevealScreenState extends State<MutualRevealScreen> {
  final bool _me = true;
  bool _them = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mutual reveal')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 20),
        const Icon(
          Icons.lock_outline_rounded,
          size: 64,
          color: BondCircleColors.purple,
        ),
        const SizedBox(height: 18),
        Text(
          'Both people must say yes',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 10),
        const Text(
          'No identity information is shown while either person has not consented.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        _ConsentTile(name: 'You', accepted: _me),
        _ConsentTile(name: 'Purple Comet', accepted: _them),
        const SizedBox(height: 28),
        if (!_them)
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              key: const Key('simulatePartnerConsentButton'),
              onPressed: () => setState(() => _them = true),
              child: const Text('Demo: Purple Comet agrees'),
            ),
          ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            key: const Key('completeMutualRevealButton'),
            onPressed: _me && _them
                ? () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const RevealedBondScreen(),
                    ),
                  )
                : null,
            child: const Text('Reveal identities'),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Keep chatting anonymously'),
        ),
      ],
    ),
  );
}

class _ConsentTile extends StatelessWidget {
  const _ConsentTile({required this.name, required this.accepted});
  final String name;
  final bool accepted;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: CircleAvatar(
        child: Icon(
          accepted ? Icons.check_rounded : Icons.hourglass_top_rounded,
        ),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(accepted ? 'Agreed to reveal' : 'Waiting for consent'),
      trailing: Icon(
        accepted ? Icons.verified_rounded : Icons.lock_outline,
        color: accepted ? Colors.green : BondCircleColors.muted,
      ),
    ),
  );
}

class RevealedBondScreen extends StatelessWidget {
  const RevealedBondScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Bond revealed')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 116,
            height: 116,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFE9A8B9), Color(0xFF9E6DD7)],
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 62,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Purple Comet is Aarohi',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 10),
          const Text(
            'You both chose to reveal. Only now are the name and profile preview visible.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('Coffee')),
              Chip(label: Text('Music')),
              Chip(label: Text('Books')),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue conversation'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: BondCircleColors.lavender,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: BondCircleColors.purple),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(subtitle),
            ],
          ),
        ),
      ],
    ),
  );
}

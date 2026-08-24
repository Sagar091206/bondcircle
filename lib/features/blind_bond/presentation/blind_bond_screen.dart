import 'package:flutter/material.dart';

import '../../../theme/bondcircle_theme.dart';

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
        if (index == 0) Navigator.of(context).pop();
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
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
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
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const Key('startBlindChatButton'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const BlindChatScreen(),
                ),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 6),
            child: Text(
              'Your identity stays hidden until Purple Comet also agrees.',
              textAlign: TextAlign.center,
              style: TextStyle(color: BondCircleColors.muted),
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

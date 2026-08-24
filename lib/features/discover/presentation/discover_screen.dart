import 'package:flutter/material.dart';

import '../../../theme/bondcircle_theme.dart';
import '../../vibe_check/presentation/vibe_check_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    super.key,
    required this.displayName,
    required this.joinedCircles,
  });

  final String displayName;
  final List<String> joinedCircles;

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  static const _profiles = [
    _Profile(
      name: 'Aarohi',
      age: 22,
      city: 'Kolkata',
      profession: 'Design student',
      bio: 'Coffee walks, thoughtful conversations and finding beautiful corners of the city.',
      match: 91,
      sharedCircle: 'Coffee Explorers',
      interests: ['Coffee', 'Design', 'Indie music'],
      gradient: [Color(0xFFE9A8B9), Color(0xFF9E6DD7)],
      icon: Icons.palette_outlined,
    ),
    _Profile(
      name: 'Meera',
      age: 23,
      city: 'Kolkata',
      profession: 'Content writer',
      bio: 'Usually carrying a novel. Always ready for bookstores, brunch and unplanned stories.',
      match: 87,
      sharedCircle: 'Readers & Stories',
      interests: ['Books', 'Brunch', 'Travel'],
      gradient: [Color(0xFFF0B47B), Color(0xFFD76C88)],
      icon: Icons.auto_stories_outlined,
    ),
    _Profile(
      name: 'Ishita',
      age: 24,
      city: 'Howrah',
      profession: 'Software engineer',
      bio: 'Building apps on weekdays and chasing sunrise trails whenever the weekend appears.',
      match: 82,
      sharedCircle: 'Weekend Trekkers',
      interests: ['Trekking', 'Tech', 'Photography'],
      gradient: [Color(0xFF63B79A), Color(0xFF5477C7)],
      icon: Icons.landscape_outlined,
    ),
  ];

  int _index = 0;
  bool _highCompatibilityOnly = false;
  int _liked = 0;
  int _passed = 0;

  _Profile get _profile => _profiles[_index % _profiles.length];

  void _advance({required bool liked}) {
    final current = _profile;
    setState(() {
      liked ? _liked++ : _passed++;
      _index = (_index + 1) % _profiles.length;
    });
    if (liked) _showMatch(current);
  }

  Future<void> _showMatch(_Profile profile) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.favorite_rounded,
          color: BondCircleColors.primary,
          size: 42,
        ),
        title: Text('You matched with ${profile.name}!'),
        content: Text(
          'You both connected through ${profile.sharedCircle}. Start with a Vibe Check before chatting.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            key: const Key('keepDiscoveringButton'),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep discovering'),
          ),
          FilledButton(
            key: const Key('startVibeCheckButton'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(this.context).push(
                MaterialPageRoute<void>(
                  builder: (_) => VibeCheckScreen(
                    matchName: profile.name,
                    sharedCircle: profile.sharedCircle,
                  ),
                ),
              );
            },
            child: const Text('Vibe Check'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          IconButton(
            key: const Key('discoverFilterButton'),
            tooltip: 'Discovery filters',
            onPressed: _openFilters,
            icon: const Icon(Icons.tune_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 6, 24, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'People in your circles',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _highCompatibilityOnly
                              ? 'Showing compatibility above 85%'
                              : 'Shared context before random swipes',
                          style: const TextStyle(color: BondCircleColors.muted),
                        ),
                      ],
                    ),
                  ),
                  _CountBadge(icon: Icons.favorite_border, value: _liked),
                  const SizedBox(width: 8),
                  _CountBadge(icon: Icons.close_rounded, value: _passed),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _ProfileCard(key: ValueKey(_index), profile: profile),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ActionButton(
                    key: const Key('passProfileButton'),
                    icon: Icons.close_rounded,
                    color: BondCircleColors.ink,
                    onPressed: () => _advance(liked: false),
                  ),
                  const SizedBox(width: 20),
                  _ActionButton(
                    key: const Key('likeProfileButton'),
                    icon: Icons.favorite_rounded,
                    color: BondCircleColors.primary,
                    prominent: true,
                    onPressed: () => _advance(liked: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openFilters() async {
    var draft = _highCompatibilityOnly;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discovery filters',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Backend-powered distance and preference filters will be added later.',
                style: TextStyle(color: BondCircleColors.muted),
              ),
              const SizedBox(height: 18),
              SwitchListTile(
                key: const Key('compatibilityFilterSwitch'),
                contentPadding: EdgeInsets.zero,
                title: const Text('High compatibility only'),
                subtitle: const Text('Show profiles with an 85%+ match score'),
                value: draft,
                onChanged: (value) => setModalState(() => draft = value),
              ),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('applyDiscoverFiltersButton'),
                onPressed: () {
                  setState(() => _highCompatibilityOnly = draft);
                  Navigator.of(context).pop();
                },
                child: const Text('Apply filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({super.key, required this.profile});
  final _Profile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: BondCircleColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: profile.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(profile.icon, color: Colors.white70, size: 130),
                  ),
                  Positioned(
                    left: 18,
                    top: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        '${profile.match}% match',
                        style: const TextStyle(
                          color: BondCircleColors.purple,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${profile.name}, ${profile.age}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const Icon(
                        Icons.verified_rounded,
                        color: BondCircleColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${profile.profession} • ${profile.city}',
                    style: const TextStyle(color: BondCircleColors.muted),
                  ),
                  const SizedBox(height: 13),
                  Text(profile.bio, style: const TextStyle(height: 1.4)),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: BondCircleColors.lavender,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Shared circle: ${profile.sharedCircle}',
                      style: const TextStyle(
                        color: BondCircleColors.purple,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: profile.interests
                        .map(
                          (item) => Chip(
                            label: Text(item),
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.prominent = false,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: prominent ? 72 : 62,
      height: prominent ? 72 : 62,
      child: IconButton.filled(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: prominent ? color : Colors.white,
          foregroundColor: prominent ? Colors.white : color,
          side: prominent
              ? null
              : const BorderSide(color: BondCircleColors.border),
          elevation: prominent ? 5 : 1,
          shadowColor: BondCircleColors.primary.withValues(alpha: 0.35),
        ),
        icon: Icon(icon, size: prominent ? 32 : 28),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.icon, required this.value});
  final IconData icon;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: BondCircleColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 4),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _Profile {
  const _Profile({
    required this.name,
    required this.age,
    required this.city,
    required this.profession,
    required this.bio,
    required this.match,
    required this.sharedCircle,
    required this.interests,
    required this.gradient,
    required this.icon,
  });

  final String name;
  final int age;
  final String city;
  final String profession;
  final String bio;
  final int match;
  final String sharedCircle;
  final List<String> interests;
  final List<Color> gradient;
  final IconData icon;
}

import 'package:flutter/material.dart';

import '../../../theme/bondcircle_theme.dart';

class VibeCheckScreen extends StatefulWidget {
  const VibeCheckScreen({
    super.key,
    required this.matchName,
    required this.sharedCircle,
  });

  final String matchName;
  final String sharedCircle;

  @override
  State<VibeCheckScreen> createState() => _VibeCheckScreenState();
}

class _VibeCheckScreenState extends State<VibeCheckScreen> {
  static const _questions = [
    _Question(
      'Your ideal first meetup feels like…',
      'Choose the setting where you would feel most comfortable.',
      [
        ('Quiet coffee and a long conversation', Icons.local_cafe_outlined),
        ('Trying a fun activity together', Icons.sports_esports_outlined),
        ('A relaxed walk in a public place', Icons.park_outlined),
        ('Dinner somewhere new', Icons.restaurant_outlined),
      ],
    ),
    _Question(
      'When a conversation becomes quiet, you…',
      'There is no perfect answer—choose what feels natural.',
      [
        ('Ask a curious follow-up question', Icons.question_answer_outlined),
        ('Share a funny story', Icons.sentiment_very_satisfied_outlined),
        ('Enjoy the silence for a moment', Icons.spa_outlined),
        ('Suggest doing something together', Icons.lightbulb_outline_rounded),
      ],
    ),
    _Question(
      'A free Sunday suddenly appears. You pick…',
      'This helps BondCircle understand your shared pace.',
      [
        ('A spontaneous mini adventure', Icons.explore_outlined),
        ('A slow brunch and bookstore visit', Icons.menu_book_outlined),
        ('A creative or cultural event', Icons.palette_outlined),
        ('A peaceful day to recharge', Icons.weekend_outlined),
      ],
    ),
  ];

  final List<int> _answers = [];
  int _questionIndex = 0;
  int? _selectedOption;

  void _continue() {
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose one answer to continue.')),
      );
      return;
    }

    _answers.add(_selectedOption!);
    if (_questionIndex == _questions.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => VibeResultScreen(
            matchName: widget.matchName,
            sharedCircle: widget.sharedCircle,
            answers: _answers,
          ),
        ),
      );
    } else {
      setState(() {
        _questionIndex++;
        _selectedOption = null;
      });
    }
  }

  void _back() {
    if (_questionIndex == 0) return Navigator.of(context).pop();
    setState(() {
      _questionIndex--;
      _selectedOption = _answers.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_questionIndex];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _back,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Vibe Check'),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: (_questionIndex + 1) / _questions.length,
                            minHeight: 7,
                            backgroundColor: BondCircleColors.border,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        '${_questionIndex + 1}/${_questions.length}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: BondCircleColors.lavender,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        'Matched through ${widget.sharedCircle}',
                        style: const TextStyle(
                          color: BondCircleColors.purple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    question.title,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question.subtitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 28),
                  ...List.generate(question.options.length, (index) {
                    final option = question.options[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _OptionTile(
                        key: Key('vibeOption$index'),
                        label: option.$1,
                        icon: option.$2,
                        selected: _selectedOption == index,
                        onTap: () => setState(() => _selectedOption = index),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              decoration: const BoxDecoration(
                color: BondCircleColors.background,
                border: Border(top: BorderSide(color: BondCircleColors.border)),
              ),
              child: FilledButton(
                key: const Key('vibeContinueButton'),
                onPressed: _continue,
                child: Text(
                  _questionIndex == _questions.length - 1
                      ? 'See our shared vibe'
                      : 'Continue',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFEDF2) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? BondCircleColors.primary
                : BondCircleColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected
                    ? BondCircleColors.primary
                    : BondCircleColors.lavender,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : BondCircleColors.purple,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: BondCircleColors.ink,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected
                  ? BondCircleColors.primary
                  : BondCircleColors.border,
            ),
          ],
        ),
      ),
    );
  }
}

class VibeResultScreen extends StatelessWidget {
  const VibeResultScreen({
    super.key,
    required this.matchName,
    required this.sharedCircle,
    required this.answers,
  });

  final String matchName;
  final String sharedCircle;
  final List<int> answers;

  int get vibeScore => 78 + answers.where((answer) => answer < 2).length * 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 28),
            Center(
              child: Container(
                width: 106,
                height: 106,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [BondCircleColors.primary, BondCircleColors.purple],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$vibeScore%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'You and $matchName share an easygoing vibe.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Your answers suggest comfortable conversation, shared activities and low-pressure plans.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            _ResultCard(
              Icons.diversity_1_outlined,
              'Shared context',
              sharedCircle,
            ),
            const SizedBox(height: 12),
            const _ResultCard(
              Icons.chat_bubble_outline_rounded,
              'Conversation starter',
              'What makes a meetup instantly feel comfortable for you?',
            ),
            const SizedBox(height: 12),
            const _ResultCard(
              Icons.shield_outlined,
              'Remember',
              'Vibe scores are conversation helpers—not judgments or guarantees.',
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
              key: const Key('openChatButton'),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat is the next milestone.')),
              ),
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: Text('Chat with $matchName'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard(this.icon, this.title, this.value);

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BondCircleColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: BondCircleColors.purple),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: BondCircleColors.muted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Question {
  const _Question(this.title, this.subtitle, this.options);

  final String title;
  final String subtitle;
  final List<(String, IconData)> options;
}

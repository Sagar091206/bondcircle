import 'package:flutter/material.dart';

import '../../../theme/bondcircle_theme.dart';
import '../../venues/presentation/venue_suggestions_screen.dart';

class MeetupPlannerScreen extends StatefulWidget {
  const MeetupPlannerScreen({
    super.key,
    required this.matchName,
    required this.sharedCircle,
  });

  final String matchName;
  final String sharedCircle;

  @override
  State<MeetupPlannerScreen> createState() => _MeetupPlannerScreenState();
}

class _MeetupPlannerScreenState extends State<MeetupPlannerScreen> {
  static const _vibes = [
    _MeetupVibe('Coffee', 'Easy conversations', Icons.local_cafe_outlined),
    _MeetupVibe('Bookstore', 'Browse and talk', Icons.menu_book_outlined),
    _MeetupVibe('Arcade', 'Playful and fun', Icons.sports_esports_outlined),
    _MeetupVibe('Brunch', 'Slow weekend mood', Icons.brunch_dining_outlined),
    _MeetupVibe('Walk', 'Public and relaxed', Icons.park_outlined),
    _MeetupVibe('Creative', 'Art, music or culture', Icons.palette_outlined),
  ];
  static const _times = [
    '11:00 AM',
    '1:00 PM',
    '4:00 PM',
    '6:00 PM',
    '7:30 PM',
  ];

  final _detailsKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  int _step = 0;
  int? _selectedVibe;
  late DateTime _selectedDate;
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 2));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step == 0 && _selectedVibe == null) {
      return _showMessage('Choose a meetup vibe to continue.');
    }
    if (_step == 1 && _selectedTime == null) {
      return _showMessage('Choose a time to continue.');
    }
    if (_step == 2 && !(_detailsKey.currentState?.validate() ?? false)) return;

    if (_step == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => MeetupPlanPreviewScreen(
            matchName: widget.matchName,
            sharedCircle: widget.sharedCircle,
            vibe: _vibes[_selectedVibe!].name,
            date: _selectedDate,
            time: _selectedTime!,
            title: _titleController.text.trim(),
            note: _noteController.text.trim(),
          ),
        ),
      );
    } else {
      setState(() => _step++);
    }
  }

  void _back() {
    if (_step == 0) return Navigator.of(context).pop();
    setState(() => _step--);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Pick the vibe', 'Choose date and time', 'Name your plan'];
    final subtitles = [
      'What kind of first meetup would feel comfortable for both of you?',
      'Choose a simple time. Your match can confirm or suggest another option.',
      'Add a short title and enough context for ${widget.matchName}.',
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _back,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Plan a meetup'),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      height: 5,
                      margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
                      decoration: BoxDecoration(
                        color: index <= _step
                            ? BondCircleColors.primary
                            : BondCircleColors.border,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    titles[_step],
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitles[_step],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 28),
                  if (_step == 0) _vibeStep(),
                  if (_step == 1) _scheduleStep(),
                  if (_step == 2) _detailsStep(),
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
                key: const Key('meetupContinueButton'),
                onPressed: _next,
                child: Text(_step == 2 ? 'Preview plan' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vibeStep() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: _vibes.length,
      itemBuilder: (context, index) {
        final vibe = _vibes[index];
        final selected = _selectedVibe == index;
        return InkWell(
          key: Key('meetupVibe$index'),
          onTap: () => setState(() => _selectedVibe = index),
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 170),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFFFEAF0) : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected
                    ? BondCircleColors.primary
                    : BondCircleColors.border,
                width: selected ? 1.6 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  vibe.icon,
                  color: selected
                      ? BondCircleColors.primary
                      : BondCircleColors.purple,
                ),
                const Spacer(),
                Text(
                  vibe.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vibe.subtitle,
                  style: const TextStyle(color: BondCircleColors.muted),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _scheduleStep() {
    final dates = List.generate(
      6,
      (index) => DateTime.now().add(Duration(days: index + 1)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (_, _) => const SizedBox(width: 9),
            itemBuilder: (context, index) {
              final date = dates[index];
              final selected = _sameDay(date, _selectedDate);
              return ChoiceChip(
                key: Key('meetupDate$index'),
                selected: selected,
                label: SizedBox(
                  width: 48,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_weekday(date.weekday)),
                      const SizedBox(height: 5),
                      Text(
                        '${date.day}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                onSelected: (_) => setState(() => _selectedDate = date),
              );
            },
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Choose a time',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 9,
          runSpacing: 9,
          children: _times
              .map(
                (time) => ChoiceChip(
                  key: Key('meetupTime$time'),
                  selected: _selectedTime == time,
                  label: Text(time),
                  avatar: const Icon(Icons.schedule_rounded, size: 17),
                  onSelected: (_) => setState(() => _selectedTime = time),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BondCircleColors.lavender,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: BondCircleColors.purple),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'The plan is only confirmed after both people agree.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailsStep() {
    final selectedVibe = _vibes[_selectedVibe!].name;
    return Form(
      key: _detailsKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(selectedVibe)),
              Chip(label: Text(_formatDate(_selectedDate))),
              Chip(label: Text(_selectedTime!)),
            ],
          ),
          const SizedBox(height: 22),
          TextFormField(
            key: const Key('meetupTitleField'),
            controller: _titleController,
            maxLength: 60,
            decoration: const InputDecoration(
              labelText: 'Plan name',
              hintText: 'e.g. Saturday coffee and stories',
              prefixIcon: Icon(Icons.edit_calendar_outlined),
            ),
            validator: (value) => (value ?? '').trim().length < 3
                ? 'Add a short plan name'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('meetupNoteField'),
            controller: _noteController,
            minLines: 3,
            maxLines: 5,
            maxLength: 240,
            decoration: const InputDecoration(
              labelText: 'Optional note',
              hintText: 'Anything your match should know?',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _weekday(int day) =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day - 1];

  String _formatDate(DateTime date) =>
      '${_weekday(date.weekday)}, ${date.day}/${date.month}';
}

class MeetupPlanPreviewScreen extends StatelessWidget {
  const MeetupPlanPreviewScreen({
    super.key,
    required this.matchName,
    required this.sharedCircle,
    required this.vibe,
    required this.date,
    required this.time,
    required this.title,
    required this.note,
  });

  final String matchName;
  final String sharedCircle;
  final String vibe;
  final DateTime date;
  final String time;
  final String title;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plan preview')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6D4DD6), Color(0xFFD94F76)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vibe.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'With $matchName • $sharedCircle',
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(height: 26),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    _PreviewPill(
                      icon: Icons.calendar_month_outlined,
                      label: '${date.day}/${date.month}/${date.year}',
                    ),
                    _PreviewPill(icon: Icons.schedule_rounded, label: time),
                  ],
                ),
              ],
            ),
          ),
          if (note.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(note, style: Theme.of(context).textTheme.bodyLarge),
          ],
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: BondCircleColors.lavender,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: BondCircleColors.purple,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Next: choose a date-friendly public venue.',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            key: const Key('chooseVenueButton'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => VenueSuggestionsScreen(
                  matchName: matchName,
                  sharedCircle: sharedCircle,
                  vibe: vibe,
                  date: date,
                  time: time,
                  title: title,
                  note: note,
                ),
              ),
            ),
            icon: const Icon(Icons.map_outlined),
            label: const Text('Choose a venue'),
          ),
        ],
      ),
    );
  }
}

class _PreviewPill extends StatelessWidget {
  const _PreviewPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetupVibe {
  const _MeetupVibe(this.name, this.subtitle, this.icon);
  final String name;
  final String subtitle;
  final IconData icon;
}

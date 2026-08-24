import 'package:flutter/material.dart';

import '../../../theme/bondcircle_theme.dart';

class SafetyCheckInScreen extends StatefulWidget {
  const SafetyCheckInScreen({
    super.key,
    required this.matchName,
    required this.planTitle,
    required this.venueName,
    required this.venueArea,
    required this.date,
    required this.time,
  });

  final String matchName;
  final String planTitle;
  final String venueName;
  final String venueArea;
  final DateTime date;
  final String time;

  @override
  State<SafetyCheckInScreen> createState() => _SafetyCheckInScreenState();
}

class _SafetyCheckInScreenState extends State<SafetyCheckInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _checkIn = '1 hour after meetup';
  bool _shareVenue = true;
  bool _shareMatchName = true;
  bool _remindMe = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _activate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _SafetyConfirmationScreen(
          friendName: _nameController.text.trim(),
          checkIn: _checkIn,
          planTitle: widget.planTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety check-in')),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  children: [
                    Text(
                      'Keep a friend in the circle',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Choose someone you trust to receive your meetup details and check-in status.',
                    ),
                    const SizedBox(height: 22),
                    _PlanCard(widget: widget),
                    const SizedBox(height: 24),
                    const Text(
                      'Trusted contact',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const Key('trustedContactNameField'),
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Friend’s name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) => (value ?? '').trim().length < 2
                          ? 'Enter your trusted contact’s name'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const Key('trustedContactPhoneField'),
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (value) =>
                          RegExp(r'^\+?[0-9 ]{8,15}$')
                              .hasMatch((value ?? '').trim())
                          ? null
                          : 'Enter a valid phone number',
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Check in with me',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      key: const Key('checkInTimeField'),
                      initialValue: _checkIn,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.schedule_outlined),
                      ),
                      items:
                          const [
                                '30 minutes after meetup',
                                '1 hour after meetup',
                                '2 hours after meetup',
                                'At the planned end time',
                              ]
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => setState(() => _checkIn = value!),
                    ),
                    const SizedBox(height: 18),
                    _SafetySwitch(
                      title: 'Share venue and time',
                      subtitle: '${widget.venueName}, ${widget.venueArea}',
                      value: _shareVenue,
                      onChanged: (value) => setState(() => _shareVenue = value),
                    ),
                    _SafetySwitch(
                      title: 'Share match’s first name',
                      subtitle: widget.matchName,
                      value: _shareMatchName,
                      onChanged: (value) =>
                          setState(() => _shareMatchName = value),
                    ),
                    _SafetySwitch(
                      title: 'Remind me to check in',
                      subtitle: 'A local prototype reminder will appear',
                      value: _remindMe,
                      onChanged: (value) => setState(() => _remindMe = value),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F2),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.sos_outlined,
                            color: BondCircleColors.primary,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'If you ever feel unsafe, leave the venue and contact local emergency services. This prototype does not send real alerts.',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              decoration: const BoxDecoration(
                color: BondCircleColors.background,
                border: Border(top: BorderSide(color: BondCircleColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const Key('activateSafetyCheckInButton'),
                  onPressed: _activate,
                  icon: const Icon(Icons.shield_outlined),
                  label: const Text('Activate check-in'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.widget});
  final SafetyCheckInScreen widget;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF6D4DD6), Color(0xFFD94F76)],
      ),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.planTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${widget.venueName} • ${widget.venueArea}',
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          '${widget.date.day}/${widget.date.month}/${widget.date.year} • ${widget.time}',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}

class _SafetySwitch extends StatelessWidget {
  const _SafetySwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
    subtitle: Text(subtitle),
    value: value,
    onChanged: onChanged,
  );
}

class _SafetyConfirmationScreen extends StatelessWidget {
  const _SafetyConfirmationScreen({
    required this.friendName,
    required this.checkIn,
    required this.planTitle,
  });
  final String friendName, checkIn, planTitle;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Check-in ready')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: BondCircleColors.lavender,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              size: 64,
              color: BondCircleColors.purple,
            ),
          ),
          const SizedBox(height: 26),
          Text(
            'Your safety check-in is ready',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 12),
          Text(
            '$friendName will be your trusted contact for “$planTitle”. We’ll check in $checkIn.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4DE),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Frontend demo: no SMS, location, or notification has actually been sent.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    ),
  );
}

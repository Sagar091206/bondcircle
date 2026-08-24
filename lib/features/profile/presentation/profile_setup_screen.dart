import 'package:flutter/material.dart';

import '../../../theme/bondcircle_theme.dart';
import '../../circles/presentation/interest_circles_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key, required this.initialName});

  final String initialName;

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  static const _interestOptions = [
    ('Coffee', Icons.local_cafe_outlined),
    ('Books', Icons.menu_book_outlined),
    ('Fitness', Icons.fitness_center_rounded),
    ('Music', Icons.headphones_outlined),
    ('Travel', Icons.flight_takeoff_rounded),
    ('Startups', Icons.rocket_launch_outlined),
    ('Movies', Icons.movie_outlined),
    ('Food', Icons.restaurant_outlined),
  ];

  final _detailsKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final _ageController = TextEditingController();
  final _cityController = TextEditingController();
  final _bioController = TextEditingController();
  final Set<String> _interests = {};
  final List<String> _customInterests = [];
  int _step = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step == 0 && !(_detailsKey.currentState?.validate() ?? false)) return;
    if (_step == 1 && _interests.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose at least 3 interests.')),
      );
      return;
    }
    if (_step < 2) setState(() => _step++);
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() => _step--);
    }
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ProfilePreviewScreen(
          name: _nameController.text.trim(),
          age: _ageController.text.trim(),
          city: _cityController.text.trim(),
          bio: _bioController.text.trim(),
          interests: _interests.toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['About you', 'Your interests', 'Add your photos'];
    final subtitles = [
      'Tell people the basics. You can edit these details later.',
      'Choose at least three things you genuinely enjoy.',
      'For now, these are frontend placeholders for your future photos.',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('profileBackButton'),
          onPressed: _back,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Create profile'),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 5,
                      margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
                      decoration: BoxDecoration(
                        color: index <= _step
                            ? BondCircleColors.primary
                            : BondCircleColors.border,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    if (_step == 0) _detailsStep(),
                    if (_step == 1) _interestsStep(),
                    if (_step == 2) _photosStep(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: FilledButton(
                key: const Key('profileContinueButton'),
                onPressed: _step == 2 ? _finish : _next,
                child: Text(_step == 2 ? 'Preview profile' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailsStep() {
    return Form(
      key: _detailsKey,
      child: Column(
        children: [
          TextFormField(
            key: const Key('profileNameField'),
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            validator: (value) =>
                (value ?? '').trim().length < 2 ? 'Enter your name' : null,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  key: const Key('profileAgeField'),
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age'),
                  validator: (value) {
                    final age = int.tryParse((value ?? '').trim());
                    return age == null || age < 18 || age > 99
                        ? 'Enter age 18–99'
                        : null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: TextFormField(
                  key: const Key('profileCityField'),
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) =>
                      (value ?? '').trim().isEmpty ? 'Enter your city' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('profileBioField'),
            controller: _bioController,
            maxLines: 4,
            maxLength: 180,
            decoration: const InputDecoration(
              labelText: 'Short introduction',
              hintText: 'What should someone know about you?',
              alignLabelWithHint: true,
            ),
            validator: (value) => (value ?? '').trim().length < 20
                ? 'Write at least 20 characters'
                : null,
          ),
        ],
      ),
    );
  }

  Widget _interestsStep() {
    return Wrap(
      spacing: 10,
      runSpacing: 12,
      children: [
        ..._interestOptions.map((option) {
          final selected = _interests.contains(option.$1);
          return FilterChip(
            key: Key('interest${option.$1}'),
            selected: selected,
            showCheckmark: false,
            avatar: Icon(option.$2, size: 19),
            label: Text(option.$1),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            onSelected: (_) => setState(() {
              selected
                  ? _interests.remove(option.$1)
                  : _interests.add(option.$1);
            }),
          );
        }),
        ..._customInterests.map((interest) {
          final selected = _interests.contains(interest);
          return FilterChip(
            key: Key('interest$interest'),
            selected: selected,
            showCheckmark: false,
            avatar: const Icon(Icons.auto_awesome_rounded, size: 19),
            label: Text(interest),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            onSelected: (_) => setState(() {
              selected ? _interests.remove(interest) : _interests.add(interest);
            }),
          );
        }),
        ActionChip(
          key: const Key('addCustomInterestButton'),
          avatar: const Icon(Icons.add_rounded, size: 20),
          label: const Text('Add interest'),
          side: const BorderSide(color: BondCircleColors.primary),
          labelStyle: const TextStyle(
            color: BondCircleColors.primary,
            fontWeight: FontWeight.w700,
          ),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          onPressed: _showAddInterestDialog,
        ),
      ],
    );
  }

  Future<void> _showAddInterestDialog() async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final addedInterest = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add your interest'),
        content: Form(
          key: formKey,
          child: TextFormField(
            key: const Key('customInterestField'),
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            maxLength: 24,
            decoration: const InputDecoration(
              hintText: 'e.g. Photography',
              prefixIcon: Icon(Icons.interests_outlined),
            ),
            validator: (value) {
              final interest = (value ?? '').trim();
              if (interest.length < 2) return 'Enter an interest';
              final existing = [
                ..._interestOptions.map((item) => item.$1),
                ..._customInterests,
              ];
              if (existing.any(
                (item) => item.toLowerCase() == interest.toLowerCase(),
              )) {
                return 'This interest is already listed';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('confirmCustomInterestButton'),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(dialogContext).pop(controller.text.trim());
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (addedInterest != null && mounted) {
      setState(() {
        _customInterests.add(addedInterest);
        _interests.add(addedInterest);
      });
    }
  }

  Widget _photosStep() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.82,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo picker will be connected later.'),
            ),
          ),
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            decoration: BoxDecoration(
              color: index == 0 ? BondCircleColors.lavender : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: BondCircleColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  index == 0 ? Icons.add_a_photo_outlined : Icons.add_rounded,
                  color: BondCircleColors.purple,
                  size: 30,
                ),
                const SizedBox(height: 10),
                Text(index == 0 ? 'Main photo' : 'Add photo'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfilePreviewScreen extends StatelessWidget {
  const ProfilePreviewScreen({
    super.key,
    required this.name,
    required this.age,
    required this.city,
    required this.bio,
    required this.interests,
  });

  final String name;
  final String age;
  final String city;
  final String bio;
  final List<String> interests;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile preview')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [BondCircleColors.lavender, Color(0xFFFFDFE8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Icon(Icons.person_rounded, size: 110, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          Text('$name, $age', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 19),
              const SizedBox(width: 5),
              Text(city),
            ],
          ),
          const SizedBox(height: 20),
          Text(bio, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests.map((item) => Chip(label: Text(item))).toList(),
          ),
          const SizedBox(height: 28),
          FilledButton(
            key: const Key('saveProfileButton'),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => InterestCirclesScreen(displayName: name),
              ),
            ),
            child: const Text('Save and choose circles'),
          ),
        ],
      ),
    );
  }
}

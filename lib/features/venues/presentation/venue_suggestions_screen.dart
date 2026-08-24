import 'package:flutter/material.dart';

import '../../../theme/bondcircle_theme.dart';
import '../../safety/presentation/safety_check_in_screen.dart';

class VenueSuggestionsScreen extends StatefulWidget {
  const VenueSuggestionsScreen({
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
  State<VenueSuggestionsScreen> createState() => _VenueSuggestionsScreenState();
}

class _VenueSuggestionsScreenState extends State<VenueSuggestionsScreen> {
  static const _filters = ['All', 'Café', 'Activity', 'Outdoors', 'Food'];
  static const _venues = [
    _Venue(
      'Paper & Bean',
      'Café',
      'Park Street',
      '1.2 km',
      4.7,
      '₹₹',
      'Open until 9 PM',
      Icons.local_cafe_outlined,
      Color(0xFFE9B38B),
      ['Well-lit', 'Busy area', 'Quiet tables'],
    ),
    _Venue(
      'Storyhouse Café',
      'Café',
      'College Street',
      '2.4 km',
      4.6,
      '₹',
      'Open until 8 PM',
      Icons.menu_book_outlined,
      Color(0xFF9BBFAD),
      ['Public place', 'Bookstore', 'Easy exit'],
    ),
    _Venue(
      'Pixel Playground',
      'Activity',
      'Salt Lake',
      '3.1 km',
      4.8,
      '₹₹',
      'Open until 10 PM',
      Icons.sports_esports_outlined,
      Color(0xFFA999E8),
      ['Staff present', 'Popular', 'Games'],
    ),
    _Venue(
      'Lakeside Garden',
      'Outdoors',
      'Rabindra Sarobar',
      '2.8 km',
      4.5,
      'Free',
      'Open until 7 PM',
      Icons.park_outlined,
      Color(0xFF86BE96),
      ['Daytime pick', 'Public', 'Open space'],
    ),
    _Venue(
      'Sunday Table',
      'Food',
      'Ballygunge',
      '1.8 km',
      4.7,
      '₹₹',
      'Open until 10 PM',
      Icons.brunch_dining_outlined,
      Color(0xFFE6A6A6),
      ['Family venue', 'Well-reviewed', 'Indoor'],
    ),
  ];

  String _filter = 'All';
  String _query = '';

  List<_Venue> get _visible => _venues.where((venue) {
    final filterMatches = _filter == 'All' || venue.category == _filter;
    final query = _query.toLowerCase();
    return filterMatches &&
        (venue.name.toLowerCase().contains(query) ||
            venue.area.toLowerCase().contains(query));
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venue suggestions')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            'Choose a date-friendly venue',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Public, comfortable options for your ${widget.vibe.toLowerCase()} plan with ${widget.matchName}.',
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: BondCircleColors.lavender,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: BondCircleColors.purple),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Demo venues and ratings for the frontend prototype. Always verify the place before meeting.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            key: const Key('venueSearchField'),
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search by venue or area',
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final filter = _filters[index];
                return ChoiceChip(
                  key: Key('venueFilter$filter'),
                  selected: _filter == filter,
                  label: Text(filter),
                  onSelected: (_) => setState(() => _filter = filter),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          if (_visible.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('No demo venues match your search.')),
            )
          else
            ..._visible.map(
              (venue) => _VenueCard(
                venue: venue,
                onDetails: () => _showDetails(venue),
                onSelect: () => _selectVenue(venue),
              ),
            ),
        ],
      ),
    );
  }

  void _showDetails(_Venue venue) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(venue.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('${venue.area} • ${venue.distance} • ${venue.price}'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: venue.tags
                  .map((tag) => Chip(label: Text(tag)))
                  .toList(),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  _selectVenue(venue);
                },
                child: const Text('Select this venue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectVenue(_Venue venue) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _SelectedVenueScreen(
          matchName: widget.matchName,
          title: widget.title,
          date: widget.date,
          time: widget.time,
          venue: venue,
        ),
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({
    required this.venue,
    required this.onDetails,
    required this.onSelect,
  });
  final _Venue venue;
  final VoidCallback onDetails;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 14),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: venue.color.withValues(alpha: .35),
                child: Icon(venue.icon, color: BondCircleColors.ink),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venue.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text('${venue.category} • ${venue.area}'),
                  ],
                ),
              ),
              Text(
                '★ ${venue.rating}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text('${venue.distance} • ${venue.price} • ${venue.hours}'),
          const SizedBox(height: 14),
          Row(
            children: [
              TextButton(
                onPressed: onDetails,
                child: const Text('View details'),
              ),
              const Spacer(),
              FilledButton(
                key: Key('selectVenue${venue.name}'),
                onPressed: onSelect,
                child: const Text('Select'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _SelectedVenueScreen extends StatelessWidget {
  const _SelectedVenueScreen({
    required this.matchName,
    required this.title,
    required this.date,
    required this.time,
    required this.venue,
  });
  final String matchName;
  final String title;
  final DateTime date;
  final String time;
  final _Venue venue;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Plan ready')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(
          Icons.check_circle_rounded,
          size: 72,
          color: BondCircleColors.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Venue selected!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Your plan with $matchName is ready to review.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                _SummaryRow(Icons.location_on_outlined, venue.name, venue.area),
                _SummaryRow(
                  Icons.calendar_month_outlined,
                  '${date.day}/${date.month}/${date.year}',
                  time,
                ),
                _SummaryRow(
                  Icons.shield_outlined,
                  'Public meetup',
                  venue.tags.take(2).join(' • '),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BondCircleColors.lavender,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Text(
            'Next milestone: share the plan with a trusted friend and set a safety check-in.',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          key: const Key('setupSafetyCheckInButton'),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => SafetyCheckInScreen(
                matchName: matchName,
                planTitle: title,
                venueName: venue.name,
                venueArea: venue.area,
                date: date,
                time: time,
              ),
            ),
          ),
          icon: const Icon(Icons.verified_user_outlined),
          label: const Text('Set up safety check-in'),
        ),
      ],
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Icon(icon, color: BondCircleColors.purple),
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

class _Venue {
  const _Venue(
    this.name,
    this.category,
    this.area,
    this.distance,
    this.rating,
    this.price,
    this.hours,
    this.icon,
    this.color,
    this.tags,
  );
  final String name, category, area, distance, price, hours;
  final double rating;
  final IconData icon;
  final Color color;
  final List<String> tags;
}

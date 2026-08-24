import 'package:flutter/material.dart';

import '../../../theme/bondcircle_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.matchName,
    required this.sharedCircle,
  });

  final String matchName;
  final String sharedCircle;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late final List<_ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      _ChatMessage(
        text: 'You matched through ${widget.sharedCircle}',
        type: _MessageType.system,
      ),
      const _ChatMessage(
        text: 'Your Vibe Check suggests starting with a relaxed, low-pressure plan.',
        type: _MessageType.system,
      ),
      _ChatMessage(
        text: 'Hey! I liked your answer about a quiet coffee meetup ☕',
        type: _MessageType.received,
        time: '5:31 PM',
      ),
      const _ChatMessage(
        text: 'Same here. A good café and an easy conversation sounds perfect.',
        type: _MessageType.sent,
        time: '5:32 PM',
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? suppliedText]) {
    final text = (suppliedText ?? _messageController.text).trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        _ChatMessage(text: text, type: _MessageType.sent, time: 'Now'),
      );
      _messageController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE9A8B9), Color(0xFF9E6DD7)],
                ),
                shape: BoxShape.circle,
              ),
              child: Text(
                widget.matchName.characters.first,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.matchName),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified_rounded,
                      color: BondCircleColors.primary,
                      size: 17,
                    ),
                  ],
                ),
                const Text(
                  'Online',
                  style: TextStyle(
                    color: Color(0xFF3D9B6A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            key: const Key('chatSafetyButton'),
            tooltip: 'Safety options',
            onPressed: _showSafetyOptions,
            icon: const Icon(Icons.shield_outlined),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              color: BondCircleColors.lavender,
              child: Row(
                children: [
                  const Icon(
                    Icons.diversity_1_outlined,
                    color: BondCircleColors.purple,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Shared circle: ${widget.sharedCircle}',
                      style: const TextStyle(
                        color: BondCircleColors.purple,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    key: const Key('planMeetupButton'),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Meetup Planner is the next milestone.'),
                      ),
                    ),
                    icon: const Icon(Icons.calendar_month_outlined, size: 18),
                    label: const Text('Plan'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) =>
                    _MessageBubble(message: _messages[index]),
              ),
            ),
            _ConversationStarters(onSelected: _sendMessage),
            _Composer(controller: _messageController, onSend: _sendMessage),
          ],
        ),
      ),
    );
  }

  Future<void> _showSafetyOptions() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Safety options',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.block_rounded),
                title: Text('Block ${widget.matchName}'),
                subtitle: const Text(
                  'They will no longer be able to contact you.',
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Report a concern'),
                subtitle: const Text(
                  'Reporting will be connected to the backend later.',
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    if (message.type == _MessageType.system) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          message.text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: BondCircleColors.muted, fontSize: 12.5),
        ),
      );
    }

    final sent = message.type == _MessageType.sent;
    return Align(
      alignment: sent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 290),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(15, 11, 15, 8),
        decoration: BoxDecoration(
          color: sent ? BondCircleColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(19),
            topRight: const Radius.circular(19),
            bottomLeft: Radius.circular(sent ? 19 : 5),
            bottomRight: Radius.circular(sent ? 5 : 19),
          ),
          border: sent ? null : Border.all(color: BondCircleColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: sent ? Colors.white : BondCircleColors.ink,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.time ?? '',
              style: TextStyle(
                color: sent ? Colors.white70 : BondCircleColors.muted,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationStarters extends StatelessWidget {
  const _ConversationStarters({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const starters = [
      'Favourite café?',
      'Weekend plan?',
      'What are you reading?',
    ];
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: starters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) => ActionChip(
          key: Key('starter$index'),
          avatar: const Icon(Icons.auto_awesome_rounded, size: 16),
          label: Text(starters[index]),
          onPressed: () => onSelected(starters[index]),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 9, 14, 14),
      decoration: const BoxDecoration(
        color: BondCircleColors.background,
        border: Border(top: BorderSide(color: BondCircleColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: const Key('chatMessageField'),
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              minLines: 1,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                hintText: 'Write a message…',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 9),
          IconButton.filled(
            key: const Key('sendChatMessageButton'),
            onPressed: onSend,
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}

enum _MessageType { sent, received, system }

class _ChatMessage {
  const _ChatMessage({required this.text, required this.type, this.time});

  final String text;
  final _MessageType type;
  final String? time;
}

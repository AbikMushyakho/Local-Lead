import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/data/messages_data.dart';

class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final String time;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
  });
}

class IndividualMessageScreen extends StatefulWidget {
  final String conversationId;

  const IndividualMessageScreen({super.key, required this.conversationId});

  @override
  State<IndividualMessageScreen> createState() =>
      _IndividualMessageScreenState();
}

class _IndividualMessageScreenState extends State<IndividualMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = const [
    ChatMessage(
      id: '1',
      sender: 'guide',
      text:
      'Hi! Thanks for your interest in booking a tour with me. I\'d love to show you around!',
      time: '10:30 AM',
    ),
    ChatMessage(
      id: '2',
      sender: 'user',
      text: 'Great! I\'m interested in a food tour. What do you recommend?',
      time: '10:32 AM',
    ),
    ChatMessage(
      id: '3',
      sender: 'guide',
      text:
      'I\'d recommend a 3-hour morning tour where we visit local markets and authentic restaurants. We can customize it based on your preferences!',
      time: '10:35 AM',
    ),
  ];

  List<ChatMessage> _allMessages = [];

  @override
  void initState() {
    super.initState();
    _allMessages = List.from(_messages);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';

    setState(() {
      _allMessages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: 'user',
        text: text,
        time: '$hour:$minute $period',
      ));
      _messageController.clear();
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    // Find conversation
    final conversation = conversations.firstWhere(
          (c) => c.id == widget.conversationId,
      orElse: () => conversations.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.card,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.arrowLeft,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Guide photo with online indicator
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            conversation.guidePhoto,
                            width: isTablet ? 48 : 42,
                            height: isTablet ? 48 : 42,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: isTablet ? 48 : 42,
                              height: isTablet ? 48 : 42,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.user,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (conversation.isOnline)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 11,
                              height: 11,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.card,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // Guide info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            conversation.guideName,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            conversation.isOnline ? 'Online' : conversation.guideSpecialty,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 13 : 12,
                              color: conversation.isOnline
                                  ? Colors.green
                                  : AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(
                isTablet ? 32 : 16,
                16,
                isTablet ? 32 : 16,
                16,
              ),
              itemCount: _allMessages.length,
              itemBuilder: (context, index) {
                final message = _allMessages[index];
                final isUser = message.sender == 'user';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Guide avatar for guide messages
                      if (!isUser) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            conversation.guidePhoto,
                            width: 28,
                            height: 28,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],

                      // Message bubble
                      Flexible(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth:
                            MediaQuery.of(context).size.width * 0.72,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? AppColors.accent
                                  : AppColors.card,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(18),
                                topRight: const Radius.circular(18),
                                bottomLeft: Radius.circular(isUser ? 18 : 4),
                                bottomRight: Radius.circular(isUser ? 4 : 18),
                              ),
                              border: isUser
                                  ? null
                                  : Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  message.text,
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: isTablet ? 15 : 14,
                                    color: isUser
                                        ? AppColors.accentForeground
                                        : AppColors.primary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  message.time,
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: isTablet ? 12 : 11,
                                    color: isUser
                                        ? AppColors.accentForeground
                                        .withAlpha(180)
                                        : AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Message input
          Container(
            decoration: const BoxDecoration(
              color: AppColors.card,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            padding: EdgeInsets.fromLTRB(
              isTablet ? 32 : 16,
              12,
              isTablet ? 32 : 16,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 16 : 14,
                        color: AppColors.primary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 16 : 14,
                          color: AppColors.mutedForeground,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      maxLines: null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: isTablet ? 48 : 44,
                    height: isTablet ? 48 : 44,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.paperPlane,
                        size: isTablet ? 18 : 16,
                        color: AppColors.accentForeground,
                      ),
                    ),
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
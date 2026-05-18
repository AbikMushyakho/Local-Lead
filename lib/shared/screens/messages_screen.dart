import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/data/messages_data.dart';
import 'package:local_lead/models/guide_model.dart';
import 'package:local_lead/models/conversation_model.dart';
import 'package:local_lead/shared/widgets/search_bar.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Conversation> get _filtered => conversations
      .where((c) =>
  _searchQuery.isEmpty ||
      c.guideName.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

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
                padding: EdgeInsets.fromLTRB(
                  isTablet ? 32 : 24,
                  16,
                  isTablet ? 32 : 24,
                  16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Messages',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 28 : 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppSearchBar(
                      controller: _searchController,
                      hintText: 'Search conversations...',
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Conversations list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
              child: Text(
                'No conversations found',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: isTablet ? 16 : 14,
                  color: AppColors.mutedForeground,
                ),
              ),
            )
                : ListView.separated(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 32 : 20,
                16,
                isTablet ? 32 : 20,
                32,
              ),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _ConversationCard(
                  conversation: _filtered[index],
                  isTablet: isTablet,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Conversation Card Widget
class _ConversationCard extends StatelessWidget {
  final Conversation conversation;
  final bool isTablet;

  const _ConversationCard({
    required this.conversation,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/message/${conversation.id}'),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Photo with online indicator
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    conversation.guidePhoto,
                    width: isTablet ? 60 : 52,
                    height: isTablet ? 60 : 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: isTablet ? 60 : 52,
                      height: isTablet ? 60 : 52,
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
                      width: 13,
                      height: 13,
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
            SizedBox(width: isTablet ? 16 : 12),

            // Conversation info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          conversation.guideName,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 16 : 15,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        conversation.lastMessageTime,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 13 : 11,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    conversation.guideSpecialty,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 13 : 12,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 14 : 13,
                            color: conversation.unreadCount > 0
                                ? AppColors.primary
                                : AppColors.mutedForeground,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            conversation.unreadCount.toString(),
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 12 : 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentForeground,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
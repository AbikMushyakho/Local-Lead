// Conversation Model
class Conversation {
  final String id;
  final String guideId;
  final String guideName;
  final String guidePhoto;
  final String guideSpecialty;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  const Conversation({
    required this.id,
    required this.guideId,
    required this.guideName,
    required this.guidePhoto,
    required this.guideSpecialty,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
  });
}

import 'package:local_lead/models/guide_model.dart';
import 'package:local_lead/models/conversation_model.dart';


const List<Conversation> conversations = [
  Conversation(
    id: '1',
    guideId: '1',
    guideName: 'Maria Santos',
    guidePhoto:
    'https://images.unsplash.com/photo-1664101606938-e664f5852fac?w=400',
    guideSpecialty: 'Food & Culture',
    lastMessage: 'Great! I\'ll meet you at the Downtown Plaza at 9 AM tomorrow.',
    lastMessageTime: '2h ago',
    unreadCount: 2,
    isOnline: true,
  ),
  Conversation(
    id: '2',
    guideId: '2',
    guideName: 'James Chen',
    guidePhoto:
    'https://images.unsplash.com/photo-1741242950155-2ac2eb91bd69?w=400',
    guideSpecialty: 'Architecture & History',
    lastMessage:
    'Thanks for booking! Looking forward to showing you the historic district.',
    lastMessageTime: '1 day ago',
    unreadCount: 0,
    isOnline: false,
  ),
  Conversation(
    id: '3',
    guideId: '3',
    guideName: 'Sofia Petrov',
    guidePhoto:
    'https://images.unsplash.com/photo-1697468575302-e50cbb0b6b35?w=400',
    guideSpecialty: 'Art & Photography',
    lastMessage: 'I know some amazing spots for golden hour photography!',
    lastMessageTime: '3 days ago',
    unreadCount: 0,
    isOnline: true,
  ),
  Conversation(
    id: '4',
    guideId: '5',
    guideName: 'Aisha Rahman',
    guidePhoto:
    'https://images.unsplash.com/photo-1712479667983-9f2872d33fb9?w=400',
    guideSpecialty: 'Markets & Shopping',
    lastMessage: 'The market tour was amazing! Thank you so much 🙏',
    lastMessageTime: '1 week ago',
    unreadCount: 0,
    isOnline: false,
  ),
];
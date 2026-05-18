import 'package:local_lead/models/guide_model.dart';
import 'package:local_lead/models/review_model.dart';

const List<String> categories = [
  'Food & Culture',
  'Architecture',
  'Art & Photography',
  'Adventure',
  'Shopping',
  'Nightlife',
];

const List<Guide> guides = [

  // Maria Santos — Food & Culture
  Guide(
    id: '1',
    name: 'Maria Santos',
    photo: 'https://images.unsplash.com/photo-1664101606938-e664f5852fac?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=400',
    email: 'maria.santos@locallead.com',
    phone: '+1 555-9876',
    location: 'San Francisco, CA',
    memberSince: 'March 2022',
    verified: true,
    specialty: 'Food & Culture',
    rating: 4.9,
    reviewCount: 50,
    totalTours: 243,
    hourlyRate: 45,
    bio: 'Born and raised in this beautiful city, I\'ve spent the last 8 years sharing my passion for local cuisine and hidden cultural gems with travelers from around the world. Let me show you the authentic side of our city!',
    languages: ['English', 'Spanish', 'Portuguese'],
    experience: '8 years',
    distance: '0.5 km away',
    certifications: [
      'Certified Tourism Professional',
      'Food Safety Certificate',
      'First Aid & CPR Certified',
    ],
    weeklyAvailability: {
      'monday': [
        AvailabilitySlot(start: '09:00', end: '12:00'),
        AvailabilitySlot(start: '14:00', end: '18:00'),
      ],
      'tuesday': [
        AvailabilitySlot(start: '09:00', end: '12:00'),
        AvailabilitySlot(start: '14:00', end: '18:00'),
      ],
      'wednesday': [
        AvailabilitySlot(start: '09:00', end: '12:00'),
        AvailabilitySlot(start: '15:00', end: '19:00'),
      ],
      'thursday': [
        AvailabilitySlot(start: '09:00', end: '12:00'),
        AvailabilitySlot(start: '14:00', end: '18:00'),
      ],
      'friday': [
        AvailabilitySlot(start: '09:00', end: '12:00'),
        AvailabilitySlot(start: '14:00', end: '18:00'),
      ],
      'saturday': [
        AvailabilitySlot(start: '10:00', end: '15:00'),
      ],
      'sunday': [],
    },
    gallery: [
      'https://images.unsplash.com/photo-1762530351369-00612964e8b5?w=1080',
      'https://images.unsplash.com/photo-1771699435159-97ae9b401156?w=1080',
      'https://images.unsplash.com/photo-1768722687185-98eb3d8c0d8c?w=1080',
    ],
    tourPhotos: [
      'https://images.unsplash.com/photo-1622322781846-37e0262fa0e0?w=1080',
      'https://images.unsplash.com/photo-1767468200546-244b9c52a307?w=1080',
      'https://images.unsplash.com/photo-1767801115513-3b7306f309da?w=1080',
      'https://images.unsplash.com/photo-1764414240760-61c181171a45?w=1080',
    ],
    reviews: [
      Review(
        id: 'r1',
        userName: 'John Davies',
        userPhoto: 'https://images.unsplash.com/photo-1718179804654-7c3720b78e67?w=100',
        rating: 5,
        date: '2 days ago',
        comment: 'Maria was absolutely fantastic! She took us to incredible local restaurants we never would have found on our own.',
        tourType: 'Food & Culture Tour',
        verified: true,
      ),
      Review(
        id: 'r2',
        userName: 'Sophie Chen',
        userPhoto: 'https://images.unsplash.com/photo-1697468575302-e50cbb0b6b35?w=100',
        rating: 5,
        date: '1 week ago',
        comment: 'Best food tour ever! Maria is passionate, knowledgeable, and so friendly. Highly recommend!',
        tourType: 'Walking Food Tour',
        verified: true,
      ),
      Review(
        id: 'r3',
        userName: 'Alex Rodriguez',
        userPhoto: 'https://images.unsplash.com/photo-1659100939687-a7c10b4d5841?w=100',
        rating: 4,
        date: '2 weeks ago',
        comment: 'Great experience overall. Maria knows all the best spots and her stories about local culture were fascinating.',
        tourType: 'Food & Culture Tour',
        verified: true,
      ),
    ],
  ),

  // James Chen — Architecture & History
  Guide(
    id: '2',
    name: 'James Chen',
    photo: 'https://images.unsplash.com/photo-1741242950155-2ac2eb91bd69?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=400',
    email: 'james.chen@locallead.com',
    phone: '+81 90-1234-5678',
    location: 'Tokyo',
    memberSince: 'June 2021',
    verified: true,
    specialty: 'Architecture & History',
    rating: 4.8,
    reviewCount: 40,
    totalTours: 189,
    hourlyRate: 50,
    bio: 'As an architect and history enthusiast, I love revealing the stories behind our city\'s iconic buildings and hidden historical sites. Join me for a journey through time!',
    languages: ['English', 'Mandarin', 'Cantonese'],
    experience: '10 years',
    distance: '1.2 km away',
    certifications: [
      'Licensed Architect',
      'Certified Heritage Guide',
      'First Aid Certified',
    ],
    weeklyAvailability: {
      'monday': [
        AvailabilitySlot(start: '09:00', end: '13:00'),
      ],
      'tuesday': [
        AvailabilitySlot(start: '09:00', end: '13:00'),
        AvailabilitySlot(start: '14:00', end: '17:00'),
      ],
      'wednesday': [
        AvailabilitySlot(start: '09:00', end: '13:00'),
      ],
      'thursday': [
        AvailabilitySlot(start: '09:00', end: '13:00'),
        AvailabilitySlot(start: '14:00', end: '17:00'),
      ],
      'friday': [
        AvailabilitySlot(start: '09:00', end: '13:00'),
      ],
      'saturday': [],
      'sunday': [],
    },
    gallery: [
      'https://images.unsplash.com/photo-1773433362083-200dc53e0af3?w=1080',
      'https://images.unsplash.com/photo-1754501480145-5c2f0ad233ba?w=1080',
      'https://images.unsplash.com/photo-1754501482346-878bb1566033?w=1080',
    ],
    tourPhotos: [
      'https://images.unsplash.com/photo-1770291230978-2678c30cddb5?w=1080',
      'https://images.unsplash.com/photo-1765024540914-666ec6440ab9?w=1080',
      'https://images.unsplash.com/photo-1774703700153-6e810b96f984?w=1080',
      'https://images.unsplash.com/photo-1763990829763-6e0817ce4d40?w=1080',
    ],
    reviews: [
      Review(
        id: 'r4',
        userName: 'Emma Watson',
        userPhoto: 'https://images.unsplash.com/photo-1664101606938-e664f5852fac?w=100',
        rating: 5,
        date: '3 days ago',
        comment: 'James brought the city\'s architecture to life with his fascinating stories and expertise.',
        tourType: 'Architecture & History Tour',
        verified: true,
      ),
      Review(
        id: 'r5',
        userName: 'Michael Brown',
        userPhoto: 'https://images.unsplash.com/photo-1712479667983-9f2872d33fb9?w=100',
        rating: 5,
        date: '5 days ago',
        comment: 'Incredible depth of knowledge. James made history engaging and fun!',
        tourType: 'City History Walk',
        verified: true,
      ),
    ],
  ),

  // Sofia Petrov — Art & Photography
  Guide(
    id: '3',
    name: 'Sofia Petrov',
    photo: 'https://images.unsplash.com/photo-1697468575302-e50cbb0b6b35?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=400',
    email: 'sofia.petrov@locallead.com',
    phone: '+33 6-1234-5678',
    location: 'Paris',
    memberSince: 'September 2022',
    verified: true,
    specialty: 'Art & Photography',
    rating: 5.0,
    reviewCount: 20,
    totalTours: 97,
    hourlyRate: 55,
    bio: 'Professional photographer and art lover helping you discover the most Instagram-worthy spots and local art scene. Perfect for creative travelers!',
    languages: ['English', 'Russian', 'French'],
    experience: '5 years',
    distance: '0.8 km away',
    certifications: [
      'Professional Photography Certificate',
      'Certified Art Guide',
      'Digital Media Specialist',
    ],
    weeklyAvailability: {
      'monday': [
        AvailabilitySlot(start: '07:00', end: '10:00'),
        AvailabilitySlot(start: '17:00', end: '20:00'),
      ],
      'tuesday': [
        AvailabilitySlot(start: '07:00', end: '10:00'),
        AvailabilitySlot(start: '17:00', end: '20:00'),
      ],
      'wednesday': [],
      'thursday': [
        AvailabilitySlot(start: '07:00', end: '10:00'),
        AvailabilitySlot(start: '17:00', end: '20:00'),
      ],
      'friday': [
        AvailabilitySlot(start: '07:00', end: '10:00'),
        AvailabilitySlot(start: '17:00', end: '20:00'),
      ],
      'saturday': [
        AvailabilitySlot(start: '06:30', end: '10:00'),
        AvailabilitySlot(start: '16:00', end: '20:00'),
      ],
      'sunday': [
        AvailabilitySlot(start: '06:30', end: '10:00'),
      ],
    },
    gallery: [
      'https://images.unsplash.com/photo-1561599775-fc0e9d8e258f?w=1080',
      'https://images.unsplash.com/photo-1640200450745-a11b8526e8e1?w=1080',
      'https://images.unsplash.com/photo-1654411748110-aeed3938042d?w=1080',
    ],
    tourPhotos: [
      'https://images.unsplash.com/photo-1750462137035-2a774b193138?w=1080',
      'https://images.unsplash.com/photo-1703850547425-397deb506fab?w=1080',
      'https://images.unsplash.com/photo-1678910078910-ae99255cbf10?w=1080',
      'https://images.unsplash.com/photo-1766931499554-0aa549f62745?w=1080',
    ],
    reviews: [
      Review(
        id: 'r6',
        userName: 'Lisa Park',
        userPhoto: 'https://images.unsplash.com/photo-1741242950155-2ac2eb91bd69?w=100',
        rating: 5,
        date: '1 day ago',
        comment: 'Sofia is amazing! Got the best photos of my trip thanks to her guidance.',
        tourType: 'Photography Walk',
        verified: true,
      ),
    ],
  ),

  // Marcus Johnson — Adventure & Nature
  Guide(
    id: '4',
    name: 'Marcus Johnson',
    photo: 'https://images.unsplash.com/photo-1659100939687-a7c10b4d5841?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=400',
    email: 'marcus.johnson@locallead.com',
    phone: '+81 90-8765-4321',
    location: 'Tokyo',
    memberSince: 'January 2023',
    verified: true,
    specialty: 'Adventure & Nature',
    rating: 4.7,
    reviewCount: 30,
    totalTours: 142,
    hourlyRate: 40,
    bio: 'Outdoor enthusiast specializing in hiking trails, natural landmarks, and adventure activities. Let\'s explore the great outdoors together!',
    languages: ['English', 'German'],
    experience: '7 years',
    distance: '2.1 km away',
    certifications: [
      'Wilderness First Responder',
      'Mountain Guide Certification',
      'Leave No Trace Educator',
    ],
    weeklyAvailability: {
      'monday': [
        AvailabilitySlot(start: '06:00', end: '12:00'),
      ],
      'tuesday': [],
      'wednesday': [
        AvailabilitySlot(start: '06:00', end: '12:00'),
      ],
      'thursday': [],
      'friday': [
        AvailabilitySlot(start: '06:00', end: '12:00'),
      ],
      'saturday': [
        AvailabilitySlot(start: '05:30', end: '13:00'),
      ],
      'sunday': [
        AvailabilitySlot(start: '05:30', end: '13:00'),
      ],
    },
    gallery: [
      'https://images.unsplash.com/photo-1581153438971-3222a5814529?w=1080',
      'https://images.unsplash.com/photo-1665138322333-061010dbe39b?w=1080',
      'https://images.unsplash.com/photo-1514481422339-db621c1fca86?w=1080',
    ],
    tourPhotos: [
      'https://images.unsplash.com/photo-1629629832921-d17e3e936cc8?w=1080',
      'https://images.unsplash.com/photo-1758671451540-58f5ef5a49ea?w=1080',
      'https://images.unsplash.com/photo-1763879853202-76eb3d66a226?w=1080',
      'https://images.unsplash.com/photo-1769007471276-8eb1e1fde091?w=1080',
    ],
    reviews: [
      Review(
        id: 'r7',
        userName: 'Tom Williams',
        userPhoto: 'https://images.unsplash.com/photo-1718179804654-7c3720b78e67?w=100',
        rating: 5,
        date: '4 days ago',
        comment: 'Marcus took us on an incredible hike with stunning views. Very knowledgeable about local flora and fauna!',
        tourType: 'Nature Hiking Tour',
        verified: true,
      ),
    ],
  ),

  // Aisha Rahman — Markets & Shopping
  Guide(
    id: '5',
    name: 'Aisha Rahman',
    photo: 'https://images.unsplash.com/photo-1712479667983-9f2872d33fb9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=400',
    email: 'aisha.rahman@locallead.com',
    phone: '+81 90-2345-6789',
    location: 'Tokyo',
    memberSince: 'May 2022',
    verified: true,
    specialty: 'Markets & Shopping',
    rating: 4.9,
    reviewCount: 17,
    totalTours: 78,
    hourlyRate: 35,
    bio: 'Navigate local markets like a pro! I\'ll help you find unique souvenirs, negotiate prices, and discover authentic local products.',
    languages: ['English', 'Arabic', 'Hindi'],
    experience: '6 years',
    distance: '1.5 km away',
    certifications: [
      'Certified Shopping Guide',
      'Cultural Liaison Certificate',
      'Language Interpretation Badge',
    ],
    weeklyAvailability: {
      'monday': [
        AvailabilitySlot(start: '09:00', end: '13:00'),
        AvailabilitySlot(start: '15:00', end: '19:00'),
      ],
      'tuesday': [
        AvailabilitySlot(start: '09:00', end: '13:00'),
        AvailabilitySlot(start: '15:00', end: '19:00'),
      ],
      'wednesday': [
        AvailabilitySlot(start: '09:00', end: '13:00'),
      ],
      'thursday': [
        AvailabilitySlot(start: '09:00', end: '13:00'),
        AvailabilitySlot(start: '15:00', end: '19:00'),
      ],
      'friday': [
        AvailabilitySlot(start: '09:00', end: '13:00'),
        AvailabilitySlot(start: '15:00', end: '19:00'),
      ],
      'saturday': [
        AvailabilitySlot(start: '08:00', end: '14:00'),
        AvailabilitySlot(start: '16:00', end: '20:00'),
      ],
      'sunday': [
        AvailabilitySlot(start: '08:00', end: '14:00'),
      ],
    },
    gallery: [
      'https://images.unsplash.com/photo-1775340137312-24a147909969?w=1080',
      'https://images.unsplash.com/photo-1758789867803-2db9b0c214fa?w=1080',
      'https://images.unsplash.com/photo-1766983218159-ad84913e41e4?w=1080',
    ],
    tourPhotos: [
      'https://images.unsplash.com/photo-1674336763650-0fc02fc99345?w=1080',
      'https://images.unsplash.com/photo-1771581254395-9da4a9c944ca?w=1080',
      'https://images.unsplash.com/photo-1772629735150-09e13df90567?w=1080',
      'https://images.unsplash.com/photo-1770811903007-8ad4a19fb283?w=1080',
    ],
    reviews: [
      Review(
        id: 'r8',
        userName: 'Rachel Green',
        userPhoto: 'https://images.unsplash.com/photo-1697468575302-e50cbb0b6b35?w=100',
        rating: 5,
        date: '6 days ago',
        comment: 'Aisha was wonderful! Found amazing deals and authentic local products.',
        tourType: 'Market Discovery Tour',
        verified: true,
      ),
    ],
  ),

  // Luca Rossi — Nightlife & Entertainment
  Guide(
    id: '6',
    name: 'Luca Rossi',
    photo: 'https://images.unsplash.com/photo-1718179804654-7c3720b78e67?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=400',
    email: 'luca.rossi@locallead.com',
    phone: '+971 50-123-4567',
    location: 'Dubai',
    memberSince: 'November 2023',
    verified: true,
    specialty: 'Nightlife & Entertainment',
    rating: 4.6,
    reviewCount: 54,
    totalTours: 201,
    hourlyRate: 38,
    bio: 'Experience the city after dark! I\'ll take you to the best bars, live music venues, and entertainment spots locals love.',
    languages: ['English', 'Italian', 'Spanish'],
    experience: '4 years',
    distance: '0.3 km away',
    certifications: [
      'Certified Entertainment Guide',
      'Responsible Service of Alcohol',
      'Event Management Certificate',
    ],
    weeklyAvailability: {
      'monday': [],
      'tuesday': [],
      'wednesday': [
        AvailabilitySlot(start: '19:00', end: '23:00'),
      ],
      'thursday': [
        AvailabilitySlot(start: '19:00', end: '23:00'),
      ],
      'friday': [
        AvailabilitySlot(start: '18:00', end: '23:00'),
      ],
      'saturday': [
        AvailabilitySlot(start: '17:00', end: '23:00'),
      ],
      'sunday': [
        AvailabilitySlot(start: '18:00', end: '22:00'),
      ],
    },
    gallery: [
      'https://images.unsplash.com/photo-1702533586864-f548c237fe04?w=1080',
      'https://images.unsplash.com/photo-1762421028264-fb4e2e9de042?w=1080',
      'https://images.unsplash.com/photo-1742588494964-7187dd0175b8?w=1080',
    ],
    tourPhotos: [
      'https://images.unsplash.com/photo-1770760692307-64606dd79c20?w=1080',
      'https://images.unsplash.com/photo-1758320576725-98b6f184c739?w=1080',
      'https://images.unsplash.com/photo-1761393574666-c7b435ef2983?w=1080',
      'https://images.unsplash.com/photo-1682185656282-13781272f8ae?w=1080',
    ],
    reviews: [
      Review(
        id: 'r9',
        userName: 'Chris Martin',
        userPhoto: 'https://images.unsplash.com/photo-1659100939687-a7c10b4d5841?w=100',
        rating: 5,
        date: '1 week ago',
        comment: 'Luca showed us an amazing night out! Great recommendations and fun company.',
        tourType: 'Nightlife Experience Tour',
        verified: true,
      ),
    ],
  ),
];
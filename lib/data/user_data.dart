import 'package:local_lead/models/guide_model.dart';
import 'package:local_lead/models/user_model.dart';
import 'package:local_lead/models/review_model.dart';


const User currentUser = User(
  id: 'user-001',
  name: 'Alex Thompson',
  photo: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
  email: 'alex.thompson@email.com',
  phone: '+1 555-0123',
  location: 'San Francisco, CA',
  memberSince: 'January 2025',
  bio: 'Adventure seeker and food lover exploring the world one city at a time.',
  verified: true,
);

const Guide currentGuide = Guide(
  id: '1',
  name: 'Maria Santos',
  photo: 'https://images.unsplash.com/photo-1664101606938-e664f5852fac?w=400',
  email: 'maria.santos@locallead.com',
  phone: '+1 555-9876',
  location: 'San Francisco, CA',
  memberSince: 'March 2022',
  bio: 'Born and raised in this beautiful city, I\'ve spent the last 8 years sharing my passion for local cuisine and hidden cultural gems with travelers from around the world.',
  verified: true,
  specialty: 'Food & Culture',
  rating: 4.9,
  reviewCount: 127,
  totalTours: 243,
  hourlyRate: 45,
  experience: '8 years',
  distance: '0.5 km away',
  languages: ['English', 'Spanish', 'Portuguese'],
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
);
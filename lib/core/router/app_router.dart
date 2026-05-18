import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:local_lead/models/booking_model.dart';
import 'package:local_lead/features/splash/splash_screen.dart';
import 'package:local_lead/features/auth/role_selection_screen.dart';
import 'package:local_lead/features/traveller/explore/explore_screen.dart';
import 'package:local_lead/features/traveller/bookings/my_bookings_screen.dart';
import 'package:local_lead/features/traveller/booking/booking_details_screen.dart';
import 'package:local_lead/features/traveller/booking/booking_confirmation_screen.dart';
import 'package:local_lead/features/traveller/profile/payment_methods_screen.dart';

import 'package:local_lead/features/guide/bookings/guide_bookings_screen.dart';
import 'package:local_lead/features/guide/profile/guide_profile_screen.dart';
import 'package:local_lead/features/guide/payout/payout_settings_screen.dart';
import 'package:local_lead/features/guide/earnings/earnings_screen.dart';
import 'package:local_lead/features/guide/reviews/my_reviews_screen.dart';
import 'package:local_lead/features/guide/manage_photos/manage_photos_screen.dart';

import 'package:local_lead/shared/widgets/bottom_navbar.dart';
import 'package:local_lead/shared/screens/messages_screen.dart';
import 'package:local_lead/shared/screens/individual_message_screen.dart';
import 'package:local_lead/shared/screens/profile_settings_screen.dart';
import 'package:local_lead/shared/screens/profile_screen.dart';
import 'package:local_lead/shared/screens/edit_personal_info_screen.dart';
import 'package:local_lead/shared/screens/edit_contact_screen.dart';
import 'package:local_lead/shared/screens/edit_professional_info_screen.dart';
import 'package:local_lead/shared/screens/edit_availability_screen.dart';
import 'package:local_lead/shared/screens/write_review_screen.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // No bottom nav routes
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/guide-profile/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return GuideProfileScreen(guideId: id);
      },
    ),
    GoRoute(
      path: '/booking-details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BookingDetailsScreen(guideId: id);
      },
    ),
    GoRoute(
      path: '/payment-methods',
      builder: (context, state) => const PaymentMethodsScreen(),
    ),

    GoRoute(
      path: '/booking-confirmation',
      builder: (context, state) {
        final booking = state.extra as Booking;
        return BookingConfirmationScreen(booking: booking);
      },
    ),
    GoRoute(
      path: '/message/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return IndividualMessageScreen(conversationId: id);
      },
    ),
    GoRoute(
      path: '/write-review',
      builder: (context, state) {
        final params = state.extra as Map<String, String>;
        return WriteReviewScreen(
          guideId: params['guideId']!,
          bookingId: params['bookingId']!,
        );
      },
    ),
    GoRoute(
      path: '/profile-settings',
      builder: (context, state) => const ProfileSettingsScreen(),
    ),

    GoRoute(
      path: '/edit-personal-info',
      builder: (context, state) => const EditPersonalInfoScreen(),
    ),

    GoRoute(
      path: '/edit-contact',
      builder: (context, state) => const EditContactScreen(),
    ),
    GoRoute(
      path: '/edit-professional-info',
      builder: (context, state) => const EditProfessionalInfoScreen(),
    ),
    GoRoute(
      path: '/edit-availability',
      builder: (context, state) => const EditAvailabilityScreen(),
    ),
    GoRoute(
      path: '/payout-settings',
      builder: (context, state) => const PayoutSettingsScreen(),
    ),
    GoRoute(
      path: '/my-reviews',
      builder: (context, state) => const MyReviewsScreen(),
    ),
    GoRoute(
      path: '/manage-photos',
      builder: (context, state) => const ManagePhotosScreen(),
    ),
    // Traveller Shell — with bottom nav
    ShellRoute(
      builder: (context, state, child) => TravellerShell(child: child),
      routes: [
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExploreScreen(),
        ),
        GoRoute(
          path: '/messages',
          builder: (context, state) => const MessagesScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const UserProfileScreen(),
        ),
        GoRoute(
          path: '/my-bookings',
          builder: (context, state) => const MyBookingsScreen(),
        ),
      ],
    ),

    // Guide Shell — with bottom nav
    ShellRoute(
      builder: (context, state, child) => GuideShell(child: child),
      routes: [
        GoRoute(
          path: '/guide-bookings',
          builder: (context, state) => const GuideBookingsScreen(),
        ),
        GoRoute(
          path: '/guide-earnings',
          builder: (context, state) => const EarningsScreen(),
        ),
        GoRoute(
          path: '/guide-messages',
          builder: (context, state) => const MessagesScreen(),
        ),
        GoRoute(
          path: '/guide-profile-page',
          builder: (context, state) => const UserProfileScreen(),
        ),
      ],
    ),
  ],
);

// Traveller Shell Widget
class TravellerShell extends StatelessWidget {
  final Widget child;
  const TravellerShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavBar(role: UserRole.traveller),
    );
  }
}

// Guide Shell Widget
class GuideShell extends StatelessWidget {
  final Widget child;
  const GuideShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavBar(role: UserRole.guide),
    );
  }
}
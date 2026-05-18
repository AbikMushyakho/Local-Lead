import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';

enum UserRole { traveller, guide }

class BottomNavBar extends StatelessWidget {
  final UserRole role;
  const BottomNavBar({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final items = role == UserRole.traveller
        ? _travellerItems
        : _guideItems;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: items.map((item) {
              final isActive = location == item['path'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => context.go(item['path'] as String),
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          item['icon'] as IconData,
                          size: 20,
                          color: isActive
                              ? AppColors.accent
                              : AppColors.mutedForeground,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: 11,
                            color: isActive
                                ? AppColors.accent
                                : AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  static const List<Map<String, dynamic>> _travellerItems = [
    {
      'path': '/explore',
      'icon': FontAwesomeIcons.house,
      'label': 'Home',
    },
    {
      'path': '/my-bookings',
      'icon': FontAwesomeIcons.calendarCheck,
      'label': 'Bookings',
    },
    {
      'path': '/messages',
      'icon': FontAwesomeIcons.message,
      'label': 'Messages',
    },
    {
      'path': '/profile',
      'icon': FontAwesomeIcons.user,
      'label': 'Profile',
    },
  ];

  static const List<Map<String, dynamic>> _guideItems = [
    {
      'path': '/guide-bookings',
      'icon': FontAwesomeIcons.calendarCheck,
      'label': 'Bookings',
    },
    {
      'path': '/guide-earnings',
      'icon': FontAwesomeIcons.dollarSign,
      'label': 'Earnings',
    },
    {
      'path': '/guide-messages',
      'icon': FontAwesomeIcons.message,
      'label': 'Messages',
    },
    {
      'path': '/guide-profile-page',
      'icon': FontAwesomeIcons.user,
      'label': 'Profile',
    },
  ];
}
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';

const List<Map<String, String>> popularDestinations = [
  {'city': 'San Francisco, CA', 'country': 'USA'},
  {'city': 'New York, NY', 'country': 'USA'},
  {'city': 'Los Angeles, CA', 'country': 'USA'},
  {'city': 'Paris', 'country': 'France'},
  {'city': 'London', 'country': 'UK'},
  {'city': 'Tokyo', 'country': 'Japan'},
  {'city': 'Barcelona', 'country': 'Spain'},
  {'city': 'Rome', 'country': 'Italy'},
  {'city': 'Dubai', 'country': 'UAE'},
  {'city': 'Bangkok', 'country': 'Thailand'},
  {'city': 'Sydney', 'country': 'Australia'},
  {'city': 'Singapore', 'country': 'Singapore'},
];

void showDestinationSelector({
  required BuildContext context,
  required String selectedDestination,
  required ValueChanged<String> onDestinationChanged,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _DestinationSelectorSheet(
      selectedDestination: selectedDestination,
      onDestinationChanged: onDestinationChanged,
    ),
  );
}

class _DestinationSelectorSheet extends StatefulWidget {
  final String selectedDestination;
  final ValueChanged<String> onDestinationChanged;

  const _DestinationSelectorSheet({
    required this.selectedDestination,
    required this.onDestinationChanged,
  });

  @override
  State<_DestinationSelectorSheet> createState() =>
      _DestinationSelectorSheetState();
}

class _DestinationSelectorSheetState
    extends State<_DestinationSelectorSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, String>> get _filtered => popularDestinations
      .where((dest) =>
      '${dest['city']} ${dest['country']}'
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()))
      .toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(
              isTablet ? 32 : 20,
              20,
              isTablet ? 32 : 20,
              16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose Destination',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.xmark,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Select a city to find local guides',
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: isTablet ? 14 : 13,
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 16),

                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) =>
                        setState(() => _searchQuery = val),
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 15 : 14,
                      color: AppColors.primary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search destinations...',
                      hintStyle: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 15 : 14,
                        color: AppColors.mutedForeground,
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14,vertical: 14),
                        child: FaIcon(
                          FontAwesomeIcons.magnifyingGlass,
                          size: 16,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          // Destinations list
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 32 : 20,
                12,
                isTablet ? 32 : 20,
                32,
              ),
              itemCount: _filtered.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isSelected = widget.selectedDestination.isEmpty;
                  return GestureDetector(
                    onTap: () {
                      widget.onDestinationChanged('');
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accent.withAlpha(15)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.globe,
                            size: 14,
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.mutedForeground,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'All Destinations',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const FaIcon(
                              FontAwesomeIcons.circleCheck,
                              size: 16,
                              color: AppColors.accent,
                            ),
                        ],
                      ),
                    ),
                  );
                }
                final dest = _filtered[index - 1];
                final isSelected =
                    widget.selectedDestination == dest['city'];

                return GestureDetector(
                  onTap: () {
                    widget.onDestinationChanged(dest['city']!);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accent.withAlpha(15)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.locationDot,
                          size: 14,
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.mutedForeground,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dest['city']!,
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 15 : 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                dest['country']!,
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 13 : 12,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const FaIcon(
                            FontAwesomeIcons.circleCheck,
                            size: 16,
                            color: AppColors.accent,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
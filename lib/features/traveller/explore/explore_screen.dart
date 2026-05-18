import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/data/guides_data.dart';
import 'package:local_lead/models/guide_model.dart';
import 'package:local_lead/shared/widgets/guide_card.dart';
import 'package:local_lead/shared/widgets/category_chip.dart';
import 'package:local_lead/shared/widgets/search_bar.dart';
import 'package:local_lead/shared/widgets/destination_selector.dart';
import 'package:local_lead/shared/widgets/advanced_filters.dart';
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  String _selectedDestination = '';
  FilterState _filters = FilterState.empty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Guide> get _filteredGuides {
    return guides.where((guide) {
      // Search query filter
      final matchesSearch = _searchQuery.isEmpty ||
          guide.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          guide.specialty.toLowerCase().contains(_searchQuery.toLowerCase());

      // Category chip filter
      final matchesCategory = _selectedCategory == null ||
          guide.specialty
              .toLowerCase()
              .contains(_selectedCategory!.toLowerCase());

      // Destination filter
      final matchesDestination = _selectedDestination.isEmpty ||
          guide.location
              .toLowerCase()
              .contains(_selectedDestination.toLowerCase());

      // Price filter
      final matchesPrice = guide.hourlyRate >= _filters.minPrice &&
          guide.hourlyRate <= _filters.maxPrice;

      // Rating filter
      final matchesRating = _filters.minRating == 0 ||
          guide.rating >= _filters.minRating;

      // Specialty filter
      final matchesSpecialty = _filters.specialties.isEmpty ||
          _filters.specialties.contains(guide.specialty);

      // Language filter
      final matchesLanguage = _filters.languages.isEmpty ||
          guide.languages
              .any((lang) => _filters.languages.contains(lang));

      return matchesSearch &&
          matchesCategory &&
          matchesDestination &&
          matchesPrice &&
          matchesRating &&
          matchesSpecialty &&
          matchesLanguage;
    }).toList();
  }

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
                  isTablet ? 24 : 16,
                  isTablet ? 32 : 24,
                  isTablet ? 16 : 12,
                ),
                child: Column(
                  children: [
                    // Title and Filter button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explore',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 32 : 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
// Location button — tap to open destination selector
                            GestureDetector(
                              onTap: () => showDestinationSelector(
                                context: context,
                                selectedDestination: _selectedDestination,
                                onDestinationChanged: (dest) =>
                                    setState(() => _selectedDestination = dest),
                              ),
                              child: Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.locationDot,
                                    size: 12,
                                    color: AppColors.mutedForeground,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _selectedDestination.isEmpty
                                        ? 'All Destinations'
                                        : _selectedDestination,
                                    style: TextStyle(
                                      fontFamily: AppFonts.family,
                                      fontSize: isTablet ? 14 : 13,
                                      color: _selectedDestination.isEmpty
                                          ? AppColors.mutedForeground
                                          : AppColors.accent,
                                      fontWeight: _selectedDestination.isEmpty
                                          ? FontWeight.w400
                                          : FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  // Show X to clear or chevron to open
                                  _selectedDestination.isEmpty
                                      ? const FaIcon(
                                    FontAwesomeIcons.chevronDown,
                                    size: 10,
                                    color: AppColors.mutedForeground,
                                  )
                                      : GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedDestination = ''),
                                    child: const FaIcon(
                                      FontAwesomeIcons.xmark,
                                      size: 12,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Filter button
// Filter button with active count badge
                        GestureDetector(
                          onTap: () => showAdvancedFilters(
                            context: context,
                            filters: _filters,
                            onFiltersChanged: (filters) =>
                                setState(() => _filters = filters),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _filters.activeCount > 0
                                      ? AppColors.accent
                                      : AppColors.secondary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.sliders,
                                    size: 16,
                                    color: _filters.activeCount > 0
                                        ? AppColors.accentForeground
                                        : AppColors.primary,
                                  ),
                                ),
                              ),
                              if (_filters.activeCount > 0)
                                Positioned(
                                  top: -4,
                                  right: -4,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: AppColors.destructive,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${_filters.activeCount}',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 16 : 12),

                    // Search Bar
                    AppSearchBar(
                      controller: _searchController,
                      hintText: 'Search guides or specialties...',
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isTablet ? 32 : 24,
                      isTablet ? 20 : 16,
                      0,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Popular Categories',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 18 : 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: categories.map((category) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: CategoryChip(
                                  label: category,
                                  isSelected: _selectedCategory == category,
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory =
                                      _selectedCategory == category
                                          ? null
                                          : category;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Nearby Guides
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isTablet ? 32 : 24,
                      isTablet ? 24 : 20,
                      isTablet ? 32 : 24,
                      isTablet ? 32 : 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section header
                        Row(
                          children: [
                            Text(
                              'Nearby Guides',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 18 : 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${_filteredGuides.length})',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 16 : 14,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                        // Guide list
                        if (_filteredGuides.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 48),
                              child: Text(
                                'No guides found',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 16 : 14,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _filteredGuides.length,
                            separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return GuideCard(guide: _filteredGuides[index]);
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
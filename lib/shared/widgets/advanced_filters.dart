import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';

const List<String> filterSpecialties = [
  'Food & Culture',
  'Architecture & History',
  'Art & Photography',
  'Adventure & Nature',
  'Markets & Shopping',
  'Nightlife & Entertainment',
];

const List<String> filterLanguages = [
  'English',
  'Spanish',
  'French',
  'Mandarin',
  'German',
  'Italian',
  'Portuguese',
  'Arabic',
  'Russian',
  'Japanese',
];

class FilterState {
  final double minPrice;
  final double maxPrice;
  final double minRating;
  final List<String> specialties;
  final List<String> languages;

  const FilterState({
    this.minPrice = 0,
    this.maxPrice = 100,
    this.minRating = 0,
    this.specialties = const [],
    this.languages = const [],
  });

  FilterState copyWith({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    List<String>? specialties,
    List<String>? languages,
  }) {
    return FilterState(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      specialties: specialties ?? this.specialties,
      languages: languages ?? this.languages,
    );
  }

  int get activeCount =>
      (minPrice != 0 || maxPrice != 100 ? 1 : 0) +
          (minRating != 0 ? 1 : 0) +
          specialties.length +
          languages.length;

  static FilterState get empty => const FilterState();
}

void showAdvancedFilters({
  required BuildContext context,
  required FilterState filters,
  required ValueChanged<FilterState> onFiltersChanged,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _AdvancedFiltersSheet(
      filters: filters,
      onFiltersChanged: onFiltersChanged,
    ),
  );
}

class _AdvancedFiltersSheet extends StatefulWidget {
  final FilterState filters;
  final ValueChanged<FilterState> onFiltersChanged;

  const _AdvancedFiltersSheet({
    required this.filters,
    required this.onFiltersChanged,
  });

  @override
  State<_AdvancedFiltersSheet> createState() =>
      _AdvancedFiltersSheetState();
}

class _AdvancedFiltersSheetState extends State<_AdvancedFiltersSheet> {
  late FilterState _local;

  final List<double> _ratingOptions = [0, 3.5, 4.0, 4.5, 4.8];

  @override
  void initState() {
    super.initState();
    _local = widget.filters;
  }

  void _toggleSpecialty(String specialty) {
    final updated = List<String>.from(_local.specialties);
    if (updated.contains(specialty)) {
      updated.remove(specialty);
    } else {
      updated.add(specialty);
    }
    setState(() => _local = _local.copyWith(specialties: updated));
  }

  void _toggleLanguage(String language) {
    final updated = List<String>.from(_local.languages);
    if (updated.contains(language)) {
      updated.remove(language);
    } else {
      updated.add(language);
    }
    setState(() => _local = _local.copyWith(languages: updated));
  }

  void _reset() {
    setState(() => _local = FilterState.empty);
  }

  void _apply() {
    widget.onFiltersChanged(_local);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Filters',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    if (_local.activeCount > 0) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          '${_local.activeCount} active',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 13 : 12,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
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
          ),

          const Divider(height: 1, color: AppColors.border),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 32 : 20,
                20,
                isTablet ? 32 : 20,
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  _SectionTitle(
                      title: 'Price per Hour', isTablet: isTablet),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${_local.minPrice.toInt()}',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 14 : 13,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      Text(
                        '\$${_local.maxPrice.toInt()}',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 14 : 13,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(
                      _local.minPrice,
                      _local.maxPrice,
                    ),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    activeColor: AppColors.accent,
                    inactiveColor: AppColors.border,
                    onChanged: (values) => setState(() => _local =
                        _local.copyWith(
                          minPrice: values.start,
                          maxPrice: values.end,
                        )),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 16),

                  // Minimum Rating
                  _SectionTitle(
                      title: 'Minimum Rating', isTablet: isTablet),
                  const SizedBox(height: 12),
                  Row(
                    children: _ratingOptions.map((rating) {
                      final isSelected = _local.minRating == rating;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: () => setState(
                                  () => _local = _local.copyWith(
                                minRating: rating,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.secondary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  rating == 0
                                      ? 'Any'
                                      : '$rating+',
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: isTablet ? 13 : 12,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.accentForeground
                                        : AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 16),

                  // Specialties
                  _SectionTitle(
                      title: 'Specialties', isTablet: isTablet),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: filterSpecialties.map((specialty) {
                      final isSelected =
                      _local.specialties.contains(specialty);
                      return GestureDetector(
                        onTap: () => _toggleSpecialty(specialty),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.secondary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            specialty,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 14 : 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColors.accentForeground
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 16),

                  // Languages
                  _SectionTitle(
                      title: 'Languages', isTablet: isTablet),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: filterLanguages.map((language) {
                      final isSelected =
                      _local.languages.contains(language);
                      return GestureDetector(
                        onTap: () => _toggleLanguage(language),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.secondary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            language,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 14 : 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColors.accentForeground
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.fromLTRB(
              isTablet ? 32 : 20,
              12,
              isTablet ? 32 : 20,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: const BoxDecoration(
              color: AppColors.card,
              border: Border(
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _reset,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 15 : 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _apply,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 15 : 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentForeground,
                          ),
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
    );
  }
}

// Section Title Widget
class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isTablet;

  const _SectionTitle({required this.title, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: AppFonts.family,
        fontSize: isTablet ? 16 : 15,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    );
  }
}
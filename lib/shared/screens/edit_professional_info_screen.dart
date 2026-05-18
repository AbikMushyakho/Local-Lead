import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';

class EditProfessionalInfoScreen extends StatefulWidget {
  const EditProfessionalInfoScreen({super.key});

  @override
  State<EditProfessionalInfoScreen> createState() =>
      _EditProfessionalInfoScreenState();
}

class _EditProfessionalInfoScreenState
    extends State<EditProfessionalInfoScreen> {
  final _hourlyRateController = TextEditingController(text: '45');
  final _specialtyInputController = TextEditingController();
  final _languageInputController = TextEditingController();
  final _certificationInputController = TextEditingController();
  bool _hasChanges = false;

  List<String> _specialties = ['Food Tours', 'Cultural Experiences', 'History'];
  List<String> _languages = ['English', 'Spanish', 'French'];
  List<String> _certifications = [
    'Licensed Tour Guide',
    'First Aid Certified',
  ];

  @override
  void initState() {
    super.initState();
    _hourlyRateController.addListener(() => setState(() => _hasChanges = true));
  }

  @override
  void dispose() {
    _hourlyRateController.dispose();
    _specialtyInputController.dispose();
    _languageInputController.dispose();
    _certificationInputController.dispose();
    super.dispose();
  }

  void _addSpecialty() {
    final val = _specialtyInputController.text.trim();
    if (val.isNotEmpty) {
      setState(() {
        _specialties.add(val);
        _hasChanges = true;
        _specialtyInputController.clear();
      });
    }
  }

  void _removeSpecialty(int index) {
    setState(() {
      _specialties.removeAt(index);
      _hasChanges = true;
    });
  }

  void _addLanguage() {
    final val = _languageInputController.text.trim();
    if (val.isNotEmpty) {
      setState(() {
        _languages.add(val);
        _hasChanges = true;
        _languageInputController.clear();
      });
    }
  }

  void _removeLanguage(int index) {
    setState(() {
      _languages.removeAt(index);
      _hasChanges = true;
    });
  }

  void _addCertification() {
    final val = _certificationInputController.text.trim();
    if (val.isNotEmpty) {
      setState(() {
        _certifications.add(val);
        _hasChanges = true;
        _certificationInputController.clear();
      });
    }
  }

  void _removeCertification(int index) {
    setState(() {
      _certifications.removeAt(index);
      _hasChanges = true;
    });
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Professional information saved!')),
    );
    context.pop();
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
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.arrowLeft,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Professional Info',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _hasChanges ? _save : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _hasChanges
                              ? AppColors.accent
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 15 : 14,
                            fontWeight: FontWeight.w600,
                            color: _hasChanges
                                ? AppColors.accentForeground
                                : AppColors.mutedForeground,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 32 : 20,
                24,
                isTablet ? 32 : 20,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pricing
                  _SectionCard(
                    title: 'Pricing',
                    isTablet: isTablet,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hourly Rate (USD)',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _hourlyRateController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 15 : 14,
                            color: AppColors.primary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your hourly rate',
                            hintStyle: TextStyle(
                              fontFamily: AppFonts.family,
                              color: AppColors.mutedForeground,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              child: FaIcon(
                                FontAwesomeIcons.dollarSign,
                                size: 16,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 44,
                              minHeight: 44,
                            ),
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: AppColors.accent),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Specialties
                  _SectionCard(
                    title: 'Specialties',
                    isTablet: isTablet,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _specialties
                              .asMap()
                              .entries
                              .map((e) => _RemovableChip(
                            label: e.value,
                            onRemove: () => _removeSpecialty(e.key),
                            isTablet: isTablet,
                          ))
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        _AddInput(
                          controller: _specialtyInputController,
                          hint: 'Add a specialty',
                          onAdd: _addSpecialty,
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Languages
                  _SectionCard(
                    title: 'Languages',
                    isTablet: isTablet,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _languages
                              .asMap()
                              .entries
                              .map((e) => _RemovableChip(
                            label: e.value,
                            onRemove: () => _removeLanguage(e.key),
                            isTablet: isTablet,
                          ))
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        _AddInput(
                          controller: _languageInputController,
                          hint: 'Add a language',
                          onAdd: _addLanguage,
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Certifications
                  _SectionCard(
                    title: 'Certifications',
                    isTablet: isTablet,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_certifications.isNotEmpty)
                          Column(
                            children: _certifications
                                .asMap()
                                .entries
                                .map((e) => Padding(
                              padding:
                              const EdgeInsets.only(bottom: 8),
                              child: _CertificationItem(
                                label: e.value,
                                onRemove: () =>
                                    _removeCertification(e.key),
                                isTablet: isTablet,
                              ),
                            ))
                                .toList(),
                          ),
                        const SizedBox(height: 4),
                        _AddInput(
                          controller: _certificationInputController,
                          hint: 'Add a certification',
                          onAdd: _addCertification,
                          isTablet: isTablet,
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

// Section Card Widget
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isTablet;

  const _SectionCard({
    required this.title,
    required this.child,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 16 : 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// Removable Chip Widget
class _RemovableChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  final bool isTablet;

  const _RemovableChip({
    required this.label,
    required this.onRemove,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 14 : 13,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const FaIcon(
              FontAwesomeIcons.xmark,
              size: 12,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

// Certification Item Widget
class _CertificationItem extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  final bool isTablet;

  const _CertificationItem({
    required this.label,
    required this.onRemove,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 14 : 13,
                color: AppColors.primary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: const FaIcon(
              FontAwesomeIcons.xmark,
              size: 14,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

// Add Input Widget
class _AddInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback onAdd;
  final bool isTablet;

  const _AddInput({
    required this.controller,
    required this.hint,
    required this.onAdd,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 15 : 14,
              color: AppColors.primary,
            ),
            onSubmitted: (_) => onAdd(),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 15 : 14,
                color: AppColors.mutedForeground,
              ),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.accent),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: isTablet ? 48 : 44,
            height: isTablet ? 48 : 44,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.plus,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
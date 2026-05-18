import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search...',
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Container(
      height: isTablet ? 52 : 48,
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: isTablet ? 18 : 16,
              color: AppColors.mutedForeground,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 16 : 14,
                color: AppColors.primary,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: isTablet ? 16 : 14,
                  color: AppColors.mutedForeground,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                onChanged('');
                onClear?.call();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FaIcon(
                  FontAwesomeIcons.xmark,
                  size: 16,
                  color: AppColors.mutedForeground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
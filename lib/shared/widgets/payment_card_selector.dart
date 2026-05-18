import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/models/guide_model.dart';
import 'package:local_lead/models/payment_card_model.dart';

class PaymentCardSelector extends StatelessWidget {
  final PaymentCard? selectedCard;
  final List<PaymentCard> cards;
  final ValueChanged<PaymentCard> onCardSelected;
  final bool isTablet;

  const PaymentCardSelector({
    super.key,
    required this.selectedCard,
    required this.cards,
    required this.onCardSelected,
    required this.isTablet,
  });

  List<Color> _getCardColors(CardType type) {
    switch (type) {
      case CardType.visa:
        return [const Color(0xFF3B82F6), const Color(0xFF2563EB)];
      case CardType.mastercard:
        return [const Color(0xFFF97316), const Color(0xFFDC2626)];
      case CardType.amex:
        return [const Color(0xFF22C55E), const Color(0xFF16A34A)];
      case CardType.discover:
        return [const Color(0xFFA855F7), const Color(0xFF7C3AED)];
    }
  }

  String _getCardLabel(CardType type) {
    switch (type) {
      case CardType.visa:
        return 'VISA';
      case CardType.mastercard:
        return 'MASTERCARD';
      case CardType.amex:
        return 'AMEX';
      case CardType.discover:
        return 'DISCOVER';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return GestureDetector(
        onTap: () => context.push('/payment-methods'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.creditCard,
                size: 20,
                color: AppColors.mutedForeground,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Add a payment method',
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: isTablet ? 15 : 14,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ),
              const FaIcon(
                FontAwesomeIcons.chevronRight,
                size: 14,
                color: AppColors.mutedForeground,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: cards.map((card) {
        final isSelected = selectedCard?.id == card.id;
        final colors = _getCardColors(card.type);

        return GestureDetector(
          onTap: () => onCardSelected(card),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Card color indicator
                Container(
                  width: 40,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      _getCardLabel(card.type).substring(0, 1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.cardNumber,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 15 : 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        card.cardHolder,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 13 : 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                if (card.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'Default',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 12 : 11,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.accent : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Center(
                    child: FaIcon(
                      FontAwesomeIcons.check,
                      size: 10,
                      color: Colors.white,
                    ),
                  )
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
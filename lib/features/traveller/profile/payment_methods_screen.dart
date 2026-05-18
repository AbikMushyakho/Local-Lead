import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/models/guide_model.dart';
import 'package:local_lead/models/payment_card_model.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  bool _showAddCard = false;
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  List<PaymentCard> _cards = [
    const PaymentCard(
      id: '1',
      cardNumber: '4532 **** **** 1234',
      cardHolder: 'Alex Thompson',
      expiryDate: '12/25',
      type: CardType.visa,
      isDefault: true,
    ),
  ];

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  CardType _getCardType(String number) {
    final firstDigit = number.isNotEmpty ? number[0] : '';
    if (firstDigit == '4') return CardType.visa;
    if (firstDigit == '5') return CardType.mastercard;
    if (firstDigit == '3') return CardType.amex;
    return CardType.discover;
  }

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

  void _addCard() {
    if (_cardNumberController.text.isEmpty ||
        _cardHolderController.text.isEmpty ||
        _expiryController.text.isEmpty ||
        _cvvController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all card details')),
      );
      return;
    }

    final rawNumber = _cardNumberController.text.replaceAll(' ', '');
    final maskedNumber =
        '${rawNumber.substring(0, 4)} **** **** ${rawNumber.substring(rawNumber.length - 4)}';

    final newCard = PaymentCard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardNumber: maskedNumber,
      cardHolder: _cardHolderController.text,
      expiryDate: _expiryController.text,
      type: _getCardType(_cardNumberController.text),
      isDefault: _cards.isEmpty,
    );

    setState(() {
      _cards = [..._cards, newCard];
      _showAddCard = false;
      _cardNumberController.clear();
      _cardHolderController.clear();
      _expiryController.clear();
      _cvvController.clear();
    });
  }

  void _deleteCard(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Card',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this card?',
          style: TextStyle(
            fontFamily: AppFonts.family,
            color: AppColors.mutedForeground,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: AppFonts.family,
                color: AppColors.mutedForeground,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                final isDefault =
                    _cards.firstWhere((c) => c.id == id).isDefault;
                _cards = _cards.where((c) => c.id != id).toList();
                if (isDefault && _cards.isNotEmpty) {
                  _cards[0] = _cards[0].copyWith(isDefault: true);
                }
              });
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                fontFamily: AppFonts.family,
                color: AppColors.destructive,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setDefault(String id) {
    setState(() {
      _cards = _cards
          .map((c) => c.copyWith(isDefault: c.id == id))
          .toList();
    });
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
                          'Payment Methods',
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
                      onTap: () =>
                          setState(() => _showAddCard = !_showAddCard),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.plus,
                            size: 16,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 32 : 20,
                20,
                isTablet ? 32 : 20,
                32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Security info banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.shieldHalved,
                          size: 16,
                          color: Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your card information is encrypted and securely stored.',
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 14 : 12,
                              color: const Color(0xFF1E3A5F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Add Card Form
                  if (_showAddCard) ...[
                    _AddCardForm(
                      cardNumberController: _cardNumberController,
                      cardHolderController: _cardHolderController,
                      expiryController: _expiryController,
                      cvvController: _cvvController,
                      onAdd: _addCard,
                      onCancel: () =>
                          setState(() => _showAddCard = false),
                      isTablet: isTablet,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Cards list
                  if (_cards.isNotEmpty) ...[
                    Text(
                      'YOUR CARDS',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 13 : 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mutedForeground,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _cards.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final card = _cards[index];
                        return _CardItem(
                          card: card,
                          colors: _getCardColors(card.type),
                          cardLabel: _getCardLabel(card.type),
                          onDelete: () => _deleteCard(card.id),
                          onSetDefault: () => _setDefault(card.id),
                          isTablet: isTablet,
                        );
                      },
                    ),
                  ] else if (!_showAddCard)
                    _EmptyState(
                      onAddCard: () =>
                          setState(() => _showAddCard = true),
                      isTablet: isTablet,
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

// Card Item Widget
class _CardItem extends StatelessWidget {
  final PaymentCard card;
  final List<Color> colors;
  final String cardLabel;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;
  final bool isTablet;

  const _CardItem({
    required this.card,
    required this.colors,
    required this.cardLabel,
    required this.onDelete,
    required this.onSetDefault,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: card.isDefault ? AppColors.accent : AppColors.border,
          width: card.isDefault ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Card Visual
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cardLabel,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    if (card.isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: Colors.white.withAlpha(100)),
                        ),
                        child: Text(
                          'Default',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 13 : 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  card.cardNumber,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: isTablet ? 20 : 18,
                    letterSpacing: 2,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cardholder',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 12 : 11,
                            color: Colors.white.withAlpha(180),
                          ),
                        ),
                        Text(
                          card.cardHolder,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 15 : 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Expires',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 12 : 11,
                            color: Colors.white.withAlpha(180),
                          ),
                        ),
                        Text(
                          card.expiryDate,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 15 : 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Card Actions
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                if (!card.isDefault)
                  Expanded(
                    child: GestureDetector(
                      onTap: onSetDefault,
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.check,
                              size: 13,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Set as Default',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 14 : 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (!card.isDefault) const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.trash,
                      size: 14,
                      color: AppColors.destructive,
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

// Add Card Form Widget
class _AddCardForm extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController cardHolderController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final VoidCallback onAdd;
  final VoidCallback onCancel;
  final bool isTablet;

  const _AddCardForm({
    required this.cardNumberController,
    required this.cardHolderController,
    required this.expiryController,
    required this.cvvController,
    required this.onAdd,
    required this.onCancel,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Card',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),

          // Card Number
          _FormField(
            label: 'Card Number',
            controller: cardNumberController,
            hint: '1234 5678 9012 3456',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberFormatter(),
            ],
            maxLength: 19,
          ),
          const SizedBox(height: 12),

          // Cardholder Name
          _FormField(
            label: 'Cardholder Name',
            controller: cardHolderController,
            hint: 'Name on card',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 12),

          // Expiry and CVV
          Row(
            children: [
              Expanded(
                child: _FormField(
                  label: 'Expiry Date',
                  controller: expiryController,
                  hint: 'MM/YY',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _ExpiryFormatter(),
                  ],
                  maxLength: 5,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormField(
                  label: 'CVV',
                  controller: cvvController,
                  hint: '123',
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  maxLength: 4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onAdd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.accentForeground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Add Card',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 16 : 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Form Field Widget
class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  const _FormField({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.inputFormatters,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          style: const TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 14,
            color: AppColors.primary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            counterText: '',
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
      ],
    );
  }
}

// Empty State Widget
class _EmptyState extends StatelessWidget {
  final VoidCallback onAddCard;
  final bool isTablet;

  const _EmptyState({required this.onAddCard, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const FaIcon(
            FontAwesomeIcons.creditCard,
            size: 48,
            color: AppColors.mutedForeground,
          ),
          const SizedBox(height: 16),
          Text(
            'No cards added',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a payment method to book guides easily',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 14 : 13,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onAddCard,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.accentForeground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
              label: Text(
                'Add Card',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Card Number Formatter
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// Expiry Formatter
class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }
    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
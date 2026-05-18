
// Payment Card Model
enum CardType { visa, mastercard, amex, discover }

class PaymentCard {
  final String id;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final CardType type;
  final bool isDefault;

  const PaymentCard({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.type,
    this.isDefault = false,
  });

  PaymentCard copyWith({
    String? id,
    String? cardNumber,
    String? cardHolder,
    String? expiryDate,
    CardType? type,
    bool? isDefault,
  }) {
    return PaymentCard(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolder: cardHolder ?? this.cardHolder,
      expiryDate: expiryDate ?? this.expiryDate,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';

enum AccountType { checking, savings }

enum PayoutSchedule { daily, weekly, monthly }

class BankAccount {
  final String accountHolder;
  final String accountNumber;
  final String routingNumber;
  final String bankName;
  final AccountType accountType;

  const BankAccount({
    required this.accountHolder,
    required this.accountNumber,
    required this.routingNumber,
    required this.bankName,
    required this.accountType,
  });
}

class PayoutSettingsScreen extends StatefulWidget {
  const PayoutSettingsScreen({super.key});

  @override
  State<PayoutSettingsScreen> createState() => _PayoutSettingsScreenState();
}

class _PayoutSettingsScreenState extends State<PayoutSettingsScreen> {
  BankAccount? _bankAccount;
  bool _isEditing = false;
  PayoutSchedule _payoutSchedule = PayoutSchedule.weekly;
  final _minimumPayoutController = TextEditingController(text: '50');

  // Form controllers
  final _accountHolderController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _routingNumberController = TextEditingController();
  AccountType _accountType = AccountType.checking;

  @override
  void dispose() {
    _minimumPayoutController.dispose();
    _accountHolderController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _routingNumberController.dispose();
    super.dispose();
  }

  void _saveBankAccount() {
    if (_accountHolderController.text.isEmpty ||
        _bankNameController.text.isEmpty ||
        _accountNumberController.text.isEmpty ||
        _routingNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all bank account details'),
        ),
      );
      return;
    }

    final maskedNumber =
        '****${_accountNumberController.text.substring(_accountNumberController.text.length - 4)}';

    setState(() {
      _bankAccount = BankAccount(
        accountHolder: _accountHolderController.text,
        bankName: _bankNameController.text,
        accountNumber: maskedNumber,
        routingNumber: _routingNumberController.text,
        accountType: _accountType,
      );
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bank account saved!')),
    );
  }

  void _removeAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Remove Account',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          'Are you sure you want to remove this bank account?',
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
                _bankAccount = null;
                _accountHolderController.clear();
                _bankNameController.clear();
                _accountNumberController.clear();
                _routingNumberController.clear();
              });
            },
            child: const Text(
              'Remove',
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

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payout settings saved!')),
    );
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
                      'Payout Settings',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
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
                  // Info banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.shieldHalved,
                          size: 16,
                          color: Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 14 : 13,
                                color: const Color(0xFF1E3A5F),
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Secure banking: ',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text:
                                  'Your bank information is encrypted and processed through secure payment partners. Payouts are typically processed within 2-5 business days.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bank Account section
                  _SectionLabel(label: 'BANK ACCOUNT', isTablet: isTablet),
                  if (_bankAccount == null || _isEditing)
                    _BankAccountForm(
                      accountHolderController: _accountHolderController,
                      bankNameController: _bankNameController,
                      accountNumberController: _accountNumberController,
                      routingNumberController: _routingNumberController,
                      accountType: _accountType,
                      isEditing: _isEditing,
                      isTablet: isTablet,
                      onAccountTypeChanged: (type) =>
                          setState(() => _accountType = type),
                      onSave: _saveBankAccount,
                      onCancel: _isEditing
                          ? () => setState(() => _isEditing = false)
                          : null,
                    )
                  else
                    _BankAccountCard(
                      account: _bankAccount!,
                      isTablet: isTablet,
                      onEdit: () => setState(() => _isEditing = true),
                      onRemove: _removeAccount,
                    ),
                  const SizedBox(height: 24),

                  // Payout Schedule
                  _SectionLabel(
                      label: 'PAYOUT SCHEDULE', isTablet: isTablet),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    child: Column(
                      children: [
                        _ScheduleOption(
                          value: PayoutSchedule.daily,
                          selected: _payoutSchedule,
                          label: 'Daily',
                          desc: 'Receive payouts every day',
                          onTap: () => setState(
                                  () => _payoutSchedule = PayoutSchedule.daily),
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 10),
                        _ScheduleOption(
                          value: PayoutSchedule.weekly,
                          selected: _payoutSchedule,
                          label: 'Weekly',
                          desc: 'Receive payouts every Monday',
                          onTap: () => setState(
                                  () => _payoutSchedule = PayoutSchedule.weekly),
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 10),
                        _ScheduleOption(
                          value: PayoutSchedule.monthly,
                          selected: _payoutSchedule,
                          label: 'Monthly',
                          desc: 'Receive payouts on the 1st of each month',
                          onTap: () => setState(
                                  () => _payoutSchedule = PayoutSchedule.monthly),
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Minimum Payout
                  _SectionLabel(
                      label: 'MINIMUM PAYOUT AMOUNT', isTablet: isTablet),
                  Container(
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
                          'Minimum Amount (USD)',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _minimumPayoutController,
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
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14,),
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
                        const SizedBox(height: 8),
                        Text(
                          'Payouts will only be processed when your balance reaches this amount',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 13 : 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  GestureDetector(
                    onTap: _saveSettings,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Save Payout Settings',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 16 : 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentForeground,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recent Payouts
                  _SectionLabel(label: 'RECENT PAYOUTS', isTablet: isTablet),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.calendarDays,
                          size: 40,
                          color: AppColors.border,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No payout history yet',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 15 : 14,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your completed payouts will appear here',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 13 : 12,
                            color: AppColors.mutedForeground,
                          ),
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

// Section Label Widget
class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isTablet;

  const _SectionLabel({required this.label, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.family,
          fontSize: isTablet ? 13 : 12,
          fontWeight: FontWeight.w600,
          color: AppColors.mutedForeground,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// Bank Account Form Widget
class _BankAccountForm extends StatelessWidget {
  final TextEditingController accountHolderController;
  final TextEditingController bankNameController;
  final TextEditingController accountNumberController;
  final TextEditingController routingNumberController;
  final AccountType accountType;
  final bool isEditing;
  final bool isTablet;
  final ValueChanged<AccountType> onAccountTypeChanged;
  final VoidCallback onSave;
  final VoidCallback? onCancel;

  const _BankAccountForm({
    required this.accountHolderController,
    required this.bankNameController,
    required this.accountNumberController,
    required this.routingNumberController,
    required this.accountType,
    required this.isEditing,
    required this.isTablet,
    required this.onAccountTypeChanged,
    required this.onSave,
    this.onCancel,
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
          _FormField(
            label: 'Account Holder Name',
            controller: accountHolderController,
            hint: 'Full name on account',
            isTablet: isTablet,
          ),
          const SizedBox(height: 14),
          _FormField(
            label: 'Bank Name',
            controller: bankNameController,
            hint: 'Name of your bank',
            isTablet: isTablet,
          ),
          const SizedBox(height: 14),
          _FormField(
            label: 'Account Number',
            controller: accountNumberController,
            hint: 'Your account number',
            isTablet: isTablet,
            obscureText: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 14),
          _FormField(
            label: 'Routing Number',
            controller: routingNumberController,
            hint: '9-digit routing number',
            isTablet: isTablet,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
          ),
          const SizedBox(height: 14),

          // Account type selector
          Text(
            'Account Type',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 14 : 13,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _AccountTypeButton(
                  label: 'Checking',
                  selected: accountType == AccountType.checking,
                  onTap: () => onAccountTypeChanged(AccountType.checking),
                  isTablet: isTablet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AccountTypeButton(
                  label: 'Savings',
                  selected: accountType == AccountType.savings,
                  onTap: () => onAccountTypeChanged(AccountType.savings),
                  isTablet: isTablet,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onSave,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Save Account',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 15 : 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (onCancel != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 15 : 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// Bank Account Card Widget
class _BankAccountCard extends StatelessWidget {
  final BankAccount account;
  final bool isTablet;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _BankAccountCard({
    required this.account,
    required this.isTablet,
    required this.onEdit,
    required this.onRemove,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.buildingColumns,
                size: 20,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.bankName,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 16 : 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          account.accountHolder,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 13 : 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Text(
                        'Verified',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 12 : 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: 'Account:',
                  value: account.accountNumber,
                  isTablet: isTablet,
                  isMonospace: true,
                ),
                const SizedBox(height: 4),
                _InfoRow(
                  label: 'Type:',
                  value: account.accountType == AccountType.checking
                      ? 'Checking'
                      : 'Savings',
                  isTablet: isTablet,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onEdit,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 14 : 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.destructive.withAlpha(60)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Remove',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 14 : 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.destructive,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Schedule Option Widget
class _ScheduleOption extends StatelessWidget {
  final PayoutSchedule value;
  final PayoutSchedule selected;
  final String label;
  final String desc;
  final VoidCallback onTap;
  final bool isTablet;

  const _ScheduleOption({
    required this.value,
    required this.selected,
    required this.label,
    required this.desc,
    required this.onTap,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withAlpha(10)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: isTablet ? 15 : 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: isTablet ? 13 : 12,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
            if (isSelected)
              const FaIcon(
                FontAwesomeIcons.circleCheck,
                size: 18,
                color: AppColors.accent,
              ),
          ],
        ),
      ),
    );
  }
}

// Account Type Button Widget
class _AccountTypeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isTablet;

  const _AccountTypeButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent.withAlpha(10) : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 15 : 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.accent : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

// Form Field Widget
class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool isTablet;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _FormField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.isTablet,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTablet ? 14 : 13,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTablet ? 15 : 14,
            color: AppColors.primary,
          ),
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
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// Info Row Widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTablet;
  final bool isMonospace;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.isTablet,
    this.isMonospace = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTablet ? 13 : 12,
            color: AppColors.mutedForeground,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: isMonospace ? 'monospace' : AppFonts.family,
            fontSize: isTablet ? 13 : 12,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
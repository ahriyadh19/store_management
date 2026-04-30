import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/models/store_payment_voucher.dart';
import 'package:store_management/views/pages/model_crud_page.dart';
import 'package:store_management/views/pages/model_module_pages.dart';

class PaymentVouchersPage extends StatelessWidget {
  const PaymentVouchersPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.highlights = const <String>[],
  });

  final String title;
  final String description;
  final IconData icon;
  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ModelCrudPage<StorePaymentVoucher>(
      title: title,
      entityLabel: paymentVoucherEntityLabel(l10n),
      description: description,
      icon: icon,
      highlights: highlights,
      formDefinition: paymentVoucherFormDefinition(l10n),
    );
  }
}

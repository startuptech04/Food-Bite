/*
 * FoodBite – Multi Restaurant Food Delivery App
 * (NodeJS, MongoDB, Angular & Flutter)
 *
 * Copyright © 2026 Elitecanyon InfoTech (https://www.elitecanyon.com/)
 * Licensed under the Envato Market License.
 *
 * Unauthorized redistribution, resale, or publication
 * of this source code on GitHub or any public repository
 * is strictly prohibited.
 *
 * This file may contain embedded identifiers and watermarks
 * for ownership verification and license enforcement.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendor/app/presentation/pages/modals/order_help_modal/bloc/order_help_modal_bloc.dart';
import 'package:vendor/app/presentation/pages/modals/print_order_invoice/print_order_invoice_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class OrderHelpModalScreen extends StatelessWidget {
  final String orderId;
  final int orderNo;
  const OrderHelpModalScreen({super.key, required this.orderId, required this.orderNo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderHelpModalBloc()..add(OrderHelpModalInitialEvent(orderId: orderId, orderNo: orderNo)),
      child: const OrderHelpModalView(),
    );
  }
}

class OrderHelpModalView extends StatelessWidget {
  const OrderHelpModalView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<OrderHelpModalBloc, OrderHelpModalState>(
      listener: (context, state) {
        if (state.status.isOrderSummaryDownloadFailed || state.status.isOrderInvoiceDownloadFailed || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isOrderSummaryDownloadSuccess || state.status.isOrderInvoiceDownloadSuccess) {
          showSuccessDialog(context, '${translate.file_downloaded_to} ${state.downloadPath}');
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isOrderInvoiceDownloadStarted || state.status.isOrderSummaryDownloadStarted ? true : false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              title: Text(translate.order_help),
              actions: [
                IconButton(onPressed: () => Navigator.of(context).pop({'action': 'none', 'value': 'none'}), icon: const Icon(Icons.close)),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return PrintOrderInvoiceScreen(orderId: state.orderId);
                          },
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.print, size: 14, color: Theme.of(context).canvasColor),
                          kAppSpacerHorizontal(width: 10),
                          Text(translate.print_invoice, style: kAppLblMediumFontBold(context, color: 'regular')),
                        ],
                      ),
                    ),
                  ),
                  kAppSpacerVertical(height: 5),
                  GestureDetector(
                    onTap: () => context.read<OrderHelpModalBloc>().add(OrderHelpModalOrderInvoiceEvent()),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.receipt, size: 14, color: Theme.of(context).canvasColor),
                              kAppSpacerHorizontal(width: 10),
                              Text(translate.download_invoice, style: kAppLblMediumFontBold(context, color: 'regular')),
                            ],
                          ),
                          state.status.isOrderInvoiceDownloadStarted ? kAppCircularProgress(context, color: 'primary', strokeWidth: 2.0, width: 20.0, height: 20.0, padding: 2.0) : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  kAppSpacerVertical(height: 5),
                  GestureDetector(
                    onTap: () => context.read<OrderHelpModalBloc>().add(OrderHelpModalOrderSummaryEvent()),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.fileExcel, size: 14, color: Theme.of(context).canvasColor),
                              kAppSpacerHorizontal(width: 10),
                              Text(translate.download_summary, style: kAppLblMediumFontBold(context, color: 'regular')),
                            ],
                          ),
                          state.status.isOrderSummaryDownloadStarted ? kAppCircularProgress(context, color: 'primary', strokeWidth: 2.0, width: 20.0, height: 20.0, padding: 2.0) : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  kAppSpacerVertical(height: 5),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop({'action': 'navigate', 'value': 'complaints'}),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.circleQuestion, size: 14, color: Theme.of(context).canvasColor),
                          kAppSpacerHorizontal(width: 10),
                          Text(translate.complaints, style: kAppLblMediumFontBold(context, color: 'regular')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
// DONE //
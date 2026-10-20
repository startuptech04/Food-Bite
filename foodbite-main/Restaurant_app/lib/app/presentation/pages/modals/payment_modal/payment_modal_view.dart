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
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/presentation/pages/modals/payment_modal/bloc/payment_modal_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class PaymentModalScreen extends StatelessWidget {
  final double payTotal;
  final String paymentList;
  const PaymentModalScreen({super.key, required this.payTotal, required this.paymentList});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentModalBloc()..add(PaymentModalInitialEvent(paymentList: paymentList)),
      child: PaymentModalView(payTotal: payTotal),
    );
  }
}

class PaymentModalView extends StatelessWidget {
  final double payTotal;

  const PaymentModalView({super.key, required this.payTotal});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<PaymentModalBloc, PaymentModalState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.keyboard_arrow_down_outlined)),
            title: Text('${translate.pay_total} : ${kAppPriceFormat(payTotal)}'),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const PaymentModalLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const PaymentModalErrorView(),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        state.paymentList.length,
                        (index) => Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(state.paymentList[index].id!),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CacheNetworkImageWidget(width: 50, height: 15.0, imageUrl: state.paymentList[index].image!),
                                    ),
                                    kAppSpacerHorizontal(width: 10),
                                    Text(state.paymentList[index].name!, style: kAppLblMediumFontBold(context)),
                                  ],
                                ),
                                Icon(Icons.keyboard_arrow_right_outlined, size: Theme.of(context).textTheme.bodyMedium?.fontSize, color: Theme.of(context).canvasColor),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class PaymentModalLoadingView extends StatelessWidget {
  const PaymentModalLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
      child: Column(
        children: List.generate(10, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
            ),
            child: Column(
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(height: 5),
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(height: 5),
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.2, borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(height: 5),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class PaymentModalErrorView extends StatelessWidget {
  const PaymentModalErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
      child: Center(
        child: Column(
          children: [
            kAppSpacerVertical(height: 20),
            Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
            kAppSpacerVertical(height: 20),
            Text(translate.something_went_wrong_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}
// DONE //
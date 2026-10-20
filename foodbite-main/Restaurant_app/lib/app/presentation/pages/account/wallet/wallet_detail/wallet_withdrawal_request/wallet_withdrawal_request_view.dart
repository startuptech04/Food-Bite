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
import 'package:vendor/app/core/models/wallet_withdrawal_detail_model.dart';
import 'package:vendor/app/presentation/pages/account/wallet/wallet_detail/payout_method/manage_payout_method/manage_payout_method_view.dart';
import 'package:vendor/app/presentation/pages/account/wallet/wallet_detail/wallet_withdrawal_request/bloc/wallet_withdrawal_request_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class WalletWithdrawalRequestScreen extends StatelessWidget {
  const WalletWithdrawalRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => WalletWithdrawalRequestBloc(), child: const WalletWithdrawalRequestView());
  }
}

class WalletWithdrawalRequestView extends StatefulWidget {
  const WalletWithdrawalRequestView({super.key});

  @override
  State<WalletWithdrawalRequestView> createState() => _WalletWithdrawalRequestViewState();
}

class _WalletWithdrawalRequestViewState extends State<WalletWithdrawalRequestView> {
  TextEditingController formNumberController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<WalletWithdrawalRequestBloc>().add(WalletWithdrawalRequestInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<WalletWithdrawalRequestBloc, WalletWithdrawalRequestState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSubmitSuccess) {
          showSuccessDialog(context, translate.withdrawal_request_sent).then((value) {
            if (!context.mounted) return;
            formNumberController.clear();
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isSubmit ? true : false,
          child: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: ThemeProvider.scaffoldPadding, horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const WalletWithdrawalRequestLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const WalletWithdrawalRequestErrorView(),
                  ] else ...[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(AssetsUrl.imageURL.walletImage, height: 35.0, width: 35.0, color: Theme.of(context).colorScheme.secondary),
                              kAppSpacerHorizontal(width: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(translate.wallet_balance, style: kAppLblTinyFontRegularLight(context)),
                                  kAppSpacerVertical(height: 5),
                                  Text(kAppPriceFormat(state.model.walletInfo!.balance!), style: kAppLblTinyFontBoldGuest(context)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    state.model.methods!.isNotEmpty && state.formElementList.isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(bottom: 10, top: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                            ),
                            child: DropdownButton<WalletPayoutMethodConfigModel>(
                              underline: const SizedBox(),
                              isExpanded: true,
                              value: state.selectedMethod,
                              dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                              style: kAppLblMediumFontRegular(context),
                              items: state.model.methods!.map((WalletPayoutMethodConfigModel item) {
                                return DropdownMenuItem<WalletPayoutMethodConfigModel>(value: item, child: Text(item.method!.name!.toString()));
                              }).toList(),
                              onChanged: (newValue) {
                                context.read<WalletWithdrawalRequestBloc>().add(WalletWithdrawalDetailMethodChangeEvent(method: newValue!));
                              },
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ManagePayoutMethodScreen(isNew: true, id: ''))).then((value) {
                                  if (!context.mounted) return;
                                  if (value == true || value.toString() == 'true') {
                                    context.read<WalletWithdrawalRequestBloc>().add(WalletWithdrawalRequestInitialEvent());
                                  }
                                });
                              },
                              style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                              child: Text(translate.add_payout_method),
                            ),
                          ),
                    state.model.methods!.isNotEmpty && state.formElementList.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: ThemeProvider.greyColorBorder, width: 1),
                              shape: BoxShape.rectangle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                state.formElementList.length,
                                (formIndex) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("${kAppTrimWord(state.formElementList[formIndex].fieldName!, 20)}:", style: kAppLblSmallFontMedium(context)),
                                      Text(kAppTrimWord(state.formElementList[formIndex].fieldValue!, 18), style: kAppLblSmallFontMedium(context)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    state.model.methods!.isNotEmpty && state.formElementList.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                child: TextFormField(
                                  controller: formNumberController,
                                  decoration: kAppInputDecoration(context, lblText: translate.form_withdrawal_amount, errText: state.isSubmitted && state.amount.isEmpty ? translate.form_required : null),
                                  style: kAppLblLargeFontMedium(context),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => context.read<WalletWithdrawalRequestBloc>().add(WalletWithdrawalDetailAmountChangeEvent(amount: formNumberController.text)),
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                              kAppSpacerVertical(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  onPressed: () => context.read<WalletWithdrawalRequestBloc>().add(WalletWithdrawalDetailSubmitEvent()),
                                  style: kAppElevatedButtonStyle(
                                    context,
                                    disabledColor: Theme.of(context).disabledColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    foreColor: Theme.of(context).scaffoldBackgroundColor,
                                    height: 50.0,
                                  ),
                                  child: state.status.isSubmit ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.withdrawal),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class WalletWithdrawalRequestLoadingView extends StatelessWidget {
  const WalletWithdrawalRequestLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        10,
        (index) => Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: ThemeProvider.scaffoldPadding),
          decoration: BoxDecoration(border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonListTile(
                hasSubtitle: true,
                padding: const EdgeInsets.all(0),
                leadingStyle: const SkeletonAvatarStyle(width: 25, height: 25),
                titleStyle: SkeletonLineStyle(height: 10, randomLength: false, borderRadius: BorderRadius.circular(16)),
                subtitleStyle: SkeletonLineStyle(height: 10, randomLength: true, borderRadius: BorderRadius.circular(16)),
              ),
              kAppSpacerVertical(height: 20),
              SkeletonParagraph(
                style: SkeletonParagraphStyle(
                  spacing: 6,
                  padding: const EdgeInsets.all(0),
                  lineStyle: SkeletonLineStyle(height: 10, randomLength: false, borderRadius: BorderRadius.circular(16)),
                ),
              ),
              kAppSpacerVertical(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 3.5, borderRadius: BorderRadius.circular(8)),
                  ),
                  SkeletonLine(
                    style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 3.5, borderRadius: BorderRadius.circular(8)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WalletWithdrawalRequestErrorView extends StatelessWidget {
  const WalletWithdrawalRequestErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //
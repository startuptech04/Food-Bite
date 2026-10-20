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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/my_payout_method_list_model.dart';
import 'package:vendor/app/presentation/pages/account/wallet/wallet_detail/payout_method/@core/bloc/payout_method_bloc.dart';
import 'package:vendor/app/presentation/pages/account/wallet/wallet_detail/payout_method/manage_payout_method/manage_payout_method_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/loader_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class PayoutMethodScreen extends StatelessWidget {
  const PayoutMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => PayoutMethodBloc(), child: const PayoutMethodView());
  }
}

class PayoutMethodView extends StatefulWidget {
  const PayoutMethodView({super.key});

  @override
  State<PayoutMethodView> createState() => _PayoutMethodViewState();
}

class _PayoutMethodViewState extends State<PayoutMethodView> {
  final ScrollController _payoutScroll = ScrollController();
  @override
  void initState() {
    super.initState();
    context.read<PayoutMethodBloc>().add(PayoutMethodInitialEvent());
    _payoutScroll.addListener(() {
      if (_payoutScroll.position.pixels == _payoutScroll.position.maxScrollExtent) {
        context.read<PayoutMethodBloc>().add(PayoutMethodLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<PayoutMethodBloc, PayoutMethodState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isLoadingDeleteStart) {
          LoaderService.showLoader(context, msg: translate.please_waiter);
        } else if (state.status.isLoadingDeleteSuccess) {
          LoaderService.hideLoder(context);
        } else if (state.status.isLoadingDeleteFailed) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode).then((value) {});
        } else if (state.status.isLoadingDefaultChangeStart) {
          LoaderService.showLoader(context, msg: translate.please_waiter);
        } else if (state.status.isLoadingDefaultChangeSuccess) {
          LoaderService.hideLoder(context);
        } else if (state.status.isLoadingDefaultChangeFailed) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode).then((value) {});
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            controller: _payoutScroll,
            padding: const EdgeInsets.symmetric(vertical: ThemeProvider.scaffoldPadding, horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const PayoutMethodLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const PayoutMethodErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const PayoutMethodEmptyView(),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(state.model.methods!.length, (index) => PayoutMethodDetailTile(index: index, model: state.model.methods![index])),
                  ),
                  kAppSpacerVertical(height: 20),
                  state.loadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
                  kAppSpacerVertical(height: 20),
                ],
              ],
            ),
          ),
          floatingActionButton: SizedBox(
            height: 30,
            child: FloatingActionButton.extended(
              heroTag: 'addPayoutMethodFab',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ManagePayoutMethodScreen(isNew: true, id: ''))).then((value) {
                  if (!context.mounted) return;
                  if (value == true || value.toString() == 'true') {
                    context.read<PayoutMethodBloc>().add(PayoutMethodInitialEvent());
                  }
                });
              },
              label: Text(translate.add),
              icon: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}

class PayoutMethodDetailTile extends StatelessWidget {
  final int index;
  final PayoutMethodDetailConfigModel model;
  const PayoutMethodDetailTile({super.key, required this.index, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
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
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).colorScheme.secondary),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, color: Theme.of(context).primaryColor, size: Theme.of(context).textTheme.labelSmall?.fontSize),
                      kAppSpacerHorizontal(width: 10),
                      Text(model.method!.name!, style: kAppLblSmallFontBold(context)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showConfirmDialog(context, translate.alert_update_payout_method_title, translate.alert_update_payout_method_sub_title, translate.cancel_lbl, translate.yes_update_btn).then((value) {
                            if (!context.mounted) return;
                            if (value) {
                              context.read<PayoutMethodBloc>().add(PayoutMethodChangeDefaultMethodEvent(index: index));
                            }
                          });
                        },
                        child: Icon(model.isDefault! ? Icons.toggle_on_outlined : Icons.toggle_off_outlined, color: Theme.of(context).primaryColor, size: 25),
                      ),
                      kAppSpacerHorizontal(width: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ManagePayoutMethodScreen(isNew: false, id: model.id!))).then((value) {
                            if (!context.mounted) return;
                            if (value == true || value.toString() == 'true') {
                              context.read<PayoutMethodBloc>().add(PayoutMethodInitialEvent());
                            }
                          });
                        },
                        child: FaIcon(FontAwesomeIcons.penToSquare, color: Theme.of(context).primaryColor, size: Theme.of(context).textTheme.labelLarge?.fontSize),
                      ),
                      kAppSpacerHorizontal(width: 20),
                      GestureDetector(
                        onTap: () {
                          showConfirmDialog(context, translate.alert_confirm_title, "${translate.confirm_delete_alert} ${translate.block_payout_method}", translate.cancel_lbl, translate.yes_delete_btn).then((value) {
                            if (!context.mounted) return;
                            if (value) {
                              context.read<PayoutMethodBloc>().add(PayoutMethodDeleteEvent(index: index));
                            }
                          });
                        },
                        child: FaIcon(FontAwesomeIcons.trashCan, color: Theme.of(context).primaryColor, size: Theme.of(context).textTheme.labelLarge?.fontSize),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              model.formElement!.length,
              (formIndex) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${kAppTrimWord(model.formElement![formIndex].fieldName!, 20)}:", style: kAppLblSmallFontMedium(context)),
                    Text(kAppTrimWord(model.formElement![formIndex].fieldValue!, 18), style: kAppLblSmallFontMedium(context)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PayoutMethodLoadingView extends StatelessWidget {
  const PayoutMethodLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        10,
        (index) => Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
          ),
          child: Column(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
              ),
              kAppSpacerVertical(height: 5),
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.2, borderRadius: BorderRadius.circular(8)),
              ),
              kAppSpacerVertical(height: 5),
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2.8, borderRadius: BorderRadius.circular(8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PayoutMethodErrorView extends StatelessWidget {
  const PayoutMethodErrorView({super.key});

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

class PayoutMethodEmptyView extends StatelessWidget {
  const PayoutMethodEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_payout_method_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_payout_method_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //
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
import 'package:vendor/app/presentation/pages/account/deliveryman_list/@core/bloc/deliveryman_list_bloc.dart';
import 'package:vendor/app/presentation/pages/account/deliveryman_list/manage_deliveryman/manage_deliveryman_view.dart';
import 'package:vendor/app/presentation/pages/modals/deliveryman_offline_message/deliveryman_offline_message_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/loader_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class DeliverymanListScreen extends StatelessWidget {
  const DeliverymanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => DeliverymanListBloc()..add(DeliverymanListInitialEvent()), child: const DeliverymanListView());
  }
}

class DeliverymanListView extends StatefulWidget {
  const DeliverymanListView({super.key});

  @override
  State<DeliverymanListView> createState() => _DeliverymanListViewState();
}

class _DeliverymanListViewState extends State<DeliverymanListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<DeliverymanListBloc>().add(DeliverymanListLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final WidgetStateProperty<Icon?> thumbIcon1 = WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    });
    final WidgetStateProperty<Icon?> thumbIcon2 = WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    });
    return BlocConsumer<DeliverymanListBloc, DeliverymanListState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isLoadingBlockedStart) {
          LoaderService.showLoader(context, msg: translate.please_waiter);
        } else if (state.status.isLoadingHideStart) {
          LoaderService.showLoader(context, msg: translate.please_waiter);
        } else if (state.status.isLoadingBlockedFailed) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode).then((value) {});
        } else if (state.status.isLoadingHideFailed) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode).then((value) {});
        } else if (state.status.isLoadingHideSuccess) {
          LoaderService.hideLoder(context);
        } else if (state.status.isLoadingBlockedSuccess) {
          LoaderService.hideLoder(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(translate.deliveryman_list), scrolledUnderElevation: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const DeliverymanListLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const DeliverymanListErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const DeliverymanListEmptyView(),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.model.results!.length,
                      (index) => Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30.0,
                                      width: 30.0,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                        child: CacheNetworkImageWidget(width: 30.0, height: 30.0, imageUrl: state.model.results![index].driverInfo!.image!),
                                      ),
                                    ),
                                    kAppSpacerHorizontal(width: 10),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${state.model.results![index].driverInfo!.firstName!} ${state.model.results![index].driverInfo!.lastName!}", style: kAppLblMediumFontBold(context)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.star, color: Theme.of(context).primaryColor, size: 12),
                                            kAppSpacerHorizontal(width: 5),
                                            Text("${state.model.results![index].rating!}", style: kAppLblTinyFontRegular(context)),
                                            kAppSpacerHorizontal(width: 5),
                                            Text("(${state.model.results![index].totalRating!})", style: kAppLblTinyFontRegular(context)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (!state.model.results![index].activeStatus!) {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        enableDrag: false,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        builder: (BuildContext context) {
                                          return FractionallySizedBox(heightFactor: 0.3, child: DeliverymanOfflineMessageModalView(message: state.model.results![index].offline!.name!));
                                        },
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.shadow, borderRadius: BorderRadius.circular(5)),
                                    child: Text(state.model.results![index].activeStatus! ? translate.online : translate.offline, style: kAppLblTinyFontBold(context)),
                                  ),
                                ),
                              ],
                            ),
                            kAppSpacerVertical(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${translate.email_lbl} : ${state.model.results![index].driverInfo!.contactEmail!}", style: kAppLblTinyFontRegular(context)),
                                    kAppSpacerVertical(height: 5),
                                    Text("${translate.contact} : ${state.model.results![index].driverInfo!.countryCode!} ${state.model.results![index].driverInfo!.contactNumber!}", style: kAppLblTinyFontRegular(context)),
                                    kAppSpacerVertical(height: 5),
                                    Text("${translate.type} : ${state.model.results![index].type! == 'salary' ? translate.salaried : translate.freelancing}", style: kAppLblTinyFontRegular(context)),
                                    kAppSpacerVertical(height: 5),
                                    Text(
                                      "${translate.city} : ${state.model.results![index].city!.name!} ${state.model.results![index].locality!.name!.isNotEmpty ? '(${state.model.results![index].locality!.name!})' : ''}",
                                      style: kAppLblTinyFontRegular(context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            kAppSpacerVertical(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(translate.blocked, style: kAppLblTinyFontRegular(context)),
                                    Transform.scale(
                                      scale: 0.5,
                                      child: Switch(
                                        value: state.model.results![index].isBlocked!,
                                        thumbIcon: thumbIcon1,
                                        activeThumbColor: Theme.of(context).primaryColor,
                                        onChanged: (bool value) {
                                          if (!state.model.results![index].isBlocked!) {
                                            showConfirmDialog(
                                              context,
                                              translate.alert_confirm_title,
                                              '${translate.sure_to_block} ${state.model.results![index].driverInfo!.firstName!} ${state.model.results![index].driverInfo!.lastName!} ${translate.block_deliveryman}',
                                              translate.cancel_lbl,
                                              translate.yes_blocked,
                                            ).then((value) {
                                              if (!context.mounted) return;
                                              if (value) {
                                                context.read<DeliverymanListBloc>().add(DeliverymanBlocAccountEvent(index: index));
                                              }
                                            });
                                          } else {
                                            context.read<DeliverymanListBloc>().add(DeliverymanBlocAccountEvent(index: index));
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(translate.hide_lbl, style: kAppLblTinyFontRegular(context)),
                                    Transform.scale(
                                      scale: 0.5,
                                      child: Switch(
                                        value: state.model.results![index].status!,
                                        thumbIcon: thumbIcon2,
                                        activeThumbColor: Theme.of(context).primaryColor,
                                        onChanged: (bool value) {
                                          if (state.model.results![index].status!) {
                                            showConfirmDialog(
                                              context,
                                              translate.alert_confirm_title,
                                              '${translate.hide_confirm_title} ${state.model.results![index].driverInfo!.firstName!} ${state.model.results![index].driverInfo!.lastName!} ${translate.block_deliveryman}',
                                              translate.cancel_lbl,
                                              translate.yes_hide_btn,
                                            ).then((value) {
                                              if (!context.mounted) return;
                                              if (value) {
                                                context.read<DeliverymanListBloc>().add(DeliverymanStatusChangeEvent(index: index));
                                              }
                                            });
                                          } else {
                                            context.read<DeliverymanListBloc>().add(DeliverymanStatusChangeEvent(index: index));
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return ManageDeliverymanScreen(isNew: false, deliverymanId: state.model.results![index].id!);
                                            },
                                            fullscreenDialog: true,
                                          ),
                                        )
                                        .then((value) {
                                          if (!context.mounted) return;
                                          if (value != null && value.toString().isNotEmpty && value.toString() == 'true') {
                                            context.read<DeliverymanListBloc>().add(DeliverymanListInitialEvent());
                                          }
                                        });
                                  },
                                  icon: FaIcon(FontAwesomeIcons.penToSquare, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
              heroTag: 'addDeliverymanFab',
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const ManageDeliverymanScreen(isNew: true, deliverymanId: '');
                        },
                        fullscreenDialog: true,
                      ),
                    )
                    .then((value) {
                      if (!context.mounted) return;
                      if (value != null && value.toString().isNotEmpty && value.toString() == 'true') {
                        context.read<DeliverymanListBloc>().add(DeliverymanListInitialEvent());
                      }
                    });
              },
              label: Text(translate.add_deliveryman),
              icon: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}

class DeliverymanListLoadingView extends StatelessWidget {
  const DeliverymanListLoadingView({super.key});

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

class DeliverymanListErrorView extends StatelessWidget {
  const DeliverymanListErrorView({super.key});

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

class DeliverymanListEmptyView extends StatelessWidget {
  const DeliverymanListEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_deliveryman_added, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_deliveryman_added_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //
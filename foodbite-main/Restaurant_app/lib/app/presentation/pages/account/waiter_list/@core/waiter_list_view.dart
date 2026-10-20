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
import 'package:vendor/app/presentation/pages/account/waiter_list/@core/bloc/waiter_list_bloc.dart';
import 'package:vendor/app/presentation/pages/account/waiter_list/manage_waiter/manage_waiter_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/loader_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class WaiterListScreen extends StatelessWidget {
  const WaiterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => WaiterListBloc()..add(WaiterListInitialEvent()), child: const WaiterListView());
  }
}

class WaiterListView extends StatefulWidget {
  const WaiterListView({super.key});

  @override
  State<WaiterListView> createState() => _WaiterListViewState();
}

class _WaiterListViewState extends State<WaiterListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<WaiterListBloc>().add(WaiterListLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final WidgetStateProperty<Icon?> thumbIcon = WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    });
    return BlocConsumer<WaiterListBloc, WaiterListState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isLoadingHideStart) {
          LoaderService.showLoader(context, msg: translate.please_waiter);
        } else if (state.status.isLoadingHideFailed) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode).then((value) {});
        } else if (state.status.isLoadingHideSuccess) {
          LoaderService.hideLoder(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(translate.waiter_list), scrolledUnderElevation: 0),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const WaiterListLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const WaiterListErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const WaiterListEmptyView(),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30.0,
                                  width: 30.0,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                    child: CacheNetworkImageWidget(width: 30.0, height: 30.0, imageUrl: state.model.results![index].waiterInfo!.image!),
                                  ),
                                ),
                                kAppSpacerHorizontal(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${state.model.results![index].waiterInfo!.firstName!} ${state.model.results![index].waiterInfo!.lastName!}", style: kAppLblMediumFontBold(context)),
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
                            kAppSpacerVertical(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${translate.email_lbl} : ${state.model.results![index].waiterInfo!.contactEmail!}", style: kAppLblTinyFontRegular(context)),
                                    kAppSpacerVertical(height: 5),
                                    Text("${translate.contact} : ${state.model.results![index].waiterInfo!.countryCode!} ${state.model.results![index].waiterInfo!.contactNumber!}", style: kAppLblTinyFontRegular(context)),
                                    kAppSpacerVertical(height: 5),
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
                                    Text(translate.hide_lbl, style: kAppLblTinyFontRegular(context)),
                                    Transform.scale(
                                      scale: 0.5,
                                      child: Switch(
                                        value: state.model.results![index].status!,
                                        thumbIcon: thumbIcon,
                                        activeThumbColor: Theme.of(context).primaryColor,
                                        onChanged: (bool value) {
                                          if (state.model.results![index].status!) {
                                            showConfirmDialog(
                                              context,
                                              translate.alert_confirm_title,
                                              "${translate.hide_confirm_title} ${state.model.results![index].waiterInfo!.firstName!} ${state.model.results![index].waiterInfo!.lastName!} ${translate.block_waiter}",
                                              translate.cancel_lbl,
                                              translate.yes_hide_btn,
                                            ).then((value) {
                                              if (!context.mounted) return;
                                              if (value) {
                                                context.read<WaiterListBloc>().add(WaiterListStatusChangeEvent(index: index));
                                              }
                                            });
                                          } else {
                                            context.read<WaiterListBloc>().add(WaiterListStatusChangeEvent(index: index));
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
                                              return ManageWaiterScreen(isNew: false, waiterId: state.model.results![index].id!);
                                            },
                                            fullscreenDialog: true,
                                          ),
                                        )
                                        .then((value) {
                                          if (!context.mounted) return;
                                          if (value != null && value.toString().isNotEmpty && value.toString() == 'true') {
                                            context.read<WaiterListBloc>().add(WaiterListInitialEvent());
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
              heroTag: 'addwaiterFab',
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const ManageWaiterScreen(isNew: true, waiterId: '');
                        },
                        fullscreenDialog: true,
                      ),
                    )
                    .then((value) {
                      if (!context.mounted) return;
                      if (value != null && value.toString().isNotEmpty && value.toString() == 'true') {
                        context.read<WaiterListBloc>().add(WaiterListInitialEvent());
                      }
                    });
              },
              label: Text(translate.add_waiter),
              icon: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}

class WaiterListLoadingView extends StatelessWidget {
  const WaiterListLoadingView({super.key});

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

class WaiterListErrorView extends StatelessWidget {
  const WaiterListErrorView({super.key});

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

class WaiterListEmptyView extends StatelessWidget {
  const WaiterListEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_waiter_added_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_waiter_added_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //
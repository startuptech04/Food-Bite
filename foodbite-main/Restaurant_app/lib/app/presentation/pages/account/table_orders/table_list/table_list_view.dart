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
import 'package:vendor/app/presentation/pages/account/table_orders/print_table_qr/print_table_qr_view.dart';
import 'package:vendor/app/presentation/pages/account/table_orders/table_list/bloc/table_list_bloc.dart';
import 'package:vendor/app/presentation/pages/modals/manage_table_modal/manage_table_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class TableListScreen extends StatelessWidget {
  const TableListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => TableListBloc()..add(TableListInitialEvent()), child: const TableListView());
  }
}

class TableListView extends StatefulWidget {
  const TableListView({super.key});

  @override
  State<TableListView> createState() => _TableListViewState();
}

class _TableListViewState extends State<TableListView> {
  final ScrollController _scrollControlleTables = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollControlleTables.addListener(() {
      if (_scrollControlleTables.position.pixels == _scrollControlleTables.position.maxScrollExtent) {
        context.read<TableListBloc>().add(TableListLoadMoreEvent());
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
    return BlocConsumer<TableListBloc, TableListState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(translate.table_list),
            scrolledUnderElevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: false,
                    enableDrag: false,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (BuildContext context) {
                      return const FractionallySizedBox(heightFactor: 0.65, child: ManageTableModalScreen(isNew: true, tableId: '', tableNumber: 0, capacity: 0));
                    },
                  ).then((value) {
                    if (!context.mounted) return;
                    if (value != null && value.toString().isNotEmpty) {
                      context.read<TableListBloc>().add(TableListInitialEvent());
                    }
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: _scrollControlleTables,
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const TableListLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const TableListErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const TableListEmptyViews(),
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
                        decoration: BoxDecoration(border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${translate.table_number} :", style: kAppLblTinyFontBold(context)),
                                    kAppSpacerHorizontal(width: 5),
                                    Text("${state.model.results![index].tableNumber!}", style: kAppLblTinyFontRegular(context)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${translate.capacity} :", style: kAppLblTinyFontBold(context)),
                                    kAppSpacerHorizontal(width: 5),
                                    Text("${state.model.results![index].capacity!}", style: kAppLblTinyFontRegular(context)),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                                          '${translate.hide_confirm_title} ${state.model.results![index].tableNumber} ${translate.block_table}',
                                          translate.cancel_lbl,
                                          translate.yes_hide_btn,
                                        ).then((value) {
                                          if (!context.mounted) return;
                                          if (value) {
                                            context.read<TableListBloc>().add(TableListChangeStatusEvent(index: index));
                                          }
                                        });
                                      } else {
                                        context.read<TableListBloc>().add(TableListChangeStatusEvent(index: index));
                                      }
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return PrintTableQrScreen(
                                            capacity: state.model.results![index].capacity!,
                                            id: state.model.results![index].id!,
                                            status: state.model.results![index].status!,
                                            tableNumber: state.model.results![index].tableNumber!,
                                          );
                                        },
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                  icon: FaIcon(FontAwesomeIcons.print, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      isDismissible: false,
                                      enableDrag: false,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      builder: (BuildContext context) {
                                        return FractionallySizedBox(
                                          heightFactor: 0.65,
                                          child: ManageTableModalScreen(
                                            isNew: false,
                                            tableId: state.model.results![index].id!,
                                            tableNumber: state.model.results![index].tableNumber!,
                                            capacity: state.model.results![index].capacity!,
                                          ),
                                        );
                                      },
                                    ).then((value) {
                                      if (!context.mounted) return;
                                      if (value != null && value.toString().isNotEmpty) {
                                        context.read<TableListBloc>().add(TableListInitialEvent());
                                      }
                                    });
                                  },
                                  icon: FaIcon(FontAwesomeIcons.penToSquare, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showConfirmDialog(context, translate.alert_confirm_title, translate.alert_remove_table_title, translate.cancel_lbl, translate.yes_delete_btn).then((value) {
                                      if (!context.mounted) return;
                                      if (value) {
                                        context.read<TableListBloc>().add(TableListDeleteTableEvent(index: index));
                                      }
                                    });
                                  },
                                  icon: FaIcon(FontAwesomeIcons.trashCan, size: Theme.of(context).textTheme.labelMedium?.fontSize),
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
        );
      },
    );
  }
}

class TableListLoadingView extends StatelessWidget {
  const TableListLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        10,
        (index) => Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.3, borderRadius: BorderRadius.circular(8)),
              ),
              SkeletonLine(style: SkeletonLineStyle(height: 10, width: 20, borderRadius: BorderRadius.circular(8))),
            ],
          ),
        ),
      ),
    );
  }
}

class TableListErrorView extends StatelessWidget {
  const TableListErrorView({super.key});

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

class TableListEmptyViews extends StatelessWidget {
  const TableListEmptyViews({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_record_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_record_found_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //
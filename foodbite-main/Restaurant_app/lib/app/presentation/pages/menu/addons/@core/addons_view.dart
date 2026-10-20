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
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:vendor/app/core/models/addons_list_model.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';
import 'package:vendor/app/presentation/pages/menu/addons/@core/bloc/addons_bloc.dart';
import 'package:vendor/app/presentation/pages/menu/addons/action/addon_action_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/loader_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/services/titlecase_string.dart';

class AddonsListScreen extends StatelessWidget {
  const AddonsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => AddonsBloc(), child: const AddonsListView());
  }
}

class AddonsListView extends StatefulWidget {
  const AddonsListView({super.key});

  @override
  State<AddonsListView> createState() => _AddonsListViewState();
}

class _AddonsListViewState extends State<AddonsListView> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollControlleAddon = ScrollController();
  @override
  void initState() {
    super.initState();
    context.read<AddonsBloc>().add(AddonsInitialEvent());
    _scrollControlleAddon.addListener(() {
      if (_scrollControlleAddon.position.pixels == _scrollControlleAddon.position.maxScrollExtent) {
        context.read<AddonsBloc>().add(AddonsLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<AddonsBloc, AddonsState>(
      listener: (context, state) {
        if (state.status.isDeleteLoaderStarted) {
          LoaderService.showLoader(context);
        } else if (state.status.isDeleteLoaderEnded) {
          LoaderService.hideLoder(context);
          context.read<AddonsBloc>().add(AddonsInitialEvent());
        } else if (state.status.isDeleteLoaderEndedWithError) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: SizedBox(
            height: 30,
            child: FloatingActionButton.extended(
              heroTag: 'addAddonFab',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddonActionScreen(isNew: true, model: AddonResultModel(locale: state.appLocale)),
                  ),
                ).then((value) {
                  if (!context.mounted) return;
                  if (value == true || value.toString() == 'true') {
                    context.read<AddonsBloc>().add(AddonsInitialEvent());
                  }
                });
              },
              label: Text(translate.add_lbl),
              icon: const Icon(Icons.add),
            ),
          ),
          body: state.status.isLoading
              ? SkeletonListView(itemCount: 10)
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollControlleAddon,
                  padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(state.addons.results!.length, (index) => AddonListTile(results: state.addons.results![index])),
                      ),
                      state.loadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
                    ],
                  ),
                ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AddonListTile extends StatelessWidget {
  final AddonResultModel results;
  const AddonListTile({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final WidgetStateProperty<Icon?> statusIcon = WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    });
    final WidgetStateProperty<Icon?> stockIcon = WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    });
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${translate.form_name} : ${results.name!}', style: kAppLblMediumFontBold(context)),
              kAppSpacerVertical(height: 5),
              Text('${translate.form_price} : ${kAppPriceFormat(results.price!)}', style: kAppLblTinyFontRegular(context)),
              kAppSpacerVertical(height: 5),
              Text('${translate.stock} : ${results.stockNumber! == -1 ? translate.unlimited : results.stockNumber!}', style: kAppLblTinyFontRegular(context)),
              kAppSpacerVertical(height: 5),
              Text('${translate.form_stock_type} : ${results.stockType!.capitalize()}', style: kAppLblTinyFontRegular(context)),
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
                  Text(translate.in_stock, style: kAppLblTinyFontRegular(context)),
                  Transform.scale(
                    scale: 0.5,
                    child: Switch(
                      value: results.inStock!,
                      thumbIcon: stockIcon,
                      activeThumbColor: Theme.of(context).primaryColor,
                      onChanged: (bool value) {
                        if (results.inStock!) {
                          showConfirmDialog(context, translate.alert_confirm_title, '${translate.alert_confirm_update_title} ${results.name!} ${translate.block_stock}', translate.cancel_lbl, translate.yes_hide_btn).then((value) {
                            if (!context.mounted) return;
                            if (value) {
                              context.read<AddonsBloc>().add(AddonsChangeStockEvent(id: results.id!, inStock: !results.inStock!, model: results));
                            }
                          });
                        } else {
                          context.read<AddonsBloc>().add(AddonsChangeStockEvent(id: results.id!, inStock: !results.inStock!, model: results));
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
                      value: results.status!,
                      thumbIcon: statusIcon,
                      activeThumbColor: Theme.of(context).primaryColor,
                      onChanged: (bool value) {
                        if (results.status!) {
                          showConfirmDialog(context, translate.alert_confirm_title, "${translate.hide_confirm_title} ${results.name!} ${translate.block_addon}", translate.cancel_lbl, translate.yes_hide_btn).then((value) {
                            if (!context.mounted) return;
                            if (value) {
                              context.read<AddonsBloc>().add(AddonsChangeStatusEvent(id: results.id!, status: !results.status!, model: results));
                            }
                          });
                        } else {
                          context.read<AddonsBloc>().add(AddonsChangeStatusEvent(id: results.id!, status: !results.status!, model: results));
                        }
                      },
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddonActionScreen(isNew: false, model: results))).then((value) {
                    if (!context.mounted) return;
                    if (value == true || value.toString() == 'true') {
                      context.read<AddonsBloc>().add(AddonsInitialEvent());
                    }
                  });
                },
                icon: FaIcon(FontAwesomeIcons.penToSquare, size: Theme.of(context).textTheme.labelMedium?.fontSize),
              ),
              IconButton(
                onPressed: () {
                  showConfirmDialog(context, translate.alert_confirm_title, translate.alert_confirm_addon_sub_title, translate.cancel_lbl, translate.confirm_delete_lbl).then((value) {
                    if (!context.mounted) return;
                    if (value) {
                      context.read<AddonsBloc>().add(AddonsDeleteEvent(id: results.id!));
                    }
                  });
                },
                icon: FaIcon(FontAwesomeIcons.trashCan, size: Theme.of(context).textTheme.labelMedium?.fontSize),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// DONE //
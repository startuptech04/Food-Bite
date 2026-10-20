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
import 'package:vendor/app/core/models/sub_categories_list_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendor/app/presentation/pages/menu/sub_categories/@core/bloc/sub_categories_bloc.dart';
import 'package:vendor/app/presentation/pages/menu/sub_categories/action/sub_categories_action_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/loader_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class SubCategoriesListScreen extends StatelessWidget {
  final bool customCategory;
  const SubCategoriesListScreen({super.key, required this.customCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubCategoriesBloc(),
      child: SubCategoriesListView(customCategory: customCategory),
    );
  }
}

class SubCategoriesListView extends StatefulWidget {
  final bool customCategory;
  const SubCategoriesListView({super.key, required this.customCategory});

  @override
  State<SubCategoriesListView> createState() => _SubCategoriesListViewState();
}

class _SubCategoriesListViewState extends State<SubCategoriesListView> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<SubCategoriesBloc>().add(SubCategoriesInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<SubCategoriesBloc, SubCategoriesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return widget.customCategory ? CustomSubCategoryTabWidget(customCategory: widget.customCategory, appLocale: state.appLocale) : const MainSubCategoryList();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomSubCategoryTabWidget extends StatefulWidget {
  final bool customCategory;
  final String appLocale;
  const CustomSubCategoryTabWidget({super.key, required this.customCategory, required this.appLocale});

  @override
  State<CustomSubCategoryTabWidget> createState() => _CustomSubCategoryTabWidgetState();
}

class _CustomSubCategoryTabWidgetState extends State<CustomSubCategoryTabWidget> with TickerProviderStateMixin {
  late TabController subCategoriesTabController;
  final List<bool> selectedTab = <bool>[true, false];
  @override
  void initState() {
    super.initState();
    subCategoriesTabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: ToggleButtons(
          direction: Axis.horizontal,
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < selectedTab.length; i++) {
                selectedTab[i] = i == index;
              }
            });
          },
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          selectedColor: Theme.of(context).primaryColor,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          color: Theme.of(context).hintColor,
          constraints: BoxConstraints(minHeight: 40.0, minWidth: (MediaQuery.of(context).size.width - 36) / 2),
          isSelected: selectedTab,
          children: <Widget>[
            Text(translate.main, style: kAppStyleTabTitleStyle(context)),
            Text(translate.custom, style: kAppStyleTabTitleStyle(context)),
          ],
        ),
      ),
      floatingActionButton: widget.customCategory == true && selectedTab[1] == true
          ? SizedBox(
              height: 30,
              child: FloatingActionButton.extended(
                heroTag: 'addNewCustomSubCategory',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesActionScreen(isNew: true, model: CustomSubCategoryResultModel(locale: widget.appLocale)),
                    ),
                  ).then((value) {
                    if (!context.mounted) return;
                    if (value == true || value.toString() == 'true') {
                      context.read<SubCategoriesBloc>().add(SubCategoriesInitialEvent());
                    }
                  });
                },
                label: Text(translate.add),
                icon: const Icon(Icons.add),
              ),
            )
          : const SizedBox(),
      body: selectedTab[0] == true ? const MainSubCategoryList() : const CustomSubCategoryList(),
    );
  }
}

class MainSubCategoryList extends StatefulWidget {
  const MainSubCategoryList({super.key});

  @override
  State<MainSubCategoryList> createState() => _MainSubCategoryListState();
}

class _MainSubCategoryListState extends State<MainSubCategoryList> {
  final ScrollController _scrollControlleMainSubCategory = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollControlleMainSubCategory.addListener(() {
      if (_scrollControlleMainSubCategory.position.pixels == _scrollControlleMainSubCategory.position.maxScrollExtent) {
        context.read<SubCategoriesBloc>().add(MainSubCategoriesLoadMoreEvent());
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubCategoriesBloc, SubCategoriesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return state.status.isLoading
            ? SkeletonListView(itemCount: 10)
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollControlleMainSubCategory,
                padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(state.categories.mainCategory!.results!.length, (index) => MainSubCategoryListTile(results: state.categories.mainCategory!.results![index])),
                    ),
                    state.customLoadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
                  ],
                ),
              );
      },
    );
  }
}

class MainSubCategoryListTile extends StatelessWidget {
  final MainSubCategoryResultModel results;
  const MainSubCategoryListTile({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(results.name!, style: kAppLblMediumFontMedium(context)),
              Text(results.category != null && results.category!.name!.isNotEmpty ? results.category!.name! : '', style: kAppLblSmallFontMedium(context)),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomSubCategoryList extends StatefulWidget {
  const CustomSubCategoryList({super.key});

  @override
  State<CustomSubCategoryList> createState() => _CustomSubCategoryListState();
}

class _CustomSubCategoryListState extends State<CustomSubCategoryList> {
  final ScrollController _scrollControlleCustomSubCategory = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollControlleCustomSubCategory.addListener(() {
      if (_scrollControlleCustomSubCategory.position.pixels == _scrollControlleCustomSubCategory.position.maxScrollExtent) {
        context.read<SubCategoriesBloc>().add(CustomSubCategoriesLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubCategoriesBloc, SubCategoriesState>(
      listener: (context, state) {
        if (state.status.isDeleteLoaderStarted) {
          LoaderService.showLoader(context);
        } else if (state.status.isDeleteLoaderEnded) {
          LoaderService.hideLoder(context);
          context.read<SubCategoriesBloc>().add(SubCategoriesInitialEvent());
        } else if (state.status.isDeleteLoaderEndedWithError) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return state.status.isLoading
            ? SkeletonListView(itemCount: 10)
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollControlleCustomSubCategory,
                padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(state.categories.vendorCategory!.results!.length, (index) => CustomSubCategoryListTile(results: state.categories.vendorCategory!.results![index])),
                    ),
                    state.customLoadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
                  ],
                ),
              );
      },
    );
  }
}

class CustomSubCategoryListTile extends StatelessWidget {
  final CustomSubCategoryResultModel results;
  const CustomSubCategoryListTile({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final WidgetStateProperty<Icon?> thumbIcon = WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    });
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(results.name!, style: kAppLblMediumFontMedium(context)),
              Text(results.category != null && results.category!.name!.isNotEmpty ? results.category!.name! : '', style: kAppLblSmallFontMedium(context)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 0.5,
                child: Switch(
                  value: results.status!,
                  thumbIcon: thumbIcon,
                  activeThumbColor: Theme.of(context).primaryColor,
                  onChanged: (bool value) => context.read<SubCategoriesBloc>().add(SubCategoriesChangeStatusEvent(status: !results.status!, model: results)),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubCategoriesActionScreen(isNew: false, model: results))).then((value) {
                    if (!context.mounted) return;
                    if (value == true || value.toString() == 'true') {
                      context.read<SubCategoriesBloc>().add(SubCategoriesInitialEvent());
                    }
                  });
                },
                icon: FaIcon(FontAwesomeIcons.penToSquare, size: Theme.of(context).textTheme.labelMedium?.fontSize),
              ),
              IconButton(
                onPressed: () {
                  showConfirmDialog(context, translate.alert_confirm_title, translate.alert_confirm_delete_sub_category, translate.cancel_lbl, translate.yes_delete_btn).then((value) {
                    if (!context.mounted) return;
                    if (value) {
                      context.read<SubCategoriesBloc>().add(SubCategoriesDeleteEvent(id: results.id!));
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
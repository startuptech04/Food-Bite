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
import 'package:vendor/app/core/models/categories_list_model.dart';
import 'package:vendor/app/presentation/pages/menu/categories/@core/bloc/categories_bloc.dart';
import 'package:vendor/app/presentation/pages/menu/categories/action/categories_action_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/loader_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class CategoryListScreen extends StatelessWidget {
  final bool customCategory;
  const CategoryListScreen({super.key, required this.customCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesBloc(),
      child: CategoryListView(customCategory: customCategory),
    );
  }
}

class CategoryListView extends StatefulWidget {
  final bool customCategory;
  const CategoryListView({super.key, required this.customCategory});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesBloc>().add(CategoriesInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<CategoriesBloc, CategoriesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return widget.customCategory ? CategoriesTabWidget(customCategory: widget.customCategory, appLocale: state.appLocale) : const MainCategoryList();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CategoriesTabWidget extends StatefulWidget {
  final bool customCategory;
  final String appLocale;
  const CategoriesTabWidget({super.key, required this.customCategory, required this.appLocale});

  @override
  State<CategoriesTabWidget> createState() => _CategoriesTabWidgetState();
}

class _CategoriesTabWidgetState extends State<CategoriesTabWidget> with TickerProviderStateMixin {
  late TabController categoriesTabController;
  final List<bool> selectedTab = <bool>[true, false];

  @override
  void initState() {
    super.initState();
    categoriesTabController = TabController(initialIndex: 0, length: 2, vsync: this);
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
                heroTag: 'addNewCustomCategory',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriesActionScreen(isNew: true, model: VendorCategoryResultModel(locale: widget.appLocale)),
                    ),
                  ).then((value) {
                    if (!context.mounted) return;
                    if (value == true || value.toString() == 'true') {
                      context.read<CategoriesBloc>().add(CategoriesInitialEvent());
                    }
                  });
                },
                label: Text(translate.add),
                icon: const Icon(Icons.add),
              ),
            )
          : const SizedBox(),
      body: selectedTab[0] == true ? const MainCategoryList() : const CustomCategoryList(),
    );
  }
}

class MainCategoryList extends StatefulWidget {
  const MainCategoryList({super.key});

  @override
  State<MainCategoryList> createState() => _MainCategoryListState();
}

class _MainCategoryListState extends State<MainCategoryList> {
  final ScrollController _scrollControlleMainCategory = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollControlleMainCategory.addListener(() {
      if (_scrollControlleMainCategory.position.pixels == _scrollControlleMainCategory.position.maxScrollExtent) {
        context.read<CategoriesBloc>().add(MainCategoriesLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesBloc, CategoriesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return state.status.isLoading
            ? SkeletonListView(itemCount: 10)
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollControlleMainCategory,
                padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(state.categories.mainCategory!.results!.length, (index) => MainCategoryListTile(results: state.categories.mainCategory!.results![index])),
                    ),
                    state.customLoadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
                  ],
                ),
              );
      },
    );
  }
}

class MainCategoryListTile extends StatelessWidget {
  final MainCategoryResultModel results;
  const MainCategoryListTile({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(10),
                  child: CacheNetworkImageWidget(width: 15.0, height: 15.0, imageUrl: results.image!),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Text(results.name!, style: kAppLblMediumFontMedium(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomCategoryList extends StatefulWidget {
  const CustomCategoryList({super.key});

  @override
  State<CustomCategoryList> createState() => _CustomCategoryListState();
}

class _CustomCategoryListState extends State<CustomCategoryList> {
  final ScrollController _scrollControlleCustomCategory = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollControlleCustomCategory.addListener(() {
      if (_scrollControlleCustomCategory.position.pixels == _scrollControlleCustomCategory.position.maxScrollExtent) {
        context.read<CategoriesBloc>().add(CustomCategoriesLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        if (state.status.isDeleteLoaderStarted) {
          LoaderService.showLoader(context);
        } else if (state.status.isDeleteLoaderEnded) {
          LoaderService.hideLoder(context);
          context.read<CategoriesBloc>().add(CategoriesInitialEvent());
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
                controller: _scrollControlleCustomCategory,
                padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(state.categories.vendorCategory!.results!.length, (index) => CustomCategoryListTile(results: state.categories.vendorCategory!.results![index])),
                    ),
                    state.customLoadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
                  ],
                ),
              );
      },
    );
  }
}

class CustomCategoryListTile extends StatelessWidget {
  final VendorCategoryResultModel results;
  const CustomCategoryListTile({super.key, required this.results});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(10),
                  child: CacheNetworkImageWidget(width: 15.0, height: 15.0, imageUrl: results.image!),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Text(results.name!, style: kAppLblMediumFontMedium(context)),
              ),
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
                  onChanged: (bool value) => context.read<CategoriesBloc>().add(CategoriesChangeStatusEvent(id: results.id!, status: !results.status!, model: results)),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesActionScreen(isNew: false, model: results))).then((value) {
                    if (!context.mounted) return;
                    if (value == true || value.toString() == 'true') {
                      context.read<CategoriesBloc>().add(CategoriesInitialEvent());
                    }
                  });
                },
                icon: FaIcon(FontAwesomeIcons.penToSquare, size: Theme.of(context).textTheme.labelMedium?.fontSize),
              ),
              IconButton(
                onPressed: () {
                  showConfirmDialog(context, translate.alert_confirm_title, translate.alert_confirm_delete_category, translate.cancel_lbl, translate.yes_delete_btn).then((value) {
                    if (!context.mounted) return;
                    if (value) {
                      context.read<CategoriesBloc>().add(CategoriesDeleteEvent(id: results.id!));
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
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

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/dining_menu_modal_response_model.dart';
import 'package:vendor/app/core/models/media_gallery_modal_response_model.dart';
import 'package:vendor/app/presentation/pages/account/menu_and_photos/bloc/menu_and_photo_bloc.dart';
import 'package:vendor/app/presentation/pages/media/media_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/new_menu_modal/new_menu_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class MenuAndPhotoScreen extends StatelessWidget {
  const MenuAndPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => MenuAndPhotoBloc()..add(MenuAndPhotoInitialEvent()), child: const MenuAndPhotoView());
  }
}

class MenuAndPhotoView extends StatefulWidget {
  const MenuAndPhotoView({super.key});

  @override
  State<MenuAndPhotoView> createState() => _MenuAndPhotoViewState();
}

class _MenuAndPhotoViewState extends State<MenuAndPhotoView> {
  final ScrollController _mainScrollController = ScrollController();
  final ScrollController _menuController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<MenuAndPhotoBloc, MenuAndPhotoState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError || state.status.isUpdateFailed) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isUpdateSuccess) {
          showSuccessDialog(context, translate.setting_saved);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isUpdateStart ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(translate.update_restaurant_menu), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              controller: _mainScrollController,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const MenuAndPhotoLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const MenuAndPhotoErrorView(),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(translate.menu_title, style: kAppLblMediumFontMedium(context)),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return NewMenuModalScreen(isNew: true, name: '', translations: [], photos: []);
                                    },
                                    fullscreenDialog: true,
                                  ),
                                )
                                .then((value) {
                                  if (!context.mounted) return;
                                  if (value != null && value.toString().isNotEmpty) {
                                    DiningMenuModalResponseModel menuModalResponseModel = DiningMenuModalResponseModel.fromJson(jsonDecode(value), state.appLocale);
                                    context.read<MenuAndPhotoBloc>().add(MenuAndPhotoMenuModalResponseEvent(response: menuModalResponseModel));
                                  }
                                });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(translate.add_new_menu, style: kAppLblMediumFontMedium(context, color: 'primary')),
                              Icon(Icons.add, color: Theme.of(context).primaryColor, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                            ],
                          ),
                        ),
                      ],
                    ),
                    state.model.menuDetail!.isNotEmpty ? kAppSpacerVertical(height: 20) : const SizedBox(),
                    SingleChildScrollView(
                      controller: _menuController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: state.model.menuDetail!
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return NewMenuModalScreen(isNew: false, name: e.name!, translations: e.translations!, photos: e.photos!);
                                          },
                                          fullscreenDialog: true,
                                        ),
                                      )
                                      .then((value) {
                                        if (!context.mounted) return;
                                        if (value != null && value.toString().isNotEmpty) {
                                          DiningMenuModalResponseModel menuModalResponseModel = DiningMenuModalResponseModel.fromJson(jsonDecode(value), state.appLocale);
                                          context.read<MenuAndPhotoBloc>().add(MenuAndPhotoMenuModalEditResponseEvent(oldName: e.name!, response: menuModalResponseModel));
                                        }
                                      });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        width: 80.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                                        ),
                                        child: Stack(
                                          children: [
                                            e.photos!.isEmpty
                                                ? Image.asset(AssetsUrl.imageURL.placeholderImage, fit: BoxFit.cover, height: 80.0, width: 80.0)
                                                : CacheNetworkImageWidget(width: 80.0, height: 80.0, imageUrl: e.photos![0]),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: GestureDetector(
                                                onTap: () => context.read<MenuAndPhotoBloc>().add(MenuAndPhotoRemoveMenuEvent(name: e.name!)),
                                                child: const Icon(Icons.delete_forever_outlined, color: ThemeProvider.errorColor, size: 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      kAppSpacerVertical(height: 5),
                                      Text("${e.displayName!} (${e.photos!.length})", style: kAppLblMediumFontRegular(context)),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(translate.dining_photos, style: kAppLblMediumFontMedium(context)),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const MediaModalScreen(selectedMedia: '');
                                    },
                                    fullscreenDialog: true,
                                  ),
                                )
                                .then((value) {
                                  if (!context.mounted) return;
                                  GalleryModalResponseModel galleryResponse = GalleryModalResponseModel.fromJson(value);
                                  if (galleryResponse.action!) {
                                    context.read<MenuAndPhotoBloc>().add(MenuAndPhotoMenuAddPhotoEvent(image: galleryResponse.data!));
                                  }
                                });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(translate.add_new_photo, style: kAppLblMediumFontMedium(context, color: 'primary')),
                              Icon(Icons.add, color: Theme.of(context).primaryColor, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                            ],
                          ),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 160,
                      child: ScrollConfiguration(
                        behavior: DiningPhotosScrollBehavior(),
                        child: GridView(
                          scrollDirection: Axis.horizontal,
                          physics: const PageScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 5.0, crossAxisSpacing: 5.0, crossAxisCount: 2, childAspectRatio: 1, mainAxisExtent: MediaQuery.of(context).size.width / 4),
                          children: state.model.diningPhotos!
                              .map(
                                (e) => Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width / 4,
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                                  ),
                                  child: Stack(
                                    children: [
                                      CacheNetworkImageWidget(width: MediaQuery.of(context).size.width / 4, height: 80, imageUrl: e),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: () => context.read<MenuAndPhotoBloc>().add(MenuAndPhotoMenuPhotoRemoveEvent(photo: e)),
                                          child: const Icon(Icons.delete_forever_outlined, color: ThemeProvider.errorColor, size: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            bottomNavigationBar: state.status.isLoading || state.status.isFailure
                ? SafeArea(child: const SizedBox())
                : SafeArea(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.read<MenuAndPhotoBloc>().add(MenuAndPhotoSaveEvent()),
                        style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                        child: state.status.isUpdateStart ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.save_lbl),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class MenuAndPhotoLoadingView extends StatelessWidget {
  const MenuAndPhotoLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonListTile(
          verticalSpacing: 5,
          leadingStyle: SkeletonAvatarStyle(width: 45, height: 45, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
          titleStyle: SkeletonLineStyle(height: 15, minLength: 200, randomLength: true, borderRadius: BorderRadius.circular(5)),
          subtitleStyle: SkeletonLineStyle(height: 12, maxLength: 200, randomLength: true, borderRadius: BorderRadius.circular(5)),
          hasSubtitle: true,
        ),
        kAppSpacerVertical(height: 20),
        SkeletonListTile(
          verticalSpacing: 5,
          leadingStyle: SkeletonAvatarStyle(width: 45, height: 45, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
          titleStyle: SkeletonLineStyle(height: 15, minLength: 200, randomLength: true, borderRadius: BorderRadius.circular(5)),
          subtitleStyle: SkeletonLineStyle(height: 12, maxLength: 200, randomLength: true, borderRadius: BorderRadius.circular(5)),
          hasSubtitle: true,
        ),
        kAppSpacerVertical(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SkeletonLine(
              style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
            ),
          ],
        ),
        kAppSpacerVertical(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(4, (index) {
              return SkeletonAvatar(
                style: SkeletonAvatarStyle(width: 100, height: 100, padding: const EdgeInsets.symmetric(horizontal: 5), borderRadius: BorderRadius.circular(8)),
              );
            }),
          ),
        ),
        kAppSpacerVertical(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(4, (index) {
              return SkeletonAvatar(
                style: SkeletonAvatarStyle(width: 100, height: 100, padding: const EdgeInsets.symmetric(horizontal: 5), borderRadius: BorderRadius.circular(8)),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class MenuAndPhotoErrorView extends StatelessWidget {
  const MenuAndPhotoErrorView({super.key});

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

class DiningPhotosScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
// DONE //
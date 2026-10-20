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
import 'package:vendor/app/core/models/dining_detail_response_model.dart';
import 'package:vendor/app/core/models/media_gallery_modal_response_model.dart';
import 'package:vendor/app/core/models/translations/menu_form_translation.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/app/presentation/pages/media/media_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/new_menu_modal/bloc/new_menu_modal_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class NewMenuModalScreen extends StatelessWidget {
  final bool isNew;
  final String name;
  final List<MenuTranslations> translations;
  final List<String> photos;
  const NewMenuModalScreen({super.key, required this.isNew, required this.name, required this.translations, required this.photos});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewMenuModalBloc()..add(NewMenuModalInitialEvent(isNew: isNew, name: name, translations: translations, photos: photos)),
      child: NewMenuModalView(isNew: isNew, name: name, translations: translations, photos: photos),
    );
  }
}

class NewMenuModalView extends StatefulWidget {
  final bool isNew;
  final String name;
  final List<MenuTranslations> translations;
  final List<String> photos;
  const NewMenuModalView({super.key, required this.isNew, required this.name, required this.translations, required this.photos});

  @override
  State<NewMenuModalView> createState() => _NewMenuModalViewState();
}

class _NewMenuModalViewState extends State<NewMenuModalView> with TickerProviderStateMixin {
  final TextEditingController _menuNameController = TextEditingController();

  List<MenuFormTranslations> translations = <MenuFormTranslations>[];

  late TabController menuTranslationTabController;

  final _menuNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (AppSupportedLanguagesModel.languages.length > 1) {
      for (var element in AppSupportedLanguagesModel.languages) {
        MenuFormTranslations keys = MenuFormTranslations(name: element.value, code: element.code, nativeName: element.value, value: '');
        translations.add(keys);
      }
    }

    _menuNameFocusNode.addListener(() {
      if (!_menuNameFocusNode.hasFocus) {
        context.read<NewMenuModalBloc>().add(NewMenuNameUnfocusedEvent());
      }
    });

    if (widget.isNew) {
      _menuNameController.text = '';
    } else {
      _menuNameController.text = widget.name;
      for (var locale in translations) {
        for (var translate in widget.translations) {
          if (locale.code == translate.code) {
            locale.value = translate.value;
          }
        }
      }
    }

    menuTranslationTabController = TabController(initialIndex: 0, length: translations.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((NewMenuModalBloc bloc) => bloc.state.isValid);
    return BlocConsumer<NewMenuModalBloc, NewMenuModalState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSuccess) {
          Navigator.of(context).pop(jsonEncode({"name": state.name.value.toString(), "translations": state.translations, "photos": state.photos}));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            title: Text(translate.add_menu),
            actions: [IconButton(onPressed: () => Navigator.of(context).pop(null), icon: const Icon(Icons.close))],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  focusNode: _menuNameFocusNode,
                  controller: _menuNameController,
                  decoration: kAppInputDecoration(context, lblText: translate.form_menu_name, errText: state.name.displayError != null ? translate.form_required : null),
                  style: kAppLblLargeFontMedium(context),
                  keyboardType: TextInputType.text,
                  onChanged: (value) => context.read<NewMenuModalBloc>().add(NewMenuNameChangedEvent(name: value)),
                  textInputAction: TextInputAction.next,
                ),
                kAppSpacerVertical(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(
                      controller: menuTranslationTabController,
                      physics: const NeverScrollableScrollPhysics(),
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Theme.of(context).hintColor,
                      indicatorColor: Theme.of(context).primaryColor,
                      labelStyle: kAppStyleTabTitleStyle(context),
                      unselectedLabelStyle: kAppStyleTabTitleStyle(context),
                      labelPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      tabs: List.generate(translations.length, (index) => Text(translations[index].name!)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                  child: TabBarView(
                    controller: menuTranslationTabController,
                    children: List.generate(
                      translations.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          initialValue: translations[index].value,
                          decoration: kAppInputDecoration(context, lblText: "${translate.form_name} ${translations[index].nativeName}"),
                          style: kAppLblLargeFontMedium(context),
                          onChanged: (value) {
                            setState(() {
                              translations[index].value = value;
                            });
                          },
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                  ),
                ),
                kAppSpacerVertical(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(translate.menu_photos, style: kAppLblMediumFontMedium(context)),
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
                                context.read<NewMenuModalBloc>().add(NewMenuSavePhotoEvent(image: galleryResponse.data!));
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
                kAppSpacerVertical(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: ScrollConfiguration(
                    behavior: MenuPhotosScrollBehavior(),
                    child: GridView(
                      scrollDirection: Axis.horizontal,
                      physics: const PageScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 5.0, crossAxisSpacing: 5.0, crossAxisCount: 2, childAspectRatio: 1, mainAxisExtent: MediaQuery.of(context).size.width / 4),
                      children: state.photos
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
                                      onTap: () => context.read<NewMenuModalBloc>().add(NewMenuRemovePhotoEvent(image: e)),
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
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isValid ? () => context.read<NewMenuModalBloc>().add(NewMenuSaveEvent(translations: translations)) : null,
                style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                child: state.status.isInProgress ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.save_lbl),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MenuPhotosScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
// DONE //
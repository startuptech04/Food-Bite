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

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/app/core/models/media_list_model.dart';
import 'package:vendor/app/presentation/pages/media/bloc/media_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/loader_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class MediaModalScreen extends StatelessWidget {
  final String selectedMedia;
  const MediaModalScreen({super.key, required this.selectedMedia});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaBloc(),
      child: MediaModalView(selectedMedia: selectedMedia),
    );
  }
}

class MediaModalView extends StatefulWidget {
  final String selectedMedia;
  const MediaModalView({super.key, required this.selectedMedia});

  @override
  State<MediaModalView> createState() => _MediaModalViewState();
}

class _MediaModalViewState extends State<MediaModalView> with TickerProviderStateMixin {
  late TabController mediaTabController;

  @override
  void initState() {
    super.initState();
    mediaTabController = TabController(initialIndex: 0, length: 2, vsync: this);
    context.read<MediaBloc>().add(MediaInitialEvent(file: widget.selectedMedia));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<MediaBloc, MediaState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            title: Text(translate.image_gallery),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop({'action': false, 'data': state.selectedMedia}),
                icon: Icon(Icons.close_outlined, color: Theme.of(context).iconTheme.color),
              ),
            ],
            bottom: TabBar(
              controller: mediaTabController,
              physics: const NeverScrollableScrollPhysics(),
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Theme.of(context).hintColor,
              indicatorColor: Theme.of(context).primaryColor,
              labelStyle: kAppStyleTabTitleStyle(context),
              unselectedLabelStyle: kAppStyleTabTitleStyle(context),
              labelPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              onTap: (int index) => context.read<MediaBloc>().add(MediaTabChangeEvent(tabIndex: index)),
              tabs: [Text(translate.upload_files), Text(translate.image_gallery)],
            ),
          ),
          body: TabBarView(
            controller: mediaTabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const MediaUploadView(),
              MediaGridView(model: state.medias),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop({'action': false, 'data': state.selectedMedia}),
                          style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).scaffoldBackgroundColor, foreColor: Theme.of(context).canvasColor, height: 50.0),
                          child: Text(translate.cancel_lbl),
                        ),
                      ),
                    ),
                    kAppSpacerHorizontal(width: 10),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.selectedMedia.isNotEmpty && state.tabIndex == 1 ? () => Navigator.of(context).pop({'action': true, 'data': state.selectedMedia}) : null,
                          style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50),
                          child: Text(translate.set_image),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MediaUploadView extends StatefulWidget {
  const MediaUploadView({super.key});

  @override
  State<MediaUploadView> createState() => _MediaUploadViewState();
}

class _MediaUploadViewState extends State<MediaUploadView> {
  XFile? newImage;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      newImage = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<MediaBloc, MediaState>(
      listener: (context, state) {
        if (state.status.isUploadLoaderStarted) {
          LoaderService.showLoader(context, msg: translate.uploading_progress);
        } else if (state.status.isUploadLoaderEnded) {
          LoaderService.hideLoder(context);
          Navigator.of(context).pop({'action': true, 'data': state.selectedMedia});
        } else if (state.status.isUploadLoaderEndedWithError) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    {
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (_) => CupertinoActionSheet(
                          title: Text(translate.choose_from, style: kAppLblMediumFontSemiBold(context)),
                          actions: <CupertinoActionSheetAction>[
                            CupertinoActionSheetAction(
                              child: Text(translate.gallery, style: kAppLblMediumFontRegular(context)),
                              onPressed: () {
                                Navigator.pop(context);
                                getImage(ImageSource.gallery);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(translate.camera, style: kAppLblMediumFontRegular(context)),
                              onPressed: () {
                                Navigator.pop(context);
                                getImage(ImageSource.camera);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(translate.cancel_lbl, style: kAppLblMediumFontRegularError(context)),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 20),
                    height: 180,
                    padding: const EdgeInsets.all(8), // Border width
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1),
                      shape: BoxShape.rectangle,
                    ),
                    child: newImage != null
                        ? Image.file(File(newImage!.path), width: (MediaQuery.of(context).size.width - 20), height: 180, fit: BoxFit.cover)
                        : CacheNetworkImageWidget(width: (MediaQuery.of(context).size.width - 20), height: 180, imageUrl: ''),
                  ),
                ),
                kAppSpacerVertical(height: 30),
                OutlinedButton(
                  onPressed: newImage != null ? () => context.read<MediaBloc>().add(MediaUploadImageEvent(newImage: newImage!)) : null,
                  style: kAppOutlineButtonStyle(context, radius: 20.0),
                  child: Text(translate.upload_and_save),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MediaGridView extends StatelessWidget {
  final VendorMediaListModel model;
  const MediaGridView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<MediaBloc, MediaState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(model.results!.length, (index) {
                    return GestureDetector(
                      onTap: () => context.read<MediaBloc>().add(MediaSelectEvent(file: model.results![index].path!)),
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(8), // Border width
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: state.selectedMedia == model.results![index].path! ? Theme.of(context).primaryColor : ThemeProvider.transparentColor,
                            width: state.selectedMedia == model.results![index].path! ? 2 : 0,
                          ),
                          shape: BoxShape.rectangle,
                        ),
                        child: CacheNetworkImageWidget(width: 40, height: 40, imageUrl: model.results![index].path!),
                      ),
                    );
                  }),
                ),
                kAppSpacerVertical(height: 30),
                state.status.isLoadMoreStarted ? kAppCircularProgress(context, strokeWidth: 1, height: 20.0, width: 20.0, padding: 10) : const SizedBox(),
                state.medias.results!.length < state.medias.totalResults!
                    ? OutlinedButton(onPressed: () => context.read<MediaBloc>().add(MediaLoadMoreEvent()), style: kAppOutlineButtonStyle(context, radius: 20.0), child: Text(translate.load_more))
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
// DONE //
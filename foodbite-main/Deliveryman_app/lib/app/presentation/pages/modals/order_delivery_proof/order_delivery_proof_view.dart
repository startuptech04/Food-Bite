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

import 'package:driver/app/presentation/pages/modals/order_delivery_proof/bloc/order_delivery_proof_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/loader_dialog.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class OrderDeliveryProofScreen extends StatelessWidget {
  final String orderId;
  const OrderDeliveryProofScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDeliveryProofBloc()..add(OrderDeliveryProofInitialEvent(orderId: orderId)),
      child: const OrderDeliveryProofView(),
    );
  }
}

class OrderDeliveryProofView extends StatefulWidget {
  const OrderDeliveryProofView({super.key});

  @override
  State<OrderDeliveryProofView> createState() => _OrderDeliveryProofViewState();
}

class _OrderDeliveryProofViewState extends State<OrderDeliveryProofView> {
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
    return BlocConsumer<OrderDeliveryProofBloc, OrderDeliveryProofState>(
      listener: (context, state) {
        if (state.status.isUploadLoaderStarted) {
          LoaderService.showLoader(context, msg: translate.loader_uploading);
        } else if (state.status.isUploadLoaderEnded) {
          LoaderService.hideLoder(context);
          Navigator.of(context).pop({'action': true, 'data': state.selectedMedia});
        } else if (state.status.isUploadLoaderEndedWithError) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            title: Text(translate.order_delivery_proof),
            actions: [
              IconButton(onPressed: () => Navigator.of(context).pop({'action': false, 'data': state.selectedMedia}), icon: const Icon(Icons.close)),
            ],
          ),
          body: SingleChildScrollView(
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
                                child: Text(translate.cancel, style: kAppLblMediumFontRegularError(context)),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 20),
                      height: MediaQuery.of(context).size.height / 2,
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
                    onPressed: newImage != null ? () => context.read<OrderDeliveryProofBloc>().add(OrderDeliveryProofUploadImageEvent(newImage: newImage!)) : null,
                    style: kAppOutlineButtonStyle(context, radius: 20.0),
                    child: Text(translate.upload_and_save),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
// DONE //
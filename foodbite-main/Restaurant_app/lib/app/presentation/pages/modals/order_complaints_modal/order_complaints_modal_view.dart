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
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/order_detail_for_complaints_response_model.dart';
import 'package:vendor/app/presentation/pages/modals/order_complaints_modal/bloc/order_complaints_modal_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class OrderComplaintsModalScreen extends StatelessWidget {
  final String orderId;
  const OrderComplaintsModalScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderComplaintsModalBloc()..add(OrderComplaintsModalInitialEvent(orderId: orderId)),
      child: const OrderComplaintsModalView(),
    );
  }
}

class OrderComplaintsModalView extends StatefulWidget {
  const OrderComplaintsModalView({super.key});

  @override
  State<OrderComplaintsModalView> createState() => _OrderComplaintsModalViewState();
}

class _OrderComplaintsModalViewState extends State<OrderComplaintsModalView> {
  XFile? newImage;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      newImage = img;
    });
  }

  Future cleanImage() async {
    setState(() {
      newImage = null;
    });
  }

  final _titleFocusNode = FocusNode();
  final _briefFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleFocusNode.addListener(() {
      if (!_titleFocusNode.hasFocus) {
        context.read<OrderComplaintsModalBloc>().add(OrderComplaintModalTitleUnfocusedEvent());
      }
    });

    _briefFocusNode.addListener(() {
      if (!_briefFocusNode.hasFocus) {
        context.read<OrderComplaintsModalBloc>().add(OrderComplaintModalBriefUnfocusedEvent());
      }
    });
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _briefFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((OrderComplaintsModalBloc bloc) => bloc.state.isValid);
    return BlocConsumer<OrderComplaintsModalBloc, OrderComplaintsModalState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isUploadFailed) {
          cleanImage();
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isUploadSuccess) {
          showSuccessDialog(context, translate.image_uploaded);
          cleanImage();
        } else if (state.status.isMediaDeleteFailed) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isMediaDeleteSuccess) {
          showSuccessDialog(context, translate.image_deleted);
        } else if (state.status.isSubmitFailed) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSubmitSuccess) {
          showSuccessDialog(context, translate.complaint_registered).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            title: Text(translate.order_complaints),
            actions: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const OrderComplaintsModalLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const OrderComplaintsModalErrorView(),
                ] else ...[
                  state.complaintsWith.isNotEmpty ? Text(translate.complaint_to, style: kAppLblTinyFontRegular(context)) : const SizedBox(),
                  state.complaintsWith.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 5),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                          ),
                          child: DropdownButton<ComplaintIssueWithListModel>(
                            underline: const SizedBox(),
                            isExpanded: true,
                            value: state.complaintTo,
                            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                            style: kAppLblMediumFontRegular(context),
                            items: state.complaintsWith.map((ComplaintIssueWithListModel item) {
                              return DropdownMenuItem<ComplaintIssueWithListModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                            }).toList(),
                            onChanged: (newValue) {
                              context.read<OrderComplaintsModalBloc>().add(OrderComplaintModalIssueWithEvent(issueWith: newValue!));
                            },
                          ),
                        )
                      : const SizedBox(),
                  state.reasonList.isNotEmpty ? Text(translate.select_reason, style: kAppLblTinyFontRegular(context)) : const SizedBox(),
                  state.reasonList.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 5),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                          ),
                          child: DropdownButton<OrderComplaintReasonConfigModel>(
                            underline: const SizedBox(),
                            isExpanded: true,
                            value: state.reason,
                            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                            style: kAppLblMediumFontRegular(context),
                            items: state.reasonList.map((OrderComplaintReasonConfigModel item) {
                              return DropdownMenuItem<OrderComplaintReasonConfigModel>(value: item, child: Text(item.name.toString()));
                            }).toList(),
                            onChanged: (newValue) {
                              context.read<OrderComplaintsModalBloc>().add(OrderComplaintModalReasonSelectEvent(reason: newValue!));
                            },
                          ),
                        )
                      : const SizedBox(),
                  Text(translate.complaint_title, style: kAppLblTinyFontRegular(context)),
                  kAppSpacerVertical(height: 5),
                  TextFormField(
                    initialValue: state.complaintTitle.value,
                    focusNode: _titleFocusNode,
                    decoration: kAppInputDecoration(context, lblText: translate.form_title, errText: state.complaintTitle.displayError != null ? translate.form_required : null),
                    style: kAppLblSmallFontMedium(context),
                    keyboardType: TextInputType.text,
                    onChanged: (value) => context.read<OrderComplaintsModalBloc>().add(OrderComplaintModalTitleChangedEvent(title: value)),
                    textInputAction: TextInputAction.next,
                  ),
                  kAppSpacerVertical(height: 5),
                  Text(translate.complaint_brief, style: kAppLblTinyFontRegular(context)),
                  kAppSpacerVertical(height: 5),
                  TextFormField(
                    initialValue: state.complaintBrief.value,
                    focusNode: _briefFocusNode,
                    decoration: kAppInputDecoration(context, lblText: translate.form_brief, errText: state.complaintBrief.displayError != null ? translate.form_required : null),
                    maxLines: 4,
                    style: kAppLblSmallFontMedium(context),
                    keyboardType: TextInputType.text,
                    onChanged: (value) => context.read<OrderComplaintsModalBloc>().add(OrderComplaintModalBriefChangedEvent(brief: value)),
                    textInputAction: TextInputAction.done,
                  ),
                  kAppSpacerVertical(height: 10),
                  Text(translate.upload_max_images, style: kAppLblTinyFontRegular(context)),
                  kAppSpacerVertical(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      state.imageProof.isNotEmpty && state.imageProof[0].isNotEmpty
                          ? Container(
                              height: 100,
                              width: 100,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                              ),
                              child: Stack(
                                children: [
                                  CacheNetworkImageWidget(width: 80, height: 80, imageUrl: state.imageProof[0]),
                                  state.status.isMediaDeleteStarted && state.mediaDeleteIndex == 0
                                      ? Align(
                                          alignment: Alignment.center,
                                          child: kAppCircularProgress(context, color: 'primary', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0),
                                        )
                                      : Align(
                                          alignment: Alignment.topRight,
                                          child: InkWell(
                                            onTap: () => context.read<OrderComplaintsModalBloc>().add(OrderComplaintModalRemoveUploadImageEvent(index: 0)),
                                            child: const Icon(Icons.delete_forever_outlined, color: ThemeProvider.errorColor, size: 18),
                                          ),
                                        ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      state.imageProof.isNotEmpty && state.imageProof.length >= 2 && state.imageProof[1].isNotEmpty
                          ? Container(
                              height: 100,
                              width: 100,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                              ),
                              child: Stack(
                                children: [
                                  CacheNetworkImageWidget(width: 80, height: 80, imageUrl: state.imageProof[1]),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () => context.read<OrderComplaintsModalBloc>().add(OrderComplaintModalRemoveUploadImageEvent(index: 1)),
                                      child: const Icon(Icons.delete_forever_outlined, color: ThemeProvider.errorColor, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      state.imageProof.isNotEmpty && state.imageProof.length >= 3 && state.imageProof[2].isNotEmpty
                          ? Container(
                              height: 100,
                              width: 100,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                              ),
                              child: Stack(
                                children: [
                                  CacheNetworkImageWidget(width: 80, height: 80, imageUrl: state.imageProof[2]),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () => context.read<OrderComplaintsModalBloc>().add(OrderComplaintModalRemoveUploadImageEvent(index: 2)),
                                      child: const Icon(Icons.delete_forever_outlined, color: ThemeProvider.errorColor, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      state.imageProof.isEmpty || state.imageProof.length != 3
                          ? Container(
                              height: 100,
                              width: 100,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                              ),
                              child: InkWell(
                                onTap: newImage != null
                                    ? null
                                    : () {
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
                                      },
                                child: newImage != null
                                    ? Stack(
                                        children: [
                                          Image.file(File(newImage!.path), width: 80, height: 80, fit: BoxFit.cover),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black.withValues(alpha: 0.9), Colors.black.withValues(alpha: 0.5)]),
                                            ),
                                          ),
                                          state.status.isUploadStarted
                                              ? Align(
                                                  alignment: Alignment.center,
                                                  child: kAppCircularProgress(context, color: 'primary', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0),
                                                )
                                              : Align(
                                                  alignment: Alignment.center,
                                                  child: InkWell(
                                                    onTap: () => context.read<OrderComplaintsModalBloc>().add(OrderComplaintModalUploadImageEvent(newImage: newImage!)),
                                                    child: Text(translate.upload, textAlign: TextAlign.center, style: kAppLblTinyBoldOffer(context)),
                                                  ),
                                                ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: () => cleanImage(),
                                              child: const Icon(Icons.delete_forever_outlined, color: ThemeProvider.errorColor, size: 18),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.image, color: Theme.of(context).canvasColor, size: 18),
                                          kAppSpacerVertical(height: 10),
                                          Text(translate.upload_proof, style: kAppLblTinyFontRegular(context)),
                                        ],
                                      ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ],
            ),
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
                          onPressed: () => isValid ? context.read<OrderComplaintsModalBloc>().add(OrderComplaintModalSubmitEvent()) : null,
                          style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50),
                          child: state.status.isInProgress ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.submit_lbl),
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

class OrderComplaintsModalLoadingView extends StatelessWidget {
  const OrderComplaintsModalLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(style: SkeletonLineStyle(height: 8, width: 64, borderRadius: BorderRadius.circular(8))),
                const SizedBox(width: 5),
                SkeletonLine(style: SkeletonLineStyle(height: 8, width: 64, borderRadius: BorderRadius.circular(8))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
        const SizedBox(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(height: 50, width: double.infinity, borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(10, (index) {
              return SkeletonAvatar(
                style: SkeletonAvatarStyle(width: 80, height: 30, padding: const EdgeInsets.symmetric(horizontal: 5), borderRadius: BorderRadius.circular(8)),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          SkeletonLine(
                            style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                          ),
                          const SizedBox(height: 5),
                          SkeletonLine(
                            style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                          ),
                          const SizedBox(height: 5),
                          SkeletonLine(
                            style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SkeletonLine(style: SkeletonLineStyle(height: 25, width: 25, borderRadius: BorderRadius.circular(8))),
                              const SizedBox(width: 10),
                              SkeletonLine(style: SkeletonLineStyle(height: 25, width: 25, borderRadius: BorderRadius.circular(8))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SkeletonAvatar(style: SkeletonAvatarStyle(width: 80, height: 80, borderRadius: BorderRadius.circular(10))),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class OrderComplaintsModalErrorView extends StatelessWidget {
  const OrderComplaintsModalErrorView({super.key});

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
// DONE //
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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:intl/intl.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/dining_coupon_list_response_model.dart';
import 'package:vendor/app/core/models/translations/dining_coupon_translation_form.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/app/presentation/pages/account/coupons/dining_coupon/dialog_dining_coupon/bloc/dialog_dining_coupon_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class DialogDiningCouponScreen extends StatelessWidget {
  final bool isNew;
  final DiningCouponInfoConfigModel model;
  const DialogDiningCouponScreen({super.key, required this.isNew, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DialogDiningCouponBloc()..add(DialogDiningCouponInitialEvent(isNew: isNew, model: model)),
      child: DialogDiningCouponView(isNew: isNew, model: model),
    );
  }
}

class DialogDiningCouponView extends StatefulWidget {
  final bool isNew;
  final DiningCouponInfoConfigModel model;
  const DialogDiningCouponView({super.key, required this.isNew, required this.model});

  @override
  State<DialogDiningCouponView> createState() => _DialogDiningCouponViewState();
}

class _DialogDiningCouponViewState extends State<DialogDiningCouponView> with TickerProviderStateMixin {
  final TextEditingController _diningCouponNameController = TextEditingController();
  final TextEditingController _diningCouponCodeController = TextEditingController();
  final TextEditingController _diningCouponLimitController = TextEditingController();
  final TextEditingController _diningCouponStartDateController = TextEditingController();
  final TextEditingController _diningCouponEndDateController = TextEditingController();
  final TextEditingController _diningCouponMinDiscountController = TextEditingController();
  final TextEditingController _diningCouponMaxDiscountController = TextEditingController();
  final TextEditingController _diningCouponPreBookingChargeController = TextEditingController();

  final _diningCouponNameFocusNode = FocusNode();
  final _diningCouponCodeFocusNode = FocusNode();
  final _diningCouponLimitFocusNode = FocusNode();
  final _diningCouponStartDateFocusNode = FocusNode();
  final _diningCouponExpireDateFocusNode = FocusNode();
  final _diningCouponMinDiscountFocusNode = FocusNode();
  final _diningCouponMaxDiscountFocusNode = FocusNode();
  final _diningCouponPreBookingChargeFocusNode = FocusNode();

  List<DiningCouponFormTranslations> translations = <DiningCouponFormTranslations>[];
  late TabController diningCouponTranslationTabController;

  @override
  void initState() {
    super.initState();
    if (AppSupportedLanguagesModel.languages.length > 1) {
      for (var element in AppSupportedLanguagesModel.languages) {
        DiningCouponFormTranslations keys = DiningCouponFormTranslations(name: element.value, code: element.code, nativeName: element.value, value: '');
        translations.add(keys);
      }
    }
    diningCouponTranslationTabController = TabController(initialIndex: 0, length: translations.length, vsync: this);

    _diningCouponNameFocusNode.addListener(() {
      if (!_diningCouponNameFocusNode.hasFocus) {
        context.read<DialogDiningCouponBloc>().add(DialogDiningCouponNameUnfocusedEvent());
      }
    });

    _diningCouponCodeFocusNode.addListener(() {
      if (!_diningCouponCodeFocusNode.hasFocus) {
        context.read<DialogDiningCouponBloc>().add(DialogDiningCouponCodeUnfocusedEvent());
      }
    });

    _diningCouponLimitFocusNode.addListener(() {
      if (!_diningCouponLimitFocusNode.hasFocus) {
        context.read<DialogDiningCouponBloc>().add(DialogDiningCouponLimitUnfocusedEvent());
      }
    });

    _diningCouponStartDateFocusNode.addListener(() {
      if (!_diningCouponStartDateFocusNode.hasFocus) {
        context.read<DialogDiningCouponBloc>().add(DialogDiningCouponStartDateUnfocusedEvent());
      }
    });

    _diningCouponExpireDateFocusNode.addListener(() {
      if (!_diningCouponExpireDateFocusNode.hasFocus) {
        context.read<DialogDiningCouponBloc>().add(DialogDiningCouponExpireDateUnfocusedEvent());
      }
    });

    _diningCouponMinDiscountFocusNode.addListener(() {
      if (!_diningCouponMinDiscountFocusNode.hasFocus) {
        context.read<DialogDiningCouponBloc>().add(DialogDiningCouponMinDiscountUnfocusedEvent());
      }
    });

    _diningCouponMaxDiscountFocusNode.addListener(() {
      if (!_diningCouponMaxDiscountFocusNode.hasFocus) {
        context.read<DialogDiningCouponBloc>().add(DialogDiningCouponMaxDiscountUnfocusedEvent());
      }
    });

    _diningCouponPreBookingChargeFocusNode.addListener(() {
      if (!_diningCouponPreBookingChargeFocusNode.hasFocus) {
        context.read<DialogDiningCouponBloc>().add(DialogDiningCouponPreBookingChargeUnfocusedEvent());
      }
    });

    if (!widget.isNew) {
      for (var locale in translations) {
        for (var translate in widget.model.translations!) {
          if (locale.code == translate.code) {
            locale.value = translate.value;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _diningCouponNameController.dispose();
    _diningCouponCodeController.dispose();
    _diningCouponLimitController.dispose();
    _diningCouponStartDateController.dispose();
    _diningCouponEndDateController.dispose();
    _diningCouponMinDiscountController.dispose();
    _diningCouponMaxDiscountController.dispose();
    _diningCouponPreBookingChargeController.dispose();

    _diningCouponNameFocusNode.dispose();
    _diningCouponCodeFocusNode.dispose();
    _diningCouponLimitFocusNode.dispose();
    _diningCouponStartDateFocusNode.dispose();
    _diningCouponExpireDateFocusNode.dispose();
    _diningCouponMinDiscountFocusNode.dispose();
    _diningCouponMaxDiscountFocusNode.dispose();
    _diningCouponPreBookingChargeFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((DialogDiningCouponBloc bloc) => bloc.state.isValid);
    return BlocConsumer<DialogDiningCouponBloc, DialogDiningCouponState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isSubmitFailed || state.status.isUpdateFailed) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSuccess) {
          _diningCouponNameController.text = state.diningCouponName.value;
          _diningCouponCodeController.text = state.diningCouponCode.value;
          _diningCouponLimitController.text = state.diningCouponLimit.value;
          _diningCouponStartDateController.text = state.diningCouponStartDate.value;
          _diningCouponEndDateController.text = state.diningCouponExpireDate.value;
          _diningCouponMinDiscountController.text = state.diningCouponMinDiscount.value;
          _diningCouponMaxDiscountController.text = state.diningCouponMaxDiscount.value;
          _diningCouponPreBookingChargeController.text = state.diningCouponPreBookingCharge.value;
        } else if (state.status.isSubmitSuccess) {
          showSuccessDialog(context, translate.coupon_added).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        } else if (state.status.isUpdateSuccess) {
          showSuccessDialog(context, translate.coupon_updated).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isSubmit || state.status.isUpdate ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(widget.isNew ? translate.add_coupon : translate.update_coupon), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const DialogDiningCouponLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const DialogDiningCouponErrorView(),
                  ] else ...[
                    TextFormField(
                      controller: _diningCouponNameController,
                      focusNode: _diningCouponNameFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_coupon_title, errText: state.diningCouponName.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          _diningCouponNameController.text = value.trimLeft();
                          _diningCouponNameController.selection = TextSelection.collapsed(offset: _diningCouponNameController.text.length);
                        }
                        if (RegExp(r'^[0-9]').hasMatch(value)) {
                          _diningCouponNameController.text = value.substring(1);
                          _diningCouponNameController.selection = TextSelection.collapsed(offset: _diningCouponNameController.text.length);
                        }
                        context.read<DialogDiningCouponBloc>().add(DialogDiningCouponNameChangedEvent(name: _diningCouponNameController.text));
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          controller: diningCouponTranslationTabController,
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
                        controller: diningCouponTranslationTabController,
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
                    TextFormField(
                      controller: _diningCouponCodeController,
                      focusNode: _diningCouponCodeFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_coupon_code, errText: state.diningCouponCode.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          _diningCouponCodeController.text = value.trimLeft();
                          _diningCouponCodeController.selection = TextSelection.collapsed(offset: _diningCouponCodeController.text.length);
                        }
                        context.read<DialogDiningCouponBloc>().add(DialogDiningCouponCodeChangedEvent(code: _diningCouponCodeController.text));
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _diningCouponLimitController,
                      focusNode: _diningCouponLimitFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_coupon_limit, errText: state.diningCouponLimit.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<DialogDiningCouponBloc>().add(DialogDiningCouponLimitChangedEvent(limit: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      showCursor: false,
                      readOnly: true,
                      focusNode: _diningCouponStartDateFocusNode,
                      controller: _diningCouponStartDateController,
                      onTap: () async {
                        DateTime startDate = DateTime.now();
                        final int nextDate = (DateTime.now().year + 30);
                        await showDatePicker(context: context, initialDate: startDate, firstDate: DateTime.now(), lastDate: DateTime(nextDate)).then((value) {
                          if (!context.mounted) return;
                          String formattedDate = DateFormat('yyyy-MM-dd').format(value!);
                          context.read<DialogDiningCouponBloc>().add(DialogDiningCouponStartDateChangedEvent(startDate: formattedDate));
                        });
                      },
                      decoration: kAppInputDecoration(
                        context,
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        lblText: translate.form_start_date,
                        errText: state.diningCouponStartDate.displayError != null ? translate.form_required : null,
                      ),
                      style: kAppLblSmallFontMedium(context),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      showCursor: false,
                      readOnly: true,
                      focusNode: _diningCouponExpireDateFocusNode,
                      controller: _diningCouponEndDateController,
                      onTap: () async {
                        DateTime startDate = DateTime.now();
                        final int nextDate = (DateTime.now().year + 30);
                        await showDatePicker(context: context, initialDate: startDate, firstDate: DateTime.now(), lastDate: DateTime(nextDate)).then((value) {
                          if (!context.mounted) return;
                          String formattedDate = DateFormat('yyyy-MM-dd').format(value!);
                          context.read<DialogDiningCouponBloc>().add(DialogDiningCouponExpireDateChangedEvent(expireDate: formattedDate));
                        });
                      },
                      decoration: kAppInputDecoration(
                        context,
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        lblText: translate.form_expire_date,
                        errText: state.diningCouponExpireDate.displayError != null ? translate.form_required : null,
                      ),
                      style: kAppLblSmallFontMedium(context),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.coupon_type, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<DiningCouponTypeModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.type,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.typeList.map((DiningCouponTypeModel item) {
                          return DropdownMenuItem<DiningCouponTypeModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<DialogDiningCouponBloc>().add(DialogDiningTypeChangeEvent(type: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _diningCouponMinDiscountController,
                      focusNode: _diningCouponMinDiscountFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.min_discount, errText: state.diningCouponMinDiscount.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<DialogDiningCouponBloc>().add(DialogDiningCouponMinDiscountChangedEvent(minDiscount: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      enabled: state.type.value! == 'percentage' ? true : false,
                      controller: _diningCouponMaxDiscountController,
                      focusNode: _diningCouponMaxDiscountFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.max_discount, errText: state.diningCouponMaxDiscount.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<DialogDiningCouponBloc>().add(DialogDiningCouponMaxDiscountChangedEvent(maxDiscount: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.coupon_availability, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<DiningCouponAvailabilityModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.availability,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.availabilityList.map((DiningCouponAvailabilityModel item) {
                          return DropdownMenuItem<DiningCouponAvailabilityModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<DialogDiningCouponBloc>().add(DialogDiningCouponAvailabilityChangeEvent(availability: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.coupon_prebooking_charge_required, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<DiningCouponPreBookingModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.preeBookingChargeRequired,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.preeBookingChargeRequiredList.map((DiningCouponPreBookingModel item) {
                          return DropdownMenuItem<DiningCouponPreBookingModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<DialogDiningCouponBloc>().add(DialogDiningCouponPreBookingChargeChangeEvent(preBooking: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      enabled: state.preeBookingChargeRequired.value! == true ? true : false,
                      controller: _diningCouponPreBookingChargeController,
                      focusNode: _diningCouponPreBookingChargeFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.pre_booking_charge, errText: state.diningCouponMaxDiscount.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<DialogDiningCouponBloc>().add(DialogDiningCouponPreBookingChargeChangedEvent(preBookingCharge: value)),
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ],
              ),
            ),
            bottomNavigationBar: state.status.isLoading || state.status.isFailure
                ? SafeArea(child: const SizedBox())
                : SafeArea(
                    child: SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: ThemeProvider.scaffoldPadding),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isValid ? () => context.read<DialogDiningCouponBloc>().add(DialogDiningCouponSubmitEvent(translations: translations)) : null,
                                  style: kAppElevatedButtonStyle(
                                    context,
                                    disabledColor: Theme.of(context).disabledColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    foreColor: Theme.of(context).scaffoldBackgroundColor,
                                    height: 50.0,
                                  ),
                                  child: state.status.isSubmit || state.status.isUpdate ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.submit_lbl),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class DialogDiningCouponLoadingView extends StatelessWidget {
  const DialogDiningCouponLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kAppSpacerVertical(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
      ],
    );
  }
}

class DialogDiningCouponErrorView extends StatelessWidget {
  const DialogDiningCouponErrorView({super.key});

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
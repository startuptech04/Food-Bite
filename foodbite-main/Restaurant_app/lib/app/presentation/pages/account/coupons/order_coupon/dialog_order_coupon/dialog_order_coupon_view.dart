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
import 'package:vendor/app/core/models/order_coupon_list_model.dart';
import 'package:vendor/app/core/models/translations/order_coupon_translation_form.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/app/presentation/pages/account/coupons/order_coupon/dialog_order_coupon/bloc/dialog_order_coupon_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class DialogOrderCouponScreen extends StatelessWidget {
  final bool isNew;
  final CouponsConfigModel model;
  const DialogOrderCouponScreen({super.key, required this.isNew, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DialogOrderCouponBloc()..add(DialogOrderCouponInitialEvent(isNew: isNew, model: model)),
      child: DialogOrderCouponView(isNew: isNew, model: model),
    );
  }
}

class DialogOrderCouponView extends StatefulWidget {
  final bool isNew;
  final CouponsConfigModel model;
  const DialogOrderCouponView({super.key, required this.isNew, required this.model});

  @override
  State<DialogOrderCouponView> createState() => _DialogOrderCouponViewState();
}

class _DialogOrderCouponViewState extends State<DialogOrderCouponView> with TickerProviderStateMixin {
  final TextEditingController _orderCouponNameController = TextEditingController();
  final TextEditingController _orderCouponCodeController = TextEditingController();
  final TextEditingController _orderCouponLimitController = TextEditingController();
  final TextEditingController _orderCouponStartDateController = TextEditingController();
  final TextEditingController _orderCouponEndDateController = TextEditingController();
  final TextEditingController _orderCouponMinDiscountController = TextEditingController();
  final TextEditingController _orderCouponMaxDiscountController = TextEditingController();
  final TextEditingController _orderCouponMinCartController = TextEditingController();

  final _orderCouponNameFocusNode = FocusNode();
  final _orderCouponCodeFocusNode = FocusNode();
  final _orderCouponLimitFocusNode = FocusNode();
  final _orderCouponStartDateFocusNode = FocusNode();
  final _orderCouponExpireDateFocusNode = FocusNode();
  final _orderCouponMinDiscountFocusNode = FocusNode();
  final _orderCouponMaxDiscountFocusNode = FocusNode();
  final _orderCouponMinCartFocusNode = FocusNode();

  List<OrderCouponFormTranslations> translations = <OrderCouponFormTranslations>[];
  late TabController orderCouponTranslationTabController;

  @override
  void initState() {
    super.initState();
    if (AppSupportedLanguagesModel.languages.length > 1) {
      for (var element in AppSupportedLanguagesModel.languages) {
        OrderCouponFormTranslations keys = OrderCouponFormTranslations(name: element.value, code: element.code, nativeName: element.value, value: '');
        translations.add(keys);
      }
    }
    orderCouponTranslationTabController = TabController(initialIndex: 0, length: translations.length, vsync: this);

    _orderCouponNameFocusNode.addListener(() {
      if (!_orderCouponNameFocusNode.hasFocus) {
        context.read<DialogOrderCouponBloc>().add(DialogOrderCouponNameUnfocusedEvent());
      }
    });
    _orderCouponCodeFocusNode.addListener(() {
      if (!_orderCouponCodeFocusNode.hasFocus) {
        context.read<DialogOrderCouponBloc>().add(DialogOrderCouponCodeUnfocusedEvent());
      }
    });
    _orderCouponLimitFocusNode.addListener(() {
      if (!_orderCouponLimitFocusNode.hasFocus) {
        context.read<DialogOrderCouponBloc>().add(DialogOrderCouponLimitUnfocusedEvent());
      }
    });
    _orderCouponStartDateFocusNode.addListener(() {
      if (!_orderCouponStartDateFocusNode.hasFocus) {
        context.read<DialogOrderCouponBloc>().add(DialogOrderCouponStartDateUnfocusedEvent());
      }
    });
    _orderCouponExpireDateFocusNode.addListener(() {
      if (!_orderCouponExpireDateFocusNode.hasFocus) {
        context.read<DialogOrderCouponBloc>().add(DialogOrderCouponExpireDateUnfocusedEvent());
      }
    });
    _orderCouponMinDiscountFocusNode.addListener(() {
      if (!_orderCouponMinDiscountFocusNode.hasFocus) {
        context.read<DialogOrderCouponBloc>().add(DialogOrderCouponMinDiscountUnfocusedEvent());
      }
    });
    _orderCouponMaxDiscountFocusNode.addListener(() {
      if (!_orderCouponMaxDiscountFocusNode.hasFocus) {
        context.read<DialogOrderCouponBloc>().add(DialogOrderCouponMaxDiscountUnfocusedEvent());
      }
    });
    _orderCouponMinCartFocusNode.addListener(() {
      if (!_orderCouponMinCartFocusNode.hasFocus) {
        context.read<DialogOrderCouponBloc>().add(DialogOrderCouponMinCartUnfocusedEvent());
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
    _orderCouponNameController.dispose();
    _orderCouponCodeController.dispose();
    _orderCouponLimitController.dispose();
    _orderCouponStartDateController.dispose();
    _orderCouponEndDateController.dispose();
    _orderCouponMinDiscountController.dispose();
    _orderCouponMaxDiscountController.dispose();
    _orderCouponMinCartController.dispose();

    _orderCouponNameFocusNode.dispose();
    _orderCouponCodeFocusNode.dispose();
    _orderCouponLimitFocusNode.dispose();
    _orderCouponStartDateFocusNode.dispose();
    _orderCouponExpireDateFocusNode.dispose();
    _orderCouponMinDiscountFocusNode.dispose();
    _orderCouponMaxDiscountFocusNode.dispose();
    _orderCouponMinCartFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((DialogOrderCouponBloc bloc) => bloc.state.isValid);
    return BlocConsumer<DialogOrderCouponBloc, DialogOrderCouponState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isSubmitFailed || state.status.isUpdateFailed) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSuccess) {
          _orderCouponNameController.text = state.orderCouponName.value;
          _orderCouponCodeController.text = state.orderCouponCode.value;
          _orderCouponLimitController.text = state.orderCouponLimit.value;
          _orderCouponStartDateController.text = state.orderCouponStartDate.value;
          _orderCouponEndDateController.text = state.orderCouponExpireDate.value;
          _orderCouponMaxDiscountController.text = state.orderCouponMaxDiscount.value;
          _orderCouponMinDiscountController.text = state.orderCouponMinDiscount.value;
          _orderCouponMaxDiscountController.text = state.orderCouponMaxDiscount.value;
          _orderCouponMinCartController.text = state.orderCouponMinCart.value;
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
                    const DialogOrderCouponLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const DialogOrderCouponErrorView(),
                  ] else ...[
                    TextFormField(
                      controller: _orderCouponNameController,
                      focusNode: _orderCouponNameFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_coupon_title, errText: state.orderCouponName.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          _orderCouponNameController.text = value.trimLeft();
                          _orderCouponNameController.selection = TextSelection.collapsed(offset: _orderCouponNameController.text.length);
                        }
                        if (RegExp(r'^[0-9]').hasMatch(value)) {
                          _orderCouponNameController.text = value.substring(1);
                          _orderCouponNameController.selection = TextSelection.collapsed(offset: _orderCouponNameController.text.length);
                        }
                        context.read<DialogOrderCouponBloc>().add(DialogOrderCouponNameChangedEvent(name: _orderCouponNameController.text));
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
                          controller: orderCouponTranslationTabController,
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
                        controller: orderCouponTranslationTabController,
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
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _orderCouponCodeController,
                      focusNode: _orderCouponCodeFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_coupon_code, errText: state.orderCouponCode.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          _orderCouponCodeController.text = value.trimLeft();
                          _orderCouponCodeController.selection = TextSelection.collapsed(offset: _orderCouponCodeController.text.length);
                        }
                        context.read<DialogOrderCouponBloc>().add(DialogOrderCouponCodeChangedEvent(code: _orderCouponCodeController.text));
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _orderCouponLimitController,
                      focusNode: _orderCouponLimitFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_coupon_limit, errText: state.orderCouponLimit.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<DialogOrderCouponBloc>().add(DialogOrderCouponLimitChangedEvent(limit: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      showCursor: false,
                      readOnly: true,
                      focusNode: _orderCouponStartDateFocusNode,
                      controller: _orderCouponStartDateController,
                      onTap: () async {
                        DateTime startDate = DateTime.now();
                        final int nextDate = (DateTime.now().year + 30);
                        await showDatePicker(context: context, initialDate: startDate, firstDate: DateTime.now(), lastDate: DateTime(nextDate)).then((value) {
                          if (!context.mounted) return;
                          String formattedDate = DateFormat('yyyy-MM-dd').format(value!);
                          context.read<DialogOrderCouponBloc>().add(DialogOrderCouponStartDateChangedEvent(startDate: formattedDate));
                        });
                      },
                      decoration: kAppInputDecoration(
                        context,
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        lblText: translate.form_start_date,
                        errText: state.orderCouponStartDate.displayError != null ? translate.form_required : null,
                      ),
                      style: kAppLblSmallFontMedium(context),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      showCursor: false,
                      readOnly: true,
                      focusNode: _orderCouponExpireDateFocusNode,
                      controller: _orderCouponEndDateController,
                      onTap: () async {
                        DateTime startDate = DateTime.now();
                        final int nextDate = (DateTime.now().year + 30);
                        await showDatePicker(context: context, initialDate: startDate, firstDate: DateTime.now(), lastDate: DateTime(nextDate)).then((value) {
                          if (!context.mounted) return;
                          String formattedDate = DateFormat('yyyy-MM-dd').format(value!);
                          context.read<DialogOrderCouponBloc>().add(DialogOrderCouponExpireDateChangedEvent(expireDate: formattedDate));
                        });
                      },
                      decoration: kAppInputDecoration(
                        context,
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        lblText: translate.form_expire_date,
                        errText: state.orderCouponExpireDate.displayError != null ? translate.form_required : null,
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
                      child: DropdownButton<OrderCouponTypeModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.type,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.typeList.map((OrderCouponTypeModel item) {
                          return DropdownMenuItem<OrderCouponTypeModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<DialogOrderCouponBloc>().add(DialogOrderCouponTypeEvent(type: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _orderCouponMinDiscountController,
                      focusNode: _orderCouponMinDiscountFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.min_discount, errText: state.orderCouponMinDiscount.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<DialogOrderCouponBloc>().add(DialogOrderCouponMinDiscountChangedEvent(minDiscount: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      enabled: state.type.value! == 'percentage' ? true : false,
                      controller: _orderCouponMaxDiscountController,
                      focusNode: _orderCouponMaxDiscountFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.max_discount, errText: state.orderCouponMaxDiscount.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<DialogOrderCouponBloc>().add(DialogOrderCouponMaxDiscountChangedEvent(maxDiscount: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _orderCouponMinCartController,
                      focusNode: _orderCouponMinCartFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.min_cart, errText: state.orderCouponMinCart.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<DialogOrderCouponBloc>().add(DialogOrderCouponMinCartChangedEvent(minCart: value)),
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
                                  onPressed: isValid ? () => context.read<DialogOrderCouponBloc>().add(DialogOrderCouponSubmitEvent(translations: translations)) : null,
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

class DialogOrderCouponLoadingView extends StatelessWidget {
  const DialogOrderCouponLoadingView({super.key});

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

class DialogOrderCouponErrorView extends StatelessWidget {
  const DialogOrderCouponErrorView({super.key});

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
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
import 'package:vendor/app/presentation/pages/modals/complete_dining_booking_modal/bloc/complete_dining_booking_modal_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class CompleteDiningBookingModalScreen extends StatelessWidget {
  final String bookingId;
  final String userName;
  final String bookingDate;
  final String contactNumber;
  final double couponCoverCharge;
  final double grandTotal;
  final String couponId;
  final String couponCode;
  final String couponDiscountType;
  final double couponMinDiscount;
  final double couponMaxDiscount;
  const CompleteDiningBookingModalScreen({
    super.key,
    required this.bookingId,
    required this.userName,
    required this.bookingDate,
    required this.contactNumber,
    required this.couponCoverCharge,
    required this.grandTotal,
    required this.couponId,
    required this.couponCode,
    required this.couponDiscountType,
    required this.couponMinDiscount,
    required this.couponMaxDiscount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompleteDiningBookingModalBloc()
        ..add(
          CompleteDiningBookingModalInitialEvent(
            bookingId: bookingId,
            userName: userName,
            bookingDate: bookingDate,
            contactNumber: contactNumber,
            couponCoverCharge: couponCoverCharge,
            grandTotal: grandTotal,
            couponId: couponId,
            couponCode: couponCode,
            couponDiscountType: couponDiscountType,
            couponMinDiscount: couponMinDiscount,
            couponMaxDiscount: couponMaxDiscount,
          ),
        ),
      child: const CompleteDiningBookingModalView(),
    );
  }
}

class CompleteDiningBookingModalView extends StatefulWidget {
  const CompleteDiningBookingModalView({super.key});

  @override
  State<CompleteDiningBookingModalView> createState() => _CompleteDiningBookingModalViewState();
}

class _CompleteDiningBookingModalViewState extends State<CompleteDiningBookingModalView> {
  final TextEditingController _bookingBillingTotalController = TextEditingController();
  final TextEditingController _bookingBillingDiscountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<CompleteDiningBookingModalBloc, CompleteDiningBookingModalState>(
      listener: (context, state) {
        if (state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isCompleteSuccess) {
          showSuccessDialog(context, translate.booking_completed).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop('true');
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isComplete ? true : false,
          child: Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              title: Text(translate.complete_dining_booking),
              actions: [IconButton(onPressed: () => Navigator.of(context).pop('false'), icon: const Icon(Icons.close))],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${translate.id} : ${state.bookingId.toUpperCase()}', style: kAppLblTinyFontRegular(context)),
                      Text(state.bookingDate, style: kAppLblTinyFontRegular(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(state.userName, style: kAppLblTinyFontRegular(context)),
                      Text(state.contactNumber, style: kAppLblTinyFontRegular(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  TextFormField(
                    controller: _bookingBillingTotalController,
                    decoration: kAppInputDecoration(context, lblText: translate.form_billing_total_amount),
                    style: kAppLblLargeFontMedium(context),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => context.read<CompleteDiningBookingModalBloc>().add(CompleteDiningBookingModalBillingTotalChangedEvent(total: value)),
                    textInputAction: TextInputAction.next,
                  ),
                  kAppSpacerVertical(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _bookingBillingDiscountController,
                          decoration: kAppInputDecoration(context, lblText: translate.form_discount),
                          style: kAppLblLargeFontMedium(context),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => context.read<CompleteDiningBookingModalBloc>().add(CompleteDiningBookingModalDiscountChangedEvent(discount: value)),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      kAppSpacerHorizontal(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          key: UniqueKey(),
                          decoration: kAppInputDecoration(context, lblText: translate.form_discount_type),
                          style: kAppLblSmallFontMedium(context),
                          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                          initialValue: state.discountType,
                          items: state.discountTypeList.map((CompleteDiningBookingModalDiscountTypeModel state) {
                            return DropdownMenuItem<String>(value: state.value, child: Text(kAppDDTranslate(context, state.label!)));
                          }).toList(),
                          onChanged: (String? value) => context.read<CompleteDiningBookingModalBloc>().add(CompleteDiningBookingModalDiscountTypeChangedEvent(value: value!)),
                        ),
                      ),
                    ],
                  ),
                  state.couponId.isNotEmpty && state.couponDiscountType == 'percentage'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            kAppSpacerVertical(height: 20),
                            Text(translate.select_dining_coupon_discount, style: kAppLblMediumFontMedium(context)),
                            kAppSpacerVertical(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                GestureDetector(
                                  onTap: () => context.read<CompleteDiningBookingModalBloc>().add(CompleteDiningBookingModalCouponPercentageChangeEvent(couponDiscountPercentage: state.couponMinDiscount)),
                                  child: Chip(
                                    key: ObjectKey('minDiscount'),
                                    label: Text('${state.couponMinDiscount}%'),
                                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    padding: const EdgeInsets.all(2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(color: state.couponSelectedPercentageDiscount == state.couponMinDiscount ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 1),
                                    ),
                                    labelStyle: kAppLblSmallFontMedium(context, color: state.couponSelectedPercentageDiscount == state.couponMinDiscount ? 'primary' : 'regular'),
                                  ),
                                ),
                                kAppSpacerHorizontal(width: 20),
                                GestureDetector(
                                  onTap: () => context.read<CompleteDiningBookingModalBloc>().add(CompleteDiningBookingModalCouponPercentageChangeEvent(couponDiscountPercentage: state.couponMaxDiscount)),
                                  child: Chip(
                                    key: ObjectKey('maxDiscount'),
                                    label: Text('${state.couponMaxDiscount}%'),
                                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    padding: const EdgeInsets.all(2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(color: state.couponSelectedPercentageDiscount == state.couponMaxDiscount ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 1),
                                    ),
                                    labelStyle: kAppLblSmallFontMedium(context, color: state.couponSelectedPercentageDiscount == state.couponMaxDiscount ? 'primary' : 'regular'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox(),
                  state.couponId.isNotEmpty && state.couponDiscountType == 'amount'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            kAppSpacerVertical(height: 20),
                            TextFormField(
                              enabled: false,
                              initialValue: kAppPriceFormat(state.couponMinDiscount),
                              decoration: kAppInputDecoration(context, lblText: translate.form_coupon_discount_amount),
                              style: kAppLblLargeFontMedium(context),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text('${translate.total_billing} ${kAppPriceFormat(state.diningGrandTotalBillAmount)}', style: kAppLblSmallFontBold(context)),
                  ),
                  kAppSpacerVertical(height: 5),
                  SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop('false'),
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
                                onPressed: () => context.read<CompleteDiningBookingModalBloc>().add(CompleteDiningBookingModalSubmitEvent()),
                                style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50),
                                child: state.status.isComplete ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0) : Text(translate.mark_as_complete),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
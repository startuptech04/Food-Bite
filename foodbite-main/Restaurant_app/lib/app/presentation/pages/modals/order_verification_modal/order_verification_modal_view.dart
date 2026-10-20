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
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:vendor/app/presentation/pages/modals/order_verification_modal/bloc/order_verification_modal_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class OrderVerificationModalScreen extends StatelessWidget {
  final String orderId;
  final String orderTo;
  final String customerOrderPin;
  final String driverOrderPin;
  final String paymentMode;
  final double grandTotal;
  const OrderVerificationModalScreen({super.key, required this.orderId, required this.orderTo, required this.customerOrderPin, required this.driverOrderPin, required this.paymentMode, required this.grandTotal});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderVerificationModalBloc()
            ..add(OrderVerificationModalInitialEvent(orderId: orderId, orderTo: orderTo, customerOrderPin: customerOrderPin, driverOrderPin: driverOrderPin, paymentMode: paymentMode, grandTotal: grandTotal)),
      child: const OrderVerificationModalView(),
    );
  }
}

class OrderVerificationModalView extends StatelessWidget {
  const OrderVerificationModalView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    OtpFieldController otpController = OtpFieldController();
    return BlocConsumer<OrderVerificationModalBloc, OrderVerificationModalState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isVerified) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            title: Text(translate.verify_otp),
            actions: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
            child: state.status.isInitial
                ? kAppCenterCircularProgress(context, color: 'primary')
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${translate.enter_verification} ${state.orderTo == 'homedelivery' ? state.driverOrderPin.length : state.customerOrderPin.length} ${translate.otp_code_length}',
                        textAlign: TextAlign.start,
                        style: kAppLblMediumFontBold(context),
                      ),
                      kAppSpacerVertical(height: 20),
                      Text(
                        '${translate.please_ask} ${state.orderTo == 'homedelivery' ? translate.deliveryman : translate.customer} ${translate.check_verification_code}',
                        textAlign: TextAlign.start,
                        style: kAppLblMediumFontMedium(context),
                      ),
                      kAppSpacerVertical(height: 30),
                      OTPTextField(
                        controller: otpController,
                        length: state.customerOrderPin.length,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 45,
                        fieldStyle: FieldStyle.box,
                        outlineBorderRadius: 5,
                        style: kAppLblMediumFontBold(context),
                        keyboardType: TextInputType.text,
                        otpFieldStyle: OtpFieldStyle(
                          borderColor: Theme.of(context).canvasColor,
                          disabledBorderColor: Theme.of(context).canvasColor,
                          focusBorderColor: Theme.of(context).canvasColor,
                          enabledBorderColor: Theme.of(context).canvasColor,
                          errorBorderColor: Theme.of(context).canvasColor,
                        ),
                        onChanged: (pin) {
                          context.read<OrderVerificationModalBloc>().add(OrderVerificationModalOTPChangeEvent(otp: pin.toString()));
                        },
                        onCompleted: (pin) {
                          context.read<OrderVerificationModalBloc>().add(OrderVerificationModalOTPChangeEvent(otp: pin.toString()));
                        },
                      ),
                      kAppSpacerVertical(height: 30),
                      state.orderTo == 'selfpickup'
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: ThemeProvider.scaffoldPadding),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${state.paymentMode == 'offline' ? translate.cash_on_delivery : translate.paid_online} - ${kAppPriceFormat(state.grandTotal)}', style: kAppLblMediumFontBold(context)),
                                      Text('${translate.order} : ${state.orderId}', style: kAppLblTinyFontRegular(context)),
                                      state.paymentMode == 'offline' ? Text(translate.collect_cash_from_customer, style: kAppLblTinyFontRegular(context)) : const SizedBox(),
                                    ],
                                  ),
                                  state.paymentMode == 'offline'
                                      ? InkWell(
                                          onTap: () => context.read<OrderVerificationModalBloc>().add(OrderVerificationModalCollectedCashEvent()),
                                          child: Icon(state.isPaymentChecked ? Icons.check_box : Icons.check_box_outline_blank, size: 25, color: Theme.of(context).canvasColor),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
          ),
          bottomNavigationBar: state.status.isInitial
              ? SafeArea(child: const SizedBox())
              : SafeArea(
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
                                onPressed: state.otp.isNotEmpty && state.customerOrderPin.length == state.otp.length && state.isPaymentChecked == true
                                    ? () => context.read<OrderVerificationModalBloc>().add(OrderVerificationSubmitEvent())
                                    : null,
                                style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50),
                                child: state.status.isSubmit ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.verify),
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
// DONE //
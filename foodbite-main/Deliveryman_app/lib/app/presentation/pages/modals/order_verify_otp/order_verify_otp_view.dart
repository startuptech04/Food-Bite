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

import 'package:driver/app/presentation/pages/modals/order_verify_otp/bloc/order_verify_otp_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class OrderVerifyOtpScreen extends StatelessWidget {
  final String orderId;
  final String customerPin;
  const OrderVerifyOtpScreen({super.key, required this.orderId, required this.customerPin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderVerifyOtpBloc()..add(OrderVerifyOtpInitialEvent(orderId: orderId, customerPin: customerPin)),
      child: const OrderVerifyOtpView(),
    );
  }
}

class OrderVerifyOtpView extends StatelessWidget {
  const OrderVerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    OtpFieldController otpController = OtpFieldController();
    return BlocConsumer<OrderVerifyOtpBloc, OrderVerifyOtpState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isVerified) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
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
                      Text("${translate.enter_verification_one} ${state.customerOrderPin.length} ${translate.enter_verification_two}", textAlign: TextAlign.start, style: kAppLblMediumFontBold(context)),
                      kAppSpacerVertical(height: 20),
                      Text(translate.check_order_detail_and_verification_code, textAlign: TextAlign.start, style: kAppLblMediumFontMedium(context)),
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
                          context.read<OrderVerifyOtpBloc>().add(OrderVerifyOtpChangeEvent(otp: pin.toString()));
                        },
                        onCompleted: (pin) {
                          context.read<OrderVerifyOtpBloc>().add(OrderVerifyOtpChangeEvent(otp: pin.toString()));
                        },
                      ),
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
                                onPressed: state.otp.isNotEmpty && state.customerOrderPin.length == state.otp.length ? () => context.read<OrderVerifyOtpBloc>().add(OrderVerifyOtpSubmitEvent()) : null,
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
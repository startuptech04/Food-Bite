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

import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:driver/app/presentation/pages/modals/otp_modal/bloc/otp_modal_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/success_dialog.dart';
import 'package:driver/app/presentation/styles/theme.dart';

class OtpModalScreen extends StatelessWidget {
  final String providerName;
  final String sentTo;
  final String providerId;
  final int otpLength;
  final bool canResendOTP;
  final String mode;
  const OtpModalScreen({super.key, required this.providerName, required this.sentTo, required this.providerId, required this.otpLength, required this.canResendOTP, required this.mode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpModalBloc()..add(OtpModalInitialEvent(provider: providerName, providerId: providerId, canResendOTP: canResendOTP, otpLength: otpLength)),
      child: OtpModalView(providerName: providerName, sentTo: sentTo, providerId: providerId, otpLength: otpLength, canResendOTP: canResendOTP, mode: mode),
    );
  }
}

class OtpModalView extends StatefulWidget {
  final String providerName;
  final String sentTo;
  final String providerId;
  final int otpLength;
  final bool canResendOTP;
  final String mode;
  const OtpModalView({super.key, required this.providerName, required this.sentTo, required this.providerId, required this.otpLength, required this.canResendOTP, required this.mode});

  @override
  State<OtpModalView> createState() => _OtpModalViewState();
}

class _OtpModalViewState extends State<OtpModalView> {
  OtpFieldController otpController = OtpFieldController();
  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<OtpModalBloc, OtpModalState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSuccess) {
          Navigator.of(context).pop({'action': true, 'status': true, 'otp': state.otp.toString()});
        } else if (state.status.isSuccessResent) {
          showSuccessDialog(context, translate.otp_sent);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isInProgress ? true : false,
          child: Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: Text(translate.verification_code),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop({'action': false, 'status': false}),
                  icon: Icon(Icons.close_outlined, color: Theme.of(context).iconTheme.color),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${translate.verification_code_sent_to} ${widget.sentTo}", textAlign: TextAlign.start, style: kAppLblMediumFontBold(context)),
                    kAppSpacerVertical(height: 20),
                    Text(widget.mode == 'email_otp' ? translate.check_email_sms_box : translate.check_phone_sms_box, textAlign: TextAlign.start, style: kAppLblMediumFontMedium(context)),
                    kAppSpacerVertical(height: 30),
                    OTPTextField(
                      controller: otpController,
                      length: widget.otpLength,
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
                        context.read<OtpModalBloc>().add(OtpModalOnOTPChanged(otp: pin.toString()));
                      },
                      onCompleted: (pin) {
                        context.read<OtpModalBloc>().add(OtpModalOnOTPChanged(otp: pin.toString()));
                        context.read<OtpModalBloc>().add(OtpModalOnSubmitEvent());
                      },
                    ),
                    kAppSpacerVertical(height: 30),
                    Center(
                      child: Text(translate.security_concern_title, textAlign: TextAlign.start, style: kAppLblSmallFontMedium(context)),
                    ),
                    kAppSpacerVertical(height: 30),
                    widget.canResendOTP
                        ? Center(
                            child: TextButton(
                              onPressed: () {
                                context.read<OtpModalBloc>().add(OtpModalOnResendEvent());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  state.status.isResend ? kAppCircularProgress(context, color: 'primary', strokeWidth: 3.0, width: 15.0, height: 15.0, padding: 2.0) : const SizedBox(),
                                  Text(translate.did_not_received_otp_resent_lbl, style: kAppLblSmallFontMedium(context)),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
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
                            onPressed: () => state.otp.isNotEmpty && state.otp.length == widget.otpLength ? context.read<OtpModalBloc>().add(OtpModalOnSubmitEvent()) : null,
                            style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50),
                            child: state.status.isInProgress ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.verify),
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
// DONE //
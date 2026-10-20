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
import 'package:waiter/app/core/config/assets_url.dart';
import 'package:waiter/app/core/models/otp_modal_response_model.dart';
import 'package:waiter/app/env.dart';
import 'package:waiter/app/presentation/pages/auth/login/login_option/email_otp/bloc/email_otp_login_bloc.dart';
import 'package:waiter/app/presentation/pages/modals/otp_modal/otp_modal_view.dart';
import 'package:waiter/app/presentation/styles/app_style.dart';
import 'package:waiter/app/presentation/styles/error_dialog.dart';
import 'package:waiter/app/presentation/styles/theme.dart';
import 'package:waiter/app/router/app_route_config.dart';
import 'package:waiter/gen/l10n/app_localizations.dart';

class EmailOtpLoginScreen extends StatelessWidget {
  const EmailOtpLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => EmailOtpLoginBloc()..add(EmailOtpLoginInitialEvent()), child: EmailOtpLoginView());
  }
}

class EmailOtpLoginView extends StatefulWidget {
  const EmailOtpLoginView({super.key});

  @override
  State<EmailOtpLoginView> createState() => _EmailOtpLoginViewState();
}

class _EmailOtpLoginViewState extends State<EmailOtpLoginView> {
  final _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<EmailOtpLoginBloc>().add(EmailOtpLoginEmailUnfocusedEvent());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((EmailOtpLoginBloc bloc) => bloc.state.isValid);
    return BlocConsumer<EmailOtpLoginBloc, EmailOtpLoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode, fromAuth: true);
        } else if (state.status.isSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.bottomTabRoute, (Route<dynamic> route) => false, arguments: [1]);
        } else if (state.status.isVerify) {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return OtpModalScreen(
                      providerName: state.verification.provider!,
                      sentTo: state.email.value.toString(),
                      providerId: state.verification.id!,
                      otpLength: state.verification.otpLength!,
                      canResendOTP: state.verification.canResendOtp!,
                      mode: state.verification.mode!,
                    );
                  },
                  fullscreenDialog: true,
                ),
              )
              .then((value) {
                if (!context.mounted) return;
                OTPModalResponse otpModalResponse = OTPModalResponse.fromJson(value);
                if (otpModalResponse.action! && otpModalResponse.status!) {
                  context.read<EmailOtpLoginBloc>().add(EmailOtpLoginLoginNowEvent(otp: otpModalResponse.otp!));
                }
              });
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: AbsorbPointer(
            absorbing: state.status.isInProgress ? true : false,
            child: Padding(
              padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("${translate.welcome_to} ${Environments.appName}", textAlign: TextAlign.center, style: kAppLblLargeFontBold(context)),
                  kAppSpacerVertical(height: 10),
                  Text(translate.email_otp_login_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
                  kAppSpacerVertical(height: 40),
                  TextFormField(
                    initialValue: state.email.value,
                    focusNode: _emailFocusNode,
                    decoration: kAppInputDecoration(context, prefixIcon: const Icon(Icons.email_outlined), lblText: translate.form_email, errText: state.email.displayError != null ? translate.form_required : null),
                    style: kAppLblSmallFontMedium(context),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => context.read<EmailOtpLoginBloc>().add(EmailOtpLoginEmailChangedEvent(email: value)),
                    textInputAction: TextInputAction.next,
                  ),
                  kAppSpacerVertical(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          activeColor: Theme.of(context).primaryColor,
                          title: Text(translate.remember_me, style: kAppLblMediumFontRegular(context)),
                          value: state.remember.value,
                          onChanged: (value) => context.read<EmailOtpLoginBloc>().add(EmailOtpLoginRememberChangedEvent(checked: value!)),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isValid ? () => context.read<EmailOtpLoginBloc>().add(EmailOtpLoginFormSubmitEvent()) : null,
                      style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                      child: state.status.isInProgress ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.verify),
                    ),
                  ),
                  kAppSpacerVertical(height: 20),
                  state.appleSignInEnabled || state.googleSignInEnabled || state.facebookSignInEnabled
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text(translate.social_sign_in_account, textAlign: TextAlign.center, style: kAppLblMediumFontSemiBold(context))],
                        )
                      : const SizedBox(),
                  kAppSpacerVertical(height: 20),
                  state.appleSignInEnabled
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton.icon(
                            icon: Image.asset(AssetsUrl.imageURL.appleSocialLogin, width: 15, height: 15),
                            label: Text(translate.apple_sign_in, style: kAppLblMediumFontSemiBold(context)),
                            onPressed: () {},
                            style: kAppElevatedButtonOutlineStyle(
                              context,
                              disabledColor: Theme.of(context).disabledColor,
                              bgColor: ThemeProvider.transparentColor,
                              foreColor: Theme.of(context).canvasColor,
                              borderColor: Theme.of(context).canvasColor,
                              height: 50,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  state.appleSignInEnabled ? kAppSpacerVertical(height: 10) : const SizedBox(),
                  state.googleSignInEnabled
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton.icon(
                            icon: state.googleSocialLoginClicked ? Icon(Icons.refresh) : Image.asset(AssetsUrl.imageURL.googleSocialLogin, width: 15, height: 15),
                            label: Text(state.googleSocialLoginClicked ? translate.please_wait_progress : translate.google_sign_in, style: kAppLblMediumFontSemiBold(context)),
                            onPressed: () => context.read<EmailOtpLoginBloc>().add(LoginWithGoogleAccountEvent()),
                            style: kAppElevatedButtonOutlineStyle(
                              context,
                              disabledColor: Theme.of(context).disabledColor,
                              bgColor: ThemeProvider.transparentColor,
                              foreColor: Theme.of(context).canvasColor,
                              borderColor: Theme.of(context).canvasColor,
                              height: 50,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  state.googleSignInEnabled ? kAppSpacerVertical(height: 10) : const SizedBox(),
                  state.facebookSignInEnabled
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton.icon(
                            icon: state.facebookSocialLoginClicked ? Icon(Icons.refresh) : Image.asset(AssetsUrl.imageURL.facebookSocialLogin, width: 15, height: 15),
                            label: Text(state.facebookSocialLoginClicked ? translate.please_wait_progress : translate.facebook_sign_in, style: kAppLblMediumFontSemiBold(context)),
                            onPressed: () => context.read<EmailOtpLoginBloc>().add(LoginWithFacebookAccountEvent()),
                            style: kAppElevatedButtonOutlineStyle(
                              context,
                              disabledColor: Theme.of(context).disabledColor,
                              bgColor: ThemeProvider.transparentColor,
                              foreColor: Theme.of(context).canvasColor,
                              borderColor: Theme.of(context).canvasColor,
                              height: 50,
                            ),
                          ),
                        )
                      : const SizedBox(),
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
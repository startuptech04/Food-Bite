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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';
import 'package:vendor/app/presentation/pages/auth/login_options/email_password/bloc/login_with_email_password_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';

import 'package:vendor/app/router/app_route_config.dart';

class LoginWithEmailPasswordScreen extends StatelessWidget {
  const LoginWithEmailPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => LoginWithEmailPasswordBloc()..add(LoginWithEmailPasswordInitialEvent()), child: LoginWithEmailPasswordView());
  }
}

class LoginWithEmailPasswordView extends StatefulWidget {
  const LoginWithEmailPasswordView({super.key});

  @override
  State<LoginWithEmailPasswordView> createState() => _LoginWithEmailPasswordViewState();
}

class _LoginWithEmailPasswordViewState extends State<LoginWithEmailPasswordView> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<LoginWithEmailPasswordBloc>().add(LoginEmailUnfocusedEvent());
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<LoginWithEmailPasswordBloc>().add(LoginPasswordUnfocusedEvent());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isValid = context.select((LoginWithEmailPasswordBloc bloc) => bloc.state.isValid);
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<LoginWithEmailPasswordBloc, LoginWithEmailPasswordState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode, fromAuth: true);
        } else if (state.status.isSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.bottomTabRoute, (Route<dynamic> route) => false, arguments: [2]);
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
                  Text('${translate.login_welcome_title} ${Environments.appName}', textAlign: TextAlign.center, style: kAppLblLargeFontBold(context)),
                  kAppSpacerVertical(height: 10),
                  Text(translate.login_with_email_password_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
                  kAppSpacerVertical(height: 40),
                  TextFormField(
                    initialValue: state.email.value,
                    focusNode: _emailFocusNode,
                    decoration: kAppInputDecoration(context, prefixIcon: const Icon(Icons.email_outlined), lblText: translate.email_lbl, errText: state.email.displayError != null ? translate.form_required : null),
                    style: kAppLblSmallFontMedium(context),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => context.read<LoginWithEmailPasswordBloc>().add(LoginEmailChangedEvent(email: value)),
                    textInputAction: TextInputAction.next,
                  ),
                  kAppSpacerVertical(height: 20),
                  TextFormField(
                    initialValue: state.password.value,
                    focusNode: _passwordFocusNode,
                    decoration: kAppInputDecoration(
                      context,
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      lblText: translate.password_lbl,
                      errText: state.password.displayError != null ? translate.form_required : null,
                      suffixIcon: Icon(_passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      haveSuffixIcon: true,
                      onPressed: () => setState(() {
                        _passwordVisible = !_passwordVisible;
                      }),
                    ),
                    style: kAppLblSmallFontMedium(context),
                    obscureText: !_passwordVisible,
                    keyboardType: TextInputType.text,
                    onChanged: (value) => context.read<LoginWithEmailPasswordBloc>().add(LoginPasswordChangedEvent(password: value)),
                    textInputAction: TextInputAction.done,
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
                          title: Text(translate.remember_me_lbl, style: kAppLblMediumFontRegular(context)),
                          value: state.remember.value,
                          onChanged: (value) => context.read<LoginWithEmailPasswordBloc>().add(LoginRememberChangedEvent(checked: value!)),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pushNamed(AppRouter.resetPasswordRoute),
                        child: Text(translate.forgot_password_lbl, style: kAppLblMediumFontRegular(context)),
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isValid ? () => context.read<LoginWithEmailPasswordBloc>().add(LoginFormSubmitEvent()) : null,
                      style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                      child: state.status.isInProgress ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.signin),
                    ),
                  ),
                  state.selfRegistration
                      ? Column(
                          children: [
                            kAppSpacerVertical(height: 20),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  text: translate.join_lbl_first,
                                  style: kAppLblMediumFontRegular(context),
                                  children: <TextSpan>[
                                    const TextSpan(text: ' '),
                                    TextSpan(
                                      text: translate.join_lbl_second,
                                      style: kAppLblMediumFontBold(context, color: 'primary'),
                                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).pushNamed(AppRouter.registerRoute),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  kAppSpacerVertical(height: 20),
                  state.appleSignInEnabled || state.googleSignInEnabled || state.facebookSignInEnabled
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text(translate.social_sign_in, textAlign: TextAlign.center, style: kAppLblMediumFontSemiBold(context))],
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
                            onPressed: () => context.read<LoginWithEmailPasswordBloc>().add(LoginWithGoogleAccountEvent()),
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
                            onPressed: () => context.read<LoginWithEmailPasswordBloc>().add(LoginWithFacebookAccountEvent()),
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
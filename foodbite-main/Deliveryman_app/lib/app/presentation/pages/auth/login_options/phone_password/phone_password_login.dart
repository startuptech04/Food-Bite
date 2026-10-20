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

import 'package:driver/app/core/config/assets_url.dart';
import 'package:driver/app/core/models/country_code_modal_response_model.dart';
import 'package:driver/app/env.dart';
import 'package:driver/app/presentation/pages/auth/login_options/phone_password/bloc/login_with_phone_password_bloc.dart';
import 'package:driver/app/presentation/pages/modals/country_modal/country_modal_view.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/app/router/app_route_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWithPhonePasswordScreen extends StatelessWidget {
  const LoginWithPhonePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => LoginWithPhonePasswordBloc()..add(LoginWithPhonePasswordInitialEvent()), child: LoginWithPhonePasswordView());
  }
}

class LoginWithPhonePasswordView extends StatefulWidget {
  const LoginWithPhonePasswordView({super.key});

  @override
  State<LoginWithPhonePasswordView> createState() => _LoginWithPhonePasswordViewState();
}

class _LoginWithPhonePasswordViewState extends State<LoginWithPhonePasswordView> {
  final TextEditingController _countryCodeController = TextEditingController();
  final _countryCodeFocusNode = FocusNode();
  final _mobileNumberFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<LoginWithPhonePasswordBloc>().add(LoginWithTypeTwoPasswordUnfocusedEvent());
      }
    });

    _countryCodeFocusNode.addListener(() {
      if (!_countryCodeFocusNode.hasFocus) {
        context.read<LoginWithPhonePasswordBloc>().add(LoginWithTypeTwoCountryCodeUnfocusedEvent());
      }
    });

    _mobileNumberFocusNode.addListener(() {
      if (!_mobileNumberFocusNode.hasFocus) {
        context.read<LoginWithPhonePasswordBloc>().add(LoginWithTypeTwoMobileNumberUnfocusedEvent());
      }
    });
  }

  @override
  void dispose() {
    _countryCodeFocusNode.dispose();
    _mobileNumberFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isValid = context.select((LoginWithPhonePasswordBloc bloc) => bloc.state.isValid);
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<LoginWithPhonePasswordBloc, LoginWithPhonePasswordState>(
      listener: (context, state) {
        if (state.status.isLoaded) {
          _countryCodeController.text = '${state.flag} (${state.countryCode.value})';
        } else if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode, fromAuth: true);
        } else if (state.status.isSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.bottomTabRoute, (Route<dynamic> route) => false, arguments: [0]);
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
                  Text("${translate.login_welcome_title} ${Environments.appName}", textAlign: TextAlign.center, style: kAppLblLargeFontBold(context)),
                  kAppSpacerVertical(height: 10),
                  Text(translate.phone_password_login_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
                  kAppSpacerVertical(height: 40),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _countryCodeController,
                          focusNode: _countryCodeFocusNode,
                          readOnly: true,
                          decoration: kAppInputDecoration(context, lblText: translate.form_country_code, errText: state.countryCode.displayError != null ? translate.form_required : null),
                          style: kAppLblSmallFontMedium(context),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return CountryCodeModalScreen(code: state.countryCode.value);
                                    },
                                    fullscreenDialog: true,
                                  ),
                                )
                                .then((value) {
                                  if (!context.mounted) return;
                                  CountryCodeModalResponseModel countryCodeResponse = CountryCodeModalResponseModel.fromJson(value);
                                  if (countryCodeResponse.action!) {
                                    _countryCodeController.text = '${countryCodeResponse.flag} (${countryCodeResponse.dialCode})';
                                    context.read<LoginWithPhonePasswordBloc>().add(LoginWithTypeTwoCountryCodeChangedEvent(countryCode: countryCodeResponse.dialCode!));
                                  }
                                });
                          },
                        ),
                      ),
                      kAppSpacerHorizontal(width: 10),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          focusNode: _mobileNumberFocusNode,
                          decoration: kAppInputDecoration(context, prefixIcon: const Icon(Icons.person_outline), lblText: translate.form_mobile, errText: state.mobileNumber.displayError != null ? translate.form_required : null),
                          style: kAppLblSmallFontMedium(context),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                          onChanged: (value) => context.read<LoginWithPhonePasswordBloc>().add(LoginWithTypeTwoMobileNumberChangedEvent(mobileNumber: value)),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  TextFormField(
                    focusNode: _passwordFocusNode,
                    decoration: kAppInputDecoration(
                      context,
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      lblText: translate.form_password,
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
                    onChanged: (value) => context.read<LoginWithPhonePasswordBloc>().add(LoginWithTypeTwoPasswordChangedEvent(password: value)),
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
                          title: Text(translate.remember_me, style: kAppLblMediumFontRegular(context)),
                          value: state.remember.value,
                          onChanged: (value) => context.read<LoginWithPhonePasswordBloc>().add(LoginWithTypeTwoRememberChangedEvent(checked: value!)),
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
                      onPressed: isValid ? () => context.read<LoginWithPhonePasswordBloc>().add(LoginWithTypeTwoFormSubmittedEvent()) : null,
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
                                      text: translate.register_as_deliveryman,
                                      style: kAppLblMediumFontBold(context, color: 'primary'),
                                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).pushNamed(AppRouter.registerRequestRoute),
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
                          children: [Text(translate.social_sign_in_lbl, textAlign: TextAlign.center, style: kAppLblMediumFontSemiBold(context))],
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
                            onPressed: () => context.read<LoginWithPhonePasswordBloc>().add(LoginWithTypeTwoGoogleAccountEvent()),
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
                            onPressed: () => context.read<LoginWithPhonePasswordBloc>().add(LoginWithTypeTwoFacebookAccountEvent()),
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
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

part of 'login_bloc.dart';

final class LoginState {
  final String deliverymanLoginWith;
  final String locale;
  const LoginState({this.deliverymanLoginWith = 'email_password', this.locale = ''});

  LoginState copyWith({String? deliverymanLoginWith, String? locale}) {
    return LoginState(deliverymanLoginWith: deliverymanLoginWith ?? this.deliverymanLoginWith, locale: locale ?? this.locale);
  }
}

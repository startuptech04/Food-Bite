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
  final String restaurantLoginWith;
  final String locale;
  const LoginState({this.locale = '', this.restaurantLoginWith = 'email_password'});

  LoginState copyWith({String? locale, String? restaurantLoginWith}) {
    return LoginState(locale: locale ?? this.locale, restaurantLoginWith: restaurantLoginWith ?? this.restaurantLoginWith);
  }
}

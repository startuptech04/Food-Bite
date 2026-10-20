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

part of 'pos_menu_modal_bloc.dart';

enum PosMenuModalStatus { initial, success, failure }

extension PosMenuModalStatusX on PosMenuModalStatus {
  bool get isInitial => this == PosMenuModalStatus.initial;
  bool get isSuccess => this == PosMenuModalStatus.success;
  bool get isFailure => this == PosMenuModalStatus.failure;
}

final class PosMenuModalState {
  final String currentInView;
  final PosMenuModalStatus status;
  final bool isDarkTheme;
  final String alertMessage;
  final String extraMessage;
  const PosMenuModalState({this.currentInView = '', this.status = PosMenuModalStatus.initial, this.isDarkTheme = false, this.alertMessage = '', this.extraMessage = ''});

  PosMenuModalState copyWith({String? currentInView, PosMenuModalStatus? status, bool? isDarkTheme, String? alertMessage, String? extraMessage}) {
    return PosMenuModalState(
      currentInView: currentInView ?? this.currentInView,
      status: status ?? this.status,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}

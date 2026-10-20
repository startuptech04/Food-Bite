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

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:share_plus/share_plus.dart';
import 'package:user/app/core/config/api_request_service.dart';
import 'package:user/app/core/models/referral_code_response_model.dart';
import 'package:user/app/core/models/server_error_model.dart';
import 'package:user/app/core/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'referral_code_event.dart';
part 'referral_code_state.dart';

class ReferralCodeBloc extends Bloc<ReferralCodeEvent, ReferralCodeState> {
  final AuthRepository _authRepository = AuthRepository();
  ReferralCodeBloc() : super(ReferralCodeState(model: ReferralCodeResponseModel())) {
    on<ReferralCodeInitialEvent>(_onReferralCodeInitialEvent);
    on<ReferralCodeReferNowEvent>(_onReferralCodeReferNowEvent);
  }

  FutureOr<void> _onReferralCodeInitialEvent(ReferralCodeInitialEvent event, Emitter<ReferralCodeState> emit) async {
    bool isAuthorized = await _authRepository.isAuthorized();
    await _authRepository.saveEvent('visited_screen', {"screen": "referral_code"}, 'referral_code_screen', 'referral_code_screen');
    if (isAuthorized) {
      try {
        emit(state.copyWith(status: ReferralCodeStatus.loading));
        final String userId = await _authRepository.userId();
        DioApiResponse response = await _authRepository.getReferralCode(userId);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ReferralCodeResponseModel data = ReferralCodeResponseModel.fromJson(myMap);
          String title = data.detail!.referralTitle!;
          String subTitle = data.detail!.referralMessage!;
          String code = data.referralCode!.code!;
          title = title.replaceAll('##CODE##', code);
          subTitle = subTitle.replaceAll('##CODE##', code);
          emit(state.copyWith(status: ReferralCodeStatus.success, referralCode: code, title: title, subTitle: subTitle, model: data));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ReferralCodeStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ReferralCodeStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    } else {
      emit(state.copyWith(status: ReferralCodeStatus.unAuthorized));
    }
  }

  FutureOr<void> _onReferralCodeReferNowEvent(ReferralCodeReferNowEvent event, Emitter<ReferralCodeState> emit) async {
    final String websiteURL = await _authRepository.websiteURL();
    final String webURL = '$websiteURL?source=app_sharing';
    final String shareText = "${state.title} - ${state.subTitle} $webURL";
    await SharePlus.instance.share(ShareParams(text: shareText));
  }
}

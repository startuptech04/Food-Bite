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
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:vendor/app/env.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'order_help_modal_event.dart';
part 'order_help_modal_state.dart';

class OrderHelpModalBloc extends Bloc<OrderHelpModalEvent, OrderHelpModalState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  OrderHelpModalBloc() : super(OrderHelpModalState()) {
    on<OrderHelpModalInitialEvent>(_onOrderHelpModalInitialEvent);
    on<OrderHelpModalOrderSummaryEvent>(_onOrderHelpModalOrderSummaryEvent);
    on<OrderHelpModalOrderInvoiceEvent>(_onOrderHelpModalOrderInvoiceEvent);
  }

  FutureOr<void> _onOrderHelpModalInitialEvent(OrderHelpModalInitialEvent event, Emitter<OrderHelpModalState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "order_help"}, 'order_help_screen', 'order_help_screen');
    emit(state.copyWith(orderId: event.orderId, orderNumber: event.orderNo, status: OrderHelpModalStatus.initial));
  }

  FutureOr<void> _onOrderHelpModalOrderSummaryEvent(OrderHelpModalOrderSummaryEvent event, Emitter<OrderHelpModalState> emit) async {
    if (!kIsWeb) {
      try {
        emit(state.copyWith(status: OrderHelpModalStatus.orderSummaryDownloadStarted));
        final String defaultLocale = await _orderRepository.getLocale();
        Directory? downloadsDir;
        if (Platform.isAndroid || Platform.isIOS) {
          downloadsDir = await getApplicationDocumentsDirectory();
        }

        if (downloadsDir != null) {
          final String savePath = "${downloadsDir.path}/${Environments.appName}_Order_ID_${state.orderNumber}.pdf";
          final String locale = defaultLocale.isNotEmpty ? defaultLocale : Environments.defaultLanguage;
          bool response = await _orderRepository.orderSummary(state.orderId, locale, savePath);
          if (response) {
            final params = ShareParams(title: 'Download Order Summary', files: [XFile(savePath)]);
            await SharePlus.instance.share(params);
            emit(state.copyWith(status: OrderHelpModalStatus.orderSummaryDownloadSuccess, downloadPath: savePath));
          } else {
            emit(state.copyWith(status: OrderHelpModalStatus.orderSummaryDownloadFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          }
        } else {
          emit(state.copyWith(status: OrderHelpModalStatus.orderSummaryDownloadFailed, statusCode: 0, alertMessage: 'Unable to get downloads directory', extraMessage: ''));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: OrderHelpModalStatus.orderSummaryDownloadFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    } else {
      emit(state.copyWith(status: OrderHelpModalStatus.customError, statusCode: 0, alertMessage: 'File cannot be downloaded from the browser. Please use a mobile device to download.', extraMessage: ''));
    }
  }

  FutureOr<void> _onOrderHelpModalOrderInvoiceEvent(OrderHelpModalOrderInvoiceEvent event, Emitter<OrderHelpModalState> emit) async {
    if (!kIsWeb) {
      try {
        emit(state.copyWith(status: OrderHelpModalStatus.orderInvoiceDownloadStarted));
        final String defaultLocale = await _orderRepository.getLocale();
        Directory? downloadsDir;
        if (Platform.isAndroid || Platform.isIOS) {
          downloadsDir = await getApplicationDocumentsDirectory();
        }

        if (downloadsDir != null) {
          final String savePath = "${downloadsDir.path}/${Environments.appName}_Invoice_${state.orderNumber}.pdf";
          final String locale = defaultLocale.isNotEmpty ? defaultLocale : Environments.defaultLanguage;
          bool response = await _orderRepository.orderInvoice(state.orderId, locale, savePath);
          if (response) {
            final params = ShareParams(title: 'Download Order Invoice', files: [XFile(savePath)]);
            await SharePlus.instance.share(params);
            emit(state.copyWith(status: OrderHelpModalStatus.orderInvoiceDownloadSuccess, downloadPath: savePath));
          } else {
            emit(state.copyWith(status: OrderHelpModalStatus.orderInvoiceDownloadFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          }
        } else {
          emit(state.copyWith(status: OrderHelpModalStatus.orderInvoiceDownloadFailed, statusCode: 0, alertMessage: 'Unable to get downloads directory', extraMessage: ''));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: OrderHelpModalStatus.orderInvoiceDownloadFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    } else {
      emit(state.copyWith(status: OrderHelpModalStatus.customError, statusCode: 0, alertMessage: 'File cannot be downloaded from the browser. Please use a mobile device to download.', extraMessage: ''));
    }
  }
}

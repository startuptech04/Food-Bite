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
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/expense_initial_response_model.dart';
import 'package:vendor/app/core/models/expense_list_model.dart';
import 'package:vendor/app/core/models/expense_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'expense_report_event.dart';
part 'expense_report_state.dart';

class ExpenseReportBloc extends Bloc<ExpenseReportEvent, ExpenseReportState> {
  final AccountRepository _accountRepository = AccountRepository();
  ExpenseReportBloc()
    : super(
        ExpenseReportState(
          pageSize: ApiRequestService.pageSize,
          initial: ExpenseInitialResponeModel(results: [], locale: ''),
          filterType: ExpenseFilterModel(name: 'expense_all', value: 'all'),
        ),
      ) {
    on<ExpenseReportInitialEvent>(_onExpenseReportInitialEvent);
    on<ExpenseReportLoadMoreEvent>(_onExpenseReportLoadMoreEvent);
    on<ExpenseReportTypeChangeEvent>(_onExpenseReportTypeChangeEvent);
  }

  FutureOr<void> _onExpenseReportInitialEvent(ExpenseReportInitialEvent event, Emitter<ExpenseReportState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "expense_report"}, 'expense_report_screen', 'expense_report_screen');
      emit(state.copyWith(status: ExpenseReportStatus.loading));
      final String vendorId = await _accountRepository.getVendorId();
      DioApiResponse response = await _accountRepository.getInitialExpenseReport(state.pageSize, state.currentPage, vendorId, 'all');
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ExpenseInitialResponeModel initial = ExpenseInitialResponeModel.fromJson(myMap, locale.toString());
        List<ExpenseModel> expenseList = <ExpenseModel>[];
        expenseList.clear();
        for (var element in initial.results!) {
          expenseList.add(element);
        }
        List<PieChartModel> chartStats = <PieChartModel>[];
        PieChartModel orderProductDiscount = PieChartModel(name: 'expense_order_product', amount: initial.orderProductDiscountExpenseData!.amount!);
        PieChartModel posProductDiscount = PieChartModel(name: 'expense_pos_product_discount', amount: initial.posOrderProductDiscountExpenseData!.amount!);
        PieChartModel tableProductDiscount = PieChartModel(name: 'expense_table_product_discount', amount: initial.tableOrderProductDiscountExpenseData!.amount!);
        PieChartModel posExtraDiscount = PieChartModel(name: 'expense_pos_extra_discount', amount: initial.posOrderExtraDiscountExpenseData!.amount!);
        PieChartModel tableExtraDiscount = PieChartModel(name: 'expense_table_extra_discount', amount: initial.tableOrderExtraDiscountExpenseData!.amount!);
        PieChartModel couponExpense = PieChartModel(name: 'expense_order_coupon', amount: initial.couponExpenseData!.amount!);
        PieChartModel diningCouponExpense = PieChartModel(name: 'expense_dining_coupon', amount: initial.diningCouponExpenseData!.amount!);
        PieChartModel diningBookingDiscount = PieChartModel(name: 'expense_dining_booking', amount: initial.diningBookingDiscountExpenseData!.amount!);
        PieChartModel orderRefund = PieChartModel(name: 'expense_order_refund', amount: initial.refundOrderExpenseData!.amount!);
        PieChartModel otherExpense = PieChartModel(name: 'expense_others', amount: initial.otherExpenseData!.amount!);

        chartStats.clear();

        chartStats.add(orderProductDiscount);
        chartStats.add(posProductDiscount);
        chartStats.add(tableProductDiscount);
        chartStats.add(posExtraDiscount);
        chartStats.add(tableExtraDiscount);
        chartStats.add(couponExpense);
        chartStats.add(diningCouponExpense);
        chartStats.add(diningBookingDiscount);
        chartStats.add(orderRefund);
        chartStats.add(otherExpense);

        List<GridExpenseModel> gridExpense = <GridExpenseModel>[];
        gridExpense.clear();

        GridExpenseModel totalExpenseGrid = GridExpenseModel(name: 'expense_total', amount: initial.totalExpenseData!.amount!, count: initial.totalExpenseData!.count!);
        GridExpenseModel orderProductDiscountGrid = GridExpenseModel(name: 'expense_order_product', amount: initial.orderProductDiscountExpenseData!.amount!, count: initial.orderProductDiscountExpenseData!.count!);
        GridExpenseModel posProductDiscountGrid = GridExpenseModel(
          name: 'expense_pos_order_product_discount',
          amount: initial.posOrderProductDiscountExpenseData!.amount!,
          count: initial.posOrderProductDiscountExpenseData!.count!,
        );
        GridExpenseModel tableProductDiscountGrid = GridExpenseModel(name: 'expense_table_order_product', amount: initial.tableOrderProductDiscountExpenseData!.amount!, count: initial.tableOrderProductDiscountExpenseData!.count!);
        GridExpenseModel posExtraDiscountGrid = GridExpenseModel(name: 'expense_pos_order_extra', amount: initial.posOrderExtraDiscountExpenseData!.amount!, count: initial.posOrderExtraDiscountExpenseData!.count!);
        GridExpenseModel tableExtraDiscountGrid = GridExpenseModel(name: 'expense_table_order_extra', amount: initial.tableOrderExtraDiscountExpenseData!.amount!, count: initial.tableOrderExtraDiscountExpenseData!.count!);
        GridExpenseModel couponExpenseGrid = GridExpenseModel(name: 'expense_order_coupon', amount: initial.couponExpenseData!.amount!, count: initial.couponExpenseData!.count!);
        GridExpenseModel diningCouponExpenseGrid = GridExpenseModel(name: 'expense_dining_coupon', amount: initial.diningCouponExpenseData!.amount!, count: initial.diningCouponExpenseData!.count!);
        GridExpenseModel diningBookingDiscountGrid = GridExpenseModel(name: 'expense_dining_booking', amount: initial.diningBookingDiscountExpenseData!.amount!, count: initial.diningBookingDiscountExpenseData!.count!);
        GridExpenseModel orderRefundGrid = GridExpenseModel(name: 'expense_order_refund_expense', amount: initial.refundOrderExpenseData!.amount!, count: initial.refundOrderExpenseData!.count!);
        GridExpenseModel otherExpenseGrid = GridExpenseModel(name: 'expense_others', amount: initial.otherExpenseData!.amount!, count: initial.otherExpenseData!.count!);

        gridExpense.add(totalExpenseGrid);
        gridExpense.add(orderProductDiscountGrid);
        gridExpense.add(posProductDiscountGrid);
        gridExpense.add(tableProductDiscountGrid);
        gridExpense.add(posExtraDiscountGrid);
        gridExpense.add(tableExtraDiscountGrid);
        gridExpense.add(couponExpenseGrid);
        gridExpense.add(diningCouponExpenseGrid);
        gridExpense.add(diningBookingDiscountGrid);
        gridExpense.add(orderRefundGrid);
        gridExpense.add(otherExpenseGrid);

        List<ExpenseFilterModel> filterList = <ExpenseFilterModel>[];
        filterList.clear();
        ExpenseFilterModel allFilter = ExpenseFilterModel(name: 'expense_all', value: 'all');
        ExpenseFilterModel orderProductDiscountFilter = ExpenseFilterModel(name: 'expense_order_product', value: 'order_product_discout');
        ExpenseFilterModel posOrderProductDiscountFilter = ExpenseFilterModel(name: 'expense_pos_product_discount', value: 'pos_order_product_discount');
        ExpenseFilterModel tableOrderProductDiscountFilter = ExpenseFilterModel(name: 'expense_table_product_discount', value: 'table_order_product_discount');
        ExpenseFilterModel posOrderExtraDiscountFilter = ExpenseFilterModel(name: 'expense_pos_extra_discount', value: 'pos_order_extra_discount');
        ExpenseFilterModel tableOrderExtraDiscountFilter = ExpenseFilterModel(name: 'expense_table_extra_discount', value: 'table_order_extra_discount');
        ExpenseFilterModel couponFilter = ExpenseFilterModel(name: 'expense_order_coupon', value: 'coupon');
        ExpenseFilterModel diningCouponFilter = ExpenseFilterModel(name: 'expense_dining_coupon', value: 'dining_coupon');
        ExpenseFilterModel diningBookingFilter = ExpenseFilterModel(name: 'expense_dining_booking', value: 'dining_booking_discount');
        ExpenseFilterModel refundOrderFilter = ExpenseFilterModel(name: 'expense_order_refund_expense', value: 'refund_order');
        ExpenseFilterModel otherFiler = ExpenseFilterModel(name: 'others', value: 'other');

        filterList.add(allFilter);
        filterList.add(orderProductDiscountFilter);
        filterList.add(posOrderProductDiscountFilter);
        filterList.add(tableOrderProductDiscountFilter);
        filterList.add(posOrderExtraDiscountFilter);
        filterList.add(tableOrderExtraDiscountFilter);
        filterList.add(couponFilter);
        filterList.add(diningCouponFilter);
        filterList.add(diningBookingFilter);
        filterList.add(refundOrderFilter);
        filterList.add(otherFiler);

        emit(
          state.copyWith(
            initial: initial,
            expenseList: expenseList,
            gridExpense: gridExpense,
            filterType: allFilter,
            filterList: filterList,
            totalResults: initial.totalResults!,
            chartStats: chartStats,
            isFilterApplied: true,
            status: initial.results!.isEmpty ? ExpenseReportStatus.empty : ExpenseReportStatus.success,
          ),
        );
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: ExpenseReportStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: ExpenseReportStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onExpenseReportLoadMoreEvent(ExpenseReportLoadMoreEvent event, Emitter<ExpenseReportState> emit) async {
    if (state.expenseList.length < state.totalResults) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _accountRepository.getVendorId();
        DioApiResponse response = await _accountRepository.getExpenseList(state.pageSize * 2, state.currentPage, vendorId, 'all');
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ExpenseListModel loadMore = ExpenseListModel.fromJson(myMap, locale.toString());
          List<ExpenseModel> expenseList = <ExpenseModel>[];
          expenseList.clear();
          for (var element in loadMore.results!) {
            expenseList.add(element);
          }
          emit(state.copyWith(expenseList: expenseList, status: expenseList.isEmpty ? ExpenseReportStatus.empty : ExpenseReportStatus.success, loadMore: false, totalResults: loadMore.totalResults!, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ExpenseReportStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), loadMore: false, extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ExpenseReportStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onExpenseReportTypeChangeEvent(ExpenseReportTypeChangeEvent event, Emitter<ExpenseReportState> emit) async {
    try {
      ExpenseFilterModel filterType = ExpenseFilterModel();
      filterType = state.filterList.firstWhere((element) => element.value == event.type);
      emit(state.copyWith(filterType: filterType, isFilterApplied: false, pageSize: ApiRequestService.pageSize));
      final String vendorId = await _accountRepository.getVendorId();
      DioApiResponse response = await _accountRepository.getExpenseList(state.pageSize, state.currentPage, vendorId, event.type);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ExpenseListModel loadMore = ExpenseListModel.fromJson(myMap, locale.toString());
        List<ExpenseModel> expenseList = <ExpenseModel>[];
        expenseList.clear();
        for (var element in loadMore.results!) {
          expenseList.add(element);
        }
        emit(state.copyWith(expenseList: expenseList, totalResults: loadMore.totalResults!, status: expenseList.isEmpty ? ExpenseReportStatus.empty : ExpenseReportStatus.success, isFilterApplied: true));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: ExpenseReportStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), isFilterApplied: true, extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: ExpenseReportStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', isFilterApplied: true));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}

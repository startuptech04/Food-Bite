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

part of 'expense_report_bloc.dart';

sealed class ExpenseReportEvent {}

final class ExpenseReportInitialEvent extends ExpenseReportEvent {}

final class ExpenseReportLoadMoreEvent extends ExpenseReportEvent {}

final class ExpenseReportTypeChangeEvent extends ExpenseReportEvent {
  final String type;
  ExpenseReportTypeChangeEvent({required this.type});
}

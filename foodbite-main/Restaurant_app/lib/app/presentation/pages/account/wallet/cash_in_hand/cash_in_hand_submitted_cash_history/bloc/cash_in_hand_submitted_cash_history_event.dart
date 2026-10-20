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

part of 'cash_in_hand_submitted_cash_history_bloc.dart';

sealed class CashInHandSubmittedCashHistoryEvent {}

final class CashInHandSubmittedCashHistoryInitialEvent extends CashInHandSubmittedCashHistoryEvent {}

final class CashInHandSubmittedCashHistoryScrollMoreEvent extends CashInHandSubmittedCashHistoryEvent {}

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

part of 'pos_and_table_order_commission_bloc.dart';

sealed class PosAndTableOrderCommissionEvent {}

final class PosAndTableOrderCommissionInitialEvent extends PosAndTableOrderCommissionEvent {}

final class PosAndTableOrderCommissionLoadMoreEvent extends PosAndTableOrderCommissionEvent {}

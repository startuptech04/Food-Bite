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

part of 'food_subscription_transaction_list_bloc.dart';

sealed class FoodSubscriptionTransactionListEvent {}

final class FoodSubscriptionTransactionListInitialEvent extends FoodSubscriptionTransactionListEvent {}

final class FoodSubscriptionLoadMoreSubscriptionTransactionEvent extends FoodSubscriptionTransactionListEvent {}

final class FoodSubscriptionPullRefreshEvent extends FoodSubscriptionTransactionListEvent {}

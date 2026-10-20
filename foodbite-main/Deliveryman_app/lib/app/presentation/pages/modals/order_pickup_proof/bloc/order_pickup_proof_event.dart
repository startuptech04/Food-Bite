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

part of 'order_pickup_proof_bloc.dart';

sealed class OrderPickupProofEvent {}

final class OrderPickupProofInitialEvent extends OrderPickupProofEvent {
  final String orderId;
  OrderPickupProofInitialEvent({required this.orderId});
}

final class OrderPickupProofUploadImageEvent extends OrderPickupProofEvent {
  final XFile newImage;
  OrderPickupProofUploadImageEvent({required this.newImage});
}

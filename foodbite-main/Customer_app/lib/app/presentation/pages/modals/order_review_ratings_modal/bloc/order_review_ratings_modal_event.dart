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

part of 'order_review_ratings_modal_bloc.dart';

sealed class OrderReviewRatingsModalEvent {}

final class OrderReviewRatingsModalInitialEvent extends OrderReviewRatingsModalEvent {
  final String orderId;
  OrderReviewRatingsModalInitialEvent({required this.orderId});
}

final class OrderReviewRatingIconPressEvent extends OrderReviewRatingsModalEvent {
  final String to;
  final String id;
  final int rate;
  OrderReviewRatingIconPressEvent({required this.to, required this.id, required this.rate});
}

final class OrderReviewRatingDriverMessageSelectEvent extends OrderReviewRatingsModalEvent {
  final String id;
  OrderReviewRatingDriverMessageSelectEvent({required this.id});
}

final class OrderReviewRatingRestaurantMessageSelectEvent extends OrderReviewRatingsModalEvent {
  final String id;
  OrderReviewRatingRestaurantMessageSelectEvent({required this.id});
}

final class OrderReviewRatingProductMessageSelectEvent extends OrderReviewRatingsModalEvent {
  final String productId;
  final String msgId;
  OrderReviewRatingProductMessageSelectEvent({required this.productId, required this.msgId});
}

final class OrderReviewRatingUploadImageEvent extends OrderReviewRatingsModalEvent {
  final XFile newImage;
  OrderReviewRatingUploadImageEvent({required this.newImage});
}

final class OrderReviewRatingRemoveUploadImageEvent extends OrderReviewRatingsModalEvent {
  final int index;
  OrderReviewRatingRemoveUploadImageEvent({required this.index});
}

final class OrderReviewShortReviewTextChangeEvent extends OrderReviewRatingsModalEvent {
  final String txt;
  OrderReviewShortReviewTextChangeEvent({required this.txt});
}

final class OrderReviewRatingSubmitEvent extends OrderReviewRatingsModalEvent {}

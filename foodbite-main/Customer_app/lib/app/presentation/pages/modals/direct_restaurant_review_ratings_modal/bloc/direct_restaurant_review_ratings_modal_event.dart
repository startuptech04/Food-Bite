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

part of 'direct_restaurant_review_ratings_modal_bloc.dart';

sealed class DirectRestaurantReviewRatingsModalEvent {}

final class DirectRestaurantReviewRatingsModalInitialEvent extends DirectRestaurantReviewRatingsModalEvent {
  final String restaurant;
  DirectRestaurantReviewRatingsModalInitialEvent({required this.restaurant});
}

final class DirectRestaurantReviewRatingsModalSubmitEvent extends DirectRestaurantReviewRatingsModalEvent {}

final class DirectRestaurantReviewRatingsModalShortReviewTextChangeEvent extends DirectRestaurantReviewRatingsModalEvent {
  final String txt;
  DirectRestaurantReviewRatingsModalShortReviewTextChangeEvent({required this.txt});
}

final class DirectRestaurantReviewRatingsModalRemoveUploadImageEvent extends DirectRestaurantReviewRatingsModalEvent {
  final int index;
  DirectRestaurantReviewRatingsModalRemoveUploadImageEvent({required this.index});
}

final class DirectRestaurantReviewRatingsModalUploadImageEvent extends DirectRestaurantReviewRatingsModalEvent {
  final XFile newImage;
  DirectRestaurantReviewRatingsModalUploadImageEvent({required this.newImage});
}

final class DirectRestaurantReviewRatingsModalIconPressEvent extends DirectRestaurantReviewRatingsModalEvent {
  final int rate;
  DirectRestaurantReviewRatingsModalIconPressEvent({required this.rate});
}

final class DirectRestaurantReviewRatingsModalRestaurantMessageSelectEvent extends DirectRestaurantReviewRatingsModalEvent {
  final String id;
  DirectRestaurantReviewRatingsModalRestaurantMessageSelectEvent({required this.id});
}

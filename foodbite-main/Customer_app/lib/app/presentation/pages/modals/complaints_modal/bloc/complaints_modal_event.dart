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

part of 'complaints_modal_bloc.dart';

sealed class ComplaintsModalEvent {}

final class ComplaintsModalInitialEvent extends ComplaintsModalEvent {
  final String orderId;
  ComplaintsModalInitialEvent({required this.orderId});
}

final class ComplaintModalIssueWithEvent extends ComplaintsModalEvent {
  final ComplaintIssueWithListModel issueWith;
  ComplaintModalIssueWithEvent({required this.issueWith});
}

final class ComplaintModalReasonSelectEvent extends ComplaintsModalEvent {
  final ComplaintReasonListModel reason;
  ComplaintModalReasonSelectEvent({required this.reason});
}

final class ComplaintModalFoodSelectEvent extends ComplaintsModalEvent {
  final FoodInCartModel food;
  ComplaintModalFoodSelectEvent({required this.food});
}

final class ComplaintModalTitleChangedEvent extends ComplaintsModalEvent {
  final String title;
  ComplaintModalTitleChangedEvent({required this.title});
}

final class ComplaintModalTitleUnfocusedEvent extends ComplaintsModalEvent {}

final class ComplaintModalBriefChangedEvent extends ComplaintsModalEvent {
  final String brief;
  ComplaintModalBriefChangedEvent({required this.brief});
}

final class ComplaintModalBriefUnfocusedEvent extends ComplaintsModalEvent {}

final class ComplaintModalImageProofEvent extends ComplaintsModalEvent {}

final class ComplaintModalUploadImageEvent extends ComplaintsModalEvent {
  final XFile newImage;
  ComplaintModalUploadImageEvent({required this.newImage});
}

final class ComplaintModalRemoveUploadImageEvent extends ComplaintsModalEvent {
  final int index;
  ComplaintModalRemoveUploadImageEvent({required this.index});
}

final class ComplaintModalSubmittedEvent extends ComplaintsModalEvent {}

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

part of 'order_complaints_modal_bloc.dart';

sealed class OrderComplaintsModalEvent {}

final class OrderComplaintsModalInitialEvent extends OrderComplaintsModalEvent {
  final String orderId;
  OrderComplaintsModalInitialEvent({required this.orderId});
}

final class OrderComplaintModalIssueWithEvent extends OrderComplaintsModalEvent {
  final ComplaintIssueWithListModel issueWith;
  OrderComplaintModalIssueWithEvent({required this.issueWith});
}

final class OrderComplaintModalReasonSelectEvent extends OrderComplaintsModalEvent {
  final OrderComplaintReasonConfigModel reason;
  OrderComplaintModalReasonSelectEvent({required this.reason});
}

final class OrderComplaintModalTitleChangedEvent extends OrderComplaintsModalEvent {
  final String title;
  OrderComplaintModalTitleChangedEvent({required this.title});
}

final class OrderComplaintModalTitleUnfocusedEvent extends OrderComplaintsModalEvent {}

final class OrderComplaintModalBriefChangedEvent extends OrderComplaintsModalEvent {
  final String brief;
  OrderComplaintModalBriefChangedEvent({required this.brief});
}

final class OrderComplaintModalBriefUnfocusedEvent extends OrderComplaintsModalEvent {}

final class OrderComplaintModalUploadImageEvent extends OrderComplaintsModalEvent {
  final XFile newImage;
  OrderComplaintModalUploadImageEvent({required this.newImage});
}

final class OrderComplaintModalRemoveUploadImageEvent extends OrderComplaintsModalEvent {
  final int index;
  OrderComplaintModalRemoveUploadImageEvent({required this.index});
}

final class OrderComplaintModalSubmitEvent extends OrderComplaintsModalEvent {}

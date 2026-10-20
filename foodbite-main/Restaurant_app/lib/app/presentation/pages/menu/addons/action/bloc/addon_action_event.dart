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

part of 'addon_action_bloc.dart';

sealed class AddonActionEvent {}

final class AddonActionInitialEvent extends AddonActionEvent {
  final bool isNew;
  final AddonResultModel model;
  AddonActionInitialEvent({required this.isNew, required this.model});
}

final class AddonActionNameChanged extends AddonActionEvent {
  final String name;
  AddonActionNameChanged({required this.name});
}

final class AddonActionNameUnfocused extends AddonActionEvent {}

final class AddonActionPriceChanged extends AddonActionEvent {
  final String price;
  AddonActionPriceChanged({required this.price});
}

final class AddonActionPriceUnfocused extends AddonActionEvent {}

final class AddonActionStockChangeEvent extends AddonActionEvent {
  final String type;
  AddonActionStockChangeEvent({required this.type});
}

final class AddonActionStockNumberChangedEvent extends AddonActionEvent {
  final String value;
  AddonActionStockNumberChangedEvent({required this.value});
}

final class AddonActionStockNumberUnfocused extends AddonActionEvent {}

final class AddonActionFormCreateSubmitted extends AddonActionEvent {
  final List<AddonsFormTranslations> translations;
  AddonActionFormCreateSubmitted({required this.translations});
}

final class AddonActionFormUpdateSubmitted extends AddonActionEvent {
  final String id;
  final AddonResultModel model;
  final List<AddonsFormTranslations> translations;
  AddonActionFormUpdateSubmitted({required this.id, required this.model, required this.translations});
}

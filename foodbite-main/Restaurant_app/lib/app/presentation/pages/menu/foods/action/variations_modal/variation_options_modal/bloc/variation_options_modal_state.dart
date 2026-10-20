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

part of 'variation_options_modal_bloc.dart';

enum VariationOptionsModalStatus { initial, success, failure, selected }

extension VariationOptionsModalStatusX on VariationOptionsModalStatus {
  bool get isInitial => this == VariationOptionsModalStatus.initial;
  bool get isSuccess => this == VariationOptionsModalStatus.success;
  bool get isFailure => this == VariationOptionsModalStatus.failure;
  bool get isSelected => this == VariationOptionsModalStatus.selected;
}

final class VariationOptionsModalState {
  final VariationOptionNameField name;
  final VariationOptionPriceField price;
  final VariationOptionStockField stock;
  final String stockType;
  final bool isValid;
  final VariationOptionsModalStatus status;
  const VariationOptionsModalState({
    this.name = const VariationOptionNameField.pure(),
    this.price = const VariationOptionPriceField.pure(),
    this.stock = const VariationOptionStockField.pure(),
    this.stockType = '',
    this.isValid = false,
    this.status = VariationOptionsModalStatus.initial,
  });

  VariationOptionsModalState copyWith({
    VariationOptionNameField? name,
    VariationOptionPriceField? price,
    VariationOptionStockField? stock,
    String? stockType,
    bool? isValid,
    VariationOptionsModalStatus? status,
    String? alertMessage,
  }) {
    return VariationOptionsModalState(
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      stockType: stockType ?? this.stockType,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
    );
  }
}

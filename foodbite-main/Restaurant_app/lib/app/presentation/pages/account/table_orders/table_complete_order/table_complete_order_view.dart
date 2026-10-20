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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/country_code_modal_response_model.dart';
import 'package:vendor/app/presentation/pages/account/table_orders/table_complete_order/bloc/table_complete_order_bloc.dart';
import 'package:vendor/app/presentation/pages/modals/country_modal/country_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/print_table_order_invoice/print_table_order_invoice_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class TableCompleteOrderScreen extends StatelessWidget {
  final int tableNumber;
  final String tableId;
  const TableCompleteOrderScreen({super.key, required this.tableNumber, required this.tableId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TableCompleteOrderBloc()..add(TableCompleteOrderInitialEvent(tableNumber: tableNumber, tableId: tableId)),
      child: TableCompleteOrderView(tableNumber: tableNumber, tableId: tableId),
    );
  }
}

class TableCompleteOrderView extends StatefulWidget {
  final int tableNumber;
  final String tableId;
  const TableCompleteOrderView({super.key, required this.tableNumber, required this.tableId});

  @override
  State<TableCompleteOrderView> createState() => _TableCompleteOrderViewState();
}

class _TableCompleteOrderViewState extends State<TableCompleteOrderView> {
  final _nameFocusNode = FocusNode();
  final _countryCodeFocusNode = FocusNode();
  final _numberFocusNode = FocusNode();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController _orderDiscountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        context.read<TableCompleteOrderBloc>().add(TableCompleteOrderCustomerNameUnfocusedEvent());
      }
    });

    _numberFocusNode.addListener(() {
      if (!_numberFocusNode.hasFocus) {
        context.read<TableCompleteOrderBloc>().add(TableCompleteOrderCustomerNumberUnfocusedEvent());
      }
    });

    nameController.text = '';
    numberController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((TableCompleteOrderBloc bloc) => bloc.state.isValid);
    return BlocConsumer<TableCompleteOrderBloc, TableCompleteOrderState>(
      listener: (context, state) {
        if (state.status.isInitial) {
          countryCodeController.text = '${state.flag} (${state.customerCountryCode.value})';
        } else if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isRemoveDiscount) {
          _orderDiscountController.text = '';
        } else if (state.status.isEmpty) {
          Navigator.of(context).maybePop();
        } else if (state.status.isOrderPlaced) {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return PrintTableOrderInvoiceScreen(orderId: state.orderInfo.id!);
                  },
                  fullscreenDialog: true,
                ),
              )
              .then((value) {
                if (!context.mounted) return;
                Navigator.of(context).maybePop();
              });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isPlacingOrder ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text("${translate.order_detail} #${widget.tableNumber}"), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const TableCompleteOrderLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const TableCompleteOrderErrorView(),
                  ] else if (state.status.isEmpty) ...[
                    const TableCompleteOrderEmptyView(),
                  ] else ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  state.model.items!.length,
                                  (foodIndex) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(kAppTrimWord(state.model.items![foodIndex].foodInfo!.name!, 50), style: kAppLblMediumFontBold(context)),
                                              kAppSpacerVertical(height: 5),
                                              state.model.items![foodIndex].optionName!.isNotEmpty
                                                  ? Container(
                                                      padding: const EdgeInsets.only(right: 5),
                                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.8, minWidth: MediaQuery.of(context).size.width / 2.5),
                                                      child: Text(state.model.items![foodIndex].optionName!, maxLines: 4, style: kAppLblTinyFontRegular(context)),
                                                    )
                                                  : const SizedBox(),
                                              kAppSpacerVertical(height: 5),
                                              state.model.items![foodIndex].instruction!.isNotEmpty
                                                  ? Container(
                                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                                      child: Text(
                                                        '${translate.form_cooking_instructions} : ${state.model.items![foodIndex].instruction!}',
                                                        maxLines: 4,
                                                        style: kAppLblTinyFontRegularChip(context, color: 'primary'),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(kAppPriceFormat(state.model.items![foodIndex].itemPrice!), style: kAppLblTinyMediumFontSemi(context)),
                                              kAppSpacerHorizontal(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  showConfirmDialog(context, translate.alert_confirm_title, translate.alert_remove_cart_title, translate.cancel_lbl, translate.alert_yes_remove).then((value) {
                                                    if (!context.mounted) return;
                                                    if (value == true || value.toString() == 'true') {
                                                      context.read<TableCompleteOrderBloc>().add(TableCompleteOrderDeleteItemEvent(itemId: state.model.items![foodIndex].id!));
                                                    }
                                                  });
                                                },
                                                child: Icon(Icons.delete_forever_outlined, color: Theme.of(context).primaryColor, size: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        kAppSpacerVertical(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _orderDiscountController,
                                decoration: kAppInputDecoration(context, lblText: translate.form_discount),
                                style: kAppLblLargeFontMedium(context),
                                keyboardType: TextInputType.number,
                                onChanged: (value) => context.read<TableCompleteOrderBloc>().add(TableCompleteOrderDiscountChangedEvent(discount: value)),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            kAppSpacerHorizontal(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                key: UniqueKey(),
                                decoration: kAppInputDecoration(context, lblText: translate.form_discount_type),
                                style: kAppLblSmallFontMedium(context),
                                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                                initialValue: state.discountType,
                                items: state.discountTypeList.map((TableOrderDiscountTypeModel state) {
                                  return DropdownMenuItem<String>(value: state.value, child: Text(kAppDDTranslate(context, state.label!)));
                                }).toList(),
                                onChanged: (String? value) => context.read<TableCompleteOrderBloc>().add(TableCompleteOrderDiscountTypeChangedEvent(value: value!)),
                              ),
                            ),
                          ],
                        ),
                        kAppSpacerVertical(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TableCompleteOrderBillingTileWidget(name: translate.item_total, icon: AssetsUrl.iconsURL.billItemTotalIcon, priceTag: '+', price: state.realPrice, canDeletePrice: false, priceName: 'realPrice'),
                              TableCompleteOrderBillingTileWidget(
                                name: translate.item_discount,
                                icon: AssetsUrl.iconsURL.billDiscountIcon,
                                priceTag: '-',
                                price: state.itemDiscount,
                                canDeletePrice: false,
                                priceName: 'itemDiscount',
                              ),
                              TableCompleteOrderBillingTileWidget(name: translate.sub_total, icon: AssetsUrl.iconsURL.billItemTotalIcon, priceTag: '+', price: state.itemTotal, canDeletePrice: false, priceName: 'itemTotal'),
                              TableCompleteOrderBillingTileWidget(
                                name: '${translate.food_service_charge} (${state.foodServiceChargeName})',
                                icon: AssetsUrl.iconsURL.billTaxIcon,
                                priceTag: '+',
                                price: state.foodServiceCharge,
                                canDeletePrice: true,
                                priceName: 'foodServiceCharge',
                              ),
                              TableCompleteOrderBillingTileWidget(
                                name: '${translate.service_charge} (${state.serviceChargeName})',
                                icon: AssetsUrl.iconsURL.billTaxIcon,
                                priceTag: '+',
                                price: state.serviceCharge,
                                canDeletePrice: true,
                                priceName: 'serviceCharge',
                              ),
                              TableCompleteOrderBillingTileWidget(
                                name: translate.packaging_charge,
                                icon: AssetsUrl.iconsURL.billPackageIcon,
                                priceTag: '+',
                                price: state.packagingCharges,
                                canDeletePrice: true,
                                priceName: 'packageCharge',
                              ),
                              TableCompleteOrderBillingTileWidget(
                                name: translate.packaging_charge_tax,
                                icon: AssetsUrl.iconsURL.billTaxIcon,
                                priceTag: '+',
                                price: state.packagingChargesTax,
                                canDeletePrice: true,
                                priceName: 'packageChargeTax',
                              ),
                              TableCompleteOrderBillingTileWidget(name: translate.form_discount, icon: AssetsUrl.iconsURL.billDiscountIcon, priceTag: '-', price: state.discountAmount, canDeletePrice: true, priceName: 'discount'),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.only(bottom: 5, top: 10),
                                decoration: BoxDecoration(
                                  border: Border(top: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(translate.grand_total, style: kAppLblMediumFontMedium(context)),
                                    Text(kAppPriceFormat(state.grandTotal), style: kAppLblMediumFontBold(context)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        kAppSpacerVertical(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => context.read<TableCompleteOrderBloc>().add(TableCompleteOrderPaymentModelChangeEvent(payment: 'offline')),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                width: MediaQuery.of(context).size.width / 2.3,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: state.paymentMode == 'offline' ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(AssetsUrl.imageURL.posCashPayment, height: 20, width: 20, color: state.paymentMode == 'offline' ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).canvasColor),
                                    kAppSpacerHorizontal(width: 10),
                                    Text(translate.cash_payment, style: state.paymentMode == 'offline' ? kAppLblMediumFontSemiBoldWhite(context) : kAppLblMediumFontSemiBold(context)),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => context.read<TableCompleteOrderBloc>().add(TableCompleteOrderPaymentModelChangeEvent(payment: 'online')),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                width: MediaQuery.of(context).size.width / 2.3,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: state.paymentMode == 'online' ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(AssetsUrl.imageURL.posOnlinePayment, height: 20, width: 20, color: state.paymentMode == 'online' ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).canvasColor),
                                    kAppSpacerHorizontal(width: 10),
                                    Text(translate.online_payment, style: state.paymentMode == 'online' ? kAppLblMediumFontSemiBoldWhite(context) : kAppLblMediumFontSemiBold(context)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        kAppSpacerVertical(height: 20),
                        DropdownButtonFormField<String>(
                          key: UniqueKey(),
                          decoration: kAppInputDecoration(context, lblText: translate.form_customer_type),
                          style: kAppLblSmallFontMedium(context),
                          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                          initialValue: state.customerType,
                          items: state.customerTypeList.map((TableOrderCustomerTypeModel state) {
                            return DropdownMenuItem<String>(value: state.value, child: Text(kAppDDTranslate(context, state.label!)));
                          }).toList(),
                          onChanged: (String? value) => context.read<TableCompleteOrderBloc>().add(TableCompleteOrderCustomerTypeChangeEvent(value: value!)),
                        ),
                        kAppSpacerVertical(height: 10),
                        state.customerType == 'regular'
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    focusNode: _nameFocusNode,
                                    controller: nameController,
                                    decoration: kAppInputDecoration(
                                      context,
                                      prefixIcon: const Icon(Icons.account_circle_outlined),
                                      lblText: translate.form_customer_name,
                                      errText: state.customerName.displayError != null ? translate.form_required : null,
                                    ),
                                    style: kAppLblSmallFontMedium(context),
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) => context.read<TableCompleteOrderBloc>().add(TableCompleteOrderCustomerNameChangedEvent(name: value)),
                                    textInputAction: TextInputAction.next,
                                  ),
                                  kAppSpacerVertical(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                          controller: countryCodeController,
                                          focusNode: _countryCodeFocusNode,
                                          readOnly: true,
                                          decoration: kAppInputDecoration(context, lblText: translate.form_country_code, errText: state.customerCountryCode.displayError != null ? translate.form_required : null),
                                          style: kAppLblSmallFontMedium(context),
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) {
                                                      return CountryCodeModalScreen(code: state.customerCountryCode.value);
                                                    },
                                                    fullscreenDialog: true,
                                                  ),
                                                )
                                                .then((value) {
                                                  if (!context.mounted) return;
                                                  CountryCodeModalResponseModel countryCodeResponse = CountryCodeModalResponseModel.fromJson(value);
                                                  if (countryCodeResponse.action!) {
                                                    setState(() {
                                                      countryCodeController.text = '${countryCodeResponse.flag} (${countryCodeResponse.dialCode})';
                                                    });
                                                    context.read<TableCompleteOrderBloc>().add(TableCompleteOrderCustomerCountryCodeChangedEvent(flag: countryCodeResponse.flag!, countryCode: countryCodeResponse.dialCode!));
                                                  }
                                                });
                                          },
                                        ),
                                      ),
                                      kAppSpacerHorizontal(width: 10),
                                      Expanded(
                                        flex: 3,
                                        child: TextFormField(
                                          focusNode: _numberFocusNode,
                                          controller: numberController,
                                          decoration: kAppInputDecoration(
                                            context,
                                            prefixIcon: const Icon(Icons.call_outlined),
                                            lblText: translate.form_customer_mobile,
                                            errText: state.customerContact.displayError != null ? translate.form_required : null,
                                          ),
                                          style: kAppLblSmallFontMedium(context),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                                          onChanged: (value) => context.read<TableCompleteOrderBloc>().add(TableCompleteOrderCustomerNumberChangedEvent(number: value)),
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                    ],
                                  ),
                                  kAppSpacerVertical(height: 20),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: ThemeProvider.scaffoldPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isValid ? () => context.read<TableCompleteOrderBloc>().add(TableCompleteOrderCompleteOrderEvent()) : null,
                            style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                            child: state.status.isPlacingOrder ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.complete_order),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TableCompleteOrderBillingTileWidget extends StatelessWidget {
  final String name;
  final String icon;
  final String priceTag;
  final double price;
  final bool canDeletePrice;
  final String priceName;
  const TableCompleteOrderBillingTileWidget({super.key, required this.name, required this.icon, required this.priceTag, required this.price, required this.canDeletePrice, required this.priceName});

  @override
  Widget build(BuildContext context) {
    return price > 0
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(icon, height: 12, width: 12, color: Theme.of(context).canvasColor),
                    kAppSpacerHorizontal(width: 10),
                    Text(name, style: kAppLblTinyFontRegular(context)),
                  ],
                ),
                canDeletePrice
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("($priceTag) ${kAppPriceFormat(price)}", style: kAppLblTinyFontBold(context)),
                          kAppSpacerHorizontal(width: 5),
                          GestureDetector(
                            onTap: () => context.read<TableCompleteOrderBloc>().add(TableCompleteOrderRemovePriceEvent(priceName: priceName)),
                            child: Icon(Icons.delete_forever_outlined, color: Theme.of(context).primaryColor, size: 12),
                          ),
                        ],
                      )
                    : Text("($priceTag) ${kAppPriceFormat(price)}", style: kAppLblTinyFontBold(context)),
              ],
            ),
          )
        : const SizedBox();
  }
}

class TableCompleteOrderLoadingView extends StatelessWidget {
  const TableCompleteOrderLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(style: SkeletonLineStyle(height: 8, width: 64, borderRadius: BorderRadius.circular(8))),
                const SizedBox(width: 5),
                SkeletonLine(style: SkeletonLineStyle(height: 8, width: 64, borderRadius: BorderRadius.circular(8))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
        const SizedBox(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(height: 50, width: double.infinity, borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(10, (index) {
              return SkeletonAvatar(
                style: SkeletonAvatarStyle(width: 80, height: 30, padding: const EdgeInsets.symmetric(horizontal: 5), borderRadius: BorderRadius.circular(8)),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: List.generate(2, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                ),
                child: Column(
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(8)),
                    ),
                    const SizedBox(height: 5),
                    SkeletonLine(
                      style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(8)),
                    ),
                    const SizedBox(height: 5),
                    SkeletonLine(
                      style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(8)),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SkeletonLine(style: SkeletonLineStyle(height: 25, width: 25, borderRadius: BorderRadius.circular(8))),
                        const SizedBox(width: 10),
                        SkeletonLine(style: SkeletonLineStyle(height: 25, width: 25, borderRadius: BorderRadius.circular(8))),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class TableCompleteOrderErrorView extends StatelessWidget {
  const TableCompleteOrderErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.table_order_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class TableCompleteOrderEmptyView extends StatelessWidget {
  const TableCompleteOrderEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.table_order_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //
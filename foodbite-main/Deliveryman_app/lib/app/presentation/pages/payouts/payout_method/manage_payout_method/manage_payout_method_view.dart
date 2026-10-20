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

import 'package:driver/app/core/models/country_code_modal_response_model.dart';
import 'package:driver/app/presentation/pages/modals/country_modal/country_modal_view.dart';
import 'package:driver/app/presentation/pages/payouts/payout_method/manage_payout_method/bloc/manage_payout_method_bloc.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:driver/app/core/config/assets_url.dart';
import 'package:driver/app/core/models/payout_method_model.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/success_dialog.dart';
import 'package:driver/app/presentation/styles/theme.dart';

class ManagePayoutMethodScreen extends StatelessWidget {
  final bool isNew;
  final String id;
  const ManagePayoutMethodScreen({super.key, required this.isNew, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManagePayoutMethodBloc()..add(ManagePayoutMethodInitialEvent(isNew: isNew, id: id)),
      child: const ManagePayoutMethodView(),
    );
  }
}

class ManagePayoutMethodView extends StatelessWidget {
  const ManagePayoutMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<ManagePayoutMethodBloc, ManagePayoutMethodState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isSubmitFailed || state.status.isUpdateFailed || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSubmitSuccess) {
          showSuccessDialog(context, translate.payout_saved).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        } else if (state.status.isUpdateSuccess) {
          showSuccessDialog(context, translate.payout_updated).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isSubmit || state.status.isUpdate ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(translate.manage_payout_method), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const ManagePayoutMethodLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const ManagePayoutMethodErrorView(),
                  ] else if (state.status.isEmpty) ...[
                    const ManagePayoutMethodEmptyView(),
                  ] else ...[
                    state.isNew
                        ? Container(
                            margin: const EdgeInsets.only(bottom: 10, top: 5),
                            width: double.infinity,
                            child: DropdownButtonFormField<String>(
                              key: UniqueKey(),
                              decoration: kAppInputDecoration(context, lblText: translate.form_select_payout_method),
                              style: kAppLblSmallFontMedium(context),
                              dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                              initialValue: state.methodId,
                              items: state.methods.map((PayoutMethodConfigModel state) {
                                return DropdownMenuItem<String>(value: state.id, child: Text(state.name!));
                              }).toList(),
                              onChanged: (String? value) => context.read<ManagePayoutMethodBloc>().add(ManagePayoutMethodChangeEvent(methodId: value!)),
                            ),
                          )
                        : const SizedBox(),
                    Text(translate.register_request_notice, style: kAppLblTinyFontRegular(context)),
                    kAppSpacerVertical(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        state.formField.length,
                        (formIndex) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.formField[formIndex].fieldType! == 'text') ...[
                              FormElementTextWidget(
                                formIndex: formIndex,
                                formLength: state.formField.length,
                                fieldName: state.formField[formIndex].fieldName!,
                                placeholder: state.formField[formIndex].placeholder!,
                                isRequired: state.formField[formIndex].isRequired!,
                                isSubmitted: state.isFormSubmitted,
                                formValue: state.formField[formIndex].value!,
                              ),
                            ] else if (state.formField[formIndex].fieldType! == 'number') ...[
                              FormElementNumberWidget(
                                formIndex: formIndex,
                                formLength: state.formField.length,
                                fieldName: state.formField[formIndex].fieldName!,
                                placeholder: state.formField[formIndex].placeholder!,
                                isRequired: state.formField[formIndex].isRequired!,
                                isSubmitted: state.isFormSubmitted,
                                formValue: state.formField[formIndex].value!,
                              ),
                            ] else if (state.formField[formIndex].fieldType! == 'phone') ...[
                              FormElementPhoneNumberWidget(
                                formIndex: formIndex,
                                formLength: state.formField.length,
                                fieldName: state.formField[formIndex].fieldName!,
                                placeholder: state.formField[formIndex].placeholder!,
                                isRequired: state.formField[formIndex].isRequired!,
                                isSubmitted: state.isFormSubmitted,
                                formValue: state.formField[formIndex].value!,
                                extraFormValue: state.formField[formIndex].extraValue!,
                                flag: state.flag,
                              ),
                            ] else if (state.formField[formIndex].fieldType! == 'email') ...[
                              FormElementEmailWidget(
                                formIndex: formIndex,
                                formLength: state.formField.length,
                                fieldName: state.formField[formIndex].fieldName!,
                                placeholder: state.formField[formIndex].placeholder!,
                                isRequired: state.formField[formIndex].isRequired!,
                                isSubmitted: state.isFormSubmitted,
                                formValue: state.formField[formIndex].value!,
                              ),
                            ] else if (state.formField[formIndex].fieldType! == 'date') ...[
                              FormElementDateWidget(
                                formIndex: formIndex,
                                formLength: state.formField.length,
                                fieldName: state.formField[formIndex].fieldName!,
                                placeholder: state.formField[formIndex].placeholder!,
                                isRequired: state.formField[formIndex].isRequired!,
                                isSubmitted: state.isFormSubmitted,
                                formValue: state.formField[formIndex].value!,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            bottomNavigationBar: state.status.isLoading || state.status.isFailure || state.status.isEmpty
                ? SafeArea(child: const SizedBox())
                : SafeArea(
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
                                  onPressed: () => context.read<ManagePayoutMethodBloc>().add(ManagePayoutMethodSubmitEvent()),
                                  style: kAppElevatedButtonStyle(
                                    context,
                                    disabledColor: Theme.of(context).disabledColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    foreColor: Theme.of(context).scaffoldBackgroundColor,
                                    height: 50.0,
                                  ),
                                  child: state.status.isSubmit || state.status.isUpdate ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.submit),
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

class FormElementTextWidget extends StatefulWidget {
  final int formIndex;
  final int formLength;
  final String fieldName;
  final String placeholder;
  final bool isRequired;
  final bool isSubmitted;
  final String formValue;
  const FormElementTextWidget({super.key, required this.formIndex, required this.formLength, required this.fieldName, required this.placeholder, required this.isRequired, required this.isSubmitted, required this.formValue});

  @override
  State<FormElementTextWidget> createState() => _FormElementTextWidgetState();
}

class _FormElementTextWidgetState extends State<FormElementTextWidget> {
  late TextEditingController formTextController;
  @override
  void initState() {
    super.initState();
    formTextController = TextEditingController(text: widget.formValue);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: formTextController,
        decoration: kAppInputDecoration(context, lblText: widget.fieldName, errText: widget.isRequired && widget.isSubmitted && widget.formValue.isEmpty ? translate.form_required : null),
        style: kAppLblLargeFontMedium(context),
        keyboardType: TextInputType.text,
        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
        onChanged: (value) {
          if (value.startsWith(' ')) {
            formTextController.text = value.trimLeft();
            formTextController.selection = TextSelection.collapsed(offset: formTextController.text.length);
          }
          if (RegExp(r'^[0-9]').hasMatch(value)) {
            formTextController.text = value.substring(1);
            formTextController.selection = TextSelection.collapsed(offset: formTextController.text.length);
          }
          context.read<ManagePayoutMethodBloc>().add(ManagePayoutMethodTextInputChangeEvent(formIndex: widget.formIndex, value: formTextController.text));
        },
        textInputAction: widget.formIndex == widget.formLength ? TextInputAction.done : TextInputAction.next,
      ),
    );
  }
}

class FormElementNumberWidget extends StatefulWidget {
  final int formIndex;
  final int formLength;
  final String fieldName;
  final String placeholder;
  final bool isRequired;
  final bool isSubmitted;
  final String formValue;
  const FormElementNumberWidget({super.key, required this.formIndex, required this.formLength, required this.fieldName, required this.placeholder, required this.isRequired, required this.isSubmitted, required this.formValue});

  @override
  State<FormElementNumberWidget> createState() => _FormElementNumberWidgetState();
}

class _FormElementNumberWidgetState extends State<FormElementNumberWidget> {
  late TextEditingController formNumberController;
  @override
  void initState() {
    super.initState();
    formNumberController = TextEditingController(text: widget.formValue);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: formNumberController,
        decoration: kAppInputDecoration(context, lblText: widget.fieldName, errText: widget.isRequired && widget.isSubmitted && widget.formValue.isEmpty ? translate.form_required : null),
        style: kAppLblLargeFontMedium(context),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
        onChanged: (value) => context.read<ManagePayoutMethodBloc>().add(ManagePayoutMethodTextInputChangeEvent(formIndex: widget.formIndex, value: formNumberController.text)),
        textInputAction: widget.formIndex == widget.formLength ? TextInputAction.done : TextInputAction.next,
      ),
    );
  }
}

class FormElementPhoneNumberWidget extends StatefulWidget {
  final int formIndex;
  final int formLength;
  final String fieldName;
  final String placeholder;
  final bool isRequired;
  final bool isSubmitted;
  final String formValue;
  final String extraFormValue;
  final String flag;
  const FormElementPhoneNumberWidget({
    super.key,
    required this.formIndex,
    required this.formLength,
    required this.fieldName,
    required this.placeholder,
    required this.isRequired,
    required this.isSubmitted,
    required this.formValue,
    required this.extraFormValue,
    required this.flag,
  });

  @override
  State<FormElementPhoneNumberWidget> createState() => _FormElementPhoneNumberWidgetState();
}

class _FormElementPhoneNumberWidgetState extends State<FormElementPhoneNumberWidget> {
  late TextEditingController formCountryCodeController;
  late TextEditingController formMobileController;

  @override
  void initState() {
    super.initState();
    formCountryCodeController = TextEditingController(text: '${widget.flag} ${widget.extraFormValue}');
    formMobileController = TextEditingController(text: widget.formValue);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: formCountryCodeController,
              readOnly: true,
              decoration: kAppInputDecoration(context, lblText: translate.form_country_code_name, errText: widget.isRequired && widget.isSubmitted && widget.formValue.isEmpty ? translate.form_required : null),
              style: kAppLblSmallFontMedium(context),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onTap: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return CountryCodeModalScreen(code: widget.extraFormValue);
                        },
                        fullscreenDialog: true,
                      ),
                    )
                    .then((value) {
                      if (!context.mounted) return;
                      CountryCodeModalResponseModel countryCodeResponse = CountryCodeModalResponseModel.fromJson(value);
                      if (countryCodeResponse.action!) {
                        formCountryCodeController.text = '${countryCodeResponse.flag} (${countryCodeResponse.dialCode})';
                        context.read<ManagePayoutMethodBloc>().add(ManagePayoutMethodCountryCodeChangeEvent(formIndex: widget.formIndex, value: countryCodeResponse.dialCode!));
                      }
                    });
              },
            ),
          ),
        ),
        kAppSpacerHorizontal(width: 10),
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: formMobileController,
              decoration: kAppInputDecoration(context, lblText: widget.fieldName, errText: widget.isRequired && widget.isSubmitted && widget.formValue.isEmpty ? translate.form_required : null),
              style: kAppLblLargeFontMedium(context),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
              onChanged: (value) => context.read<ManagePayoutMethodBloc>().add(ManagePayoutMethodTextInputChangeEvent(formIndex: widget.formIndex, value: formMobileController.text)),
              textInputAction: widget.formIndex == widget.formLength ? TextInputAction.done : TextInputAction.next,
            ),
          ),
        ),
      ],
    );
  }
}

class FormElementEmailWidget extends StatefulWidget {
  final int formIndex;
  final int formLength;
  final String fieldName;
  final String placeholder;
  final bool isRequired;
  final bool isSubmitted;
  final String formValue;
  const FormElementEmailWidget({super.key, required this.formIndex, required this.formLength, required this.fieldName, required this.placeholder, required this.isRequired, required this.isSubmitted, required this.formValue});

  @override
  State<FormElementEmailWidget> createState() => _FormElementEmailWidgetState();
}

class _FormElementEmailWidgetState extends State<FormElementEmailWidget> {
  late TextEditingController formEmailController;
  @override
  void initState() {
    super.initState();
    formEmailController = TextEditingController(text: widget.formValue);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: formEmailController,
        decoration: kAppInputDecoration(context, lblText: widget.fieldName, errText: widget.isRequired && widget.isSubmitted && widget.formValue.isEmpty ? translate.form_required : null),
        style: kAppLblLargeFontMedium(context),
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => context.read<ManagePayoutMethodBloc>().add(ManagePayoutMethodTextInputChangeEvent(formIndex: widget.formIndex, value: formEmailController.text)),
        textInputAction: widget.formIndex == widget.formLength ? TextInputAction.done : TextInputAction.next,
      ),
    );
  }
}

class FormElementDateWidget extends StatefulWidget {
  final int formIndex;
  final int formLength;
  final String fieldName;
  final String placeholder;
  final bool isRequired;
  final bool isSubmitted;
  final String formValue;
  const FormElementDateWidget({super.key, required this.formIndex, required this.formLength, required this.fieldName, required this.placeholder, required this.isRequired, required this.isSubmitted, required this.formValue});

  @override
  State<FormElementDateWidget> createState() => _FormElementDateWidgetState();
}

class _FormElementDateWidgetState extends State<FormElementDateWidget> {
  late TextEditingController formDateController;
  @override
  void initState() {
    super.initState();
    formDateController = TextEditingController(text: widget.formValue);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: formDateController,
        decoration: kAppInputDecoration(context, lblText: widget.fieldName, errText: widget.isRequired && widget.isSubmitted && widget.formValue.isEmpty ? translate.form_required : null),
        style: kAppLblLargeFontMedium(context),
        readOnly: false,
        keyboardType: TextInputType.number,
        onTap: () async {
          await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2100)).then((value) {
            if (!context.mounted) return;
            if (value != null) {
              final String selectedDate = '${value.year}-${value.month}-${value.day}';
              formDateController.text = selectedDate;
              context.read<ManagePayoutMethodBloc>().add(ManagePayoutMethodTextInputChangeEvent(formIndex: widget.formIndex, value: selectedDate));
            }
          });
        },
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

class ManagePayoutMethodLoadingView extends StatelessWidget {
  const ManagePayoutMethodLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
      ],
    );
  }
}

class ManagePayoutMethodErrorView extends StatelessWidget {
  const ManagePayoutMethodErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.something_went_wrong_error_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class ManagePayoutMethodEmptyView extends StatelessWidget {
  const ManagePayoutMethodEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_payout_method_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_payout_method_found_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //
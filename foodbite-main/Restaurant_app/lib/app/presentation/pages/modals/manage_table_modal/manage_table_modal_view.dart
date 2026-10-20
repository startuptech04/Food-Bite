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
import 'package:vendor/app/presentation/pages/modals/manage_table_modal/bloc/manage_table_modal_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class ManageTableModalScreen extends StatelessWidget {
  final bool isNew;
  final String tableId;
  final int tableNumber;
  final int capacity;
  const ManageTableModalScreen({super.key, required this.isNew, required this.tableId, required this.tableNumber, required this.capacity});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageTableModalBloc()..add(ManageTableModalInitialEvent(isNew: isNew, tableId: tableId, tableNumber: tableNumber, capacity: capacity)),
      child: ManageTableModalView(isNew: isNew, tableId: tableId, tableNumber: tableNumber, capacity: capacity),
    );
  }
}

class ManageTableModalView extends StatefulWidget {
  final bool isNew;
  final String tableId;
  final int tableNumber;
  final int capacity;
  const ManageTableModalView({super.key, required this.isNew, required this.tableId, required this.tableNumber, required this.capacity});

  @override
  State<ManageTableModalView> createState() => _ManageTableModalViewState();
}

class _ManageTableModalViewState extends State<ManageTableModalView> {
  final TextEditingController _tableNumberController = TextEditingController();
  final TextEditingController _tableCapacityController = TextEditingController();

  final _tableNumberFocusNode = FocusNode();
  final _tableCapacityFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tableNumberFocusNode.addListener(() {
      if (!_tableNumberFocusNode.hasFocus) {
        context.read<ManageTableModalBloc>().add(ManageTableModalNumberUnfocusedEvent());
      }
    });
    _tableCapacityFocusNode.addListener(() {
      if (!_tableCapacityFocusNode.hasFocus) {
        context.read<ManageTableModalBloc>().add(ManageTableModalCapacityUnfocusedEvent());
      }
    });
    if (!widget.isNew) {
      _tableNumberController.text = widget.tableNumber.toString();
      _tableCapacityController.text = widget.capacity.toString();
    }
  }

  @override
  void dispose() {
    _tableNumberController.dispose();
    _tableCapacityController.dispose();

    _tableNumberFocusNode.dispose();
    _tableCapacityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((ManageTableModalBloc bloc) => bloc.state.isValid);
    return BlocConsumer<ManageTableModalBloc, ManageTableModalState>(
      listener: (context, state) {
        if (state.status.isSubmitFailed) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSubmitSuccess) {
          showSuccessDialog(context, state.isNew ? translate.table_added : translate.table_updated).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isSubmit ? true : false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              title: Text(widget.isNew ? translate.add_new_table : translate.update_table),
              actions: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kAppSpacerVertical(height: 20),
                  TextFormField(
                    controller: _tableNumberController,
                    focusNode: _tableNumberFocusNode,
                    decoration: kAppInputDecoration(context, lblText: translate.form_table_number, errText: state.numberField.displayError != null ? translate.form_required : null),
                    style: kAppLblLargeFontMedium(context),
                    keyboardType: TextInputType.text,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                    onChanged: (value) => context.read<ManageTableModalBloc>().add(ManageTableModalNumberChangedEvent(number: value)),
                    textInputAction: TextInputAction.next,
                  ),
                  kAppSpacerVertical(height: 20),
                  TextFormField(
                    controller: _tableCapacityController,
                    focusNode: _tableCapacityFocusNode,
                    decoration: kAppInputDecoration(context, lblText: translate.form_table_capacity, errText: state.capacityField.displayError != null ? translate.form_required : null),
                    style: kAppLblLargeFontMedium(context),
                    keyboardType: TextInputType.text,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                    onChanged: (value) => context.read<ManageTableModalBloc>().add(ManageTableModalCapacityChangedEvent(capacity: value)),
                    textInputAction: TextInputAction.next,
                  ),
                  kAppSpacerVertical(height: 20),
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
                            onPressed: isValid ? () => context.read<ManageTableModalBloc>().add(ManageTableModalSubmitEvent()) : null,
                            style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                            child: state.status.isSubmit ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.save_lbl),
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
// DONE //
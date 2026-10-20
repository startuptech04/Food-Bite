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
import 'package:vendor/app/presentation/pages/modals/add_expense_modal/bloc/add_expense_modal_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class AddExpenseModalScreen extends StatelessWidget {
  const AddExpenseModalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => AddExpenseModalBloc()..add(AddExpenseModalInitialEvent()), child: const AddExpenseModalView());
  }
}

class AddExpenseModalView extends StatefulWidget {
  const AddExpenseModalView({super.key});

  @override
  State<AddExpenseModalView> createState() => _AddExpenseModalViewState();
}

class _AddExpenseModalViewState extends State<AddExpenseModalView> {
  final TextEditingController _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _amountFocusNode.addListener(() {
      if (!_amountFocusNode.hasFocus) {
        context.read<AddExpenseModalBloc>().add(AddExpenseModalAmountUnfocusedEvent());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((AddExpenseModalBloc bloc) => bloc.state.isValid);
    return BlocConsumer<AddExpenseModalBloc, AddExpenseModalState>(
      listener: (context, state) {
        if (state.status.isSubmitFailed) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSubmitSuccess) {
          showSuccessDialog(context, translate.expense_saved).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop('true');
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isSubmit ? true : false,
          child: Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              title: Text(translate.add_expense),
              actions: [IconButton(onPressed: () => Navigator.of(context).pop('false'), icon: Icon(Icons.close))],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.all(ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _amountController,
                    focusNode: _amountFocusNode,
                    decoration: kAppInputDecoration(context, lblText: translate.form_expense_amount, errText: state.amount.displayError != null ? translate.form_required : null),
                    style: kAppLblLargeFontMedium(context),
                    keyboardType: TextInputType.text,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                    onChanged: (value) => context.read<AddExpenseModalBloc>().add(AddExpenseModalAmountChangedEvent(amount: value)),
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => isValid ? context.read<AddExpenseModalBloc>().add(AddExpenseModalSubmitEvent()) : null,
                            style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50),
                            child: state.status.isSubmit ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.submit_lbl),
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
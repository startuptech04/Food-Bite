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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/app/presentation/pages/account/dining_booking/dining_booking_help/bloc/dining_booking_help_bloc.dart';
import 'package:user/gen/l10n/app_localizations.dart';

class DiningBookingHelpScreen extends StatelessWidget {
  const DiningBookingHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => DiningBookingHelpBloc()..add(DiningBookingHelpInitialEvent()), child: const DiningBookingHelpView());
  }
}

class DiningBookingHelpView extends StatelessWidget {
  const DiningBookingHelpView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<DiningBookingHelpBloc, DiningBookingHelpState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(appBar: AppBar(title: Text(translate.dining_support), scrolledUnderElevation: 0));
      },
    );
  }
}
// Done //
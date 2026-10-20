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
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:user/app/presentation/pages/app_pages/bloc/app_page_bloc.dart';
import 'package:user/app/presentation/styles/app_style.dart';
import 'package:user/app/presentation/styles/error_dialog.dart';
import 'package:user/app/presentation/styles/theme.dart';

class AppPageScreen extends StatelessWidget {
  final String slug;
  const AppPageScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppPageBloc()..add(AppPageInitialEvent(slug: slug)),
      child: const AppPageView(),
    );
  }
}

class AppPageView extends StatefulWidget {
  const AppPageView({super.key});

  @override
  State<AppPageView> createState() => _AppPageViewState();
}

class _AppPageViewState extends State<AppPageView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppPageBloc, AppPageState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage, state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(kAppPageName(context, state.title)), scrolledUnderElevation: 0),
          body: SingleChildScrollView(
            child: state.status.isLoading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Center(child: kAppCenterCircularProgress(context)),
                  )
                : Padding(
                    padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                    child: HtmlWidget(state.description, textStyle: TextStyle(color: Theme.of(context).canvasColor)),
                  ),
          ),
        );
      },
    );
  }
}
// Done //
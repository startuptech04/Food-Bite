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
import 'package:vendor/app/core/models/pos_restaurant_modal_category_model.dart';
import 'package:vendor/app/presentation/pages/modals/pos_menu_modal/bloc/pos_menu_modal_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/theme_bloc/theme_bloc.dart';

class RestaurantMenuModalScreen extends StatelessWidget {
  final String currentInView;
  final List<PosRestaurantModalCategoryModel> categories;
  const RestaurantMenuModalScreen({super.key, required this.currentInView, required this.categories});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = context.watch<ThemeBloc>().state.isDarkTheme;
    return BlocProvider(
      create: (context) => PosMenuModalBloc()..add(PosMenuModalInitialEvent(currentInView: currentInView, isDarkTheme: isDarkTheme)),
      child: RestaurantMenuModalView(categories: categories),
    );
  }
}

class RestaurantMenuModalView extends StatelessWidget {
  final List<PosRestaurantModalCategoryModel> categories;
  const RestaurantMenuModalView({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PosMenuModalBloc, PosMenuModalState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: state.isDarkTheme ? ThemeProvider.pageBackgroundColor : ThemeProvider.darkPageBackgroundColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
            child: Column(
              children: List.generate(
                categories.length,
                (categoryIndex) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(categories[categoryIndex].id!),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            categories[categoryIndex].name!,
                            style: state.currentInView == categories[categoryIndex].id ? kAppThemeToggleLblBold(context, isDarkTheme: state.isDarkTheme) : kAppThemeToggleLblRegular(context, isDarkTheme: state.isDarkTheme),
                          ),
                          Text(
                            '${categories[categoryIndex].count!}',
                            style: state.currentInView == categories[categoryIndex].id ? kAppThemeToggleLblBold(context, isDarkTheme: state.isDarkTheme) : kAppThemeToggleLblRegular(context, isDarkTheme: state.isDarkTheme),
                          ),
                        ],
                      ),
                    ),
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
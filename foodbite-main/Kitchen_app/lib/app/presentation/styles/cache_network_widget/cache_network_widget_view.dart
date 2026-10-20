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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitchen/app/core/config/assets_url.dart';
import 'package:kitchen/app/presentation/styles/cache_network_widget/bloc/cache_network_widget_bloc.dart';

class CacheNetworkImageWidget extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final BoxFit fit;
  const CacheNetworkImageWidget({super.key, required this.width, required this.height, required this.imageUrl, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CacheNetworkWidgetBloc()..add(CachedNetworkImageInitialEvent()),
      child: CacheNetworkWidgetViewer(width: width, height: height, imageUrl: imageUrl, fit: fit),
    );
  }
}

class CacheNetworkWidgetViewer extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final BoxFit fit;
  const CacheNetworkWidgetViewer({super.key, required this.width, required this.height, required this.imageUrl, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CacheNetworkWidgetBloc, CacheNetworkWidgetState>(
      listener: (context, state) {},
      builder: (context, state) {
        return CachedNetworkImage(
          height: height,
          width: width,
          imageUrl: '${state.mediaUrl}$imageUrl',
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: fit),
            ),
          ),
          placeholder: (context, url) => Image.asset(AssetsUrl.imageURL.placeholderImage, fit: fit, height: height, width: width),
          errorWidget: (context, url, error) => Image.asset(AssetsUrl.imageURL.placeholderImage, fit: fit, height: height, width: width),
        );
      },
    );
  }
}

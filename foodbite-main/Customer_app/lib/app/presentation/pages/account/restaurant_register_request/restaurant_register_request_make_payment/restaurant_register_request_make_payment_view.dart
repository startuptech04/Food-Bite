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
import 'package:user/app/core/config/api_endpoints.dart';
import 'package:user/app/core/config/api_request_service.dart';
import 'package:user/app/presentation/pages/account/restaurant_register_request/restaurant_register_request_make_payment/bloc/restaurant_register_request_make_payment_bloc.dart';
import 'package:user/app/presentation/styles/app_style.dart';
import 'package:user/app/router/app_route_config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RestaurantRegisterRequestMakePaymentScreen extends StatelessWidget {
  final String paymentId;
  const RestaurantRegisterRequestMakePaymentScreen({super.key, required this.paymentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantRegisterRequestMakePaymentBloc(),
      child: RestaurantRegisterRequestMakePaymentView(paymentId: paymentId),
    );
  }
}

class RestaurantRegisterRequestMakePaymentView extends StatefulWidget {
  final String paymentId;
  const RestaurantRegisterRequestMakePaymentView({super.key, required this.paymentId});

  @override
  State<RestaurantRegisterRequestMakePaymentView> createState() => _RestaurantRegisterRequestMakePaymentViewState();
}

class _RestaurantRegisterRequestMakePaymentViewState extends State<RestaurantRegisterRequestMakePaymentView> {
  bool isLoading = true;
  bool recallAPI = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    context.read<RestaurantRegisterRequestMakePaymentBloc>().add(RestaurantRegisterRequestPaymentInitialEvent(paymentId: widget.paymentId));
    final WebViewController controller = WebViewController();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            checkCallback(context, url);
          },
          onPageFinished: (String url) {
            checkCallback(context, url);
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            checkCallback(context, request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)));
        },
      )
      ..loadRequest(Uri.parse('${ApiRequestService.baseUrl}${ApiEndPoints.v1request.makePayment}${widget.paymentId}'));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantRegisterRequestMakePaymentBloc, RestaurantRegisterRequestMakePaymentState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.restaurantRegisterRequestSuccessRoute, (Route<dynamic> route) => false);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                WebViewWidget(controller: _controller),
                isLoading ? kAppCenterCircularProgress(context) : const Stack(),
              ],
            ),
          ),
        );
      },
    );
  }

  void checkCallback(BuildContext context, String callback) {
    if (recallAPI == true) {
      if (callback.contains('payment_processed') || callback.contains('paid_failed') || callback.contains('payment_repeated')) {
        setState(() {
          recallAPI = false;
        });
        FocusScope.of(context).requestFocus(FocusNode());
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        context.read<RestaurantRegisterRequestMakePaymentBloc>().add(RestaurantRegisterRequestPaymentResponseEvent());
      }
    }
  }
}
// Done //
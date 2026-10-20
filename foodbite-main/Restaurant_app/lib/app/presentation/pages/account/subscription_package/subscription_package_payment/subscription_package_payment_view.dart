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
import 'package:vendor/app/core/config/api_endpoints.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/presentation/pages/account/subscription_package/subscription_package_payment/bloc/subscription_package_payment_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SubscriptionPackagePaymentScreen extends StatelessWidget {
  final String paymentId;
  const SubscriptionPackagePaymentScreen({super.key, required this.paymentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubscriptionPackagePaymentBloc()..add(SubscriptionPackagePaymentInitialEvent(paymentId: paymentId)),
      child: SubscriptionPackagePaymentView(paymentId: paymentId),
    );
  }
}

class SubscriptionPackagePaymentView extends StatefulWidget {
  final String paymentId;
  const SubscriptionPackagePaymentView({super.key, required this.paymentId});

  @override
  State<SubscriptionPackagePaymentView> createState() => _SubscriptionPackagePaymentViewState();
}

class _SubscriptionPackagePaymentViewState extends State<SubscriptionPackagePaymentView> {
  bool isLoading = true;
  bool recallAPI = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
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
    return BlocConsumer<SubscriptionPackagePaymentBloc, SubscriptionPackagePaymentState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.bottomTabRoute, (Route<dynamic> route) => false, arguments: [2]);
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
        context.read<SubscriptionPackagePaymentBloc>().add(SubscriptionPackagePaymentResponseEvent());
      }
    }
  }
}
// DONE //